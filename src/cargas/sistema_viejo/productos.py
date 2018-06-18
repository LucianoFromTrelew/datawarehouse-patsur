import requests as req
import re

REQ_URL='https://api.mercadolibre.com/sites/MLA/search?category={}'
CATEGORIAS_URL='https://api.mercadolibre.com/sites/MLA/categories'
SQL_FILE='./sql/productos.sql'

IS_ALPHA_OR_SPACE=re.compile('([^\s\w])+')

def main():
    res = req.get(REQ_URL)
    categorias = [cat['id'].replace('MLA', '') for cat in req.get(
        CATEGORIAS_URL).json()]
    with open(SQL_FILE, 'w') as f:
        for cat in categorias:
            productos = [
                {'id_prod': prod['id'].replace('MLA', ''),
                 'nombre': IS_ALPHA_OR_SPACE.sub('', prod['title']),
                 'precio': prod['price']} for prod in req.get(
                REQ_URL.format(cat)).json()['results']
            ]
            for prod in productos:
                insert_string = 'INSERT INTO producto VALUES ({}, \'{}\', {}, {});\n'.format(
                    prod['id_prod'],
                    prod['nombre'],
                    cat,
                    prod['precio']
                )
                f.write(insert_string)

if __name__ == '__main__':
    main()
