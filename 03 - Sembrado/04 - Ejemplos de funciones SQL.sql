-- Ejemplos de funciones SQL para la base de datos de cultivo

-- 1. Función para obtener el total facturado a un cliente en un período
CREATE OR ALTER FUNCTION cultivo.fn_TotalFacturadoCliente(
    @p_id_cliente nvarchar(1000),
    @p_fecha_inicio datetime2,
    @p_fecha_fin datetime2
)
RETURNS float
AS
BEGIN
    DECLARE @valor_total float;
    
    SELECT @valor_total = SUM(f.total)
    FROM cultivo.factura f
    JOIN cultivo.despacho d ON f.id = d.id_factura
    WHERE d.id_cliente = @p_id_cliente
      AND f.fecha BETWEEN @p_fecha_inicio AND @p_fecha_fin;
    
    RETURN coalesce(@valor_total, 0);
END;

-- Ejemplo de uso:
-- SELECT cultivo.fn_TotalFacturadoCliente('03fc5db0-6506-4e68-97ec-9a1d7e5844d9', '2014-01-01', '2023-01-01')

-- 2. Función para obtener la cantidad total recogida por lote
CREATE OR ALTER FUNCTION cultivo.fn_CantidadTotalPorLote(@id_lote nvarchar(1000))
RETURNS float
AS
BEGIN
    DECLARE @cantidad_total float;
    
    SELECT @cantidad_total = SUM(cantidad)
    FROM cultivo.recogida
    WHERE id_lote = @id_lote;
    
    RETURN ISNULL(@cantidad_total, 0);
END;

-- Ejemplo de uso:
-- SELECT cultivo.fn_CantidadTotalPorLote('id_lote_ejemplo');

-- 3. Función para obtener el nombre completo de un lote (incluye finca y cultivo)
CREATE OR ALTER FUNCTION cultivo.fn_NombreCompletoLote(@id_lote nvarchar(1000))
RETURNS nvarchar(3000)
AS
BEGIN
    DECLARE @nombre_completo nvarchar(3000);
    
    SELECT @nombre_completo = CONCAT(l.nombre, ' (Finca: ', f.nombre, ', Cultivo: ', mc.nombre, ')')
    FROM cultivo.lote l
    JOIN cultivo.finca f ON l.id_finca = f.id
    JOIN cultivo.m_cultivo mc ON l.id_cultivo = mc.id
    WHERE l.id = @id_lote;
    
    RETURN @nombre_completo;
END;

-- Ejemplo de uso:
-- SELECT cultivo.fn_NombreCompletoLote('id_lote_ejemplo');

-- 4. Función para verificar si un despacho está completamente facturado
CREATE OR ALTER FUNCTION cultivo.fn_DespachoFacturado(@id_despacho nvarchar(1000))
RETURNS bit
AS
BEGIN
    DECLARE @facturado bit = 0;
    
    IF EXISTS (
        SELECT 1 
        FROM cultivo.despacho 
        WHERE id = @id_despacho AND id_factura IS NOT NULL
    )
        SET @facturado = 1;
    
    RETURN @facturado;
END;

-- Ejemplo de uso:
-- SELECT cultivo.fn_DespachoFacturado('id_despacho_ejemplo');

-- 5. Función para obtener el resumen de producción por finca
CREATE OR ALTER FUNCTION cultivo.fn_ResumenProduccionFinca(@id_finca nvarchar(1000))
RETURNS TABLE
AS
RETURN (
    SELECT 
        mc.id AS id_cultivo,
        mc.nombre AS nombre_cultivo,
        COUNT(DISTINCT l.id) AS total_lotes,
        COUNT(r.id) AS total_recogidas,
        SUM(r.cantidad) AS cantidad_total
    FROM cultivo.finca f
    JOIN cultivo.lote l ON f.id = l.id_finca
    JOIN cultivo.m_cultivo mc ON l.id_cultivo = mc.id
    LEFT JOIN cultivo.recogida r ON l.id = r.id_lote
    WHERE f.id = @id_finca
    GROUP BY mc.id, mc.nombre
);

-- Ejemplo de uso:
-- SELECT * FROM cultivo.fn_ResumenProduccionFinca('id_finca_ejemplo');

-- 6. Función para obtener el rendimiento promedio diario de un lote
CREATE OR ALTER FUNCTION cultivo.fn_RendimientoDiarioLote(@id_lote nvarchar(1000))
RETURNS float
AS
BEGIN
    DECLARE @rendimiento float;
    DECLARE @primera_recogida datetime2;
    DECLARE @ultima_recogida datetime2;
    DECLARE @cantidad_total float;
    DECLARE @dias_activo int;
    
    -- Obtener datos de recogidas del lote
    SELECT 
        @primera_recogida = MIN(fecha),
        @ultima_recogida = MAX(fecha),
        @cantidad_total = SUM(cantidad)
    FROM cultivo.recogida
    WHERE id_lote = @id_lote;
    
    -- Calcular días activos
    SET @dias_activo = DATEDIFF(day, @primera_recogida, @ultima_recogida);
    
    -- Calcular rendimiento diario
    IF @dias_activo = 0
        SET @rendimiento = @cantidad_total;
    ELSE
        SET @rendimiento = @cantidad_total / @dias_activo;
    
    RETURN ISNULL(@rendimiento, 0);
END;

-- Ejemplo de uso:
-- SELECT cultivo.fn_RendimientoDiarioLote('id_lote_ejemplo');