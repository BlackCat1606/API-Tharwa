USE [THARWA]
GO
/****** Object:  StoredProcedure [dbo].[historique_compte]    Script Date: 06/05/2018 16:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[historique_compte]
	(@userid varchar(50), @type int)
AS
BEGIN
	select
 case when (((date2) Is Null)) then date1  when (((date1) Is Null)) then date2 end as date , 
 case when (((type1) Is Null)) then type2  when (((type2) Is Null)) then type1 end as type ,
  case when (((montant1) Is Null)) then montant2 when (((montant2) Is Null)) then montant1 end as montant,
   case when (((commission1) Is Null)) then commission2  when (((commission2) Is Null)) then commission1 end as commission ,
   typeem,typedest,em_rec,Interlocuteur
from (
 (select Virement.Type as type1, Virement.Montant as montant1,Commission.Montant as commission1
,a.typeCompte as typeem , b.typeCompte as typedest  
,Virement.Date as date1
from Virement ,Compte,Commission,
(select TypeCompte, Code from Virement,Compte where CompteEmmetteur=Num) as a 
, ( select TypeCompte , Code from Virement,Compte where CompteDestinataire=Num)b 
where a.Code=b.Code and a.Code=Virement.Code and Compte.IdUser=@userid and (Compte.TypeCompte=@type )
and (CompteEmmetteur=Compte.Num ) and (Virement.NomEmetteur=Virement.NomDestinataire) 
and (Commission.Id=Virement.IdCommission))as c 
FULL OUTER JOIN 
(select  Virement.Type as type2, Virement.Montant as montant2  ,Commission.Montant as commission2
, case when CompteEmmetteur=Compte.Num then 0  
when  CompteDestinataire=Compte.Num then 1 end as em_rec ,
case when CompteEmmetteur=Compte.Num then NomDestinataire  
when  CompteDestinataire=Compte.Num then NomEmetteur end as Interlocuteur ,
Virement.Date as date2
from  Virement,Compte,Commission where ( (CompteEmmetteur=Compte.Num )or
 (CompteDestinataire=Compte.Num )) and 
 (Virement.NomEmetteur!=Virement.NomDestinataire) 
 and (Compte.IdUser=@userid) and (Compte.TypeCompte=@type )and (Commission.Id=Virement.IdCommission))as d
 ON date1=date2)  order by date;
END
GO
