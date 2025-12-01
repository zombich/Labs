--task1

EXEC sp_adduser 'login1', 'user1';
EXEC sp_adduser 'login2', 'user2';

CREATE USER user3 FOR LOGIN login3;
CREATE USER user4 FOR LOGIN login4;


USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [ispp3104]    Script Date: 01.12.2025 10:10:46 ******/
CREATE LOGIN [ispp3104] WITH PASSWORD=N'CRwJaWa0hMfnDQcftsjlbfBNQa1pVDhzidLGbv8hOxY=', --пароль выводится не в исходном виде, потому что он сгенерирован случайно для безопасности
DEFAULT_DATABASE=[ispp3104], 
DEFAULT_LANGUAGE=[русский],
CHECK_EXPIRATION=OFF, -- проверка срока пароля, если он истек то попросит изменить пароль 
CHECK_POLICY=OFF -- проверка пароля на удовлетворение условиям
GO

ALTER LOGIN [ispp3104] DISABLE
GO

EXEC sp_addlogin 'isppLogin312', 'Password!';
EXEC sp_addsrvrolemember 'isppLogin312', 'securityadmin';

--task2

EXEC sp_addrolemember 'db_owner', 'user1';

EXEC sp_addrolemember 'db_datareader', 'user2';
EXEC sp_addrolemember 'db_datawriter', 'user2';

EXEC sp_droprolemember 'db_datawriter','user2';

--task3

GRANT DELETE ON dbo.Ticket TO user3;
GRANT INSERT ON dbo.Ticket TO user3;

GRANT SELECT ON OBJECT::dbo.Visitor TO user4;
GRANT UPDATE ON OBJECT::dbo.Visitor ([Name], [Email]) TO user4;

DENY SELECT ON OBJECT::dbo.Visitor TO user2;
DENY UPDATE ON OBJECT::dbo.Visitor ([Name]) TO user4;

--task4

DECLARE @loginName NVARCHAR(50), @number INT
SET @number = 1;
WHILE @number <= 4
	BEGIN
		set @loginName = 'reader'+ CAST(@number AS NVARCHAR(1));
		EXEC('CREATE USER [' + @loginName + '] FOR LOGIN [' + @loginName + '] WITH DEFAULT_SCHEMA=[ispp3104]');
		EXEC sp_addrolemember 'db_datareader', @loginName;
		SET @number += 1;
	END

--task5