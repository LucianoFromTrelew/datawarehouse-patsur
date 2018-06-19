import pandas as pd
from random import randint


SQL_FILE_VIEJO = './sql/clientes_viejo.sql'
SQL_FILE_NUEVO = './sql/clientes_nuevo.sql'


def main():
    clientes = pd.read_csv('./clientes.csv', sep=';')

    id_cliente_nuevo = 1
    id_cliente_viejo = 10000

    clientes_nuevos = ''
    clientes_viejos = ''

    for index, row in clientes.iterrows():
        tipo_cliente = randint(0, 4)

        clientes_viejos += 'INSERT INTO "cliente" (nro_cliente,nombre,tipo,direccion) VALUES ({},\'{}\',{},\'{}\');\n'.format(
                id_cliente_viejo,
                row['nombre'],
                tipo_cliente,
                row['direccion']
            )

        clientes_nuevos += 'INSERT INTO "cliente" (cod_cliente,nombre,cod_tipo,direccion) VALUES ({},\'{}\',{},\'{}\');\n'.format(
                id_cliente_nuevo,
                row['nombre'],
                tipo_cliente,
                row['direccion']
            )

        id_cliente_viejo += 1
        id_cliente_nuevo += 1

    with open(SQL_FILE_NUEVO, 'w') as f:
        f.write(clientes_nuevos)
        f.close()

    with open(SQL_FILE_VIEJO, 'w') as f:
        f.write(clientes_viejos)
        f.close()


if __name__ == "__main__":
    main()
