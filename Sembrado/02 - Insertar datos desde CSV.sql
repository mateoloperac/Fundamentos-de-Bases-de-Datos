--Instrucciones para importar los archivos

--Insertar los clientes
--Validar que la información quedo cargada
select * from cultivo.cliente

--Actualizar id que tenían comillas dobles
update cultivo.cliente
set id = REPLACE(id, '"', '')

--Insertar fincas a tabla temporal con import flat file
select * from cultivo.tmp_fincas

--Insertar datos en tabla final para ver como se inserta de una tabla a otra
insert into cultivo.finca
select * from cultivo.tmp_fincas

--eliminar tabla temporal
drop table cultivo.tmp_fincas

--Insertar datos en tabla usuario
select * from cultivo.usuario

--Intentar importar las facturas, muestra error
--Importar a tabla temporal para evitar error de tipado y consultar
select * from cultivo.tmp_facturas

--Hacer el insert en la tabla factura haciendo conversión de tipos
insert into cultivo.factura (id, fecha, total)
select id, cast(fecha as datetime2(7)), total
from cultivo.tmp_facturas

--Validar que si se hayan insertado todos los datos
select count(*) from cultivo.tmp_facturas
select count(*) from cultivo.factura

--Eliminar tabla 
drop table cultivo.tmp_facturas

--Importar despachos en tabla temporal, validar los datos y luego moverlos a la tabla definitiva
select * from cultivo.tmp_despachos

insert into cultivo.despacho (id, fecha, id_cliente, id_factura)
select id, cast(fecha as datetime2(7)), id_cliente, id_factura from cultivo.tmp_despachos

--Importar m_cultivo
select * from cultivo.m_cultivo

--Importar lote
select * from cultivo.lote

--Actualizar id que tenían comillas dobles
update cultivo.lote
set id = REPLACE(id, '"', '')
where id like '%"%'

--Importar precio en temporal y moverla
select * from cultivo.tmp_precios

insert into cultivo.precio
select id, id_cultivo, valor, cast(fecha as datetime2(7)) from cultivo.tmp_precios

--Importar datos de recogidas en tmp y permitiendo valores null
insert into cultivo.recogida
select * from cultivo.tmp_recogidas

--Comparar totales con excel para estar tranquilos
select count(*), sum(cantidad) from cultivo.tmp_recogidas

--Eliminar tablas temporales
drop table cultivo.tmp_despachos
drop table cultivo.tmp_precios
drop table cultivo.tmp_recogidas