-- Tabla Artista
CREATE TABLE Artista (
    artistaId SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    generoMusical VARCHAR(50),
    paisOrigen VARCHAR(50)
);

-- Tabla Cancion
CREATE TABLE Cancion (
    cancionId SERIAL PRIMARY KEY,
    artistaId INT,
    titulo VARCHAR(100) NOT NULL,
    album VARCHAR(100),
    duracion INT, -- Duración en segundos
    anioLanzamiento INT,
    FOREIGN KEY (artistaId) REFERENCES Artista(artistaId)
);

-- Tabla Lugar
CREATE TABLE Lugar (
    lugarId SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50),
    pais VARCHAR(50),
    capacidad INT
);

-- Tabla Concierto
CREATE TABLE Concierto (
    conciertoId SERIAL PRIMARY KEY,
    artistaPrincipalId INT,
    lugarId INT,
    fecha DATE,
    horaInicio TIME,
    precioBase DECIMAL(10,2),
    estado VARCHAR(20) DEFAULT 'Programado', -- Programado, Realizado, Cancelado
    agotado BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (artistaPrincipalId) REFERENCES Artista(artistaId),
    FOREIGN KEY (lugarId) REFERENCES Lugar(lugarId)
);

-- Tabla Setlist
CREATE TABLE Setlist (
    setlistId SERIAL PRIMARY KEY,
    conciertoId INT,
    cancionId INT,
    ordenAparicion INT,
    notas VARCHAR(200),
    FOREIGN KEY (conciertoId) REFERENCES Concierto(conciertoId),
    FOREIGN KEY (cancionId) REFERENCES Cancion(cancionId)
); 