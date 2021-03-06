USE [THARWA]
GO
/****** Object:  StoredProcedure [dbo].[commission_mensuelle]    Script Date: 06/05/2018 16:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[commission_mensuelle] 
 (@Montant decimal(19,4),@Montant2 decimal(19,4), @Montant3 decimal(19,4),@Montant4 decimal(19,4))
 -- le montant  represente le tarif de commission du compte courant 
 -- le montant 2  represente le tarif de commission du compte epargne 
 -- le montant 3 represente la conversion de 200 da en EUR
 -- le montant 4 represente la conversion de 200 da en USD
	
AS
BEGIN TRANSACTION;  
DECLARE @name VARCHAR(50) -- numCompte 
DECLARE @bal decimal(19,4) -- balance
DECLARE @diff   decimal(19,4) 


--Commission mensuelles des frais de gestion des comptes courants
	

	
    DECLARE comm_cursor CURSOR   FOR select Num,Balance from Compte where TypeCompte=0 and Etat=1 and Num!='THW000001DZD' and Num!='THW000002DZD';   
    OPEN comm_cursor  
    FETCH NEXT FROM comm_cursor INTO @name ,@bal; 
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
         insert into Commission ([CodeCommission] ,[Date],[Montant],[NumCompte]) VALUES (7,GETDATE(),@Montant,@name);
	     set @diff=@bal-@Montant
		 if (@diff>=0) 
		   begin 
	          
			  UPDATE [dbo].[Compte] SET Balance +=@Montant WHERE Num='THW000001DZD' ;
		   end 
		   else
		    begin 
		     if (@diff<=-@Montant)
			    begin 
		            UPDATE [dbo].[Compte] SET Balance +=@Montant WHERE Num='THW000002DZD' ;
			    end 
			  else 
			       begin 
				    UPDATE [dbo].[Compte] SET Balance +=@bal WHERE Num='THW000001DZD' ;
		            UPDATE [dbo].[Compte] SET Balance +=-@diff WHERE Num='THW000002DZD' ;
			       end 
		  end 
		  UPDATE [dbo].[Compte] SET Balance -=@Montant WHERE Num= @name ;
		 FETCH NEXT FROM comm_cursor INTO @name ,@bal; 
    END 

    CLOSE comm_cursor  ;
    DEALLOCATE comm_cursor;



--Commission mensuelles des frais de gestion des comptes epargnes
	DECLARE comm_cursor CURSOR   FOR select Num,Balance from Compte where TypeCompte=1 and Etat=1 ;   
    OPEN comm_cursor  
    FETCH NEXT FROM comm_cursor INTO @name ,@bal; 
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
         insert into Commission ([CodeCommission] ,[Date],[Montant],[NumCompte]) VALUES (8,GETDATE(),@Montant2,@name);
	     set @diff=@bal-@Montant2
		 if (@diff>=0) 
		   begin 
			  UPDATE [dbo].[Compte] SET Balance +=@Montant2 WHERE Num='THW000001DZD' ;
		   end 
		   else
		    begin 
		     if (@diff<=-@Montant2)
			    begin 
		            UPDATE [dbo].[Compte] SET Balance +=@Montant2 WHERE Num='THW000002DZD' ;
			    end 
			  else 
			       begin 
				    UPDATE [dbo].[Compte] SET Balance +=@bal WHERE Num='THW000001DZD' ;
		            UPDATE [dbo].[Compte] SET Balance +=-@diff WHERE Num='THW000002DZD' ;
			       end 
		  end 
		  UPDATE [dbo].[Compte] SET Balance -=@Montant2 WHERE Num= @name ;
		 FETCH NEXT FROM comm_cursor INTO @name ,@bal; 
    END 

    CLOSE comm_cursor  ;
    DEALLOCATE comm_cursor;


--Commission mensuelles des frais de gestion des comptes devise EUR
	DECLARE comm_cursor CURSOR   FOR select Num,Balance from Compte where TypeCompte=2 and Etat=1 ;   
    OPEN comm_cursor  
    FETCH NEXT FROM comm_cursor INTO @name ,@bal; 
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
         insert into Commission ([CodeCommission] ,[Date],[Montant],[NumCompte]) VALUES (9,GETDATE(),@Montant3,@name);
	     set @diff=@bal-@Montant3
		 if (@diff>=0) 
		   begin 
			  UPDATE [dbo].[Compte] SET Balance +=@Montant3 WHERE Num='THW000001DZD' ;
		   end 
		   else
		    begin 
		     if (@diff<=-@Montant3)
			    begin 
		            UPDATE [dbo].[Compte] SET Balance +=@Montant3 WHERE Num='THW000002DZD' ;
			    end 
			  else 
			       begin 
				    UPDATE [dbo].[Compte] SET Balance +=@bal WHERE Num='THW000001DZD' ;
		            UPDATE [dbo].[Compte] SET Balance +=-@diff WHERE Num='THW000002DZD' ;
			       end 
		  end 
		  UPDATE [dbo].[Compte] SET Balance -=@Montant3 WHERE Num= @name ;
		 FETCH NEXT FROM comm_cursor INTO @name ,@bal; 
    END 

    CLOSE comm_cursor  ;
    DEALLOCATE comm_cursor;

--Commission mensuelles des frais de gestion des comptes devise USD 
	DECLARE comm_cursor CURSOR   FOR select Num,Balance from Compte where TypeCompte=3 and Etat=1 ;   
    OPEN comm_cursor  
    FETCH NEXT FROM comm_cursor INTO @name ,@bal; 
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
         insert into Commission ([CodeCommission] ,[Date],[Montant],[NumCompte]) VALUES (9,GETDATE(),@Montant4,@name);
	     set @diff=@bal-@Montant4
		 if (@diff>=0) 
		   begin 
			  UPDATE [dbo].[Compte] SET Balance +=@Montant3 WHERE Num='THW000001DZD' ;
		   end 
		   else
		    begin 
		     if (@diff<=-@Montant4)
			    begin 
		            UPDATE [dbo].[Compte] SET Balance +=@Montant4 WHERE Num='THW000002DZD' ;
			    end 
			  else 
			       begin 
				    UPDATE [dbo].[Compte] SET Balance +=@bal WHERE Num='THW000001DZD' ;
		            UPDATE [dbo].[Compte] SET Balance +=-@diff WHERE Num='THW000002DZD' ;
			       end 
		  end 
		  UPDATE [dbo].[Compte] SET Balance -=@Montant4 WHERE Num= @name ;
		 FETCH NEXT FROM comm_cursor INTO @name ,@bal; 
    END 

    CLOSE comm_cursor  ;
    DEALLOCATE comm_cursor;
commit;
GO
