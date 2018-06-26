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
