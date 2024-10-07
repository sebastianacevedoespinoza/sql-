-- Database: Prueba-Sebastian-Acevedo

-- DROP DATABASE IF EXISTS "Prueba-Sebastian-Acevedo";

CREATE DATABASE "Prueba-Sebastian-Acevedo"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Spain.1252'
    LC_CTYPE = 'Spanish_Spain.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


Create Table peliculas(
id Integer Primary Key,
nombre Varchar(255) not Null,
anno Integer not Null
);

Create Table tags(
id Integer Primary Key,
tag Varchar(32) not Null
);

--tabla intermedia
Create Table pelicula_tag(
pelicula_id Integer References peliculas(id),
tag_id Integer References tags(id)
);

--insertando datos en la tablas peliculas
Insert Into peliculas(id,
nombre, anno) Values
(1, 'Interstellar', 2014),
(2, 'Oppenheimer', 2023),
(3, 'Back to Future', 1985),
(4, 'Batman', 2022),
(5, 'Home Alone', 1990);

Select * From peliculas;

--instertando datos en la tabla tags
Insert Into tags(id, tag) Values
(1, 'Ciencia Ficcion'),
(2, 'Ciencia'),
(3, 'Aventura'),
(4, 'Accion'),
(5, 'Familiar');

Select * From tags;

-- insertando datos en la tabla intermedia
Insert Into pelicula_tag (pelicula_id, tag_id) Values
(1,1),
(1,2),
(1,3),
(2,4),
(2,5);

Select * From pelicula_tag;


-- Cuenta la cantidad de tags que tiene cada película
Select peliculas.id As id_pelicula, peliculas.nombre As nombre_pelicula, Count(pelicula_tag.tag_id) As cantidad_tags
From peliculas
Left Join pelicula_tag On peliculas.id=pelicula_id
Group By peliculas.id, peliculas.nombre
Order By peliculas.id Asc;

-- Otro Modelo

-- creando tabla preguntas
Create Table preguntas(
id Integer Primary Key,
pregunta Varchar(255),
respuesta_correcta Varchar
);

--Creando la tabla usuarios 
Create Table usuarios(
id Integer Primary Key,
nombre Varchar(255),
edad Integer
);

-- creando la tabla intermedia respuestas
Create Table respuestas(
id Integer Primary Key,
respuesta Varchar(255),
usuario_id Integer,
pregunta_id Integer,
Foreign Key (usuario_id) References usuarios(id),
Foreign Key (pregunta_id) References preguntas(id)
);

-- insertando datos en la tabla preguntas
Insert Into preguntas (id, pregunta, respuesta_correcta) Values
(1,'¿se puede dividir por 0?', 'no'),
(2,'¿la asociatividad en multiplicacion es valida?', 'si'),
(3,'¿la materia oscura es visible?', 'no'),
(4,'¿el potencial electromagnetico es de largo alcance?','si'),
(5,'¿el boson de Higgs le da masa a las particulas subatomicas?', 'si');

Select * From preguntas;

-- intersando datos en la tabla usuarios
Insert Into usuarios(id, nombre, edad) Values
(1,'Sebastian', 39),
(2,'Vittorio',12),
(3, 'Cecilia', 64),
(4,'Javiera', 35),
(5,'Juan', 66);

Select * From usuarios;

-- insertando datos en la tabla respuestas
Insert Into respuestas(id, respuesta, usuario_id, pregunta_id) Values
(1,'no',1,2),
(2,'no',2,1),
(3,'si',3,5),
(4,'si',4,5),
(5,'si',5,5);

Select * From respuestas;

--Cuenta la cantidad de respuestas correctas totales por usuario
Select usuarios.id, usuarios.nombre, Count(respuestas.respuesta = preguntas.respuesta_correcta) As respuestas_correctas
From usuarios
Left Join respuestas On respuestas.usuario_id = usuarios.id
Left Join preguntas On respuestas.pregunta_id = preguntas.id
And respuestas.respuesta = preguntas.respuesta_correcta
Group By usuarios.id, usuarios.nombre
Order By usuarios.id;

--Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente
Select preguntas.id, preguntas.pregunta, Count(respuestas.usuario_id) As numero_usuarios
From preguntas
Left Join respuestas
On respuestas.pregunta_id = preguntas.id
And respuestas.respuesta = preguntas.respuesta_correcta
Group By preguntas.id, preguntas.pregunta
Order By preguntas.id Asc;

--Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario
Alter Table respuestas
Drop Constraint respuestas_usuario_id_fkey,
Add Foreign Key (usuario_id)
References usuarios(id)
On Delete Cascade;
-- borrando 1er usuario
Delete From usuarios Where id=1;

--visualizando la tabla respuestas
Select * From respuestas;

--Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos
Alter Table usuarios
Add Constraint check_edad_mayor_18 Check (edad >=18);

--Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único

-- agregando la columna email
Alter Table usuarios
Add email Varchar Unique;

--agregando email en tabla usuarios
Update usuarios Set email = Case
When id = 1 Then 'sebastian@mail.com'
When id = 2 Then 'vittorio@mail.com'
When id = 3 Then 'cecilia@mail.com'
When id = 4 Then 'javiera@mail.com'
When id = 5 Then 'juan@mail.com'

Else 'usuario sin email' end;

Select * From usuarios;