CREATE OR REPLACE FUNCTION get_random_range_int(min integer, max integer) RETURNS SETOF INTEGER AS $$
/*
    Genera un entero aleatorio en el rango especificado
    Recibe dos enteros min y max
    Devuelve un entero aleatorio entre [min, max] 
*/
BEGIN
    RETURN QUERY
    SELECT *
    FROM generate_series(min, max)
    ORDER BY random()
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_random_venta() RETURNS SETOF venta AS $$
/*
    Devuelve una venta aleatoria
    No recibe nada
    Devuelve un registro de la tabla venta
*/
BEGIN
    RETURN QUERY
    SELECT * 
    FROM venta
    ORDER BY random()
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_random_producto() RETURNS SETOF producto AS $$
/*
    Devuelve un producto aleatorio
    No recibe nada
    Devuelve un registro de la tabla producto
*/
BEGIN
    RETURN QUERY
    SELECT * 
    FROM producto
    ORDER BY random()
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insertar_detalle_venta(cantidad_detalles integer) RETURNS VOID AS $$
/*
    Inserta los detalles de venta masivamente
    Recibe una cantidad de detalles a ingresar
    No devuelve nada
*/
DECLARE
    MIN_UNIDAD CONSTANT integer := 1;
    MAX_UNIDAD CONSTANT integer := 100;

    i integer;
    venta venta%ROWTYPE;
    producto producto%ROWTYPE;
    unidad integer;
BEGIN
    FOR i IN 1..cantidad_detalles LOOP
        SELECT * INTO venta FROM get_random_venta();
        SELECT * INTO producto FROM get_random_producto();
        SELECT INTO unidad get_random_range_int(
            MIN_UNIDAD,
            MAX_UNIDAD
        );

        RAISE NOTICE '[%/%] INSERTANDO DETALLE (%, %, %, %)',
            i,
            cantidad_detalles,
            venta.nro_factura,
            producto.nro_producto,
            unidad,
            producto.precio_actual;

        INSERT INTO detalle_venta VALUES(
            venta.nro_factura,
            producto.nro_producto,
            producto.nombre,
            unidad,
            producto.precio_actual
        ) ON CONFLICT DO NOTHING;

    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT insertar_detalle_venta(
    10
    -- get_random_range_int(100000, 1000000)
);
