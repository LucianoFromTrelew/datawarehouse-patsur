SELECT 
    cli.id_cliente AS "ID Cliente", 
    cli.nombre AS "Nombre", 
    CAST(SUM(ven.monto_vendido) AS bigint) AS "Total vendido", 
    RANK() OVER (ORDER BY SUM(ven.monto_vendido) DESC) AS "Mayores compradores" 
FROM venta AS ven 
    JOIN cliente AS cli ON ven.id_cliente=cli.id_cliente 
GROUP BY cli.id_cliente;
