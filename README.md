# spring-petclinic-deploy

Clonamos el repositorio git:

````
https://github.com/cloud-computing-team21/spring-petclinic-deploy.git
````

# Entorno

Seleccioamos el entorno en el que instalar. En este ejemplo, solo hay un entorno "int" y los ficheros de configuración los tenemos que cambiar antes de la instalación. Cuando este terminado todo integrado y terminado, el entorno ira por rama.

````
cd spring-petclinic-deploy
cd int
````

## Levantamos la bbdd

Inicializamos la bbdd y creamos la tabla petclinic.

````
docker run -it -d --name petclinic-postgres -e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic -p 5432:5432 postgres:9.6.0
````

Miramos los logs

````
docker logs petclinic-postgres -f
````

Y validamos que arranca sin errores:

````
PostgreSQL init process complete; ready for start up.

LOG:  database system was shut down at 2024-01-21 17:43:47 UTC
LOG:  MultiXact member wraparound protections are now enabled
LOG:  autovacuum launcher started
LOG:  database system is ready to accept connections
````

Y ahora podemos crear la estructura y los datos con los ficheros que hay en la carpeta **<entorno>/config/db**:

````
initDB.sql
populateDB.sql
````

**Nota**: Por ahora es una bbdd docker. Cuando no sea Docker, supongemos que ya estara creada y que se cargara de datos por otro lado.

## Levantamos el API

Arrancamos el api, apuntando al fichero de configuraciónn.

Configuramos el fichero **<entorno>/config/petclinic-rest/petclinic-rest.properties** a nuestro gusto. Los valores por defecto son:

````
spring.profiles.active=postgresql,spring-data-jpa
spring.datasource.url=jdbc:postgresql://amcdocker.costaisa.org:5432/petclinic
spring.datasource.username=postgres
spring.datasource.password=petclinic
````

Y a continuación arrancamos la aplicación.

````
docker run -it -d --env-file=${PWD}/config/petclinic-rest/petclinic-rest.properties --name petclinic-rest --restart=always -p 9966:9966 jbravo/spring-petclinic-rest:3.2.1
````

Miramos los logs

````
docker logs petclinic-postgres -f
````

Y validamos que arranca sin errores:

````
INFO  Http11NioProtocol - Starting ProtocolHandler ["http-nio-9966"]
INFO  TomcatWebServer - Tomcat started on port 9966 (http) with context path '/petclinic'
INFO  PetClinicApplication - Started PetClinicApplication in 9.146 seconds (process running for 9.737)
````

Ya estamos en condiciones de acceder por URL a la definición del API:

````
http://amcdocker.costaisa.org:9966/petclinic
````

## Levantamos el Frontend

Configuramos el fichero **/config/petclinic-angular/environment.js** a nuestro gusto. Los valores por defecto son

````
const env = {
  REST_API_URL: 'http://amcdocker.costaisa.org:9966/petclinic/api/' 
};
````

Arrancamos el frontend, al volumen donde tenemos la configuarión.

````
docker run -it -d --name petclinic-angular -v ${PWD}/config/petclinic-angular/environment.js:/usr/share/nginx/html/assets/environments/environment.js --restart=always -p 8080:8080 jbravo/spring-petclinic-angular:0.2.0
````

Ya estamos en condiciones de acceder por URL a la definición del API:

````
http://amcdocker.costaisa.org:8080/
````

## Script de migración

Ejecutar el script [migrate-db.sh](int/db/migrate-db.sh) con el arn de la BBDD RDS para crear y poblar toda la base de datos:

```bash
migrate-db.sh rds-master.ctl8bhoer7ou.us-east-1.rds.amazonaws.com
```
