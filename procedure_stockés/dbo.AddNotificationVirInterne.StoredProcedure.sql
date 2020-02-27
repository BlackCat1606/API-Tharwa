USE [THARWA]
GO
/****** Object:  StoredProcedure [dbo].[AddNotificationVirInterne]    Script Date: 06/05/2018 16:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNotificationVirInterne]  
   (@CompteDestinataire varchar(50)
	,@CompteEmmetteur varchar(50))

AS

BEGIN TRANSACTION; 
DECLARE 
 @date Datetime,
 @dat varchar(12),
 @mois varchar(2),
 @annee varchar(4),
 @jour varchar(2),
 @heure varchar(2),
 @minute varchar(2),
 @CodeNotif varchar(37);
set  @date=GETDATE();
set  @mois=SUBSTRING(CONVERT(varchar(8), @date,101),1,2)
set  @annee=YEAR(@date);
set  @jour=DAY(@date);
set  @heure=(SUBSTRING(CONVERT(varchar(8), @date, 108), 1, 2));
set  @minute=  (SUBSTRING(CONVERT(varchar(8), @date, 108), 4, 2));
set  @dat = CONCAT(@annee,@mois,@jour,@heure,@minute);
set  @CodeNotif=Concat(@CompteEmmetteur,@CompteDestinataire,@dat);

 INSERT [dbo].[Notifications] ([CodeNotif]
           ,[Type]
           ,[Etat]
           )
 VALUES (@CodeNotif, 0,0) ;
 COMMIT; 
GO
