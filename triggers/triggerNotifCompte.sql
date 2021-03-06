USE [THARWA]
GO
/****** Object: Trigger [dbo].[notification_compte_] Script Date: 05/05/2018 15:07:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter TRIGGER [dbo].[notification_compte_] ON [dbo].[Compte]
FOR UPDATE
AS
declare @newState int;
declare @oldState int;
declare @idclient varchar(50);
declare @date  datetime = GETDATE();
declare @numCompte varchar(50);
select  @newState=i.Etat from inserted i;
select  @oldState=d.Etat from deleted d;
select  @idclient = i.IdUser from inserted i;
select  @numCompte = i.Num from inserted i;
if (@newState != @oldState)
begin
insert into [dbo].[NotificationsCompte] ([IdClient],[Date] ,[NumCompte],[Etat])
    VALUES  (@idclient,@date,@numCompte,@newState);
end;
GO
ALTER TABLE [dbo].[Compte] ENABLE TRIGGER [notification_compte_]
GO