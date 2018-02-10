
-- Q1 returns (name,father,mother)
SELECT personb.name, personb.mother, personb.father
FROM person AS personb
WHERE dod < (SELECT MIN(dod)
FROM person
WHERE person.name = personb.father
)AND
dod < (SELECT MIN(dod)
FROM person
WHERE person.name = personb.mother
)
ORDER BY personb.name ASC
;


-- Q2 returns (name)
SELECT DISTINCT name
FROM
(SELECT name
FROM monarch
WHERE house IS NOT NULL
UNION
SELECT name
FROM prime_minister) AS t
ORDER BY name ASC
;



-- Q3 returns (name)
SELECT monarch.name
FROM monarch
JOIN person
on person.name = monarch.name
WHERE monarch.coronation < person.dod
ORDER BY name ASC
;

-- Q4 returns (house,name,accession)
SELECT monarcha.name, monarcha.house, monarcha.accession
FROM monarch AS monarcha
WHERE monarcha.accession <= ALL
(
  SELECT monarchb.accession
  FROM monarch AS monarchb
  WHERE monarchb.house = monarcha.house
)
AND monarcha.house IS NOT NULL
ORDER BY monarcha.accession ASC



;

-- Q5 returns (first_name,popularity)
SELECT name AS first_name, COUNT(name) AS popularity
FROM
(
  SELECT name
  FROM person
  WHERE POSITION(' 'in name) = 0 AND name IS NOT NULL
  union all
  SELECT SUBSTRING
  (
	  name, 0, POSITION(' 'in name)
  )AS name
  FROM  person
  WHERE POSITION(' 'in name) > 0
)AS t
GROUP BY name
HAVING count(name) > 1
ORDER by popularity DESC, first_name ASC

;
-- Q6 returns (house,seventeenth,eighteenth,nineteenth,twentieth)
SELECT tmp1.house,
(
  SELECT count(*)
FROM monarch
WHERE accession >= '1600-1-1' AND accession < '1700-1-1' AND house = tmp1.house) AS seventeenth,
(SELECT count(1)
FROM monarch
WHERE accession >= '1700-1-1' AND accession < '1800-1-1' AND house = tmp1.house) AS eighteenth,
(SELECT count(1)
FROM monarch
WHERE accession >= '1800-1-1' AND accession < '1900-1-1' AND house = tmp1.house) AS nineteenth,
(SELECT count(1)
FROM monarch
WHERE accession >= '1900-1-1' AND accession < '2000-1-1' AND house = tmp1.house) AS twentieth
FROM
(
  SELECT DISTINCT house
  FROM monarch
  WHERE house IS NOT NULL
)AS tmp1



;

-- Q7 returns (father,child,born)
SELECT father1.father,father1.name AS child,
row_number() over(PARTITION BY father1.father ORDER BY father1.dob ASC) AS born
FROM (SELECT*
FROM person
WHERE father IS NOT NULL) AS father1

;

-- Q8 returns (monarch,prime_minister)
SELECT house.name AS monarch, p.name AS prime_minister
FROM prime_minister AS p,
(SELECT s1.name AS name, s1.coronation AS start, s2.coronation AS end1
FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY house ORDER BY coronation ASC) AS rownumber,
   name, house, coronation
FROM monarch
WHERE coronation IS NOT NULL) AS s1
JOIN
(
SELECT ROW_NUMBER() OVER(PARTITION BY house ORDER BY coronation ASC) AS rownumber,
   name, house, coronation
FROM monarch
WHERE coronation IS NOT NULL) AS s2
ON s1.rownumber + 1 = s2.rownumber
AND s1.house = s2.house
) AS house
WHERE p.entry between start and end1

;
