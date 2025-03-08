-- 1. Encontrar artistas que tienen conciertos con precio superior al promedio
SELECT DISTINCT a.nombre, c.precioBase
FROM Artista a
JOIN Concierto c ON a.artistaId = c.artistaPrincipalId
WHERE c.precioBase > (
    SELECT AVG(precioBase) 
    FROM Concierto
);

-- 2. Artistas con conciertos más caros que cualquier concierto de Taylor Swift
SELECT DISTINCT a.nombre
FROM Artista a
JOIN Concierto c ON a.artistaId = c.artistaPrincipalId
WHERE c.precioBase > (
    SELECT MIN(precioBase)
    FROM Concierto as c
    JOIN Artista as a on a.artistaId = c.artistaPrincipalId 
    WHERE a.nombre = 'Taylor Swift'
);

--CTE
WITH ConciertosTaylorSwift AS (
    SELECT a.nombre, MIN(precioBase) as precioMinimo
    FROM Concierto as c
    JOIN Artista as a on a.artistaId = c.artistaPrincipalId 
    WHERE a.nombre = 'Taylor Swift'
    GROUP BY a.nombre
)
SELECT DISTINCT a.nombre
FROM Artista a
JOIN Concierto c ON a.artistaId = c.artistaPrincipalId
JOIN ConciertosTaylorSwift cts ON c.precioBase > cts.precioMinimo;

-- 3. Conciertos con precio igual a alguno de los conciertos en Colombia
update Concierto
set precioBase = 115
where conciertoId in ('2','16')

--subquery
SELECT c.conciertoId, a.nombre AS artista, l.nombre AS lugar, l.pais, c.precioBase
FROM Concierto c
JOIN Artista a ON c.artistaPrincipalId = a.artistaId
JOIN Lugar l ON c.lugarId = l.lugarId
WHERE l.pais <> 'Colombia'
AND c.precioBase IN (
    SELECT c2.precioBase
    FROM Concierto c2
    JOIN Lugar l2 ON c2.lugarId = l2.lugarId
    WHERE l2.pais = 'Colombia'
);

--CTE
with precioColombia as (
SELECT c2.precioBase
    FROM Concierto c2
    JOIN Lugar l2 ON c2.lugarId = l2.lugarId
    WHERE l2.pais = 'Colombia'
)
SELECT c.conciertoId, a.nombre AS artista, l.nombre AS lugar, l.pais, c.precioBase
FROM Concierto c
JOIN Artista a ON c.artistaPrincipalId = a.artistaId
JOIN Lugar l ON c.lugarId = l.lugarId
WHERE l.pais <> 'Colombia'
AND c.precioBase IN (select precioBase from precioColombia)

-- 4. Encontrar los artistas que tienen más canciones que el promedio
--subquery
select a.artistaId, a.nombre, count(*) as totalCanciones
from Cancion as c
join Artista as a on a.artistaId = c.artistaId
group by a.artistaId, a.nombre
having count(*) > (
select avg(cancionesPorArtista.cantidadCanciones) as promedioCancionesPorArtista
from (
	select c.artistaId, count(*) as cantidadCanciones
	from Cancion as c
	group by c.artistaId) as cancionesPorArtista);

--CTE
WITH CancionesPorArtista AS (
    SELECT c.artistaId, COUNT(*) AS cantidadCanciones
    FROM Cancion AS c
    GROUP BY c.artistaId
),
PromedioCancionesPorArtista AS (
    SELECT AVG(cantidadCanciones) AS promedio
    FROM CancionesPorArtista
)
SELECT a.artistaId, a.nombre, COUNT(*) AS totalCanciones
FROM Cancion AS c
JOIN Artista AS a ON a.artistaId = c.artistaId
GROUP BY a.artistaId, a.nombre
HAVING COUNT(*) > (SELECT promedio FROM PromedioCancionesPorArtista);


-- Ejemplo adicional: Artistas con la mayor diferencia entre su concierto más caro y más barato
WITH PreciosPorArtista AS (
    SELECT 
        a.artistaId,
        a.nombre,
        MAX(c.precioBase) AS precioMax,
        MIN(c.precioBase) AS precioMin
    FROM Artista a
    JOIN Concierto c ON a.artistaId = c.artistaPrincipalId
    GROUP BY a.artistaId, a.nombre
)
SELECT 
    nombre,
    precioMax,
    precioMin,
    (precioMax - precioMin) AS diferencia
FROM PreciosPorArtista
WHERE (precioMax - precioMin) > 0
ORDER BY diferencia DESC;

-- 1. Encontrar artistas que tienen exactamente el mismo número de canciones que el promedio
-- No se puede resolver sin subconsulta porque necesitamos calcular el promedio exacto
SELECT a.nombre, COUNT(*) AS numeroCanciones
FROM Artista a
JOIN Cancion c ON a.artistaId = c.artistaId
GROUP BY a.nombre
HAVING COUNT(*) = (
    SELECT AVG(cancionesPorArtista.cantidadCanciones) 
    FROM (
        SELECT artistaId, COUNT(*) AS cantidadCanciones
        FROM Cancion
        GROUP BY artistaId
    ) AS cancionesPorArtista
);

-- 2. Encontrar los conciertos cuyo precio es exactamente igual al segundo precio más alto
-- No se puede resolver sin subconsulta porque necesitamos encontrar el segundo valor más alto
SELECT c.conciertoId, a.nombre AS artista, l.nombre AS lugar, c.precioBase
FROM Concierto c
JOIN Artista a ON c.artistaPrincipalId = a.artistaId
JOIN Lugar l ON c.lugarId = l.lugarId
WHERE c.precioBase = (
    SELECT MAX(precioBase)
    FROM Concierto
    WHERE precioBase < (
        SELECT MAX(precioBase) 
        FROM Concierto
    )
);

-- 3. Artistas que tienen conciertos en todos los países donde hay lugares registrados
-- No se puede resolver sin subconsulta porque requiere cuantificación universal ("para todos")
SELECT a.nombre
FROM Artista a
WHERE NOT EXISTS (
    SELECT DISTINCT l.pais
    FROM Lugar l
    WHERE NOT EXISTS (
        SELECT 1
        FROM Concierto c
        WHERE c.artistaPrincipalId = a.artistaId
        AND c.lugarId IN (
            SELECT lugarId 
            FROM Lugar 
            WHERE pais = l.pais
        )
    )
);

-- 4. Encontrar artistas que no tienen ninguna canción con duración menor que el promedio
-- No se puede resolver sin subconsulta porque necesitamos comparar con el promedio global
SELECT a.nombre
FROM Artista a
WHERE NOT EXISTS (
    SELECT 1
    FROM Cancion c
    WHERE c.artistaId = a.artistaId
    AND c.duracion < (
        SELECT AVG(duracion)
        FROM Cancion
    )
);

-- 5. Lugares que han albergado conciertos de todos los géneros musicales existentes
-- No se puede resolver sin subconsulta porque requiere cuantificación universal
SELECT l.nombre, l.ciudad, l.pais
FROM Lugar l
WHERE NOT EXISTS (
    SELECT DISTINCT generoMusical
    FROM Artista
    WHERE generoMusical IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM Concierto c
        JOIN Artista a ON c.artistaPrincipalId = a.artistaId
        WHERE c.lugarId = l.lugarId
        AND a.generoMusical = Artista.generoMusical
    )
);

