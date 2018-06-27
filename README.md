## Trabajo Final para la material Bases de Datos II, UNPSJB
## Datawarehouse

### Cátedra
- Lic. Gabriel Ingravallo
- Lic. Cristian Parise


#### Integrantes:
- Luciano Serruya Aloisi
- Pablo Toledo Margalef


---

Para este trabajo se utilizaron contenedores de *Docker* para simular las bases operativas de la organización PatSur, el datawarehouse, y el servidor de Pentaho (corre en el puerto `7070`)

Crear los contenedores con:

```bash
docker-compose up -d
```

Para reanudarlos, ejecutar el comando:

```bash
docker-compose start
```

---

Para eliminar la red y los contenedores, ejecutar:

```bash
docker-compose down
```

Para deterner los contenedores, ejecutar el comando:

```bash
docker-compose stop
```

### Pentaho

Para ingresar al servidor de Pentaho BI, en un navegador ingresar la dirección `localhost:7070`, ingresar como usuario `admin` (contraseña `password`)
