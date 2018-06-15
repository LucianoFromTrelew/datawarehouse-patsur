import requests as req

REQ_URL='https://api.mercadolibre.com/sites/MLA/categories'
SQL_FILE='./sql/categorias.sql'

def main():
    res = req.get(REQ_URL)
    categorias = res.json()
    with open(SQL_FILE, 'w') as f:
        for cat in categorias:
            for sub_cat in range(1,6):
                insert_string = 'INSERT INTO categoria VALUES ({}, {}, \'{}\');\n'.format(
                    cat['id'].replace('MLA', ''),
                    sub_cat,
                    cat['name']
                )
                f.write(insert_string)

if __name__ == '__main__':
    main()
