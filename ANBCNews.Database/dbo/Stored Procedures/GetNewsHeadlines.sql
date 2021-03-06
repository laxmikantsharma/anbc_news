﻿
CREATE PROCEDURE [dbo].[GetNewsHeadlines]
@NewsTypeID INT=0,
@SectionID INT=0,
@OnlyVideo BIT=0,
@PageNo INT=1
AS
BEGIN

DECLARE   @temp TABLE(NewsID INT) 
DECLARE @MaxNewsInSection INT ,@ImageSize varchar(15)='', @PageSize INT =10,@TotalRecored INT

IF @PageNo=0
	SET @PageNo=1

	IF(@SectionID>0)
	BEGIN
		SELECT @MaxNewsInSection=CASE WHEN MNS.MaxNewsInSection>0 THEN  MNS.MaxNewsInSection ELSE 200 END ,
		@ImageSize= CASE WHEN ISNULL( MNS.ImageSize,'')!='' THEN   MNS.ImageSize+'/' ELSE '' END 
		FROM [dbo].[MasterNewsSection] MNS WHERE  MNS.SectionID=@SectionID 

		  INSERT INTO @temp  SELECT TOP(@MaxNewsInSection) NH.[NewsID] 
		  FROM [dbo].[NewsHeader] NH 
			JOIN [dbo].[NewsSection] NS ON NH.NewsID =NS.NewsID
			WHERE NS.SectionID=@SectionID 
			AND (NH.IsVideo=@OnlyVideo OR @OnlyVideo=0)
			ORDER BY PublishedDate DESC
			SET @PageSize=1000
	END

	SELECT NH.[NewsID]
		  ,NH.[Headline]
		  ,NH.[NewsTypeID]
		  ,NH.[PublishedDate]
		  ,NH.[PageUrl]
		  ,NH.IsVideo
		  ,MIT.NewsType
		  ,CASE WHEN ISNULL(NI.Name,'')!='' THEN '/image/'+CAST(NH.[NewsID] AS Varchar(10))+'/'+@ImageSize+''+NI.Name ELSE '' END  ImagePath
		  ,NV.[Time] AS VideoTime
	  FROM [dbo].[NewsHeader] NH 
	  INNER JOIN [dbo].[MasterNewsType] MIT  ON NH.[NewsTypeID]=MIT.ID
	  LEFT JOIN [dbo].NewsImage NI  ON NI.[NewsID]=NH.[NewsID]
	  LEFT JOIN [dbo].NewsVideo NV  ON NV.[NewsID]=NH.[NewsID]
	  WHERE 
	  (NH.NewsTypeID=@NewsTypeID OR @NewsTypeID=0)
	  AND (NH.NewsID IN(SELECT NS.NewsID FROM @temp NS) OR @SectionID=0)
	  AND (NH.IsVideo=@OnlyVideo OR @OnlyVideo=0)
	  AND  NH.IsPublished=1 
	  ORDER BY NH.PublishedDate DESC
	   OFFSET (@PageNo -1) * @PageSize ROWS
	  FETCH NEXT @PageSize ROWS ONLY
END