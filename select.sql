--1. количество исполнителей в каждом жанре;
SELECT 
	s."name" as style_name,
	count(ss.singer_id) as count_singers  
FROM
	styles s
	INNER JOIN singers_styles ss 
	ON s.style_id = ss.style_id
GROUP BY 
	s.style_id 
ORDER BY 
	style_name

--2. количество треков, вошедших в альбомы 2019-2020 годов;
SELECT 
	count(t.track_id) AS count_tracks
FROM
	albums a
INNER JOIN tracks t  
	ON
	a.album_id = t.album_id
WHERE 
	a."year" BETWEEN 2019 AND 2020

--3. средняя продолжительность треков по каждому альбому;
SELECT
	a."name" as album_name,
	avg(t.duration) as avg_duration  
FROM
	albums a 
	INNER JOIN tracks t  
	ON a.album_id  = t.album_id
GROUP BY 
	a.album_id
ORDER BY 
	album_name

--4. все исполнители, которые не выпустили альбомы в 2020 году;
SELECT 
	s.nickname
FROM
	singers s
WHERE
	s.singer_id NOT IN (
		SELECT
			sa.singer_id
		FROM 
			albums a
			INNER JOIN singers_albums sa
				ON a.album_id = sa.album_id
				AND a."year" = 2020)
ORDER BY 
	nickname 

--5. названия сборников, в которых присутствует конкретный исполнитель (выберите сами);
SELECT DISTINCT 
	c."name" as coll_name,
	c."year" as coll_year 
FROM
	collections c
	INNER JOIN tracks_collections tc 
	ON c.collection_id = tc.collection_id 
	INNER JOIN tracks t 
	ON tc.track_id = t.track_id 
	INNER JOIN singers_albums sa 
	ON t.album_id = sa.album_id 
WHERE 
	sa.singer_id = 4 -- Mylene Farmer
ORDER BY 
	c."name" 
	
--6. название альбомов, в которых присутствуют исполнители более 1 жанра;
SELECT 
	a."name" 
FROM 
	albums a 
	INNER JOIN singers_albums sa 
	ON a.album_id = sa.album_id 
	INNER JOIN singers s 
	ON sa.singer_id = s.singer_id 
	INNER JOIN singers_styles ss 
	ON s.singer_id = ss.singer_id
GROUP BY 
	a.album_id  
HAVING 
	count(ss.style_id)>1 
	
--7. наименование треков, которые не входят в сборники;
SELECT 
	t."name"
FROM 
	tracks t 
	LEFT JOIN tracks_collections tc 
	ON t.track_id = tc.track_id 
WHERE
	tc.track_id IS NULL 
	
--8. исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
SELECT 
	s.nickname,
	t.duration 
FROM
	singers s 
	INNER JOIN singers_albums sa 
	ON s.singer_id = sa.singer_id 
	INNER JOIN tracks t 
	ON t.album_id = sa.album_id
WHERE
	t.duration IN (SELECT min(duration) FROM tracks)
	
--9. название альбомов, содержащих наименьшее количество треков.
SELECT
	a."name" as album_name,
	count(t.track_id) as count_tracks
FROM 
	albums a
	INNER JOIN tracks t 
	ON a.album_id = t.album_id  
GROUP BY 
	a.album_id 
HAVING 
	count(t.track_id) IN (
		SELECT
			count(t.track_id) as c
		FROM
			tracks t
		GROUP BY
			t.album_id 
		ORDER BY
			c
		LIMIT 1)
