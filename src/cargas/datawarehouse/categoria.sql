CREATE EXTENSION IF NOT EXISTS dblink;

-- Conexión con el sistema actual
SELECT DBLINK_CONNECT(
	'sistema_actual',
	'host=172.40.0.20 port=5432 password=admin user=admin dbname=facturacion'
);

INSERT INTO categoria (id_categoria, id_subcategoria, descripcion)
SELECT
    *
FROM
    DBLINK('sistema_actual', 'SELECT * FROM categoria')
    AS consulta_actual(id_categoria integer, id_subcategoria integer, descripcion varchar(100));
