-- Creamos vistas que reunan todos los datos de las tablas de dimensión del DW
-- así podemos armar el cubo OLAP en Pentaho más fácilmente (simulamos un esquema estrella)

CREATE VIEW productos_dim_view AS 
    SELECT 
        prod.id_producto, 
        prod.id_categoria, 
        prod.id_subcategoria, 
        prod.descripcion, 
        cat.descripcion AS cat_descripcion 
    FROM 
        producto AS prod 
        LEFT JOIN categoria AS cat ON prod.id_categoria=cat.id_categoria AND prod.id_subcategoria=cat.id_subcategoria;

CREATE VIEW sucursales_dim_view AS 
    SELECT 
        suc.id_sucursal, 
        suc.descripcion AS nombre_sucursal, 
        ciud.id_ciudad, 
        ciud.descripcion AS nombre_ciudad, 
        prov.id_provincia, 
        prov.descripcion AS nombre_provincia, 
        reg.id_region, 
        reg.descripcion AS nombre_region 
    FROM 
        distribucion_geografica AS suc 
        LEFT JOIN ciudad AS ciud ON suc.id_ciudad=ciud.id_ciudad 
        LEFT JOIN provincia AS prov ON ciud.id_provincia=prov.id_provincia 
        LEFT JOIN region AS reg ON prov.id_region=reg.id_region;

CREATE VIEW clientes_dim_view AS 
    SELECT 
        cli.id_cliente, 
        cli.nombre, 
        tc.id_tipo, 
        tc.descripcion 
    FROM 
        cliente AS cli 
        LEFT JOIN tipo_cliente AS tc ON cli.id_tipo=tc.id_tipo;

CREATE VIEW tiempo_dim_view AS
    SELECT
        t.id_tiempo,
        t.anio,
        CASE 
            WHEN t.mes >= 1 AND t.mes <= 3
                THEN 'Primer trimestre'
            WHEN t.mes >= 4 AND t.mes <= 6
                THEN 'Segundo trimestre'
            WHEN t.mes >= 7 AND t.mes <= 9
                THEN 'Tercer trimestre'
            WHEN t.mes >= 10 AND t.mes <= 12
                THEN 'Cuarto trimestre'
        END AS trimestre,
        t.mes,
        CASE 
            WHEN t.mes=1 THEN 'ENERO'
            WHEN t.mes=2 THEN 'FEBRERO'
            WHEN t.mes=3 THEN 'MARZO'
            WHEN t.mes=4 THEN 'ABRIL'
            WHEN t.mes=5 THEN 'MAYO'
            WHEN t.mes=6 THEN 'JUNIO'
            WHEN t.mes=7 THEN 'JULIO'
            WHEN t.mes=8 THEN 'AGOST'
            WHEN t.mes=9 THEN 'SEPTIEMBRE'
            WHEN t.mes=10 THEN 'OCTUBRE'
            WHEN t.mes=11 THEN 'NOVIEMBRE'
            WHEN t.mes=12 THEN 'DICIEMBRE'
        END AS nombre_mes
    FROM tiempo AS t;
