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


CREATE OR REPLACE FUNCTION get_random_date(min timestamp, max timestamp) RETURNS SETOF date AS $$
/*
    Genera una fecha aleatoria en el rango especificado
    Recibe dos timestamp min y max
    Devuelve una fecha aleatoria entre [min, max]
 */
BEGIN

    RETURN QUERY
    SELECT date(min +
       random() * (max - min));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_random_cliente() RETURNS SETOF cliente AS $$
/*
    Devuelve un cliente aleatorio
    No recibe nada
    Devuelve un registro de la tabla cliente
*/
BEGIN
    RETURN QUERY
    SELECT * 
    FROM cliente
    ORDER BY random()
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_random_medio_pago() RETURNS SETOF medio_pago AS $$
/*
    Devuelve un medio de pago aleatorio
    No recibe nada
    Devuelve un registro de la tabla medio_pago
*/
BEGIN
    RETURN QUERY
    SELECT * 
    FROM medio_pago
    ORDER BY random()
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insertar_ventas(cantidad_ventas integer) RETURNS VOID AS $$
/*
    Inserta ventas masivamente
    Recibe una cantidad de ventas a ingresar
    No devuelve nada
*/
DECLARE
    MIN_FECHA CONSTANT timestamp := '2010-03-01';
    MAX_FECHA CONSTANT timestamp := '2018-06-01';
    MIN_NRO_FACTURA CONSTANT integer := 1;
    MAX_NRO_FACTURA CONSTANT integer := 1000000;

    i integer;
    fecha_venta date;
    nro_factura integer;
    cliente cliente%ROWTYPE;
    medio_pago medio_pago%ROWTYPE;
BEGIN
    FOR i IN 1..cantidad_ventas LOOP
        SELECT INTO fecha_venta get_random_date(
            MIN_FECHA,
            MAX_FECHA
        );
        SELECT INTO nro_factura get_random_range_int(
            MIN_NRO_FACTURA, 
            MAX_NRO_FACTURA
        );
        SELECT * INTO cliente FROM get_random_cliente();
        SELECT * INTO medio_pago FROM get_random_medio_pago();

        RAISE NOTICE '[%/%] INSERTANDO VENTA (%, %, %, %, %)',
            i,
            cantidad_ventas,
            fecha_venta,
            nro_factura,
            cliente.cod_cliente,
            cliente.nombre,
            medio_pago.descripcion;

        INSERT INTO venta VALUES(
            fecha_venta,
            nro_factura,
            cliente.cod_cliente,
            cliente.nombre,
            medio_pago.cod_medio_pago
        ) ON CONFLICT DO NOTHING;

    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT insertar_ventas(
    10
    -- get_random_range_int(100000, 1000000)
);
