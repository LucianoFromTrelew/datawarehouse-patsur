create extension if not exists dblink;
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

insert into te_producto (producto_s_n, producto_s_v)
select consulta_actual.cod_producto ,consulta_viejo.nro_producto from
dblink('sistema_actual', 'select cod_producto, nombre from producto')
as consulta_actual(cod_producto integer,nombre varchar(50)) 
left join
dblink('sistema_viejo', 'select nro_producto, nombre from producto') 
as consulta_viejo(nro_producto integer,nombre varchar(50)) 
    on consulta_viejo.nombre = consulta_actual.nombre;

