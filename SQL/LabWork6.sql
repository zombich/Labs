--task1

CREATE TRIGGER TrChangeEmail
    ON Visitor
    AFTER UPDATE
    AS
	IF UPDATE(Email)
		INSERT INTO VisitorEmail(VisitorId,Email)
		SELECT VisitorId,Email
		FROM deleted;

--task2

CREATE TRIGGER TrDeleteFilm
    ON Film
    INSTEAD OF DELETE
    AS
	UPDATE Film
	SET IsDeleted=1
	WHERE FilmId IN (SELECT FilmId
					FROM deleted);

--task3

CREATE TRIGGER TrDeleteVisitor
    ON Visitor
    AFTER DELETE
    AS
	INSERT INTO DeletedVisitor(VisitorId,Phone,[Name],Birthday,Email)
	SELECT *
	FROM deleted;

--task4

CREATE TRIGGER TrInsertSession
    ON [Session]
    INSTEAD OF INSERT
    AS
	BEGIN
	
	INSERT INTO [Session] (FilmId,HallId,Price,StartDate,Is3D)
	SELECT FilmId,HallId,Price,StartDate,Is3D
	FROM inserted;

	UPDATE [Session]
	SET Price = 100
	WHERE [Session].Price < 100;
	END
	

--task 5

CREATE TRIGGER TrInsertTicket
    ON Ticket
    INSTEAD OF INSERT
    AS






