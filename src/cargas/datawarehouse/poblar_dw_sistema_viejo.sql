create or replace function poblar_datawarehouse_sistema_viejo(anio integer, mes integer) returns integer as
$$
begin
    PERFORM DBLINK_CONNECT(
        'sistema_viejo',
        'host=172.40.0.10 port=5432 password=admin user=admin dbname=facturacion'
    );
	-- crear tabla temporaria
	create table tmp_ventas as
	select
	* 
	from 
	dblink(
		'sistema_viejo', 
		'select
		fecha_venta,
		v.nro_factura,
		v.nro_cliente,
		dv.nro_producto,
		cast( (select (random() * 30) + 1) as integer) as cod_sucursal, -- Asignamos la sucursal at random, no hay en los sistemas viejo o nuevo rastros de sucursal
		case 
		when v.forma_pago = ''DEPOSITO'' then 5
		when v.forma_pago = ''EFECTIVO'' then 1
		when v.forma_pago = ''CHEQUE'' then 4
		end as cod_medio_pago,
		unidad * precio as monto_vendido,
		unidad as cantidad_vendida,
		p.nombre as nombre_producto,
		p.nro_categ,
		1,
		precio_actual,
		c.nombre as nombre_cliente,
		c.tipo
		from venta v, cliente c, detalle_venta dv, producto p
		where 
		v.nro_factura = dv.nro_factura
		and v.nro_cliente = c.nro_cliente
		and dv.nro_producto = p.nro_producto 
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
	WHERE v.cod_cliente = te.cliente_s_v AND te.cliente_d_w not in (SELECT id_cliente from cliente);
	
	-- Insertar productos
	insert into producto
	SELECT DISTINCT 
	producto_d_w as id_producto, 
	cod_categoria as id_categoria,
	cod_subcategoria as id_subcategoria,
	nombre_producto as descripcion
	FROM tmp_ventas v, te_producto te
	WHERE v.cod_producto = te.producto_s_v AND te.producto_d_w not in (SELECT id_producto from producto);

	-- Insertar ventas
	INSERT INTO venta
	SELECT
	v.fecha_venta as fecha,
	(select get_id_tiempo($1,$2)) as id_tiempo,
	v.id_factura as id_factura, 
	te_cliente.cliente_d_w as id_cliente, 
	te_producto.producto_d_w as id_producto, 
	v.cod_sucursal as id_sucursal, 
	v.cod_medio_pago as id_medio_pago, 
	v.monto_vendido as monto_vendido, 
	v.cantidad_vendida as cantidad_vendida
	FROM tmp_ventas v, te_cliente, te_producto
	WHERE v.cod_cliente = te_cliente.cliente_s_v AND v.cod_producto =te_producto.producto_s_v
	and id_factura not in (select id_factura from venta);
	
	drop table tmp_ventas;
    PERFORM DBLINK_DISCONNECT('sistema_viejo');
	return 0;
end;
$$ language plpgsql;
