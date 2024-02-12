
Cuando un chart de helm se procesa, tenemos que tener en cuenta varias cosas:

- Los ficheros YAML, HELM no los interpreta como YAML... sino como archivos de texto plano
- En ese fichero de texto plano, podemos meter templates de Go
- Los templates se escriben entre doble llave {{ }}
- Cuando estamos ejecutando un template, siempre tenemos a nuestra disposición un CONTEXTO

# Qué es un Contexto, dentro de una ejecución de HELM?

Un MAPA clave/valor, del que puedo sacar datos... Realmente a última hora descubrimos que un contexto es simplemente un objeto que tengo en memoria: MAPA, Lista, número.
Con qué sintaxis?
- Sintaxis absoluta
- Sintaxis relativa

Imaginad que el contexto es una estructura de carpetas en mi HDD.. Dentro de cada carpeta hay más carpetas... y/o archivos.

    /
        home/
        etc/
            nginx/
                nginx.conf
        var/
            log/
                nginx/
                    access.log
                    error.log

Para ubicar un archivo o carpeta en el sistema de archivos que sintaxis tenéis?
- Rutas ABSOLUTAS
    /var/log/nginx/access.log
    /etc/nginx/nginx.conf
- Rutas RELATIVAS... relativas a QUE? A la carpeta en la que estoy
    Si estoy en el raiz /, y quiero acceder a /var/log/nginx/access.log:
        var/log/nginx/access.log
    Si estoy en /var/log, y quiero acceder a /var/log/nginx/access.log:
        nginx/access.log

Vamos a tener a nuestra disposición un conjunto claves/valor (MAPA) JERARQUICA, el valor de una clave puede ser un nuevo mapa o un escalar... o una lista.

/
    clave1/
            valor1
    clave2/
            subclave2.1/
                        valor2.1
            subclave2.2/
                        valor2.2

# Cuál es la sintaxis concreta en las plantillas de HELM
Como si fuera la del sistema de archivos... reemplazando las / por .
Menos la barra inicial, que se reemplaza por $.
- RUTA ABSOLUTA
    $.clave1.valor1
    $.clave2.subclave2.1.valor2.1
- RUTAS RELATIVAS
    Si estoy en $.clave2, y quiero acceder a subclave2.1:
        .subclave2.1

# Cual es la estructura BASE de datos que me ofrece HELM
                                    $ <(1)
                                    |
    -------------------------------------------------------------------------------------
    |                   |                   |                   |         |             |       
    Values            Chart              Release             Files     Capabilities  Template
                      todos                 |
                        los             ---------
                          datos         |       |
                      del             Name   Namespace
                        archivo
                          Chart.yaml

Cuando se ejecuta helm install, se pasan un nombre de release y el namspace de despliegue:
    $ helm install mi-release CHART --namespace mi-namespace
    $ helm install mi-release CHART -n mi-namespace

Por defecto, HELM me va a ubicar en la 'carpeta' RAIZ: $ <(1)

Cara cambiar de carpeta (CONTEXTO)
{{ with $.Values }}
    {{ .wordpress.replicas.min }}
    {{ with .wordpress.ingress }}
        {{ .enabled }}
        {{ .host }}
    {{ end }} // cd -
{{ end }} 

El .Values contiene:
- Los datos que se hayan pasado por linea de comandos... sueltos
+ Los datos que se hayan pasado en un fichero custom de valores
    $ helm install RELEASENAME CHART -f values-custom.yaml
+ Los datos que se hayan pasado en el fichero values.yaml del chart

Los de arriba machacan a los de abajo




public static String nombreServicio(Object release){
    Map<String,String> mapa = new HashMap<>();
    mapa.put("release",release);
    mapa.put("nombre","mariadb");
    return prefijo(mapa);
}
public static String nombreStatefulset(Object release){
    Map<String,String> mapa = new HashMap<>();
    mapa.put("release",release);
    mapa.put("nombre","mariadb");
    return prefijo(mapa);
}
public static String prefijo(Object release){
    return ((Map<String,String>) release).get("release") + "-" + ((Map<String,String>) release).get("nombre");
}
