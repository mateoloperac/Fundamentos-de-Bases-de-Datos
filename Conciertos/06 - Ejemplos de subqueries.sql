-- 1. Ejemplo básico: Encontrar todos los conciertos de artistas que son de Colombia
SELECT c.conciertoId, c.fecha, a.nombre as artista
FROM Concierto c
WHERE c.artistaPrincipalId IN (
    SELECT artistaId 
    FROM Artista 
    WHERE paisOrigen = 'Colombia'
);

-- 2. Encontrar artistas que tienen conciertos con precio superior al promedio
SELECT DISTINCT a.nombre, c.precioBase
FROM Artista a
JOIN Concierto c ON a.artistaId = c.artistaPrincipalId
WHERE c.precioBase > (
    SELECT AVG(precioBase) 
    FROM Concierto
);

-- 3. Encontrar las canciones que nunca han sido incluidas en ningún setlist
SELECT titulo
FROM Cancion
WHERE cancionId NOT IN (
    SELECT cancionId 
    FROM Setlist
);

-- 4. Encontrar los artistas que tienen más canciones que el promedio
select a.artistaId, a.nombre, count(*) as totalCanciones
from Cancion as c
join Artista as a on a.artistaId = c.artistaId
group by a.artistaId, a.nombre
having count(*) > (
select avg(cancionesPorArtista.cantidadCanciones) as promedioCancionesPorArtista
from (
	select c.artistaId, count(*) as cantidadCanciones
	from Cancion as c
	group by c.artistaId) as cancionesPorArtista)
);