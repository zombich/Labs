
--CREATE TRIGGER »м€“риггера
--    ON таблица/представление
--    INSTEAD OF/AFTER команда/команды
--    AS
--    BEGIN
--	 действи€
--    END

CREATE TRIGGER TrGamesRowsCount
    ON Game
    AFTER DELETE,INSERT,UPDATE
    AS
    PRINT ' оличество измененных строк: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

UPDATE Game
SET PRICE+=1;


-- сохранение истории изменени€ цены
CREATE TRIGGER TrSavePrice
    ON Game
    AFTER UPDATE
    AS
		IF UPDATE(Price) --опционально
			INSERT INTO GamePrice(GameId,OldPrice)
			SELECT GameId,Price
			FROM deleted;
    
UPDATE Game
SET PRICE+=10
WHERE GameId=3;

--сохранение удаленных строк в отдельной таблице

CREATE TRIGGER TrSaveCategory
    ON Category
    AFTER DELETE
    AS
		INSERT INTO DeletedCategory(CategoryId,[Name])
		SELECT CategoryId,[Name]
		FROM deleted;

INSERT INTO CATEGORY([Name])
VALUES('рогалик'),('jRPG');

DELETE
FROM Category
WHERE CategoryId=5;

--триггер замен€ющий удаление на пометку об удалении

CREATE TRIGGER TrDeleteGame
    ON Game
    INSTEAD OF DELETE
    AS
		UPDATE Game
		SET IsDeleted=1
		WHERE GameId IN (SELECT GameId
						FROM deleted);

-- оформление продажи ключей игры со списанием данных из св€занной таблицы Game


CREATE TRIGGER TrAddSale
    ON Sale
    AFTER INSERT
    AS
		UPDATE Game
		SET KeysAmount -= inserted.KeysAmount
		FROM Game
			JOIN inserted ON Game.GameId=inserted.GameId;
    
	-- запрет уменьшени€ цены 

CREATE TRIGGER TrChangePrice
	ON Game
	AFTER UPDATE
	AS
		IF UPDATE(Price)
		IF EXISTS (SELECT * 
	           FROM inserted i
			     JOIN deleted d ON i.GameId=d.GameId
			   WHERE i.Price < d.Price)
		THROW 50000, 'Ќельз€ уменьшать цену', 1;

RAISERROR('test', 10,1)
RAISERROR('test', 11,1)

select * 
from sys.messages
where language_id=1049

--проверка имеющегос€ кол-ва ключей

disable trigger им€“риггер on таблица
enable trigger им€“риггера on таблица

disable trigger TrAddSale on Sale


CREATE TRIGGER TrAddSaleWithCheck
    ON Sale
    AFTER INSERT
    AS
	BEGIN
		-- объ€вление переменных
		DECLARE @gamesKeys SMALLINT;
		DECLARE @salesKeys SMALLINT;
		--присваивание значений
		SELECT @gamesKeys=g.KeysAmount, @salesKeys=i.KeysAmount
		FROM Game g
			JOIN inserted i ON g.GameId=i.GameId;

		IF (@gamesKeys < @salesKeys)
		THROW 50001, 'Ќедостаточно ключей игры', 1
		ELSE
			UPDATE Game
			SET KeysAmount -= inserted.KeysAmount
			FROM Game
				JOIN inserted ON Game.GameId=inserted.GameId;
	END

CREATE TRIGGER TrAddSaleWithCheck2
ON Sale
INSTEAD OF INSERT
AS
BEGIN
	-- объ€вление переменных
	DECLARE @gamesKeys SMALLINT;
	DECLARE @salesKeys SMALLINT;
	--присваивание значений
	SELECT @gamesKeys=g.KeysAmount, @salesKeys=i.KeysAmount
	FROM Game g
		JOIN inserted i ON g.GameId=i.GameId;

	IF (@gamesKeys < @salesKeys)
	THROW 50001, 'Ќедостаточно ключей игры', 1
	ELSE
	BEGIN
		INSERT INTO Sale(GAmeId,KeysAmount)
		SELECT GameId, KeysAmount
		FROM inserted;

		UPDATE Game
		SET KeysAmount -= inserted.KeysAmount
		FROM Game
			JOIN inserted ON Game.GameId=inserted.GameId;
	END
END