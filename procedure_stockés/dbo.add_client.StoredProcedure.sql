USE [THARWA]
GO
/****** Object:  StoredProcedure [dbo].[add_client]    Script Date: 06/05/2018 16:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[add_client]  

	(@Id varchar(50),@password varchar(MAX),@username varchar(50),@numTel varchar(50),@Nom varchar(20)
	,@Prenom varchar(20), @Adresse varchar(90),@Fonction varchar(20),@Photo varchar(max),@Type int,@num varchar(50)
	,@Date datetime)

AS

BEGIN TRANSACTION T1; 

/*set @Montantcom=@Montant*0.02 ; */
insert into Users ([userId],[type] ,[password],[username],[numTel])
    VALUES  (@Id,2,@password,@username,@numTel);
insert into Client ([IdUser],[Nom],[Prenom],[Adresse],[Fonction],[Photo],[Type])
    VALUES (@Id,@Nom,@Prenom,@Adresse,@Fonction,@Photo,@Type);
insert into Compte ([Num],[Balance],[DateCreation],[CodeMonnaie],[IdUser],[Etat],[TypeCompte])
    VALUES (@num,0,@Date,'DZD',@Id,0,0);

COMMIT TRANSACTION T1; 

GO
