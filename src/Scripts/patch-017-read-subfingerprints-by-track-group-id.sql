USE FingerprintsDb
GO 
if not exists(select * from sys.columns 
   where Name = N'GroupId' and Object_ID = Object_ID(N'Tracks'))
begin
   	alter table Tracks add GroupId varchar(20)
end
go
-- INSERT TRACK
IF OBJECT_ID('sp_InsertTrack','P') IS NOT NULL
	DROP PROCEDURE sp_InsertTrack
GO
CREATE PROCEDURE sp_InsertTrack
	@ISRC VARCHAR(50),
	@Artist VARCHAR(255),
	@Title VARCHAR(255),
	@Album VARCHAR(255),
	@ReleaseYear INT,
	@TrackLengthSec INT,
	@GroupId VARCHAR(20)
AS
INSERT INTO Tracks (
	ISRC,
	Artist,
	Title,
	Album,
	ReleaseYear,
	TrackLengthSec,
	GroupId
	) OUTPUT inserted.Id
VALUES
(
 	@ISRC, @Artist, @Title, @Album, @ReleaseYear, @TrackLengthSec, @GroupId
);

GO
IF OBJECT_ID('sp_ReadSubFingerprintsByHashBinHashTableAndThresholdWithGroupId','P') IS NOT NULL
	DROP PROCEDURE sp_ReadSubFingerprintsByHashBinHashTableAndThresholdWithGroupId
GO
CREATE PROCEDURE sp_ReadSubFingerprintsByHashBinHashTableAndThresholdWithGroupId
	@HashBin_1 BIGINT, @HashBin_2 BIGINT, @HashBin_3 BIGINT, @HashBin_4 BIGINT, @HashBin_5 BIGINT, 
	@HashBin_6 BIGINT, @HashBin_7 BIGINT, @HashBin_8 BIGINT, @HashBin_9 BIGINT, @HashBin_10 BIGINT,
	@HashBin_11 BIGINT, @HashBin_12 BIGINT, @HashBin_13 BIGINT, @HashBin_14 BIGINT, @HashBin_15 BIGINT, 
	@HashBin_16 BIGINT, @HashBin_17 BIGINT, @HashBin_18 BIGINT, @HashBin_19 BIGINT, @HashBin_20 BIGINT,
	@HashBin_21 BIGINT, @HashBin_22 BIGINT, @HashBin_23 BIGINT, @HashBin_24 BIGINT, @HashBin_25 BIGINT,
	@Threshold INT, @GroupId VARCHAR(20)
AS
SELECT SubFingerprints.Id, SubFingerprints.TrackId, SubFingerprints.Signature
FROM SubFingerprints INNER JOIN
	( SELECT Hashes.SubFingerprintId as SubFingerprintId FROM 
	   (
	    SELECT * FROM HashTable_1 WHERE HashBin = @HashBin_1
		UNION ALL
		SELECT * FROM HashTable_2 WHERE HashBin = @HashBin_2
		UNION ALL
		SELECT * FROM HashTable_3 WHERE HashBin = @HashBin_3
		UNION ALL
		SELECT * FROM HashTable_4 WHERE HashBin = @HashBin_4
		UNION ALL
		SELECT * FROM HashTable_5 WHERE HashBin = @HashBin_5
		UNION ALL
		SELECT * FROM HashTable_6 WHERE HashBin = @HashBin_6
		UNION ALL
		SELECT * FROM HashTable_7 WHERE HashBin = @HashBin_7
		UNION ALL
		SELECT * FROM HashTable_8 WHERE HashBin = @HashBin_8
		UNION ALL
		SELECT * FROM HashTable_9 WHERE HashBin = @HashBin_9
		UNION ALL
		SELECT * FROM HashTable_10 WHERE HashBin = @HashBin_10
		UNION ALL
		SELECT * FROM HashTable_11 WHERE HashBin = @HashBin_11
		UNION ALL
		SELECT * FROM HashTable_12 WHERE HashBin = @HashBin_12
		UNION ALL
		SELECT * FROM HashTable_13 WHERE HashBin = @HashBin_13
		UNION ALL
		SELECT * FROM HashTable_14 WHERE HashBin = @HashBin_14
		UNION ALL
		SELECT * FROM HashTable_15 WHERE HashBin = @HashBin_15
		UNION ALL
		SELECT * FROM HashTable_16 WHERE HashBin = @HashBin_16
		UNION ALL
		SELECT * FROM HashTable_17 WHERE HashBin = @HashBin_17
		UNION ALL
		SELECT * FROM HashTable_18 WHERE HashBin = @HashBin_18
		UNION ALL
		SELECT * FROM HashTable_19 WHERE HashBin = @HashBin_19
		UNION ALL
		SELECT * FROM HashTable_20 WHERE HashBin = @HashBin_20
		UNION ALL
		SELECT * FROM HashTable_21 WHERE HashBin = @HashBin_21
		UNION ALL
		SELECT * FROM HashTable_22 WHERE HashBin = @HashBin_22
		UNION ALL
		SELECT * FROM HashTable_23 WHERE HashBin = @HashBin_23
		UNION ALL
		SELECT * FROM HashTable_24 WHERE HashBin = @HashBin_24
		UNION ALL
		SELECT * FROM HashTable_25 WHERE HashBin = @HashBin_25
	  ) AS Hashes
	 GROUP BY Hashes.SubFingerprintId
	 HAVING COUNT(Hashes.SubFingerprintId) >= @Threshold
	) AS Thresholded ON SubFingerprints.Id = Thresholded.SubFingerprintId	
INNER JOIN Tracks ON SubFingerprints.TrackId = Tracks.Id AND Tracks.GroupId = @GroupId
GO