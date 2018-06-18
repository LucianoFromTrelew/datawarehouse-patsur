CREATE TABLE categoria (
    id_categoria integer,
    id_subcategoria integer,
    descripcion varchar(100),
    PRIMARY KEY (id_categoria, id_subcategoria)
);

CREATE TABLE producto (
    id_producto integer,
    id_categoria integer,
    id_subcategoria integer,
    descripcion varchar(100),
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria,id_subcategoria) REFERENCES categoria (id_categoria, id_subcategoria)
);

CREATE TABLE medios (
    id_medio_pago integer,
    descripcion varchar(100),
    PRIMARY KEY (id_medio_pago)
);

CREATE TABLE region (
    id_region integer,
    descripcion varchar(100),
    PRIMARY KEY (id_region)
);

CREATE TABLE provincia(
    id_provincia integer,
    id_region integer, 
    descripcion varchar(100),
    PRIMARY KEY (id_provincia),
    FOREIGN KEY (id_region) REFERENCES region(id_region)
);

CREATE TABLE ciudad (
    id_ciudad integer,
    id_provincia integer,
    descripcion varchar(100),
    PRIMARY KEY (id_ciudad),
    FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia)
);

CREATE TABLE distribucion_geografica (
    id_sucursal integer,
    id_ciudad integer,
    descripcion varchar(100),
    PRIMARY KEY (id_sucursal),
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

CREATE TABLE tipo_cliente (
    id_tipo integer,
    descripcion varchar(100),
    PRIMARY KEY (id_tipo)
);

CREATE TABLE cliente (
    id_cliente integer,
    id_tipo integer,
    nombre varchar(100),
    apellido varchar(100),
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_tipo) REFERENCES tipo_cliente(id_tipo)
);

CREATE TABLE venta(
    fecha date,
    id_factura integer,
    id_cliente integer, 
    id_producto integer, 
    id_sucursal integer,
    id_medio_pago integer,
    monto_vendido real, 
    cantidad_Vendida integer,
    PRIMARY KEY (
        fecha, 
        id_factura, 
        id_cliente, 
        id_producto, 
        id_sucursal, 
        id_medio_pago
    ),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_sucursal) REFERENCES distribucion_geografica(id_sucursal),
    FOREIGN KEY (id_medio_pago) REFERENCES medios(id_medio_pago)
);
