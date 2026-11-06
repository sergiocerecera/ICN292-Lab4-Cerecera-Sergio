-- 1. Preparación de la base de datos
DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;

-- 2. Tabla autores (tabla padre)
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60),
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL,
    PRIMARY KEY (id_autor)
);

-- 3. Tabla colecciones (tabla para libros)
CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    PRIMARY KEY (id_coleccion)
);
-- 4. Tabla libros (hija de autores y colecciones)
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT,
    id_autor INT,
    id_coleccion INT,
    titulo VARCHAR(120) NOT NULL,
    paginas INT,
    ejemplares_vendidos INT,
    anio INT,
    PRIMARY KEY (id_libro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);
-- 5. Tabla pagos (hija de autores)
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT,
    id_autor INT,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pago),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- CARGA DE DATOS

-- 1. Carga oficial de autores (6 autores)
INSERT INTO autores (nombre, pais, genero) VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

-- 2. Carga de colecciones de prueba (al menos 2 colecciones con DATE)
INSERT INTO colecciones (titulo, fecha_publicacion) VALUES
('Colección Clásicos Austral', '2022-03-15'),
('Colección Voces Contemporáneas', '2024-01-10');

-- 3. Carga oficial de libros (12 libros, asignados a una colección)
INSERT INTO libros (id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio) VALUES
(1, 1, 'Cielo de Enero', 210, 1500, 2024),
(1, 1, 'Marea Baja', 185, 800, 2023),
(1, 1, 'El Norte', 200, 2200, 2024),
(2, 1, 'Estrellas que Caen', 240, 3000, 2022),
(2, 1, 'Máquinas', 215, 450, 2024),
(3, 2, 'Luz Artificial', 300, 1200, 2024),
(3, 2, 'Ruido Blanco', 280, 600, 2023),
(4, 2, 'El Barrio de Lila', 190, 5000, 2024),
(4, 2, 'Antes del Amanecer', 205, 2700, 2024),
(4, 2, 'La Calle 8', 175, 900, 2023),
(5, 2, 'Flor de Hierro', 195, 4100, 2024),
(5, 2, 'Hora Dorada', 220, 1800, 2022);

-- 4. Carga de pagos de prueba (al menos 3 pagos, dos al mismo autor)
INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES
(1, '2024-03-10', 150000.50),
(1, '2024-06-15', 200000.00),
(4, '2024-05-20', 350000.75);

-- CONSULTA 1

SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre ASC;
-- CONSULTA 2

SELECT titulo, paginas
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas ASC;

-- CONSULTA 3

SELECT 
    COUNT(*) AS total_libros,
    SUM(ejemplares_vendidos) AS total_ejemplares_vendidos,
    AVG(paginas) AS promedio_paginas,
    MIN(anio) AS anio_mas_antiguo,
    MAX(ejemplares_vendidos) AS max_ejemplares_vendidos
FROM libros;

-- CONSULTA 4

SELECT DISTINCT genero
FROM autores
ORDER BY genero ASC;

-- CONSULTA 5

SELECT 
    a.nombre, 
    COUNT(*) AS libros_2024
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre ASC;

-- CONSULTA 6

SELECT titulo, ejemplares_vendidos
FROM libros
WHERE anio = 2024 AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;

-- CONSULTA 7


-- 1. Inserción del nuevo libro
INSERT INTO libros (id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio) 
VALUES (3, 2, 'Papel Mojado', 260, 50, 2024);

-- 2. SELECT previo: verificar que la fila existe antes de borrar
SELECT * FROM libros WHERE titulo = 'Papel Mojado';

-- 3. DELETE: eliminación filtrando por título
DELETE FROM libros WHERE titulo = 'Papel Mojado';

-- 4. SELECT posterior: comprobar que ya no está (devuelve 0 filas)
SELECT * FROM libros WHERE titulo = 'Papel Mojado';

-- CONSULTA 8


-- 1. SELECT previo: ver valor actual (1500 ejemplares)
SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE titulo = 'Cielo de Enero';

-- 2. UPDATE calculado: suma 100 sobre el valor existente
UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';

-- 3. SELECT posterior: comprobar nuevo valor (1600 ejemplares)
SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE titulo = 'Cielo de Enero';

-- CONSULTA 9

SELECT 
    l.titulo AS titulo_libro,
    c.titulo AS titulo_coleccion,
    c.fecha_publicacion
FROM libros l
JOIN colecciones c ON l.id_coleccion = c.id_coleccion;

-- CONSULTA 10

-- 1. Detalle de cada pago con nombre de autor, fecha y monto
SELECT 
    a.nombre, 
    p.fecha_pago, 
    p.monto
FROM autores a
JOIN pagos p ON a.id_autor = p.id_autor;

-- 2. Total pagado a cada autor
SELECT 
    a.nombre, 
    SUM(p.monto) AS total_pagado
FROM autores a
JOIN pagos p ON a.id_autor = p.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY total_pagado DESC;