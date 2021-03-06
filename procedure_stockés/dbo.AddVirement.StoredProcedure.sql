USE [THARWA]
GO
/****** Object:  StoredProcedure [dbo].[AddVirement]    Script Date: 06/05/2018 16:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddVirement]  
    (@Montant decimal(19,4),@CompteDestinataire varchar(50),@CompteEmmetteur varchar(50))
AS
 INSERT [dbo].[Virement] ([Montant],[CompteEmmetteur],[CompteDestinataire])
 VALUES (@Montant, @CompteDestinataire, @CompteEmmetteur)
UPDATE [dbo].[Compte]
SET Balance -=@Montant  
WHERE  Num=@CompteEmmetteur

UPDATE [dbo].[Compte]
SET Balance +=@Montant 
WHERE Num= @CompteDestinataire

GO
