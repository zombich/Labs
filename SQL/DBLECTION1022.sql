CREATE PROCEDURE dbo.GetGamesByPrice 
    @maxPrice decimal(16,2) 
  
AS
    SELECT *
	FROM Game
	WHERE Price<=@maxPrice

EXEC dbo.GetGamesByPrice 1500
EXECUTE dbo.GetGamesByPrice 1500

CREATE PROCEDURE dbo.AddCategory 
    @name nvarchar(100),
	@id int OUTPUT 
AS
    BEGIN
	INSERT INTO Category([Name])
	VALUES(@name);
	SET @id = SCOPE_IDENTITY();
	END

DECLARE	@id int
EXEC    dbo.AddCategory N'хоррор2', @id OUTPUT
SELECT	@id

SELECT * FROM Category;


CREATE FUNCTION [dbo].[GetGamesByPrices]
(
    @min decimal(16,2),
    @max decimal(16,2)
)
RETURNS TABLE AS RETURN
    SELECT *
	FROM Game
	WHERE Price <= @max AND Price >= @min

SELECT *
FROM dbo.GetGamesByPrices(50,500);