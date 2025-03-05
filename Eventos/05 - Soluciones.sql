-- EJERCICIOS SQL - PREGUNTAS Y SOLUCIONES

-- EJERCICIOS BÁSICOS (WHERE Y OPERADORES LÓGICOS)
-- 1. Encuentra todos los artistas que son de Colombia o Puerto Rico.
SELECT * FROM Artista 
WHERE paisOrigen IN ('Colombia', 'Puerto Rico');

-- 2. Muestra todas las canciones lanzadas entre 2015 y 2020.
SELECT titulo, anioLanzamiento 
FROM Cancion 
WHERE anioLanzamiento BETWEEN 2015 AND 2020;

-- 3. Lista los conciertos que tienen un precio base mayor a $100 y no están agotados.
SELECT * FROM Concierto 
WHERE precioBase > 100 AND agotado = 0;

-- 4. Encuentra todos los lugares con capacidad mayor a 50000 personas que no estén en Reino Unido.
SELECT * FROM Lugar 
WHERE capacidad > 50000 AND pais != 'Reino Unido';

-- EJERCICIOS DE ORDENAMIENTO Y FILTRADO
-- 5. Muestra todas las canciones lanzadas en 2022, 
--    ordenadas por duración de forma descendente.
SELECT titulo, duracion
FROM Cancion
WHERE anioLanzamiento = 2022
ORDER BY duracion DESC;

-- 6. Muestra los lugares que tengan una capacidad mayor a 10000 personas,
--    ordenados por capacidad de mayor a menor, 
--    y si tienen la misma capacidad, ordénalos por nombre descendente.
SELECT nombre, ciudad, capacidad
FROM Lugar
WHERE capacidad > 10000
ORDER BY capacidad DESC, nombre DESC;

-- 7. Cuenta cuántos conciertos hay en cada estado (Programado, Realizado, Cancelado)
--    considerando solo los conciertos con precio base mayor a $50.
SELECT 
    estado, 
    COUNT(*) as total_conciertos
FROM Concierto
WHERE precioBase > 50
GROUP BY estado;

-- EJERCICIOS INTERMEDIOS (ORDER BY Y TOP)
-- 8. Muestra las 5 canciones más largas (por duración) y sus artistas.
SELECT TOP 5 c.titulo, c.duracion, a.nombre as artista
FROM Cancion c
JOIN Artista a ON c.artistaId = a.artistaId
ORDER BY c.duracion DESC;

-- 9. Lista los 3 conciertos más caros y el nombre del artista principal.
SELECT TOP 3 c.fecha, c.precioBase, a.nombre as artista
FROM Concierto c
JOIN Artista a ON c.artistaPrincipalId = a.artistaId
ORDER BY c.precioBase DESC;

-- 10. Encuentra los 10 lugares con menor capacidad ordenados por ciudad.
SELECT TOP 10 * FROM Lugar
ORDER BY capacidad ASC, ciudad ASC;

-- EJERCICIOS CON GROUP BY
-- 11. Muestra cuántas canciones tiene cada artista.
SELECT a.nombre, COUNT(c.cancionId) as total_canciones
FROM Artista a
LEFT JOIN Cancion c ON a.artistaId = c.artistaId
GROUP BY a.nombre;

-- 12. Calcula el promedio de duración de las canciones por género musical.
SELECT a.generoMusical, AVG(c.duracion) as duracion_promedio
FROM Artista a
JOIN Cancion c ON a.artistaId = c.artistaId
GROUP BY a.generoMusical;

-- 13. Cuenta cuántos conciertos hay en cada país.
SELECT l.pais, COUNT(c.conciertoId) as total_conciertos
FROM Lugar l
LEFT JOIN Concierto c ON l.lugarId = c.lugarId
GROUP BY l.pais;

-- EJERCICIOS AVANZADOS (COMBINANDO CONCEPTOS)
-- 14. Muestra los artistas que tienen más de 2 conciertos programados para 2024.
SELECT a.nombre, COUNT(c.conciertoId) as total_conciertos
FROM Artista a
JOIN Concierto c ON a.artistaId = c.artistaPrincipalId
WHERE YEAR(c.fecha) = 2024
GROUP BY a.nombre
HAVING COUNT(c.conciertoId) > 2;

-- 15. Lista los lugares que han tenido conciertos con precio promedio superior a $100.
SELECT l.nombre, AVG(c.precioBase) as precio_promedio
FROM Lugar l
JOIN Concierto c ON l.lugarId = c.lugarId
GROUP BY l.nombre
HAVING AVG(c.precioBase) > 100;

-- EJERCICIOS CON CASE
-- 16. Clasifica los conciertos por rango de precios.
SELECT 
    conciertoId,
    precioBase,
    CASE 
        WHEN precioBase < 80 THEN 'Económico'
        WHEN precioBase BETWEEN 80 AND 100 THEN 'Intermedio'
        ELSE 'Premium'
    END as categoria_precio
FROM Concierto;

-- 17. Categoriza los lugares por tamaño.
SELECT 
    nombre,
    capacidad,
    CASE 
        WHEN capacidad < 20000 THEN 'Pequeño'
        WHEN capacidad BETWEEN 20000 AND 50000 THEN 'Mediano'
        ELSE 'Grande'
    END as tamaño_venue
FROM Lugar;

-- EJERCICIOS COMPLEJOS
-- 18. Encuentra los artistas que tienen conciertos en todos los países donde tienen otros artistas del mismo género musical.
SELECT DISTINCT a1.nombre
FROM Artista a1
JOIN Concierto c1 ON a1.artistaId = c1.artistaPrincipalId
JOIN Lugar l1 ON c1.lugarId = l1.lugarId
WHERE NOT EXISTS (
    SELECT DISTINCT l2.pais
    FROM Artista a2
    JOIN Concierto c2 ON a2.artistaId = c2.artistaPrincipalId
    JOIN Lugar l2 ON c2.lugarId = l2.lugarId
    WHERE a2.generoMusical = a1.generoMusical
    AND l2.pais NOT IN (
        SELECT l3.pais
        FROM Concierto c3
        JOIN Lugar l3 ON c3.lugarId = l3.lugarId
        WHERE c3.artistaPrincipalId = a1.artistaId
    )
);

-- 19. Muestra la duración total del setlist para cada concierto.
SELECT 
    c.conciertoId,
    a.nombre as artista,
    SUM(can.duracion) as duracion_total
FROM Concierto c
JOIN Artista a ON c.artistaPrincipalId = a.artistaId
JOIN Setlist s ON c.conciertoId = s.conciertoId
JOIN Cancion can ON s.cancionId = can.cancionId
GROUP BY c.conciertoId, a.nombre;

-- 20. Encuentra los artistas que tienen más canciones que el promedio.
WITH PromedioCancionesPorArtista AS (
    SELECT AVG(canciones_por_artista) as promedio
    FROM (
        SELECT COUNT(*) as canciones_por_artista
        FROM Cancion
        GROUP BY artistaId
    ) t
)
SELECT a.nombre, COUNT(c.cancionId) as total_canciones
FROM Artista a
JOIN Cancion c ON a.artistaId = c.artistaId
GROUP BY a.nombre
HAVING COUNT(c.cancionId) > (SELECT promedio FROM PromedioCancionesPorArtista);

-- 21. Lista los conciertos con la mayor variedad de géneros musicales en su setlist.
SELECT 
    c.conciertoId,
    a.nombre as artista_principal,
    COUNT(DISTINCT a2.generoMusical) as cantidad_generos
FROM Concierto c
JOIN Artista a ON c.artistaPrincipalId = a.artistaId
JOIN Setlist s ON c.conciertoId = s.conciertoId
JOIN Cancion can ON s.cancionId = can.cancionId
JOIN Artista a2 ON can.artistaId = a2.artistaId
GROUP BY c.conciertoId, a.nombre
ORDER BY cantidad_generos DESC;

-- 22. Muestra los artistas que tienen conciertos consecutivos (con menos de 7 días de diferencia).
SELECT 
    a.nombre,
    c1.fecha as primer_concierto,
    c2.fecha as segundo_concierto,
    DATEDIFF(day, c1.fecha, c2.fecha) as dias_diferencia
FROM Concierto c1
JOIN Concierto c2 ON c1.artistaPrincipalId = c2.artistaPrincipalId
JOIN Artista a ON c1.artistaPrincipalId = a.artistaId
WHERE c1.fecha < c2.fecha
AND DATEDIFF(day, c1.fecha, c2.fecha) < 7
ORDER BY a.nombre, c1.fecha;

-- 23. Calcula el porcentaje de ocupación de venues por país.
SELECT 
    l.pais,
    COUNT(c.conciertoId) as total_conciertos,
    SUM(CASE WHEN c.agotado = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(c.conciertoId) as porcentaje_agotados
FROM Lugar l
JOIN Concierto c ON l.lugarId = c.lugarId
GROUP BY l.pais
ORDER BY porcentaje_agotados DESC;