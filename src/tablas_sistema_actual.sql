CREATE TABLE tipo_cliente (
    cod_tipo integer,
    descripcion text,
    PRIMARY KEY (cod_tipo)
);

CREATE TABLE cliente (
    cod_cliente integer,
    nombre varchar(50),
    cod_tipo integer,
    direccion varchar(100),
    PRIMARY KEY (cod_cliente, nombre),
    FOREIGN KEY (cod_tipo) REFERENCES tipo_cliente (cod_tipo)
);

CREATE TABLE categoria (
    cod_categoria integer,
    cod_subcategoria integer,
    descripcion text,
    PRIMARY KEY (cod_categoria, cod_subcategoria)
);

CREATE TABLE producto (
    cod_producto integer,
    nombre varchar(100),
    cod_categoria integer,
    cod_subcategoria integer,
    precio_actual real,
    PRIMARY KEY (cod_producto),
    FOREIGN KEY (cod_categoria, cod_subcategoria) REFERENCES categoria (cod_categoria, cod_subcategoria)
);

-- Que onda esta tabla, nada que ver los campos
CREATE TABLE medio_pago (
    cod_medio_pago integer,
    descripcion text,
    valor real,
    unidad integer,
    tipo_operacion integer,
    PRIMARY KEY (cod_medio_pago)
);

CREATE TABLE venta (
    fecha_venta timestamp,
    id_factura integer,
    cod_cliente integer,
    nombre varchar(50),
    cod_medio_pago integer,
    PRIMARY KEY (id_factura),
    FOREIGN KEY (cod_cliente, nombre) REFERENCES cliente (cod_cliente, nombre),
    FOREIGN KEY (cod_medio_pago) REFERENCES medio_pago (cod_medio_pago)
);

CREATE TABLE detalle_venta (
    id_factura integer,
    cod_producto integer,
    descripcion text,
    unidad integer,
    precio real,
    PRIMARY KEY (id_factura, cod_producto),
    FOREIGN KEY (cod_producto) REFERENCES producto (cod_producto)
);
