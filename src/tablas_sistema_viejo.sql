CREATE TABLE cliente (
    nro_cliente integer,
    nombre varchar(50),
    tipo integer,
    direccion varchar(100),
    PRIMARY KEY (nro_cliente)
);

CREATE TABLE categoria (
    nro_categ integer,
    descripcion text,
    PRIMARY KEY (nro_categ)
);

CREATE TABLE producto (
    nro_producto integer,
    nombre varchar(100),
    nro_categ integer,
    precio_actual real,
    PRIMARY KEY (nro_producto),
    FOREIGN KEY (nro_categ) REFERENCES categoria (nro_categ)
);

CREATE TABLE venta (
    fecha_venta timestamp,
    nro_factura integer,
    nro_cliente integer,
    nombre varchar(50),
    forma_pago varchar(10),
    PRIMARY KEY (nro_factura),
    FOREIGN KEY (nro_cliente) REFERENCES cliente (nro_cliente)
);

CREATE TABLE detalle_venta (
    nro_factura integer,
    nro_producto integer,
    descripcion text,
    unidad integer,
    precio real,
    PRIMARY KEY (nro_factura, nro_producto),
    FOREIGN KEY (nro_factura) REFERENCES venta (nro_factura),
    FOREIGN KEY (nro_producto) REFERENCES producto (nro_producto)
);
