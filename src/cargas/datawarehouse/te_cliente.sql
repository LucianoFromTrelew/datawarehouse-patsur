-- Tabla de Equivalencia para clientes
CREATE TABLE te_cliente (
	cliente_s_v integer,
	cliente_s_n integer,
	cliente_d_w serial
);

create extension if not exists dblink
-- Creacion de tabla de equivalencia

-- Conexión con el sistema de facturación viejo
select dblink_connect(
	'sistema_viejo',
	'host=172.40.0.10 port=5432 password=admin user=admin dbname=facturacion'
);

-- Conexión con el sistema actual
select dblink_connect(
	'sistema_actual',
	'host=172.40.0.20 port=5432 password=admin user=admin dbname=facturacion'
);

-- Inserta en la tabla de equivalencia de clientes
-- teniendo en cuenta que pueden haber clientes con el mismo nombre,
-- en cuyo caso los inserta en la misma fila
select * from te_cliente
insert into te_cliente (cliente_s_n, cliente_s_v)
select consulta_actual.cod_cliente,consulta_viejo.nro_cliente from
dblink('sistema_actual', 'select cod_cliente, nombre from cliente')
as consulta_actual(cod_cliente integer,nombre varchar(50)) 
left join
dblink('sistema_viejo', 'select nro_cliente, nombre from cliente') 
as consulta_viejo(nro_cliente integer,nombre varchar(50)) on consulta_viejo.nombre = consulta_actual.nombre
