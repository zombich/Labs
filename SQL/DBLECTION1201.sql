EXEC sp_adduser 'login2', 'user2';

EXEC sp_addrolemember 'db_datareader', 'user2';
EXEC sp_addrolemember 'db_datawriter', 'user2';

declare @tableName NVARCHAR(50);
set @tableName = 'category';
EXEC('select * from ['+@tableName+'] where name like ''rpg''');

-- GRANT / DENY / REVOKE

