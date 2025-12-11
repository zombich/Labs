--task1

UPDATE dbo.Import1_User
SET lastenter = CASE
 WHEN CHARINDEX('/', lastenter) > 0 THEN
 FORMAT(TRY_CONVERT(DATE, lastenter, 101), 'dd.MM.yyyy') -- MM/dd/yyyy
 ELSE
 lastenter
 END -- если формат даты корректный END AS новый—толбец

 --task 3
 CREATE TABLE Import3_userRoles(
	RoleName NVARCHAR(20),
	IdUser int,
	[Login] NVARCHAR(20),
	[Password] NVARCHAR(20)
);

 DECLARE @xml XML = '
 <Users>
    <Role name="Admin">
        <User>
            <iduser>1</iduser>
            <login>admin1</login>
            <password>password123</password>
        </User>
        <User>
            <iduser>2</iduser>
            <login>admin2</login>
            <password>password456</password>
        </User>
    </Role>
    <Role name="Editor">
        <User>
            <iduser>3</iduser>
            <login>editor1</login>
            <password>editorpass1</password>
        </User>
        <User>
            <iduser>4</iduser>
            <login>editor2</login>
            <password>editorpass2</password>
        </User>
    </Role>
    <Role name="Viewer">
        <User>
            <iduser>5</iduser>
            <login>viewer1</login>
            <password>viewpass1</password>
        </User>
        <User>
            <iduser>6</iduser>
            <login>viewer2</login>
            <password>viewpass2</password>
        </User>
    </Role>
    <Role name="Guest">
        <User>
            <iduser>7</iduser>
            <login>guest1</login>
            <password>guestpass1</password>
        </User>
        <User>
            <iduser>8</iduser>
            <login>guest2</login>
            <password>guestpass2</password>
        </User>
        <User>
            <iduser>9</iduser>
            <login>guest3</login>
            <password>guestpass3</password>
        </User>
        <User>
            <iduser>10</iduser>
            <login>guest4</login>
            <password>guestpass4</password>
        </User>
    </Role>
</Users>
';

DECLARE @hDoc INT;
EXEC sp_xml_preparedocument @hDoc OUTPUT, @xml



INSERT INTO Import3_userRoles
SELECT *
FROM OPENXML(@hDoc, '/Users/Role/User')
WITH
(
	RoleName NVARCHAR(20) '../@name',
	IdUser int 'iduser',
	[Login] NVARCHAR(20) 'login',
	[Password] NVARCHAR(20) 'password'
);

SELECT * FROM Import3_userRoles;

SELECT * FROM Import3_User;

SELECT * FROM Import3_Role;
