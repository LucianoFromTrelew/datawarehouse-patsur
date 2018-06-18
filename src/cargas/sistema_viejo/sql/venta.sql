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

CREATE OR REPLACE FUNCTION get_random_forma_pago() RETURNS VARCHAR(10) AS $$
/*
    Devuelve una forma de pago aleatorio
    No recibe nada
    Devuelve una cadena con uno de los valores posibles 
    ['EFECTIVO', 'DEBITO', 'CREDITO', 'CHEQUE', 'DEPOSITO']
*/
DECLARE
    i integer;
    formas_pago varchar(10)[] = array['EFECTIVO', 'DEBITO', 'CREDITO', 'CHEQUE', 'DEPOSITO'];
BEGIN
    SELECT INTO i get_random_range_int(1, 5);
    RETURN formas_pago[i];
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insertar_ventas(cantidad_ventas integer) RETURNS VOID AS $$
/*
    Inserta ventas masivamente
    Recibe una cantidad de ventas a ingresar
    No devuelve nada
*/
DECLARE
    MIN_FECHA CONSTANT timestamp := '1990-01-01';
    MAX_FECHA CONSTANT timestamp := '2010-01-01';
    MIN_NRO_FACTURA CONSTANT integer := 1;
    MAX_NRO_FACTURA CONSTANT integer := 1000000;

    i integer;
    fecha_venta date;
    nro_factura integer;
    cliente cliente%ROWTYPE;
    forma_pago varchar(10);
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
        SELECT INTO forma_pago get_random_forma_pago();

        RAISE NOTICE '[%/%] INSERTANDO VENTA (%, %, %, %, %)',
            i,
            cantidad_ventas,
            fecha_venta,
            nro_factura,
            cliente.nro_cliente,
            cliente.nombre,
            forma_pago;

        INSERT INTO venta VALUES(
            fecha_venta,
            nro_factura,
            cliente.nro_cliente,
            cliente.nombre,
            forma_pago
        ) ON CONFLICT DO NOTHING;

    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT insertar_ventas(
    10
    -- get_random_range_int(100000, 1000000)
);
