SELECT DBLINK_CONNECT(
	'sistema_actual',
	'host=172.40.0.20 port=5432 password=admin user=admin dbname=facturacion'
);

create or replace function poblar_datawarehouse_sistema_nuevo(anio integer, mes integer) returns integer as
$$
begin
	-- crear tabla temporaria
	create table tmp_ventas as
	select
	* 
	from 
	dblink(
		'sistema_actual', 
		'select
		fecha_venta,
		v.id_factura,
		v.cod_cliente,
		dv.cod_producto,
		cast( (select (random() * 30) + 1) as integer) as cod_sucursal, -- Asignamos la sucursal at random, no hay en los sistemas viejo o nuevo rastros de sucursal
		cod_medio_pago,
		unidad * precio as monto_vendido,
		unidad as cantidad_vendida,
		p.nombre as nombre_producto,
		p.cod_categoria,
		p.cod_subcategoria,
		precio,
		c.nombre as nombre_cliente,
		c.cod_tipo
		from venta v, cliente c, detalle_venta dv, producto p
		where 
		v.id_factura = dv.id_factura
		and v.cod_cliente = c.cod_cliente
		and dv.cod_producto = p.cod_producto 
		and date_part ( ''month'',   fecha_venta) =  '|| $2 ||'
				and date_part (''year'',  fecha_venta) = ' || $1 ||'
		order by 1'
	) as st(
		fecha_venta date,
		id_factura integer,
		cod_cliente integer,
		cod_producto integer,
		cod_sucursal integer,
		cod_medio_pago integer,
		monto_vendido real,
		cantidad_vendida integer,
		nombre_producto varchar(100),
		cod_categoria integer,
		cod_subcategoria integer,
		precio real,
		nombre_cliente varchar(100),
		cod_tipo integer
	);
	-- Insertar clientes
	insert into cliente
	SELECT DISTINCT cliente_d_w as id_cliente, cod_tipo as id_tipo, nombre_cliente as nombre
	FROM tmp_ventas v, te_cliente te
	WHERE v.cod_cliente = te.cliente_s_n AND te.cliente_d_w not in (SELECT id_cliente from cliente);
	
	-- Insertar productos
	insert into producto
	SELECT DISTINCT 
	producto_d_w as id_producto, 
	cod_categoria as id_categoria,
	cod_subcategoria as id_subcategoria,
	nombre_producto as descripcion
	FROM tmp_ventas v, te_producto te
	WHERE v.cod_producto = te.producto_s_n AND te.producto_d_w not in (SELECT id_producto from producto);

	-- Insertar ventas
	INSERT INTO venta
	SELECT
	v.fecha_venta as fecha,
	v.id_factura as id_factura, 
	te_cliente.cliente_d_w as id_cliente, 
	te_producto.producto_d_w as id_producto, 
	v.cod_sucursal as id_sucursal, 
	v.cod_medio_pago as id_medio_pago, 
	v.monto_vendido as monto_vendido, 
	v.cantidad_vendida as cantidad_vendida,
	(select get_id_tiempo($1,$2)) as id_tiempo
	FROM tmp_ventas v, te_cliente, te_producto
	WHERE v.cod_cliente = te_cliente.cliente_s_n AND v.cod_producto =te_producto.producto_s_n
	and id_factura not in (select id_factura from venta);
	
	drop table tmp_ventas;
	return 0;
end;
$$ language plpgsql;
