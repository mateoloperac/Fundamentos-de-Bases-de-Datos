--consulta simple
select * from Artista
where nombre = 'Taylor Swift';

--operadores lógicos y ordenamiento
select top 2 * from Concierto as c 
where precioBase < 115 and precioBase > 90
order by precioBase asc;

-- in y not in
select * from Concierto
where artistaPrincipalId in (1, 3);
--where artistaPrincipalId not in (1, 3);

--group by y funciones de agregación
select estado, count(*) from Concierto as c
group by estado;

select c.lugarId, avg(precioBase) as promedio from Concierto as c
group by c.lugarId
order by promedio asc;

--having
select c.lugarId, avg(precioBase) as promedio from Concierto as c
group by c.lugarId
having avg(precioBase) = 95
order by promedio asc;