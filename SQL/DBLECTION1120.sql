
CREATE FUNCTION GetGamesByPrice2
(
    @maxPrice int = 1000
)
RETURNS TABLE AS RETURN
(
	SELECT *
	FROM Game
	WHERE price < @maxPrice
)

SELECT *
FROM GetGamesByPrice2(1500);

CREATE FUNCTION GetGamesCount
(
    @categoryId int
)
RETURNS INT
AS
BEGIN
	DECLARE @count INT;
    SELECT @count = COUNT(*)
	FROM Game
	WHERE CategoryId = @categoryId;
	RETURN @count
END

SELECT dbo.GetGamesCount(1);

SELECT *, dbo.GetGamesCount(CategoryId) AS GamesCount
FROM Category;

DECLARE @id INT;
EXEC AddCategory 'coolcategory' , @id OUTPUT;
SELECT @id;

DECLARE	@id int

EXEC	[dbo].[AddCategory]
		N'zxcursed',
		@id OUTPUT

SELECT	@id as N'@id'