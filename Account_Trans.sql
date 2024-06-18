USE [bank_Validation]
GO

/****** Object:  Table [dbo].[Account_Trans]    Script Date: 6/18/2024 7:59:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Account_Trans](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Account_Header_Id] [int] NOT NULL,
	[Account_ID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Account_Trans]  WITH CHECK ADD  CONSTRAINT [FK_Account_Trans_Account_Header_Id] FOREIGN KEY([Account_Header_Id])
REFERENCES [dbo].[Account_Header] ([ID])
GO

ALTER TABLE [dbo].[Account_Trans] CHECK CONSTRAINT [FK_Account_Trans_Account_Header_Id]
GO

ALTER TABLE [dbo].[Account_Trans]  WITH CHECK ADD  CONSTRAINT [FK_Account_Trans_Account_Id] FOREIGN KEY([Account_ID])
REFERENCES [dbo].[Account] ([ID])
GO

ALTER TABLE [dbo].[Account_Trans] CHECK CONSTRAINT [FK_Account_Trans_Account_Id]
GO


