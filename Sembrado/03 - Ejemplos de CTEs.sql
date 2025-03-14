-- Ejemplos de subqueries resueltos con Common Table Expressions (CTEs) y window functions
-- para la base de datos de cultivo

-- 1. Listar las recogidas con la cantidad de cada recogida, el total de recogidas por lote
-- y el porcentaje sobre el total de recogidas por lote
WITH TotalRecogidasPorLote AS (
    SELECT 
        id_lote,
        SUM(cantidad) AS total_recogidas
    FROM cultivo.recogida
    GROUP BY id_lote
)
SELECT 
    r.id AS id_recogida,
    r.cantidad,
    trl.total_recogidas,
    (r.cantidad / trl.total_recogidas) * 100 AS porcentaje_sobre_total
FROM cultivo.recogida r
JOIN TotalRecogidasPorLote trl ON r.id_lote = trl.id_lote
ORDER BY porcentaje_sobre_total DESC;

-- 2. Listar los despachos pendientes de facturación con el total de recogidas y cantidad
-- y con un estado de pendiente de facturar o sin recogidas cuando la cantidad es 0
WITH DespachosSinFactura AS (
    SELECT 
        d.id AS id_despacho,
        d.fecha,
        c.nombre AS cliente,
        COUNT(r.id) AS total_recogidas,
        SUM(r.cantidad) AS cantidad_total
    FROM cultivo.despacho d
    JOIN cultivo.cliente c ON d.id_cliente = c.id
    LEFT JOIN cultivo.recogida r ON d.id = r.id_despacho
    WHERE d.id_factura IS NULL
    GROUP BY d.id, d.fecha, c.nombre
)
SELECT 
    dsf.*,
    CASE 
        WHEN total_recogidas = 0 THEN 'Sin recogidas'
        ELSE 'Pendiente de facturar'
    END AS estado
FROM DespachosSinFactura dsf
ORDER BY fecha DESC;

-- 3. Encontrar recogidas que superan el promedio de su cultivo en el mismo mes
-- para cada cultivo, mostrar el promedio mensual, la diferencia con el
-- promedio mensual (cantidad - promedio mensual) y el porcentaje sobre el
-- promedio mensual ((cantidad / promedio mensual) - 1) * 100
WITH PromedioMensualPorCultivo AS (
    SELECT 
        YEAR(r.fecha) AS año,
        MONTH(r.fecha) AS mes,
        l.id_cultivo,
        AVG(r.cantidad) AS promedio_mensual
    FROM cultivo.recogida r
    JOIN cultivo.lote l ON r.id_lote = l.id
    GROUP BY YEAR(r.fecha), MONTH(r.fecha), l.id_cultivo
)
SELECT 
    r.id AS id_recogida,
    r.fecha,
    r.cantidad,
    mc.nombre AS cultivo,
    pmc.promedio_mensual,
    (r.cantidad - pmc.promedio_mensual) AS diferencia_del_promedio,
    ((r.cantidad / pmc.promedio_mensual) - 1) * 100 AS porcentaje_sobre_promedio
FROM cultivo.recogida r
JOIN cultivo.lote l ON r.id_lote = l.id
JOIN cultivo.m_cultivo mc ON l.id_cultivo = mc.id
JOIN PromedioMensualPorCultivo pmc ON 
    YEAR(r.fecha) = pmc.año AND 
    MONTH(r.fecha) = pmc.mes AND 
    l.id_cultivo = pmc.id_cultivo
WHERE r.cantidad > pmc.promedio_mensual
ORDER BY porcentaje_sobre_promedio DESC;

-- 4. Repetir el ejercicio 1 con window functions
select id as id_recogida,
cantidad,
sum(cantidad) over (partition by id_lote) as total_recogidas,
(cantidad/sum(cantidad) over (partition by id_lote))*100 as porcentaje_sobre_total
from cultivo.recogida
ORDER BY porcentaje_sobre_total DESC;

-- 5. Encontrar las fincas más productivas por tipo de cultivo
WITH ProduccionPorFincaYCultivo AS (
    SELECT 
        f.id AS id_finca,
        f.nombre AS nombre_finca,
        mc.id AS id_cultivo,
        mc.nombre AS nombre_cultivo,
        SUM(r.cantidad) AS cantidad_total
    FROM cultivo.finca f
    JOIN cultivo.lote l ON f.id = l.id_finca
    JOIN cultivo.m_cultivo mc ON l.id_cultivo = mc.id
    JOIN cultivo.recogida r ON l.id = r.id_lote
    GROUP BY f.id, f.nombre, mc.id, mc.nombre
),
RankingProduccion AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY id_cultivo ORDER BY cantidad_total DESC) AS ranking
    FROM ProduccionPorFincaYCultivo
)
SELECT 
    id_finca,
    nombre_finca,
    id_cultivo,
    nombre_cultivo,
    cantidad_total
FROM RankingProduccion
WHERE ranking = 1
ORDER BY cantidad_total DESC;


