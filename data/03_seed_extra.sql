-- =====================================================
-- 03_seed_extra.sql — Datos adicionales (50+ películas)
-- Ejecutar DESPUÉS de 02_seed.sql
-- =====================================================

-- ─── PERSONAS ADICIONALES ──────────────────────────────────────────────────

INSERT INTO persona (nombre, fecha_nacimiento, nacionalidad) VALUES
    ('Steven Spielberg',      '1946-12-18', 'Estadounidense'),   -- 14
    ('Tom Hanks',             '1956-07-09', 'Estadounidense'),   -- 15
    ('David Fincher',         '1962-08-28', 'Estadounidense'),   -- 16
    ('Brad Pitt',             '1963-12-18', 'Estadounidense'),   -- 17
    ('Edward Norton',         '1969-08-18', 'Estadounidense'),   -- 18
    ('Martin Scorsese',       '1942-11-17', 'Estadounidense'),   -- 19
    ('Leonardo DiCaprio',     '1974-11-11', 'Estadounidense'),   -- 20
    ('Robert De Niro',        '1943-08-17', 'Estadounidense'),   -- 21
    ('Francis Ford Coppola',  '1939-04-07', 'Estadounidense'),   -- 22
    ('Marlon Brando',         '1924-04-03', 'Estadounidense'),   -- 23
    ('Al Pacino',             '1940-04-25', 'Estadounidense'),   -- 24
    ('Quentin Tarantino',     '1963-03-27', 'Estadounidense'),   -- 25
    ('Samuel L. Jackson',     '1948-12-21', 'Estadounidense'),   -- 26
    ('James Cameron',         '1954-08-16', 'Canadiense'),       -- 27
    ('Cate Blanchett',        '1969-05-14', 'Australiana'),      -- 28
    ('Peter Jackson',         '1961-10-31', 'Neozelandesa'),     -- 29
    ('Elijah Wood',           '1981-01-28', 'Estadounidense'),   -- 30
    ('Natalie Portman',       '1981-06-09', 'Israelí'),          -- 31
    ('Darren Aronofsky',      '1969-02-12', 'Estadounidense'),   -- 32
    ('Alfonso Cuarón',        '1961-11-28', 'Mexicana'),         -- 33
    ('Alejandro G. Iñárritu', '1963-08-15', 'Mexicana'),        -- 34
    ('Guillermo del Toro',    '1964-10-09', 'Mexicana'),         -- 35
    ('Ivana Baquero',         '1994-06-11', 'Española'),         -- 36
    ('Paul Thomas Anderson',  '1970-06-26', 'Estadounidense'),   -- 37
    ('Daniel Day-Lewis',      '1957-04-29', 'Británica'),        -- 38
    ('Jodie Foster',          '1962-11-19', 'Estadounidense'),   -- 39
    ('Jonathan Demme',        '1944-02-22', 'Estadounidense'),   -- 40
    ('Anthony Hopkins',       '1937-12-31', 'Galesa'),           -- 41
    ('Christopher Nolan',     '1970-07-30', 'Británica'),        -- ya existe id=1, se omite
    ('Christian Bale',        '1974-01-30', 'Británica'),        -- 42
    ('Heath Ledger',          '1979-04-04', 'Australiana'),      -- 43
    ('Wachowski Sisters',     '1965-06-21', 'Estadounidense'),   -- 44
    ('Keanu Reeves',          '1964-09-02', 'Canadiense'),       -- 45
    ('Ridley Scott',          '1937-11-30', 'Británica'),        -- ya existe id=4, se omite
    ('Russell Crowe',         '1964-04-07', 'Neozelandesa'),     -- 46
    ('Clint Eastwood',        '1930-05-31', 'Estadounidense'),   -- 47
    ('Morgan Freeman',        '1937-06-01', 'Estadounidense'),   -- 48
    ('Sofia Coppola',         '1971-05-14', 'Estadounidense'),   -- 49
    ('Scarlett Johansson',    '1984-11-22', 'Estadounidense'),   -- 50
    ('Wes Anderson',          '1969-05-01', 'Estadounidense'),   -- 51
    ('Bill Murray',           '1950-09-21', 'Estadounidense'),   -- 52
    ('Denis Villeneuve',      '1967-10-03', 'Canadiense'),       -- ya existe id=7, se omite
    ('Jake Gyllenhaal',       '1980-12-19', 'Estadounidense'),   -- 53
    ('Michel Gondry',         '1963-05-08', 'Francesa'),         -- 54
    ('Jim Carrey',            '1962-01-17', 'Canadiense'),       -- 55
    ('Kate Winslet',          '1975-10-05', 'Británica'),        -- 56
    ('Spike Jonze',           '1969-10-22', 'Estadounidense'),   -- 57
    ('Joaquin Phoenix',       '1974-10-28', 'Estadounidense'),   -- 58
    ('Todd Phillips',         '1970-12-20', 'Estadounidense'),   -- 59
    ('Robert Zemeckis',       '1952-05-14', 'Estadounidense'),   -- 60
    ('Richard Linklater',     '1960-07-30', 'Estadounidense'),   -- 61
    ('Ethan Hawke',           '1970-11-06', 'Estadounidense'),   -- 62
    ('Julie Delpy',           '1969-12-21', 'Francesa'),         -- 63
    ('Park Chan-wook',        '1963-08-23', 'Coreana'),          -- 64
    ('Choi Min-sik',          '1962-05-27', 'Coreana'),          -- 65
    ('Wong Kar-wai',          '1958-07-17', 'China'),            -- 66
    ('Tony Leung',            '1962-06-27', 'China'),            -- 67
    ('Xavier Dolan',          '1989-03-20', 'Canadiense'),       -- 68
    ('Pedro Almodóvar',       '1949-09-25', 'Española'),         -- 69
    ('Penélope Cruz',         '1974-04-28', 'Española'),         -- 70
    ('Federico Fellini',      '1920-01-20', 'Italiana'),         -- 71
    ('Ingmar Bergman',        '1918-07-14', 'Sueca'),            -- 72
    ('Akira Kurosawa',        '1910-03-23', 'Japonesa'),         -- 73
    ('Toshiro Mifune',        '1920-04-01', 'Japonesa'),         -- 74
    ('Andrei Tarkovsky',      '1932-04-04', 'Rusa'),             -- 75
    ('Paul Verhoeven',        '1938-07-18', 'Neerlandesa'),      -- 76
    ('Sharon Stone',          '1958-03-10', 'Estadounidense');   -- 77

-- ─── PRODUCTORAS ADICIONALES ───────────────────────────────────────────────

INSERT INTO productora (nombre) VALUES
    ('Miramax Films'),          -- 6
    ('Columbia Pictures'),      -- 7
    ('20th Century Fox'),       -- 8
    ('DreamWorks Pictures'),    -- 9
    ('New Line Cinema'),        -- 10
    ('MGM'),                    -- 11
    ('Focus Features'),         -- 12
    ('Sony Pictures'),          -- 13
    ('Lionsgate'),              -- 14
    ('Netflix'),                -- 15
    ('Apple TV+'),              -- 16
    ('Blumhouse Productions'),  -- 17
    ('Plan B Entertainment');   -- 18

-- ─── USUARIOS ADICIONALES ──────────────────────────────────────────────────

INSERT INTO usuario (nombre, email) VALUES
    ('Ana Martínez',      'ana.martinez@email.com'),    -- 5
    ('Pedro López',       'pedro.lopez@email.com'),     -- 6
    ('Laura Sánchez',     'laura.sanchez@email.com'),   -- 7
    ('Diego Herrera',     'diego.herrera@email.com'),   -- 8
    ('Valentina Torres',  'valentina.torres@email.com'),-- 9
    ('Sebastián Moreno',  'sebastian.moreno@email.com');-- 10

-- ─── PELÍCULAS ADICIONALES (50+) ───────────────────────────────────────────
-- Los comentarios indican el id_pelicula asignado (continuando desde 10)

INSERT INTO pelicula (titulo, fecha_lanzamiento, duracion, id_pais) VALUES
    ('El Club de la Pelea',             '1999-10-15', 139, 1),  -- 11
    ('El Padrino',                      '1972-03-15', 175, 1),  -- 12
    ('Pulp Fiction',                    '1994-10-14', 154, 1),  -- 13
    ('El Caballero Oscuro',             '2008-07-18', 152, 1),  -- 14
    ('Matrix',                          '1999-03-31', 136, 1),  -- 15
    ('Gladiador',                       '2000-05-05', 155, 1),  -- 16
    ('Forrest Gump',                    '1994-07-06', 142, 1),  -- 17
    ('El Señor de los Anillos: La Comunidad del Anillo', '2001-12-19', 178, 2), -- 18
    ('Titanic',                         '1997-12-19', 194, 1),  -- 19
    ('Requiem por un Sueño',            '2000-10-06', 102, 1),  -- 20
    ('El Laberinto del Fauno',          '2006-10-11', 118, 3),  -- 21
    ('Petróleo Sangriento',             '2007-12-26', 158, 1),  -- 22
    ('El Silencio de los Inocentes',    '1991-02-14', 118, 1),  -- 23
    ('Braveheart',                      '1995-05-24', 178, 1),  -- 24
    ('Gran Torino',                     '2008-12-12', 116, 1),  -- 25
    ('Origen',                          '2010-07-16', 148, 2),  -- 26
    ('El Gran Hotel Budapest',          '2014-03-07', 99,  1),  -- 27
    ('Perdida',                         '2014-10-03', 149, 1),  -- 28
    ('Prisioneros',                     '2013-09-20', 153, 1),  -- 29
    ('Eterno Resplandor de una Mente sin Recuerdos', '2004-03-19', 108, 1), -- 30
    ('Her',                             '2013-12-18', 126, 1),  -- 31
    ('Joker',                           '2019-10-04', 122, 1),  -- 32
    ('Forrest Gump',                    '1994-07-06', 142, 1),  -- duplicado intencional para probar
    ('El Pianista',                     '2002-05-24', 150, 3),  -- 33
    ('Antes del Amanecer',              '1995-01-27', 101, 1),  -- 34
    ('Oldboy',                          '2003-11-21', 120, 5),  -- 35
    ('En el Humor del Amor',            '2000-05-20', 98,  4),  -- 36
    ('Mullholland Drive',               '2001-10-12', 147, 1),  -- 37
    ('Terrence Malick: El Árbol de la Vida', '2011-05-27', 139, 1), -- 38
    ('Volver',                          '2006-03-17', 121, 3),  -- 39
    ('Amarcord',                        '1973-12-18', 123, 3),  -- 40
    ('El Séptimo Sello',                '1957-02-16', 96,  4),  -- 41 (Suecia=4 Japón, usamos id=4)
    ('Rashomon',                        '1950-08-25', 88,  4),  -- 42
    ('Solaris',                         '1972-03-20', 167, 1),  -- 43
    ('Instinto Básico',                 '1992-03-20', 127, 1),  -- 44
    ('Schindler''s List',               '1993-11-30', 195, 1),  -- 45
    ('Salvar al Soldado Ryan',          '1998-07-24', 169, 1),  -- 46
    ('Black Swan',                      '2010-12-17', 108, 1),  -- 47
    ('Roma',                            '2018-11-21', 135, 1),  -- 48
    ('Birdman',                         '2014-10-17', 119, 1),  -- 49
    ('Blade Runner 2049',               '2017-10-06', 164, 1),  -- 50
    ('Mad Max: Fury Road',              '2015-05-15', 120, 1),  -- 51
    ('Get Out',                         '2017-02-24', 104, 1),  -- 52
    ('Hereditary',                      '2018-06-08', 127, 1),  -- 53
    ('Moonlight',                       '2016-10-21', 111, 1),  -- 54
    ('La La Land',                      '2016-12-09', 128, 1),  -- 55
    ('Whiplash',                        '2014-10-10', 107, 1),  -- 56
    ('1917',                            '2019-12-04', 119, 2),  -- 57
    ('Dunkerque',                       '2017-07-21', 106, 2),  -- 58
    ('El Faro',                         '2019-10-18', 109, 1),  -- 59
    ('Mujeres al Borde de un Ataque de Nervios', '1988-03-23', 89, 3), -- 60
    ('Portrait of a Lady on Fire',      '2019-09-18', 122, 3),  -- 61
    ('Parasite: Director''s Cut',       '2019-07-30', 149, 5),  -- 62
    ('Drive',                           '2011-09-16', 100, 2),  -- 63
    ('No Country for Old Men',          '2007-11-09', 122, 1);  -- 64

-- ─── GÉNEROS ───────────────────────────────────────────────────────────────

INSERT INTO pelicula_genero (id_pelicula, id_genero) VALUES
-- El Club de la Pelea (11): Drama, Thriller
(11,2),(11,7),
-- El Padrino (12): Drama
(12,2),
-- Pulp Fiction (13): Thriller, Drama
(13,7),(13,2),
-- El Caballero Oscuro (14): Acción, Thriller
(14,3),(14,7),
-- Matrix (15): Ciencia Ficción, Acción
(15,1),(15,3),
-- Gladiador (16): Acción, Drama
(16,3),(16,2),
-- Forrest Gump (17): Drama, Romance
(17,2),(17,5),
-- El Señor de los Anillos (18): Aventura, Drama
(18,8),(18,2),
-- Titanic (19): Romance, Drama
(19,5),(19,2),
-- Requiem por un Sueño (20): Drama
(20,2),
-- El Laberinto del Fauno (21): Drama, Terror, Aventura
(21,2),(21,4),(21,8),
-- Petróleo Sangriento (22): Drama
(22,2),
-- El Silencio de los Inocentes (23): Terror, Thriller
(23,4),(23,7),
-- Braveheart (24): Acción, Drama
(24,3),(24,2),
-- Gran Torino (25): Drama
(25,2),
-- Origen (26): Ciencia Ficción, Acción, Thriller
(26,1),(26,3),(26,7),
-- El Gran Hotel Budapest (27): Drama
(27,2),
-- Perdida (28): Thriller, Drama
(28,7),(28,2),
-- Prisioneros (29): Thriller, Drama
(29,7),(29,2),
-- Eterno Resplandor (30): Romance, Ciencia Ficción, Drama
(30,5),(30,1),(30,2),
-- Her (31): Romance, Ciencia Ficción, Drama
(31,5),(31,1),(31,2),
-- Joker (32): Drama, Thriller
(32,2),(32,7),
-- El Pianista (33): Drama
(33,2),
-- Antes del Amanecer (34): Romance, Drama
(34,5),(34,2),
-- Oldboy (35): Thriller, Drama
(35,7),(35,2),
-- En el Humor del Amor (36): Romance, Drama
(36,5),(36,2),
-- Mullholland Drive (37): Thriller, Drama
(37,7),(37,2),
-- El Árbol de la Vida (38): Drama
(38,2),
-- Volver (39): Drama
(39,2),
-- Amarcord (40): Drama
(40,2),
-- El Séptimo Sello (41): Drama
(41,2),
-- Rashomon (42): Drama, Thriller
(42,2),(42,7),
-- Solaris (43): Ciencia Ficción, Drama
(43,1),(43,2),
-- Instinto Básico (44): Thriller
(44,7),
-- Schindler's List (45): Drama
(45,2),
-- Salvar al Soldado Ryan (46): Acción, Drama
(46,3),(46,2),
-- Black Swan (47): Terror, Drama
(47,4),(47,2),
-- Roma (48): Drama
(48,2),
-- Birdman (49): Drama
(49,2),
-- Blade Runner 2049 (50): Ciencia Ficción, Drama
(50,1),(50,2),
-- Mad Max: Fury Road (51): Acción, Ciencia Ficción
(51,3),(51,1),
-- Get Out (52): Terror, Thriller
(52,4),(52,7),
-- Hereditary (53): Terror
(53,4),
-- Moonlight (54): Drama
(54,2),
-- La La Land (55): Romance, Drama
(55,5),(55,2),
-- Whiplash (56): Drama
(56,2),
-- 1917 (57): Acción, Drama
(57,3),(57,2),
-- Dunkerque (58): Acción, Drama
(58,3),(58,2),
-- El Faro (59): Terror, Drama
(59,4),(59,2),
-- Mujeres al Borde (60): Drama
(60,2),
-- Portrait of a Lady on Fire (61): Romance, Drama
(61,5),(61,2),
-- Parasite Director's Cut (62): Drama, Thriller
(62,2),(62,7),
-- Drive (63): Acción, Thriller
(63,3),(63,7),
-- No Country for Old Men (64): Thriller, Drama
(64,7),(64,2);

-- ─── IDIOMAS ───────────────────────────────────────────────────────────────

INSERT INTO pelicula_idioma (id_pelicula, id_idioma, tipo) VALUES
(11,1,'original'),(11,2,'doblado'),(11,2,'subtitulado'),
(12,1,'original'),(12,2,'doblado'),
(13,1,'original'),(13,2,'doblado'),(13,2,'subtitulado'),
(14,1,'original'),(14,2,'doblado'),
(15,1,'original'),(15,2,'doblado'),(15,2,'subtitulado'),
(16,1,'original'),(16,2,'doblado'),
(17,1,'original'),(17,2,'doblado'),(17,2,'subtitulado'),
(18,1,'original'),(18,2,'doblado'),(18,2,'subtitulado'),
(19,1,'original'),(19,2,'doblado'),
(20,1,'original'),(20,2,'subtitulado'),
(21,3,'original'),(21,2,'subtitulado'),
(22,1,'original'),(22,2,'subtitulado'),
(23,1,'original'),(23,2,'doblado'),
(24,1,'original'),(24,2,'doblado'),
(25,1,'original'),(25,2,'subtitulado'),
(26,1,'original'),(26,2,'doblado'),(26,2,'subtitulado'),
(27,1,'original'),(27,2,'subtitulado'),
(28,1,'original'),(28,2,'subtitulado'),
(29,1,'original'),(29,2,'subtitulado'),
(30,1,'original'),(30,2,'subtitulado'),
(31,1,'original'),(31,2,'subtitulado'),
(32,1,'original'),(32,2,'doblado'),(32,2,'subtitulado'),
(33,3,'original'),(33,2,'subtitulado'),
(34,1,'original'),(34,2,'subtitulado'),
(35,5,'original'),(35,2,'subtitulado'),
(36,4,'original'),(36,2,'subtitulado'),
(37,1,'original'),(37,2,'subtitulado'),
(38,1,'original'),(38,2,'subtitulado'),
(39,3,'original'),(39,2,'subtitulado'),
(40,3,'original'),(40,2,'subtitulado'),
(41,4,'original'),(41,2,'subtitulado'),
(42,4,'original'),(42,2,'subtitulado'),
(43,1,'original'),(43,2,'subtitulado'),
(44,1,'original'),(44,2,'doblado'),
(45,1,'original'),(45,2,'doblado'),(45,2,'subtitulado'),
(46,1,'original'),(46,2,'doblado'),
(47,1,'original'),(47,2,'subtitulado'),
(48,2,'original'),(48,1,'subtitulado'),
(49,1,'original'),(49,2,'subtitulado'),
(50,1,'original'),(50,2,'subtitulado'),
(51,1,'original'),(51,2,'doblado'),
(52,1,'original'),(52,2,'subtitulado'),
(53,1,'original'),(53,2,'subtitulado'),
(54,1,'original'),(54,2,'subtitulado'),
(55,1,'original'),(55,2,'subtitulado'),
(56,1,'original'),(56,2,'subtitulado'),
(57,1,'original'),(57,2,'subtitulado'),
(58,1,'original'),(58,2,'subtitulado'),
(59,1,'original'),(59,2,'subtitulado'),
(60,3,'original'),(60,2,'subtitulado'),
(61,3,'original'),(61,2,'subtitulado'),
(62,5,'original'),(62,2,'subtitulado'),
(63,2,'original'),(63,2,'subtitulado'),
(64,1,'original'),(64,2,'subtitulado');

-- ─── PRODUCTORAS ───────────────────────────────────────────────────────────

INSERT INTO pelicula_productora (id_pelicula, id_productora) VALUES
(11,7),(12,7),(13,6),(14,1),(15,1),(16,5),(17,9),(18,10),
(19,2),(20,4),(21,7),(22,4),(23,6),(24,2),(25,1),(26,1),
(27,12),(28,8),(29,1),(30,12),(31,7),(32,1),(33,7),(34,12),
(35,7),(36,7),(37,12),(38,1),(39,7),(40,7),(41,7),(42,7),
(43,7),(44,7),(45,9),(46,9),(47,4),(48,15),(49,8),(50,1),
(51,1),(52,17),(53,4),(54,4),(55,2),(56,14),(57,5),(58,1),
(59,4),(60,7),(61,3),(62,7),(63,12),(64,2);

-- ─── PARTICIPACIONES ───────────────────────────────────────────────────────

INSERT INTO participacion (id_pelicula, id_persona, id_rol, personaje) VALUES
-- El Club de la Pelea (11)
(11,16,3,NULL),(11,17,1,'Tyler Durden'),(11,18,1,'El Narrador'),
-- El Padrino (12)
(12,22,3,NULL),(12,23,1,'Vito Corleone'),(12,24,1,'Michael Corleone'),
-- Pulp Fiction (13)
(13,25,3,NULL),(13,26,1,'Jules Winnfield'),(13,17,1,'Vincent Vega'),
-- El Caballero Oscuro (14)
(14,1,3,NULL),(14,42,1,'Bruce Wayne'),(14,43,1,'El Joker'),
-- Matrix (15)
(15,44,3,NULL),(15,45,1,'Neo'),
-- Gladiador (16)
(16,4,3,NULL),(16,46,1,'Máximo Décimo Meridio'),
-- Forrest Gump (17)
(17,60,3,NULL),(17,15,1,'Forrest Gump'),
-- El Señor de los Anillos (18)
(18,29,3,NULL),(18,30,1,'Frodo Bolsón'),
-- Titanic (19)
(19,27,3,NULL),(19,20,1,'Jack Dawson'),(19,56,2,'Rose DeWitt Bukater'),
-- Requiem por un Sueño (20)
(20,32,3,NULL),
-- El Laberinto del Fauno (21)
(21,35,3,NULL),(21,36,2,'Ofelia'),
-- El Silencio de los Inocentes (23)
(23,40,3,NULL),(23,39,2,'Clarice Starling'),(23,41,1,'Hannibal Lecter'),
-- Origen (26)
(26,1,3,NULL),(26,20,1,'Cobb'),
-- El Gran Hotel Budapest (27)
(27,51,3,NULL),(27,52,1,'M. Gustave'),
-- Perdida (28)
(28,16,3,NULL),(28,53,1,'Nick Dunne'),
-- Prisioneros (29)
(29,7,3,NULL),(29,53,1,'Keller Dover'),
-- Eterno Resplandor (30)
(30,54,3,NULL),(30,55,1,'Joel Barish'),(30,56,2,'Clementine Kruczynski'),
-- Her (31)
(31,57,3,NULL),(31,58,1,'Theodore Twombly'),
-- Joker (32)
(32,59,3,NULL),(32,58,1,'Arthur Fleck'),
-- Antes del Amanecer (34)
(34,61,3,NULL),(34,62,1,'Jesse'),(34,63,2,'Céline'),
-- Oldboy (35)
(35,64,3,NULL),(35,65,1,'Oh Dae-su'),
-- En el Humor del Amor (36)
(36,66,3,NULL),(36,67,1,'Sr. Chow'),
-- Volver (39)
(39,69,3,NULL),(39,70,2,'Raimunda'),
-- Schindler's List (45)
(45,14,3,NULL),(45,20,1,'Oskar Schindler'),
-- Salvar al Soldado Ryan (46)
(46,14,3,NULL),(46,15,1,'Capitán Miller'),
-- Black Swan (47)
(47,32,3,NULL),(47,31,2,'Nina Sayers'),
-- Roma (48)
(48,33,3,NULL),
-- Birdman (49)
(49,34,3,NULL),
-- Blade Runner 2049 (50)
(50,7,3,NULL),(50,8,1,'Agente K'),
-- Mad Max: Fury Road (51)
(51,14,3,NULL),
-- Moonlight (54)
(54,34,3,NULL),
-- La La Land (55)
(55,7,3,NULL),(55,9,2,'Mia Dolan'),
-- Whiplash (56)
(56,37,3,NULL),
-- 1917 (57)
(57,14,3,NULL),
-- Dunkerque (58)
(58,1,3,NULL),
-- No Country for Old Men (64)
(64,25,3,NULL);

-- ─── CONTENIDO TEXTUAL ─────────────────────────────────────────────────────

INSERT INTO contenido_textual (id_pelicula, tipo, texto) VALUES

(11,'sinopsis',
'Un oficinista anónimo e insatisfecho con su vida rutinaria conoce a Tyler Durden, un carismático y nihilista vendedor de jabón. Juntos fundan el Club de la Pelea, un grupo clandestino donde los hombres se confrontan físicamente para escapar del vacío de la vida moderna. El club crece hasta convertirse en una organización terrorista llamada el Proyecto Mayhem. El narrador descubre una perturbadora verdad sobre su propia identidad.'),
(11,'descripcion',
'El Club de la Pelea es una crítica feroz al consumismo, la masculinidad tóxica y la alienación de la sociedad postmoderna. David Fincher construye un thriller psicológico vertiginoso con un giro final que recontextualiza toda la película. Brad Pitt y Edward Norton ofrecen actuaciones magnéticas en una de las películas más influyentes de los años noventa.'),

(12,'sinopsis',
'Don Vito Corleone, el patriarca de una poderosa familia mafiosa italiana en Nueva York, es herido en un atentado tras negarse a apoyar el negocio de la droga de un rival. Su hijo Michael, un ex veterano de guerra que intentaba mantenerse al margen de los negocios familiares, se ve arrastrado al mundo del crimen organizado para vengar a su padre y proteger a la familia. La historia abarca la transición del poder de una generación a otra dentro de la mafia americana.'),
(12,'descripcion',
'El Padrino es considerada una de las mejores películas de la historia del cine. Francis Ford Coppola y Mario Puzo crearon una épica sobre el poder, la lealtad y la corrupción moral. Las actuaciones de Marlon Brando y Al Pacino son legendarias. La película redefinió el género del cine de gánsteres y sigue siendo una referencia cultural universal.'),

(13,'sinopsis',
'En el Los Ángeles criminal de los años noventa, las historias de varios personajes se entrelazan de manera no lineal: dos sicarios filosóficos en una misión, un boxeador que debe perder un combate, la esposa de un gángster que pasa una noche peligrosa, y dos atracadores de restaurantes. El azar, la violencia y los diálogos afilados conectan estas historias en un mosaico del crimen urbano.'),
(13,'descripcion',
'Pulp Fiction revolucionó el cine independiente y la narrativa cinematográfica con su estructura no lineal, sus diálogos brillantes y su mezcla irreverente de violencia, humor negro y referencias culturales. Quentin Tarantino consolidó su estatus como uno de los directores más originales de su generación. La película revitalizó la carrera de John Travolta y lanzó a Samuel L. Jackson a la fama mundial.'),

(14,'sinopsis',
'Bruce Wayne, el vigilante enmascarado conocido como Batman, enfrenta su mayor amenaza cuando el Joker, un criminal caótico y sin motivaciones claras, comienza a sembrar el terror en Ciudad Gótica. El Joker pone a prueba los límites morales de Batman y de toda la ciudad, forzando a sus ciudadanos a tomar decisiones imposibles. El teniente Harvey Dent, el fiscal más honesto de la ciudad, se convierte en víctima de la manipulación del Joker.'),
(14,'descripcion',
'El Caballero Oscuro es considerada la mejor película de superhéroes jamás realizada. Christopher Nolan elevó el género a la categoría de cine de autor con una reflexión profunda sobre el caos, la moral y el heroísmo. La actuación póstuma de Heath Ledger como el Joker es una de las más celebradas de la historia del cine moderno.'),

(15,'sinopsis',
'Thomas Anderson, un programador de día y hacker de noche conocido como Neo, descubre que la realidad que conoce es una simulación computarizada llamada Matrix, creada por máquinas para subyugar a la humanidad. Guiado por Morfeo y la enigmática Trinity, Neo aprende a manipular las reglas de la Matrix y descubre su destino como El Elegido para liberar a la humanidad.'),
(15,'descripcion',
'Matrix es una película de ciencia ficción que combina filosofía budista, existencialismo y estética cyberpunk en un espectáculo de acción sin precedentes. Las hermanas Wachowski introdujeron el efecto bullet time e innovaron el cine de acción para siempre. La película plantea preguntas sobre la naturaleza de la realidad, el libre albedrío y la identidad que siguen siendo relevantes.'),

(16,'sinopsis',
'Máximo Décimo Meridio, el general más respetado del ejército romano, es traicionado por Cómodo, el ambicioso hijo del Emperador Marco Aurelio, quien asesina al Emperador y a la familia de Máximo. Esclavizado y forzado a convertirse en gladiador, Máximo lucha en las arenas del Imperio Romano con el único objetivo de vengarse de Cómodo ante los ojos de Roma.'),
(16,'descripcion',
'Gladiador es una épica histórica que revitalizó el péplum cinematográfico en el siglo XXI. Ridley Scott construyó un mundo romano con una escala visual impresionante. Russell Crowe ofrece una actuación poderosa como el general caído que busca justicia. La película ganó cinco premios Óscar, incluyendo Mejor Película.'),

(17,'sinopsis',
'Forrest Gump es un hombre de Alabama con una inteligencia por debajo de la media pero un corazón extraordinario. Sin buscarlo, se convierte en testigo y participante involuntario de los momentos más importantes de la historia americana del siglo XX: la guerra de Vietnam, el movimiento de derechos civiles, el escándalo Watergate. A lo largo de toda su vida, Forrest corre detrás del amor de su infancia, Jenny.'),
(17,'descripcion',
'Forrest Gump es una carta de amor a la historia americana contada desde la perspectiva de un hombre simple y honesto. Robert Zemeckis usa efectos visuales pioneros para insertar a Tom Hanks en imágenes de archivo históricas. La película es un homenaje a la bondad, la perseverancia y el amor incondicional que tocó el corazón de millones de espectadores.'),

(18,'sinopsis',
'El hobbit Frodo Bolsón hereda el Anillo Único, una joya de poder inmenso forjada por el Señor Oscuro Sauron para dominar a todos los seres de la Tierra Media. Guiado por el mago Gandalf, Frodo parte en un peligroso viaje acompañado de la Comunidad del Anillo para destruir el anillo en el Monte del Destino, el único lugar donde puede ser destruido.'),
(18,'descripcion',
'La Comunidad del Anillo es la primera entrega de la trilogía de El Señor de los Anillos, la adaptación cinematográfica de la novela de J.R.R. Tolkien realizada por Peter Jackson. La película construye un mundo fantástico de una riqueza visual y cultural sin precedentes. Es una de las empresas cinematográficas más ambiciosas y exitosas de la historia del cine.'),

(19,'sinopsis',
'En 1912, Jack Dawson, un joven artista sin dinero, gana en un juego de cartas un pasaje de tercera clase en el Titanic, el transatlántico más lujoso del mundo. A bordo, se enamora de Rose DeWitt Bukater, una joven de la alta sociedad comprometida con un hombre rico y arrogante. Cuando el Titanic choca con un iceberg y comienza a hundirse, Jack y Rose luchan por sobrevivir y por su amor.'),
(19,'descripcion',
'Titanic es la película romántica más taquillera de la historia y ganó once premios Óscar. James Cameron combinó una historia de amor épica con una recreación meticulosa del hundimiento del Titanic. La química entre Leonardo DiCaprio y Kate Winslet convirtió a la pareja en íconos del cine romántico.'),

(20,'sinopsis',
'Cuatro personas en Nueva York persiguen sus sueños mientras caen en la adicción. Harry Goldfarb y sus amigos Marion y Tyrone se hunden en el consumo de heroína mientras intentan conseguir dinero para sus proyectos de vida. La madre de Harry, Sara, se vuelve adicta a las pastillas para adelgazar al ser seleccionada para un programa de televisión. Las cuatro historias convergen en un desenlace devastador.'),
(20,'descripcion',
'Réquiem por un Sueño es una de las películas más perturbadoras sobre la adicción jamás realizada. Darren Aronofsky usa técnicas cinematográficas innovadoras para hacer sentir al espectador el vértigo y la desesperación de la dependencia. La banda sonora de Clint Mansell se convirtió en una de las más reconocibles del cine moderno.'),

(21,'sinopsis',
'En la España de la posguerra franquista de 1944, la joven Ofelia viaja con su madre a un puesto militar en el bosque donde su nuevo padrastro, el despiadado Capitán Vidal, comanda las tropas. Ofelia descubre el laberinto del fauno y conoce a Pan, un fauno que le revela que es en realidad una princesa de un reino mágico subterráneo. Para reclamar su trono debe completar tres peligrosas tareas.'),
(21,'descripcion',
'El Laberinto del Fauno es una fábula oscura y poética que entrelaza la brutalidad histórica del franquismo con un mundo de fantasía perturbador y hermoso. Guillermo del Toro crea una alegoría sobre la inocencia, la obediencia y la resistencia. Es una de las películas en español más aclamadas internacionalmente del siglo XXI.'),

(22,'sinopsis',
'En California a principios del siglo XX, el ambicioso Daniel Plainview es un prospector de petróleo que convence a una comunidad religiosa liderada por el joven predicador Eli Sunday de venderle sus tierras, ricas en petróleo. A medida que Plainview acumula riqueza y poder, su mente se deteriora por la codicia y la paranoia en una batalla de voluntades y ego contra Eli Sunday.'),
(22,'descripcion',
'Petróleo Sangriento es una epopeya sobre la codicia, la religión y el nacimiento del capitalismo americano. La actuación de Daniel Day-Lewis como Daniel Plainview es considerada una de las mejores de la historia del cine. Paul Thomas Anderson construye un film lento, hipnótico e implacable sobre los pecados fundacionales de los Estados Unidos.'),

(23,'sinopsis',
'La agente del FBI Clarice Starling es enviada a entrevistar al brillante y perturbador asesino en serie y caníbal Hannibal Lecter, encarcelado en una prisión de máxima seguridad, para obtener su ayuda en la captura de otro asesino en serie activo conocido como Buffalo Bill. La relación entre Clarice y Hannibal es un juego de manipulación psicológica en el que los límites entre cazador y presa se difuminan.'),
(23,'descripcion',
'El Silencio de los Inocentes es una de las pocas películas en ganar los cinco premios Óscar principales. Jonathan Demme creó un thriller psicológico de una tensión insoportable. Las actuaciones de Jodie Foster y Anthony Hopkins son de las más memorables de la historia. La película redefinió el género del thriller de serial killers.'),

(26,'sinopsis',
'Dom Cobb es un ladrón especializado en robar secretos dentro de los sueños de sus víctimas. Le ofrecen la oportunidad de borrar su pasado criminal si logra plantar una idea en la mente de un heredero empresarial, una técnica conocida como inception. Para ello, Cobb y su equipo deben adentrarse en múltiples capas de sueños dentro de sueños, donde la realidad y la ilusión se vuelven indistinguibles.'),
(26,'descripcion',
'Origen es un espectáculo de ciencia ficción que desafía la percepción del espectador con su arquitectura narrativa de múltiples niveles. Christopher Nolan construye un laberinto de sueños con una lógica interna coherente y una escala de producción monumental. La película equilibra el entretenimiento de blockbuster con ideas filosóficas sobre la memoria, la culpa y la realidad subjetiva.'),

(27,'sinopsis',
'El excéntrico y refinado M. Gustave, conserje del legendario Gran Hotel Budapest en los años treinta, y su fiel botones Zero Moustafa se ven envueltos en el robo de una invaluable pintura renacentista y en el asesinato de una anciana aristócrata. Perseguidos por la familia de la fallecida y por una guerra que se cierne sobre Europa, los dos amigos viven una serie de aventuras estrafalarias.'),
(27,'descripcion',
'El Gran Hotel Budapest es la obra más elaborada visualmente de Wes Anderson, con una paleta de colores pastel y una composición simétrica característica. La película es una nostálgica carta de amor a la Europa de entreguerras y a la tradición del hotel de lujo. Bill Murray encabeza un elenco coral de estrellas en una comedia de aventuras elegante y melancólica.'),

(28,'sinopsis',
'Nick Dunne llega a casa el día de su quinto aniversario de bodas para encontrar que su esposa Amy ha desaparecido. Las evidencias encontradas hacen que Nick sea el principal sospechoso. Mientras la investigación policial avanza y los medios convierten el caso en un espectáculo, el punto de vista narrativo alterna entre Nick y el diario de Amy, que revela una historia de matrimonio muy distinta a la que Nick cuenta.'),
(28,'descripcion',
'Perdida es un thriller matrimonial que disecciona las construcciones sociales del matrimonio, los medios de comunicación y la identidad pública. David Fincher dirige con su característica frialdad clínica una historia de manipulación y mentira. La película es un estudio perturbador sobre cómo las personas construyen y destruyen narrativas sobre sí mismas.'),

(29,'sinopsis',
'Keller Dover, un padre de familia religioso y autosuficiente, ve cómo su hija pequeña y la de su vecino desaparecen en el día de Acción de Gracias. Cuando el único sospechoso es liberado por falta de pruebas, Keller decide tomar la justicia en sus manos de una manera que pone a prueba sus propios límites morales. El detective Loki investiga el caso mientras Keller desciende a sus propios métodos oscuros.'),
(29,'descripcion',
'Prisioneros es un thriller de desaparición que confronta al espectador con preguntas incómodas sobre la justicia, la tortura y los límites de la moralidad cuando se trata de proteger a los propios hijos. Denis Villeneuve dirige con una tensión sostenida y un dominio visual magistral. Jake Gyllenhaal y Hugh Jackman ofrecen actuaciones de gran intensidad emocional.'),

(30,'sinopsis',
'Joel Barish y Clementine Kruczynski, tras romper su relación, deciden someterse a un procedimiento científico para borrar todos sus recuerdos del otro. Mientras los recuerdos de Joel son eliminados uno a uno, él revive sus momentos con Clementine y se da cuenta de que no quiere perderlos. La historia transcurre de manera no lineal dentro de la mente de Joel mientras lucha por preservar sus recuerdos.'),
(30,'descripcion',
'Eterno Resplandor de una Mente sin Recuerdos es una exploración poética y melancólica del amor, la memoria y la identidad. Michel Gondry y Charlie Kaufman crearon una obra original que desafía las convenciones narrativas. Jim Carrey y Kate Winslet ofrecen interpretaciones sorprendentemente contenidas y emotivas en una historia sobre por qué amamos a pesar del dolor.'),

(31,'sinopsis',
'Theodore Twombly, un hombre solitario en proceso de divorcio que trabaja escribiendo cartas personales para otros, se enamora de Samantha, su nuevo sistema operativo de inteligencia artificial con una voz cálida y una personalidad en constante evolución. La relación entre Theodore y Samantha es profunda e íntima, pero la naturaleza ilimitada de la IA y la finitud humana crean una asimetría insalvable.'),
(31,'descripcion',
'Her es una reflexión filosófica sobre el amor, la soledad y lo que significa ser humano en una era tecnológica. Spike Jonze construye un futuro cercano reconfortante y alienante a la vez. La voz de Scarlett Johansson como Samantha es una actuación en sí misma, cargada de matices y emoción sin necesidad de presencia física. La película anticipó debates actuales sobre las relaciones con inteligencias artificiales.'),

(32,'sinopsis',
'Arthur Fleck es un payaso fracasado y comediante en ciernes que vive en Gotham City, una metrópolis decadente y llena de desigualdad social. Ignorado, humillado y víctima de enfermedades mentales sin tratamiento, Arthur sufre una serie de eventos que lo llevan a transformarse en el Joker, un agente del caos que inspira a las masas marginadas a rebelarse contra el sistema.'),
(32,'descripcion',
'Joker es una película de origen de superhéroe que se aleja radicalmente del género para convertirse en un estudio de personaje sobre la salud mental, la marginalización social y la violencia sistémica. Todd Phillips y Joaquin Phoenix crearon un antihéroe trágico y provocador. La película generó debate por su representación de la violencia pero fue aclamada por la actuación de Phoenix, que le valió el Óscar.'),

(33,'sinopsis',
'Wladyslaw Szpilman, un pianista judío polaco, sobrevive la ocupación nazi de Varsovia y el exterminio del gueto gracias a su talento musical y a la ayuda de personas que arriesgan sus vidas por él. La película sigue su odisea de supervivencia a través de los horrores del Holocausto, escondido en apartamentos abandonados mientras la ciudad es destruida a su alrededor.'),
(33,'descripcion',
'El Pianista es el testimonio cinematográfico más personal de Roman Polanski, él mismo sobreviviente del Holocausto. La película muestra los horrores de la guerra con una sobriedad documental que la hace más devastadora. Adrien Brody ofrece una actuación extraordinaria y ganó el Óscar al Mejor Actor. Es una de las obras más importantes sobre el Holocausto en el cine.'),

(34,'sinopsis',
'En Viena, Jesse, un joven americano, y Céline, una estudiante francesa, se conocen en un tren y deciden pasar juntos la noche antes de que Jesse tome su vuelo de regreso a Estados Unidos. Caminando por las calles de la ciudad, visitando bares, cementerios y la orilla del Danubio, hablan de amor, vida, filosofía y sus sueños mientras una conexión profunda e inesperada crece entre ellos.'),
(34,'descripcion',
'Antes del Amanecer es una de las películas románticas más auténticas e inteligentes del cine. Richard Linklater construye toda la película en tiempo real a base de conversaciones, sin dramatismo ni artificios. La química entre Ethan Hawke y Julie Delpy es extraordinaria. La película inició una trilogía que siguió a los personajes décadas después.'),

(35,'sinopsis',
'Oh Dae-su es un hombre corriente que es secuestrado y encerrado durante quince años en una habitación sin saber por qué ni por quién. Al ser liberado abruptamente, obsesionado con encontrar la razón de su prisión y vengarse, conoce a una joven cocinera llamada Mi-do y juntos siguen las pistas que lo llevan a una verdad que habría preferido no descubrir.'),
(35,'descripcion',
'Oldboy es una obra maestra del cine coreano y una de las películas de venganza más perturbadoras y originales jamás realizadas. Park Chan-wook construye un thriller de misterio con un giro final devastador que redefine todo lo anterior. La película forma parte de la trilogía de la venganza del director y es referencia obligatoria del cine asiático contemporáneo.'),

(36,'sinopsis',
'Hong Kong, año 2000. El Sr. Chow y la Sra. Chan, vecinos en un edificio de apartamentos, descubren que sus respectivos cónyuges están teniendo una aventura. Mientras enfrentan la traición juntos, entre ellos crece una conexión emocional profunda que ambos se niegan a consumar por el deseo de no ser como las personas que los traicionaron.'),
(36,'descripcion',
'En el Humor del Amor es una obra de arte visual y sensorial del director hongkonés Wong Kar-wai. Con una fotografía de slow motion de una belleza hipnótica y una banda sonora melancólica, la película explora el amor no correspondido, la represión emocional y el peso de las decisiones no tomadas. Es considerada una de las películas románticas más elegantes de la historia.'),

(39,'sinopsis',
'Raimunda, una mujer trabajadora de Madrid, regresa a su pueblo natal en La Mancha cuando su madre Irene, que creía muerta, aparece misteriosamente. Simultáneamente, Raimunda tiene que afrontar la muerte accidental de su marido a manos de su hija Paula. La historia mezcla realismo mágico, secretos familiares y la solidaridad entre mujeres de diferentes generaciones.'),
(39,'descripcion',
'Volver es una de las películas más aclamadas de Pedro Almodóvar, un homenaje a las mujeres fuertes de La Mancha y a las madres en particular. Penélope Cruz ofrece la actuación más elogiada de su carrera. La película mezcla comedia, drama y elementos del realismo mágico con la maestría narrativa y visual característica de Almodóvar.'),

(45,'sinopsis',
'En la Alemania nazi, el empresario alemán Oskar Schindler llega a Cracovia buscando hacer negocios usando mano de obra judía barata. Con el tiempo, al presenciar las atrocidades del régimen nazi contra los judíos del gueto, Schindler se transforma y usa toda su fortuna y sus contactos para salvar las vidas de más de mil judíos de los campos de exterminio.'),
(45,'descripcion',
'La Lista de Schindler es considerada una de las más grandes películas de la historia del cine. Steven Spielberg eligió filmarla en blanco y negro para darle un carácter documental y evitar cualquier estetización del horror. La película es una reflexión sobre la capacidad del ser humano tanto para el mal como para la bondad más extrema, y un testimonio imperecedero del Holocausto.'),

(46,'sinopsis',
'Durante la invasión aliada de Normandía en la Segunda Guerra Mundial, el Capitán John Miller recibe la misión de encontrar al soldado James Ryan, el último de cuatro hermanos vivos, cuya madre ha recibido ya tres notificaciones de muerte. Miller y su escuadrón cruzan la Francia ocupada por los nazis en una misión que pone en cuestión el valor de una vida frente a muchas.'),
(46,'descripcion',
'Salvar al Soldado Ryan redefinió la representación de la guerra en el cine con su brutal y visceral recreación del desembarco de Normandía en los primeros veinte minutos. Steven Spielberg logra un equilibrio extraordinario entre el espectáculo bélico y la reflexión humanista sobre el sacrificio y el deber. La película ganó cinco premios Óscar incluyendo Mejor Dirección.'),

(47,'sinopsis',
'Nina Sayers es una bailarina perfeccionista de una compañía de ballet de Nueva York que consigue el papel protagónico de El Lago de los Cisnes, que requiere interpretar tanto al Cisne Blanco como al Cisne Negro. La búsqueda de Nina por alcanzar la perfección y liberar su lado oscuro la lleva a una espiral de paranoia, alucinaciones y competencia obsesiva con una nueva bailarina.'),
(47,'descripcion',
'Black Swan es un thriller psicológico de danza que explora los límites entre la perfección artística y la autodestrucción. Darren Aronofsky construye una atmósfera de pesadilla que hace dudar al espectador de lo que es real y lo que es alucinación. Natalie Portman ganó el Óscar a Mejor Actriz por una interpretación física y emocionalmente devastadora.'),

(48,'sinopsis',
'En la Ciudad de México de 1970, Cleo, una empleada doméstica indígena de la familia Sofía, vive el embarazo de su hijo en soledad tras ser abandonada por su novio, mientras la familia que trabaja atraviesa su propia crisis matrimonial. Ambas mujeres, de clases sociales radicalmente distintas, enfrentan juntas la pérdida y el abandono en un México convulsionado políticamente.'),
(48,'descripcion',
'Roma es una película autobiográfica de Alfonso Cuarón filmada en un blanco y negro de belleza extraordinaria. Ganó tres premios Óscar incluyendo Mejor Película Internacional y Mejor Dirección. La película es una reflexión íntima sobre la memoria, la maternidad y la desigualdad de clases en México, narrada con una mirada poética y documental simultáneamente.'),

(50,'sinopsis',
'En un futuro distópico donde los replicantes han sido prohibidos en la Tierra, K es un agente de la policía de Los Ángeles que caza replicantes ilegales. Durante una misión, descubre un secreto enterrado que podría desequilibrar el orden de la sociedad. Su investigación lo lleva a buscar al legendario Rick Deckard, desaparecido desde hace treinta años.'),
(50,'descripcion',
'Blade Runner 2049 es una secuela que supera las expectativas al expandir el universo de la película original con preguntas más profundas sobre la humanidad, la identidad y la memoria. Denis Villeneuve dirige con una paciencia y una grandiosidad visual que rinde homenaje a Ridley Scott mientras construye algo genuinamente nuevo. La fotografía de Roger Deakins ganó el Óscar.'),

(52,'sinopsis',
'Chris Washington, un joven afroamericano, visita con su novia blanca Rose a los padres de ella en su mansión rural. Desde la llegada, Chris percibe algo profundamente perturbador en el comportamiento de los criados negros de la casa y en las actitudes de los amigos liberales de los Armitage. Lo que parecía una visita familiar normal esconde un horror racial de proporciones inconcebibles.'),
(52,'descripcion',
'Get Out es una película de terror que usa el género para construir una crítica devastadora al racismo encubierto de la clase media blanca liberal americana. Jordan Peele debutó como director con un guion magistralmente construido donde cada detalle tiene significado. La película fue un fenómeno cultural y ganó el Óscar al Mejor Guion Original.'),

(53,'sinopsis',
'Cuando la matriarca de la familia Graham muere, su hija Annie y el resto de la familia comienzan a descubrir secretos perturbadores sobre su linaje. Extraños sucesos se acumulan: presencias en la oscuridad, símbolos tallados en las paredes, y una tragedia devastadora que fractura a la familia. El horror se intensifica cuando Annie descubre la verdadera naturaleza del mal que persigue a su familia.'),
(53,'descripcion',
'Hereditary es una de las películas de terror más aclamadas de la última década, que combina el horror sobrenatural con un drama familiar devastador sobre el duelo y la culpa. Ari Aster construye un ambiente de terror psicológico de una eficacia aterradora. Toni Collette ofrece una de las actuaciones más intensas del cine de terror moderno.'),

(54,'sinopsis',
'Moonlight narra la vida de Chiron en tres capítulos que lo muestran de niño, adolescente y adulto joven. Criado en Miami por una madre adicta al crack, Chiron es un niño tímido y diferente que encuentra protección en Juan, un traficante local. La película sigue su camino de autodescubrimiento, explorando su identidad racial, social y sexual en un ambiente de violencia y marginalización.'),
(54,'descripcion',
'Moonlight ganó el Óscar a Mejor Película en una de las ceremonias más dramáticas de la historia. Barry Jenkins creó una obra de una delicadeza y una belleza visual extraordinarias sobre la identidad negra y la masculinidad queer en América. La película es íntima y universal a la vez, un retrato de la vulnerabilidad humana que trasciende cualquier etiqueta.'),

(55,'sinopsis',
'Mia es una aspirante a actriz que trabaja como barista en un estudio de cine en Los Ángeles. Sebastian es un pianista de jazz que sueña con abrir su propio club. Los dos se enamoran mientras persiguen sus sueños en una ciudad que parece diseñada para frustrarlos. La película alterna entre el musical exuberante de sus momentos de felicidad y el drama realista de sus ambiciones en conflicto.'),
(55,'descripcion',
'La La Land es un homenaje al Hollywood clásico y al musical de los años cincuenta filmado con una sensibilidad contemporánea. Damien Chazelle ganó el Óscar a Mejor Dirección con tan solo 32 años. La película equilibra la magia del musical con una historia de amor madura y agridulce sobre el precio de los sueños. Ganó seis premios Óscar.'),

(56,'sinopsis',
'Andrew Neiman es un joven baterista de jazz que ingresa al conservatorio de música más prestigioso de Nueva York. Es seleccionado por Terence Fletcher, el director de la orquesta de élite, que usa métodos de enseñanza brutales, humillantes y psicológicamente devastadores para llevar a sus músicos al límite. La relación entre maestro y alumno se convierte en una batalla de voluntades extrema.'),
(56,'descripcion',
'Whiplash es un estudio psicológico sobre la ambición, la excelencia y el precio del perfeccionismo. Damien Chazelle dirige con una energía vertiginosa que convierte una película sobre jazz en un thriller de suspense. J.K. Simmons ganó el Óscar al Mejor Actor de Reparto por su interpretación de Fletcher, uno de los maestros más memorablemente crueles del cine.'),

(57,'sinopsis',
'Durante la Primera Guerra Mundial, dos soldados británicos, Schofield y Blake, reciben una misión desesperada: cruzar territorio enemigo para entregar un mensaje que podría salvar la vida de 1.600 soldados, entre ellos el hermano de Blake. La película se desarrolla en tiempo real y fue filmada para parecer un único plano continuo sin cortes.'),
(57,'descripcion',
'1917 es un prodigio técnico y emocional del cine bélico. Sam Mendes y el director de fotografía Roger Deakins crearon la ilusión de una película rodada en un único plano continuo, sumergiéndo al espectador en la experiencia de la guerra de manera inmersiva e íntima. La película ganó tres premios Óscar y fue nominada a Mejor Película.'),

(58,'sinopsis',
'En mayo de 1940, el ejército aliado está atrapado en las playas de Dunkerque, Francia, acorralado por las fuerzas nazis sin posibilidad de escape. La película sigue tres líneas temporales simultáneas: los soldados en tierra esperando durante días, los civiles en sus barcos cruzando el Canal en horas, y los pilotos de la RAF luchando en el aire durante minutos para proteger la evacuación.'),
(58,'descripcion',
'Dunkerque es la película de guerra más experimental de Christopher Nolan, estructurada sobre tres escalas temporales que convergen. Con una narración mínima de diálogos y un uso monumental del sonido y la imagen, Nolan crea una experiencia de terror y supervivencia de una intensidad casi insoportable. Es cine de guerra sin glamour y sin heroísmo fácil.'),

(60,'sinopsis',
'Pepa, una actriz de doblaje de Madrid, intenta ponerse en contacto con su ex pareja Iván, que la ha dejado de manera abrupta. Mientras espera su llamada en su ático lleno de plantas y animales, se cruza con una serie de mujeres con sus propias crisis: la ex mujer de Iván acaba de salir de un psiquiátrico, su amiga Candela está mezclada con terroristas islámicos, y la nueva novia de Iván llega al apartamento.'),
(60,'descripcion',
'Mujeres al Borde de un Ataque de Nervios es la comedia más celebrada de Pedro Almodóvar y la película que lo lanzó a la fama internacional. Con un ritmo frenético, colores vibrantes y diálogos brillantes, la película es una farsa sobre el desamor, la solidaridad femenina y el caos de la vida moderna en Madrid. Fue nominada al Óscar a Mejor Película en Lengua Extranjera.'),

(63,'sinopsis',
'Un conductor silencioso y misterioso que trabaja de día como especialista de acción en Hollywood y de noche como conductor de escape para criminales, se involucra sentimentalmente con su vecina Irene y su hijo. Cuando intenta protegerlos de la deuda del marido de Irene con la mafia, el conductor queda atrapado en una espiral de violencia que amenaza con destruirlo todo.'),
(63,'descripcion',
'Drive es un neo-noir estilizado que combina influencias del cine europeo de arte y el cine de acción americano. Nicolas Winding Refn construye una atmósfera hipnótica con una banda sonora de synthwave nostálgica y una dirección de fotografía de colores neón. Ryan Gosling interpreta al conductor con un mutismo expresivo que lo convierte en uno de los personajes más carismáticos del cine contemporáneo.'),

(64,'sinopsis',
'En el Oeste americano, el alguacil Ed Tom Bell investiga una serie de crímenes relacionados con un cargamento de droga y dinero que el cazador Llewelyn Moss encontró en el desierto de Texas. El implacable sicario Anton Chigurh persigue a Moss mientras Bell reflexiona sobre la violencia y el mal en un mundo que ya no reconoce. La película es una meditación sobre el destino y la imposibilidad de detener el mal.'),
(64,'descripcion',
'No es País para Viejos es una adaptación de la novela de Cormac McCarthy realizada por los hermanos Coen con una frialdad y un rigor formal extraordinarios. Javier Bardem encarna a Anton Chigurh, uno de los villanos más aterradores de la historia del cine. La película ganó cuatro premios Óscar incluyendo Mejor Película y es una reflexión nihilista sobre la violencia y la mortalidad.');

-- ─── BANDAS SONORAS ────────────────────────────────────────────────────────

INSERT INTO banda_sonora (id_pelicula, nombre) VALUES
(11, 'Fight Club Original Score'),
(13, 'Pulp Fiction Soundtrack'),
(14, 'The Dark Knight Original Score'),
(15, 'The Matrix Original Score'),
(17, 'Forrest Gump Soundtrack'),
(18, 'The Lord of the Rings: The Fellowship of the Ring'),
(19, 'Titanic Original Soundtrack'),
(20, 'Requiem for a Dream Soundtrack'),
(26, 'Inception Original Score'),
(32, 'Joker Original Soundtrack'),
(45, 'Schindler''s List Original Score'),
(47, 'Black Swan Original Score'),
(50, 'Blade Runner 2049 Original Score'),
(55, 'La La Land Original Motion Picture Soundtrack'),
(56, 'Whiplash Original Motion Picture Soundtrack'),
(57, '1917 Original Motion Picture Soundtrack');

INSERT INTO cancion (id_banda, nombre, duracion) VALUES
-- Fight Club
(4, 'Who Is Tyler Durden?',         183),
(4, 'Medula Oblongata',             204),
-- Pulp Fiction
(5, 'Misirlou',                     155),
(5, 'Son of a Preacher Man',        162),
-- The Dark Knight
(6, 'Why So Serious?',              548),
(6, 'A Dark Knight',                421),
-- Matrix
(7, 'Main Title',                   171),
(7, 'Clubbed to Death',             300),
-- Forrest Gump
(8, 'Forrest Gump Suite',           183),
(8, 'Run Forrest Run',              152),
-- Lord of the Rings
(9, 'The Shire',                    221),
(9, 'Concerning Hobbits',           204),
(9, 'The Bridge of Khazad-dum',     378),
-- Titanic
(10,'My Heart Will Go On',          273),
(10,'Rose',                         192),
-- Requiem for a Dream
(11,'Lux Aeterna',                  201),
(11,'Meltdown',                     183),
-- Inception
(12,'Time',                         268),
(12,'Dream is Collapsing',          170),
-- Joker
(13,'Smile',                        183),
(13,'Bathroom Dance',               204),
-- Schindler's List
(14,'Theme from Schindler''s List', 196),
(14,'Jewish Town (Krakow Ghetto)',  222),
-- Black Swan
(15,'A Swan Lake',                  204),
(15,'Stumbled Beginnings',          183),
-- Blade Runner 2049
(16,'2049',                         285),
(16,'Mesa',                         310),
-- La La Land
(17,'City of Stars',                270),
(17,'Another Day of Sun',           253),
(17,'Mia & Sebastian''s Theme',     148),
-- Whiplash
(18,'Whiplash',                     204),
(18,'Caravan',                      373),
-- 1917
(19,'Nineteen Seventeen',           237),
(19,'Come Back to Us',              183);

-- ─── RESEÑAS ───────────────────────────────────────────────────────────────

INSERT INTO resena (id_usuario, id_pelicula, texto, calificacion) VALUES
-- Usuario 1 (Juan Alejandro)
(1,11,'El Club de la Pelea es una película que te golpea en la cara con su crítica al consumismo. El giro final es uno de los mejores de la historia del cine. Fincher y Pitt en su mejor momento.',5),
(1,14,'Heath Ledger como el Joker es simplemente insuperable. Cada escena en la que aparece es magnética. Nolan elevó el cine de superhéroes a algo que nunca había sido antes.',5),
(1,26,'Origen me rompió el cerebro la primera vez que la vi. La arquitectura de los sueños dentro de sueños es un ejercicio de narrativa compleja ejecutada con perfección. La peonza final...',5),
(1,32,'Joaquin Phoenix entrega una actuación que te rompe el corazón. El Joker de Todd Phillips es un estudio de la marginalización social más que una película de superhéroes.',4),
(1,55,'La La Land es una experiencia cinematográfica que mezcla la magia del musical con el realismo agridulce del amor. El final es perfecto precisamente porque no es el que esperabas.',5),
-- Usuario 2 (Juan José)
(2,12,'El Padrino es simplemente la mejor película que he visto. Cada diálogo, cada plano, cada actuación es perfecta. Marlon Brando define lo que significa ser el patriarca de una familia.',5),
(2,13,'Pulp Fiction cambió mi forma de ver el cine. La estructura no lineal, los diálogos filosóficos sobre hamburguesas, la violencia pop. Tarantino es un genio incomprendido.',5),
(2,15,'Matrix me explotó la mente a los 12 años y sigue siendo una película filosóficamente fascinante. El bullet time todavía se ve increíble. Keanu Reeves nunca estuvo mejor.',5),
(2,35,'Oldboy es una experiencia brutal e inolvidable. El giro final es uno de los más perturbadores del cine. Park Chan-wook es el maestro del thriller de venganza.',5),
(2,64,'No es País para Viejos es una obra maestra de la frialdad narrativa. Javier Bardem como Chigurh da miedo de verdad. Los hermanos Coen en su máximo nivel.',5),
-- Usuario 3 (María)
(3,17,'Forrest Gump me hace llorar cada vez sin importar cuántas veces la vea. Tom Hanks es la personificación de la bondad humana. Una película sobre la América del siglo XX contada con magia.',5),
(3,19,'Titanic es mi película romántica favorita de todos los tiempos. Sé que el final me va a destrozar y lo elijo ver igualmente. DiCaprio y Winslet tienen una química extraordinaria.',5),
(3,45,'La Lista de Schindler es devastadora y necesaria. El uso del blanco y negro hace que las pocas pinceladas de color sean más impactantes. La chica del abrigo rojo...',5),
(3,47,'Black Swan es una pesadilla bellísima. Natalie Portman es absolutamente increíble bailando y actuando simultáneamente. Aronofsky hace que dudes de lo que ves en pantalla.',5),
(3,54,'Moonlight es una de las películas más bellas que he visto. La historia de Chiron es íntima y universal a la vez. El color de cada capítulo cambia junto con la identidad del protagonista.',5),
-- Usuario 4 (Carlos)
(4,21,'El Laberinto del Fauno es la película de fantasía oscura más poética que existe. Guillermo del Toro construye un mundo mágico aterrador que coexiste con el horror franquista real.',5),
(4,23,'El Silencio de los Inocentes todavía me da escalofríos. La relación entre Clarice y Hannibal es uno de los juegos psicológicos más fascinantes del cine de thriller.',5),
(4,36,'En el Humor del Amor es cine puro. Wong Kar-wai construye la tensión sexual más intensa sin mostrar nada explícito. Tony Leung y Maggie Cheung son perfectos.',5),
(4,50,'Blade Runner 2049 es visualmente la película más hermosa que he visto en el cine. Roger Deakins merece todos los Óscares por la fotografía. Ryan Gosling está magnifico.',5),
(4,63,'Drive es la película más cool de la última década. El silencio de Ryan Gosling dice más que cualquier diálogo. La banda sonora de synthwave es perfecta.',5),
-- Usuario 5 (Ana)
(5,11,'El Club de la Pelea tiene una energía caótica perfectamente controlada. Edward Norton como el narrador es un tour de force. La primera regla del club de la pelea es no hablar del club de la pelea.',4),
(5,30,'Eterno Resplandor es la película romántica más original que existe. La idea de borrar recuerdos para escapar del dolor y descubrir que aún así los elegiría es devastadora.',5),
(5,31,'Her es una película de ciencia ficción sobre el amor que me hizo llorar. Spike Jonze entiende la soledad moderna de una manera que ningún otro director ha logrado.',5),
(5,34,'Antes del Amanecer es la película de amor más realista que he visto. Dos personas hablando toda la noche por una ciudad. Simple y absolutamente perfecta.',5),
(5,39,'Volver es Almodóvar en estado puro. Penélope Cruz es luminosa. La forma en que la película celebra a las mujeres fuertes de La Mancha es emotiva y hermosa.',5),
-- Usuario 6 (Pedro)
(6,16,'Gladiador es una épica que te tiene en el borde del asiento. Russell Crowe es magnético como Máximo. El Coliseo nunca se vería tan imponente en el cine.',5),
(6,18,'El Señor de los Anillos es la epopeya cinematográfica definitiva. Peter Jackson construyó la Tierra Media con un amor y un detalle que trasciende cualquier adaptación anterior.',5),
(6,22,'Petróleo Sangriento es una lección de interpretación de Daniel Day-Lewis. Lenta y monumental como la extracción de petróleo que retrata. BEBO TU BATIDO.',5),
(6,57,'1917 es el logro técnico cinematográfico más impresionante de los últimos años. La ilusión del plano continuo crea una tensión que no desaparece ni un segundo.',5),
(6,58,'Dunkerque es la mejor película de guerra que he visto. Sin héroes, sin discursos, solo la experiencia visceral del miedo y la supervivencia.',5),
-- Usuario 7 (Laura)
(7,20,'Réquiem por un Sueño es una película que no quiero ver de nuevo pero que no puedo olvidar. La música de Mansell se te mete en la cabeza. El final es devastador.',4),
(7,33,'El Pianista es una de las representaciones más sobrias y devastadoras del Holocausto. Adrien Brody lleva la película con una actuación silenciosa y poderosa.',5),
(7,48,'Roma es una película de una belleza visual extraordinaria. Yalitza Aparicio como Cleo es sorprendente para ser su debut. Cuarón le rinde homenaje a las mujeres que lo criaron.',5),
(7,52,'Get Out me aterró de una manera que ninguna película de terror convencional ha logrado. Jordan Peele construyó una crítica racial brillante dentro de un thriller de horror impecable.',5),
(7,60,'Mujeres al Borde de un Ataque de Nervios es la comedia más divertida de Almodóvar. El ritmo frenético y los colores vibrantes son únicos. Carmen Maura es perfecta.',5),
-- Usuario 8 (Diego)
(8,14,'El Caballero Oscuro redefine lo que puede ser una película de superhéroes. Nolan construyó una ciudad real con problemas reales y un villano filosóficamente aterrador.',5),
(8,26,'Origen es una de las pocas películas de ciencia ficción que te hace pensar durante días después de verla. La arquitectura de los sueños es impecable.',5),
(8,28,'Perdida es un thriller matrimonial de una frialdad perturbadora. El giro de la mitad es inesperado. Rosamund Pike debería haber ganado el Óscar.',5),
(8,29,'Prisioneros te hace sentir incómodo con tus propios juicios morales. Hugh Jackman y Jake Gyllenhaal están extraordinarios. Denis Villeneuve es un maestro del suspense.',5),
(8,56,'Whiplash es adrenalina pura. La última escena de batería es una de las más intensas de la historia del cine. J.K. Simmons da miedo de la manera correcta.',5),
-- Usuario 9 (Valentina)
(9,13,'Pulp Fiction es mi película favorita. Cada vez que la veo descubro un detalle nuevo. Los diálogos de Tarantino tienen un ritmo musical único.',5),
(9,27,'El Gran Hotel Budapest es el más delicioso de los mundos de Wes Anderson. La simetría, los colores pastel, Ralph Fiennes brillante. Es como vivir dentro de una ilustración.',5),
(9,34,'Antes del Amanecer es mi película romántica favorita. La química de Hawke y Delpy es tan natural que parece documental. Richard Linklater es un maestro de lo cotidiano.',5),
(9,47,'Black Swan es terror de alta costura. Aronofsky usa el ballet como metáfora de la autodestrucción con una precisión quirúrgica. Natalie Portman es sublime.',5),
(9,55,'La La Land me rompió el corazón de la manera más hermosa. El final alternativo es la escena más melancólica del cine romántico moderno.',5),
-- Usuario 10 (Sebastián)
(10,15,'Matrix es la película más influyente de los años noventa. El bullet time, la filosofía del simulacro, el diseño de producción. Todo en ella es perfecto y original.',5),
(10,35,'Oldboy me perturbó profundamente. El giro final es de los más impactantes que he experimentado en el cine. El cine coreano a su máximo nivel.',5),
(10,50,'Blade Runner 2049 es ciencia ficción de autor en su estado más puro. Lenta, contemplativa y visualmente sublime. Merece más reconocimiento del que recibió.',5),
(10,52,'Get Out es la película de terror más inteligente de la última década. Peele construye el horror con precisión quirúrgica usando el racismo cotidiano.',5),
(10,64,'No es País para Viejos es filosofía nihilista filmada con la frialdad de los hermanos Coen. Chigurh es el villano más aterrador por lo que representa, no por lo que hace.',5);

-- ─── VISUALIZACIONES ───────────────────────────────────────────────────────

INSERT INTO visualizacion (id_usuario, id_pelicula, tiempo_actual, completada, fecha_ultima) VALUES
(1,11,8340,TRUE,'2024-05-10 21:00:00'),
(1,14,9120,TRUE,'2024-05-12 22:30:00'),
(1,26,8880,TRUE,'2024-05-15 21:45:00'),
(1,32,7320,TRUE,'2024-05-18 20:00:00'),
(1,55,7680,TRUE,'2024-05-20 21:30:00'),
(2,12,10500,TRUE,'2024-05-08 22:00:00'),
(2,13,9240,TRUE,'2024-05-11 21:00:00'),
(2,15,8160,TRUE,'2024-05-13 22:00:00'),
(2,35,7200,TRUE,'2024-05-16 21:00:00'),
(2,64,7320,TRUE,'2024-05-19 22:30:00'),
(3,17,8520,TRUE,'2024-05-07 20:30:00'),
(3,19,11640,TRUE,'2024-05-09 21:00:00'),
(3,45,11700,TRUE,'2024-05-14 22:00:00'),
(3,47,6480,TRUE,'2024-05-17 21:30:00'),
(3,54,6660,TRUE,'2024-05-21 20:00:00'),
(4,21,7080,TRUE,'2024-05-06 21:00:00'),
(4,23,7080,TRUE,'2024-05-10 22:00:00'),
(4,36,5880,TRUE,'2024-05-13 20:30:00'),
(4,50,9840,TRUE,'2024-05-17 22:00:00'),
(4,63,6000,TRUE,'2024-05-22 21:00:00'),
(5,11,8340,TRUE,'2024-05-05 21:30:00'),
(5,30,6480,TRUE,'2024-05-08 22:00:00'),
(5,31,7560,TRUE,'2024-05-12 21:00:00'),
(5,34,6060,TRUE,'2024-05-15 20:30:00'),
(5,39,7260,TRUE,'2024-05-19 21:00:00'),
(6,16,9300,TRUE,'2024-05-04 22:00:00'),
(6,18,10680,TRUE,'2024-05-07 21:30:00'),
(6,22,9480,TRUE,'2024-05-11 22:00:00'),
(6,57,7140,TRUE,'2024-05-16 21:00:00'),
(6,58,6360,TRUE,'2024-05-21 22:30:00'),
(7,20,6120,TRUE,'2024-05-03 22:00:00'),
(7,33,9000,TRUE,'2024-05-09 21:30:00'),
(7,48,8100,TRUE,'2024-05-14 20:00:00'),
(7,52,6240,TRUE,'2024-05-18 21:00:00'),
(7,60,5340,TRUE,'2024-05-22 20:30:00'),
(8,14,9120,TRUE,'2024-05-02 22:00:00'),
(8,26,8880,TRUE,'2024-05-06 21:30:00'),
(8,28,8940,TRUE,'2024-05-10 22:00:00'),
(8,29,9180,TRUE,'2024-05-15 21:00:00'),
(8,56,6420,TRUE,'2024-05-20 22:00:00'),
(9,13,9240,TRUE,'2024-05-01 21:00:00'),
(9,27,5940,TRUE,'2024-05-05 20:30:00'),
(9,34,6060,TRUE,'2024-05-09 21:30:00'),
(9,47,6480,TRUE,'2024-05-13 22:00:00'),
(9,55,7680,TRUE,'2024-05-18 21:00:00'),
(10,15,8160,TRUE,'2024-04-30 22:00:00'),
(10,35,7200,TRUE,'2024-05-04 21:30:00'),
(10,50,9840,TRUE,'2024-05-08 22:00:00'),
(10,52,6240,TRUE,'2024-05-12 21:00:00'),
(10,64,7320,TRUE,'2024-05-17 22:30:00');

-- ─── FAVORITOS ─────────────────────────────────────────────────────────────

INSERT INTO favorito (id_usuario, id_pelicula) VALUES
(1,11),(1,14),(1,26),(1,55),
(2,12),(2,13),(2,15),(2,64),
(3,17),(3,19),(3,45),(3,54),
(4,21),(4,36),(4,50),(4,63),
(5,30),(5,31),(5,34),(5,39),
(6,16),(6,18),(6,57),(6,58),
(7,33),(7,48),(7,52),
(8,26),(8,29),(8,56),
(9,13),(9,27),(9,55),
(10,15),(10,35),(10,64);