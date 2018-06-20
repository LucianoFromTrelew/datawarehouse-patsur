CREATE EXTENSION IF NOT EXISTS dblink;

-- Conexión con el sistema actual
SELECT DBLINK_CONNECT(
	'sistema_actual',
	'host=172.40.0.20 port=5432 password=admin user=admin dbname=facturacion'
);

INSERT INTO medios (id_medio_pago, descripcion)
SELECT
    *
FROM
    DBLINK('sistema_actual', 'SELECT cod_medio_pago, descripcion FROM medio_pago')
    AS consulta_actual(id_medio_pago integer, descripcion varchar(100));
