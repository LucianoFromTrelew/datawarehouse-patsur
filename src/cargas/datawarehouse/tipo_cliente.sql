CREATE EXTENSION IF NOT EXISTS dblink;

-- Conexión con el sistema actual
SELECT DBLINK_CONNECT(
	'sistema_actual',
	'host=172.40.0.20 port=5432 password=admin user=admin dbname=facturacion'
);

INSERT INTO tipo_cliente (id_tipo, descripcion)
SELECT
    *
FROM
    DBLINK('sistema_actual', 'SELECT * FROM tipo_cliente')
    AS consulta_actual(id_tipo integer, descripcion varchar(100));
