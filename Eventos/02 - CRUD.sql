-- Insertar datos de ejemplo
INSERT INTO Artista (nombre, generoMusical, paisOrigen)
VALUES 
    ('Taylor Swift', 'Pop', 'Estados Unidos'),
    ('Bad Bunny', 'Reggaeton', 'Puerto Rico'),
    ('Coldplay', 'Rock Alternativo', 'Reino Unido'),
    ('Karol G', 'Reggaeton', 'Colombia'),
    ('Ed Sheeran', 'Pop', 'Reino Unido'),
    ('Metallica', 'Metal', 'Estados Unidos'),
    ('Shakira', 'Pop Latino', 'Colombia'),
    ('Arctic Monkeys', 'Rock Alternativo', 'Reino Unido');

INSERT INTO Cancion (artistaId, titulo, album, duracion, anioLanzamiento)
VALUES 
    -- Canciones de Taylor Swift
    (1, 'Cruel Summer', 'Lover', 178, 2019),
    (1, 'Anti-Hero', 'Midnights', 200, 2022),
    (1, 'Shake It Off', '1989', 219, 2014),
    -- Canciones de Bad Bunny
    (2, 'Tití Me Preguntó', 'Un Verano Sin Ti', 241, 2022),
    (2, 'Me Porto Bonito', 'Un Verano Sin Ti', 178, 2022),
    -- Canciones de Coldplay
    (3, 'Fix You', 'X&Y', 295, 2005),
    (3, 'Yellow', 'Parachutes', 266, 2000),
    -- Canciones de Karol G
    (4, 'MAMIII', 'MAÑANA SERÁ BONITO', 225, 2022),
    (4, 'Provenza', 'MAÑANA SERÁ BONITO', 214, 2022),
    -- Canciones de Ed Sheeran
    (5, 'Shape of You', '÷', 233, 2017),
    (5, 'Perfect', '÷', 263, 2017),
    -- Canciones de Metallica
    (6, 'Enter Sandman', 'Metallica', 331, 1991),
    (6, 'Nothing Else Matters', 'Metallica', 386, 1991),
    -- Canciones de Shakira
    (7, 'Hips Dont Lie', 'Oral Fixation Vol. 2', 218, 2006),
    (7, 'La Tortura', 'Fijación Oral Vol. 1', 213, 2005),
    -- Canciones de Arctic Monkeys
    (8, 'Do I Wanna Know?', 'AM', 272, 2013),
    (8, '505', 'Favourite Worst Nightmare', 253, 2007);

INSERT INTO Lugar (nombre, ciudad, pais, capacidad)
VALUES 
    ('Estadio Azteca', 'Ciudad de México', 'México', 87523),
    ('Madison Square Garden', 'Nueva York', 'Estados Unidos', 20789),
    ('Wembley Stadium', 'Londres', 'Reino Unido', 90000),
    ('Movistar Arena', 'Bogotá', 'Colombia', 14000),
    ('O2 Arena', 'Londres', 'Reino Unido', 20000),
    ('Foro Sol', 'Ciudad de México', 'México', 65000),
    ('Camp Nou', 'Barcelona', 'España', 99354),
    ('Tokyo Dome', 'Tokio', 'Japón', 55000);

-- Ahora insertamos múltiples conciertos por artista
INSERT INTO Concierto (artistaPrincipalId, lugarId, fecha, horaInicio, precioBase)
VALUES 
    -- Conciertos de Taylor Swift
    (1, 1, '2024-06-15', '20:30', 100.00), -- En Estadio Azteca
    (1, 2, '2024-06-20', '21:00', 120.00), -- En MSG
    -- Conciertos de Bad Bunny
    (2, 2, '2024-07-20', '21:00', 85.00),  -- En MSG
    (2, 1, '2024-07-25', '20:00', 90.00),  -- En Estadio Azteca
    -- Conciertos de Coldplay
    (3, 3, '2024-08-10', '19:45', 95.00),  -- En Wembley
    (3, 1, '2024-08-15', '20:30', 85.00),  -- En Estadio Azteca
    -- Conciertos de Karol G
    (4, 4, '2024-09-10', '20:00', 75.00),
    (4, 1, '2024-09-15', '21:00', 80.00),
    -- Conciertos de Ed Sheeran
    (5, 5, '2024-10-01', '19:30', 110.00),
    (5, 6, '2024-10-15', '20:00', 95.00),
    -- Conciertos de Metallica
    (6, 7, '2024-11-05', '21:00', 130.00),
    (6, 8, '2024-11-20', '20:30', 125.00),
    -- Conciertos de Shakira
    (7, 4, '2024-12-01', '20:00', 115.00),
    (7, 7, '2024-12-15', '21:00', 120.00),
    -- Conciertos de Arctic Monkeys
    (8, 5, '2025-01-10', '20:30', 90.00),
    (8, 6, '2025-01-20', '21:00', 85.00);

INSERT INTO Setlist (conciertoId, cancionId, ordenAparicion, notas)
VALUES 
    -- Setlist primer concierto Taylor Swift
    (1, 1, 1, 'Versión Album'),
    (1, 2, 2, 'Versión Acústica'),
    (1, 3, 3, 'Remix con elementos de Blank Space'),
    -- Setlist segundo concierto Taylor Swift
    (2, 1, 1, 'Versión Extendida'),
    (2, 3, 2, 'Versión Album'),
    -- Setlist primer concierto Bad Bunny
    (3, 4, 1, 'Versión Album'),
    (3, 5, 2, 'Versión Extendida'),
    -- Setlist primer concierto Coldplay
    (5, 6, 1, 'Versión Album'),
    (5, 7, 2, 'Versión Acústica'),
    -- Setlist Karol G
    (7, 8, 1, 'Versión Remix'),
    (7, 9, 2, 'Versión Album'),
    -- Setlist Ed Sheeran
    (9, 10, 1, 'Versión Acústica'),
    (9, 11, 2, 'Versión con Loop Pedal'),
    -- Setlist Metallica
    (11, 12, 1, 'Versión Extendida'),
    (11, 13, 2, 'Versión Album'),
    -- Setlist Shakira
    (13, 14, 1, 'Versión con Bailarines'),
    (13, 15, 2, 'Remix 2024'),
    -- Setlist Arctic Monkeys
    (15, 16, 1, 'Versión Album'),
    (15, 17, 2, 'Versión Extendida');

DELETE FROM Setlist WHERE setlistId = 1;

UPDATE Artista SET paisOrigen = 'Colombia' WHERE nombre = 'Taylor Swift';

SELECT * FROM Artista;


