### Cómo abrir el cubo OLAP de PatSur en Pentaho BI Server

1) Ingresar al servidor de Pentaho como se comentaba en el `README` raíz del repo
2) `Manage Data Sources` > Click en el engranaje (a la izquierda de `New Data Source`) > `New Connection...`

    ```
        Database Type: PostgreSQL
        Host Name: conn_datawarehouse
        Database Name: datawarehouse
        Port Number: 5432
        User Name: admin
        Password: admin
    ```
3) `Manage Data Sources` > Click en el engranaje (a la izquierda de `New Data Source`) > `Import Analysis...`

    ```
        Mondrian File: patsur_olap.mondrian.xml
        Data Source: conn_datawarehouse
    ```

4) Ya estaría creado el cubo, para visualizarlo ir a `Create New` > `JPivot View` (Schema `PatSur`, Cube `CuboVentas`)
