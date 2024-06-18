USE [bank_Validation]
GO

/****** Object:  Table [dbo].[Account_Header]    Script Date: 6/18/2024 7:56:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Account_Header](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Account_Id] [int] NOT NULL,
	[Account_HeadType_Id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Account_Header]  WITH CHECK ADD  CONSTRAINT [FK_Account_Header_Account_HeadType_Id] FOREIGN KEY([Account_HeadType_Id])
REFERENCES [dbo].[Account_HeadType] ([ID])
GO

ALTER TABLE [dbo].[Account_Header] CHECK CONSTRAINT [FK_Account_Header_Account_HeadType_Id]
GO

ALTER TABLE [dbo].[Account_Header]  WITH CHECK ADD  CONSTRAINT [FK_Account_Header_Account_Id] FOREIGN KEY([Account_Id])
REFERENCES [dbo].[Account] ([ID])
GO

ALTER TABLE [dbo].[Account_Header] CHECK CONSTRAINT [FK_Account_Header_Account_Id]
GO


