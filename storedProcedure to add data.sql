USE [bank_Validation]
GO
/****** Object:  StoredProcedure [dbo].[UserChoice]    Script Date: 4/25/2024 5:37:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[UserChoice]
    @choice INT,
    @amount money = NULL,
    @account_id INT = NULL,

    @account_header_id INT = NULL
AS
BEGIN
    DECLARE @resultMessage NVARCHAR(100);

	--=======================================================================================================================
       
        IF @choice = 1 AND( @account_id != 4  AND @account_id !=5)
        BEGIN
			DECLARE @Gaccount_header_id INT;
	        DECLARE @account_head_relations_id INT;

           INSERT INTO Account_Header(Account_Id,Account_HeadType_Id)
           VALUES ( @account_id, @choice);
		   SET @Gaccount_header_id = SCOPE_IDENTITY(); 
		   --print' record is insert'

		   INSERT INTO Account_Trans(Account_Header_Id,Account_ID,Amount)
		   VALUES(@Gaccount_header_id,4,@amount );

		   INSERT INTO Account_Trans(Account_Header_Id,Account_ID,Amount)
		   VALUES(@Gaccount_header_id,@account_id,@amount * -1);

		   INSERT INTO Account_Head_relations(Date)
		   VALUES(GETUTCDATE());
		   SET @account_head_relations_id = SCOPE_IDENTITY();

		   INSERT INTO Account_Header_trans(Account_Header_Id,Amount_A,Account_Head_relations_ID)
		   VALUES(@Gaccount_header_id,0,@account_head_relations_id);
           --SET @resultMessage = 'First case executed: Data inserted into Table1.';
		   print 'From choice :1'
        END
		--======================================================================================================
        ELSE IF @choice = 2
        BEGIN
		DECLARE @v_CAHID INT;
		DECLARE @2Gaccount_header_id INT;
		DECLARE @2Gr_id INT;

		SELECT @v_CAHID = Account_Id from Account_Header
		                  where Id=@account_header_id;
		SELECT @2Gr_id=Account_Head_relations_Id from Account_Header_trans
		                  Where Account_Header_Id=@account_header_id;

		Insert into Account_Header(Account_Id,Account_HeadType_Id)
		values(@v_CAHID,@choice);
		SET @2Gaccount_header_id=SCOPE_IDENTITY();

		Insert into Account_Trans(Account_Header_Id,Account_ID,Amount)
		values(@2Gaccount_header_id,4,@amount* -1);

		Insert into Account_Trans(Account_Header_Id,Account_ID,Amount)
		values(@2Gaccount_header_id,6,@amount);

		Insert into Account_Header_trans(Account_Header_Id,Amount_A,Account_Head_relations_Id)
		values(@2Gaccount_header_id,@amount,@2Gr_id);

		    --    print @v_CAHID;
            --SET @resultMessage = 'Second case executed: Data inserted into Table2.';
			print 'From choice :2'
        END
		--=============================================================================================
		ELSE IF @choice = 3 AND( @account_id != 4  AND @account_id !=5)
        BEGIN
		DECLARE @3Gaccount_header_id INT;
		DECLARE @3Gr_id INT;

		Insert into Account_Header(Account_Id,Account_HeadType_Id)
		Values(@account_id,@choice);
		SET @3Gaccount_header_id=SCOPE_IDENTITY();
		print'Insert record to Account_Header'

		Insert into Account_Trans(Account_Header_Id,Account_ID,Amount )
		Values(@3Gaccount_header_id,4,@amount * -1);
		print'Insert record to Account_Trans'

		Insert into Account_Trans(Account_Header_Id,Account_ID,Amount)
		Values(@3Gaccount_header_id,@account_id,@amount);
		print'Insert record to Account_Trans'

		Insert into Account_Head_relations(Date)
		Values(GETUTCDATE());
		SET @3Gr_id=SCOPE_IDENTITY();
		print'Insert record to Account_Head_relations'

		Insert into Account_Header_trans(Account_Header_Id,Amount_A,Account_Head_relations_Id)
		Values(@3Gaccount_header_id,0,@3Gr_id);

		print'Insert record to Account_Header_trans'
           
            --SET @resultMessage = 'Second case executed: Data inserted into Table2.';
			print 'From choice :3'
        END
		--=======================================================================================================
		ELSE IF @choice = 4
        BEGIN
		DECLARE @4Gaccount_id INT;
		DECLARE @4Gaccount_header_id INT;
		DECLARE @4Gr_id INT;

		SELECT @4Gaccount_id=Account_Id from  Account_Header 
		                     where Id=@account_header_id;
		SELECT @4Gr_id=Account_Head_relations_Id from Account_Header_trans
		               Where Account_Header_Id=@account_header_id;

           Insert into Account_Header(Account_Id,Account_HeadType_Id)
		   values(@4Gaccount_id,@choice);
		   SET @4Gaccount_header_id =SCOPE_IDENTITY();

		   Insert into Account_Trans (Account_Header_Id,Account_ID,Amount)
		   Values(@4Gaccount_header_id,4,@amount);

		   Insert into Account_Trans(Account_Header_Id,Account_ID,Amount)
		   Values(@4Gaccount_header_id,6,@amount * -1);

		   Insert into Account_Header_trans(Account_Header_Id,Amount_A,Account_Head_relations_Id)
		   Values(@4Gaccount_header_id,@amount,@4Gr_id);
		   
            --SET @resultMessage = 'Second case executed: Data inserted into Table2.';
			print 'From choice :4'
        END
		--===================================================================================================================
		ELSE IF @choice = 5 AND( @account_id != 4  AND @account_id !=5)
        BEGIN
		DECLARE @5Gaccount_header_id INT;
		DECLARE @5Gr_id INT;

           Insert into Account_Header(Account_Id,Account_HeadType_Id)
		   Values(@account_id,@choice);
           SET @5Gaccount_header_id=SCOPE_IDENTITY();

		   Insert into Account_Trans(Account_Header_Id,Account_ID,Amount)
		   Values(@5Gaccount_header_id,5,@amount * -1);

		   Insert into Account_Trans(Account_Header_Id,Account_ID,Amount)
		   Values(@5Gaccount_header_id,@account_id,@amount);

		   Insert into Account_Head_relations(Date)
		   Values(GETUTCDATE());
		   SET @5Gr_id=SCOPE_IDENTITY();

		   Insert into Account_Header_trans(Account_Header_Id,Amount_A,Account_Head_relations_Id)
		   Values(@5Gaccount_header_id,0,@5Gr_id);
            --SET @resultMessage = 'Second case executed: Data inserted into Table2.';
			print 'From choice :5'
        END
		ELSE IF @choice=6
		BEGIN
		  print 'From choice :6'
		END
        ELSE
        BEGIN
            SET @resultMessage = 'Invalid choice. No action taken.';
        END
		
     -- SELECT @resultMessage AS ResultMessage;
END;
