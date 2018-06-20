CREATE EXTENSION IF NOT EXISTS dblink;
-- Creacion de tabla de equivalencia

-- Conexión con el sistema de facturación viejo
SELECT DBLINK_CONNECT(
	'sistema_viejo',
	'host=172.40.0.10 port=5432 password=admin user=admin dbname=facturacion'
);

-- Conexión con el sistema actual
SELECT DBLINK_CONNECT(
	'sistema_actual',
	'host=172.40.0.20 port=5432 password=admin user=admin dbname=facturacion'
);

-- Inserta en la tabla de equivalencia de clientes
-- teniendo en cuenta que pueden haber clientes con el mismo nombre,
-- en cuyo caso los inserta en la misma fila

INSERT INTO te_producto (producto_s_n, producto_s_v)
SELECT 
    consulta_actual.cod_producto,
    consulta_viejo.nro_producto 
FROM
    DBLINK('sistema_actual', 'SELECT cod_producto, nombre FROM producto')
    AS consulta_actual(cod_producto integer, nombre varchar(100))
    LEFT JOIN
        DBLINK('sistema_viejo', 'SELECT nro_producto, nombre FROM producto')
        AS consulta_viejo(nro_producto integer, nombre varchar(100))
    ON consulta_viejo.nombre = consulta_actual.nombre;

