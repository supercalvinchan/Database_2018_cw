
-- Q1 returns (name,father,mother)
SELECT personb.name, persona.mother, personc.father
FROM person AS personb
JOIN person AS persona ON personb.name = persona.mother
JOIN person AS personc ON personb.name = personc.father
WHERE personb.dod < persona.dod
AND personb.dod < personc.dod
ORDER BY personb.name ASC
;

-- Q2 returns (name)
SELECT persona.name
FROM person AS persona
JOIN monarch AS monarcha
ON monarcha.name = persona.name
WHERE monarcha.house IS NOT NULL
JOIN prime_minister AS prime_ministera
ON prime_ministera.name = persona.name
ORDER BY persona.name ASC
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
WHERE monarcha.accession < ALL
(
  SELECT monarchb.accession
  FROM monarch AS monarchb
  WHERE monarchb.house = monarcha.house
)
ORDER BY monarcha.accession ASC
;

-- Q5 returns (first_name,popularity)




;

-- Q6 returns (house,seventeenth,eighteenth,nineteenth,twentieth)

;

-- Q7 returns (father,child,born)

;

-- Q8 returns (monarch,prime_minister)

;
