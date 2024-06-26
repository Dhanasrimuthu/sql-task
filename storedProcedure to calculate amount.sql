USE [bank_Validation]
GO
/****** Object:  StoredProcedure [dbo].[CheckBalance]    Script Date: 5/2/2024 2:36:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CheckBalance]
@P_account_Id INT
AS
BEGIN
DECLARE @Final_Amount INT 
	DECLARE @Final_Invoice INT
	DECLARE @Final_Credit INT
	DECLARE @Final_Bill INT

    IF OBJECT_ID('Account_Balance_View1') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View1;
    END

    IF OBJECT_ID('Account_Balance_View2') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View2;
    END

    IF OBJECT_ID('Account_Balance_View3') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View3;
    END

	DECLARE @Invoice INT;

	SELECT @Invoice = ID from Account_HeadType Where Name='Invoice';
    
    IF EXISTS (
        SELECT 1 FROM Account_Header
        WHERE Account_Id = @P_account_Id AND Account_HeadType_Id = @Invoice
    )
    BEGIN
        DECLARE @sql1 NVARCHAR(MAX);
        DECLARE @sql2 NVARCHAR(MAX);
        DECLARE @sql3 NVARCHAR(MAX);
		--print @Invoice;
        SET @sql1 = '
        CREATE VIEW Account_Balance_View1 AS
        SELECT  AHT.Account_Head_relations_Id, AT.Amount,AT.Account_Header_Id, AT.Account_ID
        FROM Account_Trans AS AT
        JOIN Account_Header_trans AS AHT
        ON AHT.Account_Header_Id = AT.Account_Header_Id
        WHERE AT.Account_Header_Id IN (
            SELECT ID
            FROM Account_Header
            WHERE Account_Id = ' + CAST(@P_account_Id AS NVARCHAR) + '
            AND Account_HeadType_Id = '+CAST(@Invoice AS nvarchar)+'
        );';

        SET @sql2 = '
        CREATE VIEW Account_Balance_View2 AS
        SELECT  Ac_H_T.Account_Head_relations_Id,
		 CASE
            WHEN COUNT(*) = 1 THEN MAX(Ac_H_T.Amount_A)  
            ELSE SUM(Ac_H_T.Amount_A)                    
            END AS Amount_A
        FROM Account_Header_trans AS Ac_H_T
        WHERE (Amount_A > 0 AND Account_Head_relations_Id IN (
            SELECT AHT1.Account_Head_relations_Id
            FROM Account_Trans AS AT1
            JOIN Account_Header_trans AS AHT1
            ON AHT1.Account_Header_Id = AT1.Account_Header_Id
            WHERE AT1.Account_Header_Id IN (
                SELECT ID
                FROM Account_Header
                WHERE Account_Id = ' + CAST(@P_account_Id AS NVARCHAR) + '
                AND Account_HeadType_Id = '+CAST(@Invoice AS nvarchar)+'
            )
        ))
		 GROUP BY Ac_H_T.Account_Head_relations_Id;';

        EXEC sp_executesql @sql1;
        EXEC sp_executesql @sql2;

       -- SELECT * FROM Account_Balance_View1;
        --SELECT * FROM Account_Balance_View2;
		SET @sql3 = '
       CREATE VIEW Account_Balance_View3 AS 
       SELECT  
        --A1.Account_Head_relations_Id, 
		A1.Account_Header_Id,
        A1.Amount,
		A2.Amount_A,
		(Select Name from Account_HeadType Where Account_HeadType.ID = '+CAST(@Invoice AS NVARCHAR)+') AS Account_HeadType_Name ,
        --A1.Account_ID,
		(Select Name from Account where A1.Account_ID = Account.ID) as AccountName,
        CASE
            WHEN A2.Account_Head_relations_Id IS NULL THEN A1.Amount
            WHEN A1.Amount > 0 THEN A1.Amount - A2.Amount_A
            ELSE A1.Amount + A2.Amount_A
        END AS Result
    FROM
        Account_Balance_View1 AS A1
    LEFT JOIN
        Account_Balance_View2 AS A2 ON A1.Account_Head_relations_Id = A2.Account_Head_relations_Id;'
        EXEC sp_executesql @sql3;
        SELECT * FROM Account_Balance_View3;

		Select @Final_Invoice=SUM(Result) from Account_Balance_View3
	    where AccountName='Receivable';

    END
    ELSE
    BEGIN
        PRINT 'FROM INVOICE No invoice';
    END
	--===============================================================================================
	 IF OBJECT_ID('Account_Balance_View4') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View4;
    END

    IF OBJECT_ID('Account_Balance_View5') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View5;
    END

    IF OBJECT_ID('Account_Balance_View6') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View6;
    END

	DECLARE @Credit INT;
	SELECT @Credit = ID from Account_HeadType Where Name='Credit';

    IF EXISTS (
        SELECT 1 FROM Account_Header
        WHERE Account_Id = @P_account_Id AND Account_HeadType_Id = @Credit
    )
    BEGIN
        DECLARE @sql4 NVARCHAR(MAX);
        DECLARE @sql5 NVARCHAR(MAX);
        DECLARE @sql6 NVARCHAR(MAX);

        SET @sql4 = '
        CREATE VIEW Account_Balance_View4 AS
        SELECT  AHT.Account_Head_relations_Id, AT.Amount,AT.Account_Header_Id, AT.Account_ID
        FROM Account_Trans AS AT
        JOIN Account_Header_trans AS AHT
        ON AHT.Account_Header_Id = AT.Account_Header_Id
        WHERE AT.Account_Header_Id IN (
            SELECT ID
            FROM Account_Header
            WHERE Account_Id = ' + CAST(@P_account_Id AS NVARCHAR) + '
            AND Account_HeadType_Id = '+CAST(@Credit AS nvarchar)+'
        );';

       SET @sql5 = '
              CREATE VIEW Account_Balance_View5 AS
              SELECT  Ac_H_T.Account_Head_relations_Id,
        CASE
            WHEN COUNT(*) = 1 THEN MAX(Ac_H_T.Amount_A)  
            ELSE SUM(Ac_H_T.Amount_A)                    
            END AS Amount_A
        FROM Account_Header_trans AS Ac_H_T
        WHERE (Ac_H_T.Amount_A > 0 AND Ac_H_T.Account_Head_relations_Id IN (
            SELECT AHT1.Account_Head_relations_Id
            FROM Account_Trans AS AT1
            JOIN Account_Header_trans AS AHT1
            ON AHT1.Account_Header_Id = AT1.Account_Header_Id
            WHERE AT1.Account_Header_Id IN (
                SELECT ID
                FROM Account_Header
                WHERE Account_Id = ' + CAST(@P_account_Id AS NVARCHAR) + '
                AND Account_HeadType_Id = '+CAST(@Credit AS NVARCHAR)+'
        )
    ))
        GROUP BY Ac_H_T.Account_Head_relations_Id;';


        EXEC sp_executesql @sql4;
        EXEC sp_executesql @sql5;

        --SELECT * FROM Account_Balance_View4;
        --SELECT * FROM Account_Balance_View5;
		SET @sql6 = '
          CREATE VIEW Account_Balance_View6 AS 
          SELECT  
             -- A1.Account_Head_relations_Id, 
			  A1.Account_Header_Id, 
              A1.Amount,
			  A2.Amount_A,
			  (Select Name from Account_HeadType Where Account_HeadType.ID = '+CAST(@Credit AS NVARCHAR)+') AS Account_HeadType_Name ,
             -- A1.Account_ID,
			  (Select Name from Account where A1.Account_ID = Account.ID) as AccountName,
          CASE
              WHEN A2.Account_Head_relations_Id IS NULL THEN A1.Amount
              WHEN A1.Amount > 0 THEN A1.Amount - A2.Amount_A
              ELSE A1.Amount + A2.Amount_A
         END AS Result
         FROM
              Account_Balance_View4 AS A1
         LEFT JOIN
         Account_Balance_View5 AS A2 ON A1.Account_Head_relations_Id = A2.Account_Head_relations_Id;'
         EXEC sp_executesql @sql6;
         SELECT * FROM Account_Balance_View6;

		 Select @Final_Credit=SUM(Result) from Account_Balance_View6
	     where AccountName='Receivable';
		 END
    ELSE
    BEGIN
        -- No rows present
        PRINT 'FROM CREDIT No credit';
        --SELECT 'No rows present' AS Result;
    END
		--=============================================================================
	IF OBJECT_ID('Account_Balance_View7') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View7;
    END

    IF OBJECT_ID('Account_Balance_View8') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View8;
    END

    IF OBJECT_ID('Account_Balance_View9') IS NOT NULL
    BEGIN
        DROP VIEW Account_Balance_View9;
    END

	DECLARE @Bill INT;
	SELECT @Bill=ID From Account_HeadType Where Name='Bill';

    IF EXISTS (
        SELECT 1 FROM Account_Header
        WHERE Account_Id = @P_account_Id AND Account_HeadType_Id = @Bill
    )
    BEGIN
        DECLARE @sql7 NVARCHAR(MAX);
        DECLARE @sql8 NVARCHAR(MAX);
        DECLARE @sql9 NVARCHAR(MAX);

        SET @sql7 = '
        CREATE VIEW Account_Balance_View7 AS
        SELECT  AHT.Account_Head_relations_Id, AT.Amount,AT.Account_Header_Id, AT.Account_ID
        FROM Account_Trans AS AT
        JOIN Account_Header_trans AS AHT
        ON AHT.Account_Header_Id = AT.Account_Header_Id
        WHERE AT.Account_Header_Id IN (
            SELECT ID
            FROM Account_Header
            WHERE Account_Id = ' + CAST(@P_account_Id AS NVARCHAR) + '
            AND Account_HeadType_Id = '+CAST(@Bill AS nvarchar)+'
        );';

        SET @sql8 = '
        CREATE VIEW Account_Balance_View8 AS
        SELECT DISTINCT Ac_H_T.Account_Head_relations_Id, 
		 CASE
            WHEN COUNT(*) = 1 THEN MAX(Ac_H_T.Amount_A)  
            ELSE SUM(Ac_H_T.Amount_A)                    
            END AS Amount_A
        FROM Account_Header_trans AS Ac_H_T
        WHERE (Amount_A > 0 AND Account_Head_relations_Id IN (
            SELECT AHT1.Account_Head_relations_Id
            FROM Account_Trans AS AT1
            JOIN Account_Header_trans AS AHT1
            ON AHT1.Account_Header_Id = AT1.Account_Header_Id
            WHERE AT1.Account_Header_Id IN (
                SELECT ID
                FROM Account_Header
                WHERE Account_Id = ' + CAST(@P_account_Id AS NVARCHAR) + '
                AND Account_HeadType_Id = '+CAST(@Bill AS nvarchar)+'
            )
        ))
		 GROUP BY Ac_H_T.Account_Head_relations_Id;'
		
        EXEC sp_executesql @sql7;
        EXEC sp_executesql @sql8;

        --SELECT * FROM Account_Balance_View7;
        --SELECT * FROM Account_Balance_View8;
		SET @sql9 = '
    CREATE VIEW Account_Balance_View9 AS 
    SELECT  
        --A1.Account_Head_relations_Id, 
		A1.Account_Header_Id,
        A1.Amount,
		A2.Amount_A,
		(Select Name from Account_HeadType Where ID = '+CAST(@Bill As nvarchar)+')AS Account_HeadType_Name,
        --A1.Account_ID,
		(Select Name from Account where A1.Account_ID = Account.ID) as AccountName,
        CASE
            WHEN A2.Account_Head_relations_Id IS NULL THEN A1.Amount
            WHEN A1.Amount > 0 THEN A1.Amount - A2.Amount_A
            ELSE A1.Amount + A2.Amount_A
        END AS Result
    FROM
        Account_Balance_View7 AS A1
    LEFT JOIN
        Account_Balance_View8 AS A2 ON A1.Account_Head_relations_Id = A2.Account_Head_relations_Id;'
    EXEC sp_executesql @sql9;
    SELECT * FROM Account_Balance_View9;

	Select @Final_Bill=SUM(Result) from Account_Balance_View9
	where AccountName='Payable';
    END
    ELSE
    BEGIN
        -- No rows present
        PRINT 'FROM BILL No bill';
        --SELECT 'No rows present' AS Result;
    END
	if(@Final_Invoice IS Null)
	BEGIN
	SET @Final_Invoice =0;
	END
	if(@Final_Credit IS Null)
	BEGIN
	SET @Final_Credit =0;
	END
	if(@Final_Bill IS Null)
	BEGIN
	SET @Final_Bill =0;
	END
	select @Final_Invoice AS Final_Invoice;
	select @Final_Credit AS Final_Credit;
	select  @Final_Bill AS Final_Bill;
	SET @Final_Amount =@Final_Invoice+@Final_Credit+@Final_Bill;
	print @Final_Amount;
	Select (select Name from Account where ID= @P_account_Id) AS Account_Name,@Final_Amount AS Final_Amount
END



