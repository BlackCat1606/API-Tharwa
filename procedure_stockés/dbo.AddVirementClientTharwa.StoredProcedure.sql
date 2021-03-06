USE [THARWA]
GO
/****** Object:  StoredProcedure [dbo].[AddVirementClientTharwa]    Script Date: 06/05/2018 16:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddVirementClientTharwa]  
   (@Montant decimal(19,4),@CompteDestinataire varchar(50)
	,@CompteEmmetteur varchar(50),@Motif varchar(MAX),@NomEmetteur varchar(20)
	,@numordre int, @Statut varchar(20),@NomDestinataire varchar(50),@PourcentageCommission decimal(19,4),
 @IdCommission int)

AS

BEGIN TRANSACTION; 
DECLARE @code varchar(50),
 @date Datetime,
 @dat varchar(12),
 @mois varchar(2),
 @annee varchar(4),
 @jour varchar(2),
 @heure varchar(2),
 @MontantCommission decimal(19,4), 
 @minute varchar(2);

set  @date=GETDATE();
set  @mois=SUBSTRING(CONVERT(varchar(8), @date,101),1,2);
set  @annee=YEAR(@date)
set  @jour=DAY(@date);
set  @heure=(SUBSTRING(CONVERT(varchar(8), @date, 108), 1, 2));
set  @minute=  (SUBSTRING(CONVERT(varchar(8), @date, 108), 4, 2));
set  @dat = CONCAT(@annee,@mois,@jour,@heure,@minute);
set  @code=Concat(@CompteEmmetteur,@CompteDestinataire,@dat);
--set @IdCommission=4;
set @MontantCommission= @PourcentageCommission*@Montant;

--Insertion de la commission //
INSERT [dbo].[Commission] ([CodeCommission],
			[Date],
			[Montant],
			[NumCompte]
) 
 VALUES (4,@date,@MontantCommission,@CompteEmmetteur) ;



--Insertin du virement
 INSERT [dbo].[Virement] ([Code]
           ,[Date]
           ,[Motif]
           ,[Statut]
           ,[Montant]
           ,[Justificatif]
           ,[NumOrdreVirement]
           ,[NomEmetteur]
           ,[CompteEmmetteur]
           ,[BanqueEmmeteur]
           ,[NomDestinataire]
           ,[CompteDestinataire]
           ,[BanqueDestinataire]
           ,[Type],[IdCommission])
 VALUES (@code, @date, @Motif,@Statut,@Montant,'NULL',@numordre
 ,@NomEmetteur,@CompteEmmetteur,'THW',@NomDestinataire,@CompteDestinataire,'THW',0,@IdCommission) ;


UPDATE [dbo].[Compte]
SET Balance -=@Montant+@MontantCommission
WHERE  Num=@CompteEmmetteur

UPDATE [dbo].[Compte]
SET Balance +=@Montant 
WHERE Num= @CompteDestinataire

COMMIT; 
GO
