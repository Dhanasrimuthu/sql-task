USE [bank_Validation]
GO

/****** Object:  Table [dbo].[Account_Header_trans]    Script Date: 6/18/2024 7:57:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Account_Header_trans](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Account_Header_Id] [int] NOT NULL,
	[Amount_A] [money] NULL,
	[Account_Head_relations_Id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Account_Header_trans]  WITH CHECK ADD  CONSTRAINT [F_key_Account_Head_relations_id] FOREIGN KEY([Account_Head_relations_Id])
REFERENCES [dbo].[Account_Head_relations] ([ID])
GO

ALTER TABLE [dbo].[Account_Header_trans] CHECK CONSTRAINT [F_key_Account_Head_relations_id]
GO

ALTER TABLE [dbo].[Account_Header_trans]  WITH CHECK ADD  CONSTRAINT [FK_Account_Header_trans_Account_Header_Id] FOREIGN KEY([Account_Header_Id])
REFERENCES [dbo].[Account_Header] ([ID])
GO

ALTER TABLE [dbo].[Account_Header_trans] CHECK CONSTRAINT [FK_Account_Header_trans_Account_Header_Id]
GO


