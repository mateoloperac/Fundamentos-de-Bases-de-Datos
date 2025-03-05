-- Crear base de datos
CREATE DATABASE ConciertosMedellin;

-- Tabla Artista (antes Artistas)
CREATE TABLE Artista (
    artistaId INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    generoMusical VARCHAR(50),
    paisOrigen VARCHAR(50)
);

-- Tabla Cancion (antes Canciones)
CREATE TABLE Cancion (
    cancionId INT PRIMARY KEY IDENTITY(1,1),
    artistaId INT,
    titulo VARCHAR(100) NOT NULL,
    album VARCHAR(100),
    duracion INT, -- Duración en segundos
    anioLanzamiento INT,
    FOREIGN KEY (artistaId) REFERENCES Artista(artistaId)
);

-- Tabla Lugar (antes Lugares)
CREATE TABLE Lugar (
    lugarId INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50),
    pais VARCHAR(50),
    capacidad INT
);

-- Tabla Concierto (antes Conciertos)
CREATE TABLE Concierto (
    conciertoId INT PRIMARY KEY IDENTITY(1,1),
    artistaPrincipalId INT,
    lugarId INT,
    fecha DATE,
    horaInicio TIME,
    precioBase DECIMAL(10,2),
    estado VARCHAR(20) DEFAULT 'Programado', -- Programado, Realizado, Cancelado
    agotado BIT DEFAULT 0,
    FOREIGN KEY (artistaPrincipalId) REFERENCES Artista(artistaId),
    FOREIGN KEY (lugarId) REFERENCES Lugar(lugarId)
);

-- Tabla Setlist
CREATE TABLE Setlist (
    setlistId INT PRIMARY KEY IDENTITY(1,1),
    conciertoId INT,
    cancionId INT,
    ordenAparicion INT,
    notas VARCHAR(200),
    FOREIGN KEY (conciertoId) REFERENCES Concierto(conciertoId),
    FOREIGN KEY (cancionId) REFERENCES Cancion(cancionId)
);