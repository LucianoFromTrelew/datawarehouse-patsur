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

INSERT INTO te_cliente (cliente_s_n, cliente_s_v)
SELECT
    consulta_actual.cod_cliente,
    consulta_viejo.nro_cliente
FROM
    DBLINK('sistema_actual', 'SELECT cod_cliente, nombre FROM cliente')
    AS consulta_actual(cod_cliente integer, nombre varchar(50))
    LEFT JOIN
        DBLINK('sistema_viejo', 'select nro_cliente, nombre from cliente')
        AS consulta_viejo(nro_cliente integer, nombre varchar(50))
    ON consulta_viejo.nombre = consulta_actual.nombre;
