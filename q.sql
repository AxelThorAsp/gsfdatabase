.header on
.mode column
.nullvalue null
--2021
--Spurning 1.
.system echo '*** Spurning 1 ***'
--a
.system echo '1.a'
SELECT title, year
FROM Movie
ORDER BY title
LIMIT 1;

.system echo '1.b'
SELECT name
FROM MovieExec
WHERE NOT EXISTS
(SELECT * FROM Movie WHERE producerC = cert);

.system echo '1.c'
SELECT s.name
FROM Studio s
WHERE NOT EXISTS
    (SELECT *
     FROM Movie m1
     WHERE EXISTS
     (SELECT *
      FROM starsIn
      WHERE starName = 'Jack Nicholson'
      AND m1.producerC = s.presC
      AND m1.title = movieTitle
      AND m1.year = movieYear
     )
    );

.system echo '-----------'
select name from Studio where not exists
	(select * from Movie, StarsIn where
		name = studioName and
		title = movieTitle and
		year = movieYear and
		starName = 'Jack Nicholson');

--Spurning 2
.system echo '*** Spurning 2 ***'
.system echo '2.a'
.system echo '--------------------'
SELECT m1.title
FROM Movie m1, Movie m2
WHERE m1.title = m2.title
AND m1.year < m2.year;

.system echo '2.b'
.system echo '--------------------'
select name from MovieStar as m1 where
	not exists
	(select name from MovieStar as m2 where
		m2.gender = 'F' and
		m1.name <> m2.name and
		not exists
		(select * from StarsIn as s1, StarsIn as s2 where
			s1.movieTitle = s2.movieTitle and
			s1.movieYear = s2.movieYear and
			s1.starName = m1.name and
			s2.starName = m2.name));
.system echo '2.c'
.system echo '--------------------'
SELECT starName, SUM(length)
FROM StarsIn
LEFT JOIN Movie
ON movieTitle = title
AND movieYear = year
GROUP BY starName
HAVING COUNT(*) >= 2;

.system echo '3.a'
.system echo '--------------------'

SELECT me.name, IFNULL(SUM(length),0) , COUNT(title) as numberOfMovies
FROM MovieExec me
LEFT JOIN Movie m
ON m.producerC = me.cert
GROUP BY me.cert
;

.system echo '3.b'
.system echo '---------------------'
SELECT s.name , s.address
FROM Studio s
LEFT JOIN Movie m
ON m.studioName = s.name
GROUP BY s.name
ORDER BY SUM(m.length) DESC LIMIT 1;

.system echo '3.c'
.system echo '---------------------'
SELECT name, SUM(length)
FROM MovieStar
LEFT JOIN StarsIn
ON starName = name
JOIN Movie
ON (title = movieTitle AND movieYear = year)
GROUP BY name
ORDER BY SUM(length) DESC LIMIT 1;


.system echo '4.a'
.system echo '---------------------'

SELECT DISTINCT s1.starName
FROM StarsIn s1
WHERE
(SELECT COUNT(*) FROM StarsIn s2
     WHERE s2.movieTitle
     LIKE 'Star Trek%'
     AND s2.starName = s1.starName)
=
(SELECT COUNT(*) FROM Movie WHERE title LIKE 'Star Trek%');



.system echo '5.a'
select starName from StarsIn, Movie where
	movieTitle = title and
	movieYear = year
	group by StarName
	order by count(distinct producerC) desc limit 1;
