SELECT
    t.anio AS "Año", 
    t.mes AS "Mes",
    CASE 
        WHEN t.mes >= 1 AND t.mes <= 3 THEN
            'Primer trimestre'
        WHEN t.mes >= 4 AND t.mes <= 6 THEN
            'Segundo trimestre'
        WHEN t.mes >= 7 AND t.mes <= 9 THEN
            'Tercer trimestre'
        WHEN t.mes >= 10 AND t.mes <= 12 THEN
            'Cuarto trimestre'
        ELSE 'INCORRECTO'
    END AS "Trimestre",
    cli.nombre AS "Cliente",
    prod.descripcion AS "Producto",
    suc.descripcion AS "Sucursal",
    ciud.descripcion AS "Ciudad",
    prov.descripcion AS "Provincia",
    mp.descripcion AS "Medio de pago",
    SUM(ven.cantidad_vendida) AS "Cantidad vendida",
    CAST(SUM(ven.monto_vendido) AS bigint) AS "Total vendido"
FROM venta AS ven
    JOIN tiempo AS t ON ven.id_tiempo=t.id_tiempo
    JOIN cliente AS cli ON ven.id_cliente=cli.id_cliente
    JOIN producto AS prod ON ven.id_producto=prod.id_producto
    JOIN medios AS mp ON ven.id_medio_pago=mp.id_medio_pago
    JOIN distribucion_geografica AS suc ON ven.id_sucursal=suc.id_sucursal
    JOIN ciudad AS ciud ON suc.id_ciudad=ciud.id_ciudad
    JOIN provincia AS prov ON ciud.id_provincia=prov.id_provincia
GROUP BY 
    CUBE(
        (t.anio, t.mes),
        (cli.id_cliente, cli.nombre),
        (prod.id_producto, prod.descripcion),
        (mp.id_medio_pago, mp.descripcion),
        (suc.id_sucursal, suc.descripcion, ciud.id_ciudad, ciud.descripcion, prov.id_provincia, prov.descripcion)
    )
;
