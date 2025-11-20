--task 1
CREATE FUNCTION GetUserPoints
(
    @userId int
)
RETURNS INT
AS
BEGIN
	DECLARE @points int;
	SELECT @points = SUM(Film.Duration)
	FROM Ticket INNER JOIN
		Visitor ON Ticket.VisitorId = Visitor.VisitorId INNER JOIN
		Session ON Ticket.SessionId = Session.SessionId INNER JOIN
		Film ON Session.FilmId = Film.FilmId
	WHERE (Ticket.VisitorId = @userId);
	RETURN ISNULL(@points,0);
END

DROP FUNCTION dbo.GetUserPoints;

SELECT *, dbo.GetUserPoints(VisitorId) AS Points
FROM Visitor;

--task 2

CREATE FUNCTION GetFilmsByGenre
(
	@genreName nvarchar(50)
)
RETURNS TABLE AS RETURN
(
SELECT        Film.FilmId, Film.Name, STRING_AGG(Genre.Name, ', ') AS Genres
FROM Film INNER JOIN
	FilmGenre ON Film.FilmId = FilmGenre.FilmId INNER JOIN
	Genre ON FilmGenre.GenreId = Genre.GenreId
WHERE (Genre.Name IN (@genreName))
GROUP BY Film.FilmId, Film.Name
)

DROP FUNCTION dbo.GetFilmsByGenre;

SELECT *
FROM dbo.GetFilmsByGenre('Мультфильм');


--task 3
CREATE PROCEDURE AddTicket
    @phone char(10),
    @sessionId int,
	@row tinyint,
	@seat tinyint,
	@ticketId int OUTPUT
AS
BEGIN	
    INSERT INTO Ticket(VisitorId,SessionId,[Row],Seat)
	SELECT  VisitorId, @sessionId, @row, @seat
	FROM Visitor
	WHERE Visitor.Phone = @phone;
	SET @ticketId = SCOPE_IDENTITY();
END

DROP PROCEDURE AddTicket;

DECLARE	@ticketId int

EXEC	[dbo].[AddTicket]
		@phone = '1849104951',
		@sessionId = 9,
		@row = 2,
		@seat = 3,
		@ticketId = @ticketId OUTPUT

SELECT	@ticketId as TicketId;

--task 4
CREATE PROCEDURE AddHall
    @cinema nvarchar(50) = 'Титан-Арена',
	@hallNumber tinyint,
	@rowsCount tinyint,
	@seatsCount tinyint
AS
	BEGIN
		IF 
		(EXISTS(
			SELECT * 
			FROM Hall 
			WHERE Cinema = @cinema AND HallNumber = @hallNumber
		))
	BEGIN
		UPDATE Hall
		SET SeatsCount = @seatsCount,
			RowsCount = @rowsCount
		WHERE Cinema = @cinema AND HallNumber = @hallNumber;
	END

	ELSE
		BEGIN
			INSERT INTO Hall(Cinema, HallNumber, RowsCount,SeatsCount)
			VALUES(@cinema, @hallNumber, @rowsCount,@seatsCount);
		END
	END

DROP PROCEDURE dbo.AddHall;

EXEC	[dbo].[AddHall]
		@cinema = 'Макси',
		@hallNumber = 13,
		@rowsCount = 19,
		@seatsCount = 21;