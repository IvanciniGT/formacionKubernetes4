# Devops

Cultura/movimiento en pro de la automatización.

Hemos querido que la gente de DEV se entere de lo que ocurre con el OPS y la gente del OPS se entere de lo que ocurre con el DEV. (venía inducido por ALM)

DEVOPS:                 Automatizables?
- PLAN                      x    JIRA, TRELLO, etc.                 v
- CODE                      x                                       |
- BUILD                     √                                       * Desarrollo ágil
- TEST                      √                                       |
  - Diseño de la prueba     x                                       |
  - Ejecución               √                                       * Integración continua 
                                                            (Implica el tener un entorno de integración)
- RELEASE                   √                                       |
    Poner una RELEASE en manos de mi cliente / de mi usuario        * Entrega continua
- DEPLOY                    √       Kubernetes                      * Despliegue continuo
                                                            (Implica el tener un entorno de producción)
- OPERATE                   √           Helm
- MONITOR                   √           Prometheus/Grafana - ELK

## Automatizar?

Crear una máquina / programa que realice lo que antiguamente realizaba un ser humano... con sus manitas.

En el mundo IT, hoy en día automatizamos:

- Compilación / empaquetado de un código: MAVEN, GRADLE, SBT, ANT, MAKE, MSBUILD, DOTNET. POETRY, NPM, YARN, PIP, RAKE, bash, etc.
  Nosotros hemos pasado de compilar/empaquetar un código a crear un programa (o configurarlo) para que ahora la computadora/programa haga el trabajo por nosotros.

    ^^^ QUIEN LO HACE? Desarrollo

- La ejecución de unas pruebas: JUNIT, TESTNG, MOCHA, JEST, CUCUMBER, KARMA, JASMINE, MSTest, UnitTest
    Pruebas de interfaz WEB: SELENIUM, CYPRESS, PUPPETEER, etc.
    Pruebas de interfaz App: APPIUM, Katalon, etc.
    Pruebas de servicios Web: SOAPUI, POSTMAN, karate, ReadyAPI, etc.
    O me creo programas usando esas librerías, o configuro esos programas para que hagan el trabajo por mí.

    ^^^ QUIEN LO HACE? Desarrollo / Testing (QA)

- El despliegue y configuración de una infraestructura: ANSIBLE, CHEF, PUPPET, SALT, TERRAFORM, CLOUDFORMATION, AZURE ARM, etc.
    O me creo programas usando esas librerías, o configuro esos programas para que hagan el trabajo por mí.

    ^^^ QUIEN LO HACE? SysAdmin, Operaciones, Sistemas ---> DEVOPS

Hace falta una automatización de SEGUNDO NIVEL... que llame a esas otras automatizaciones... y las orqueste:
JENKINS, CIRCLECI, TRAVIS, GITLABCI, GITHUB ACTIONS, AZURE DEVOPS, TEAMCITY, FLUX, ARGOCD, etc. <--- Devops perfil

---

# Antiguamente:

SDLC: Software Development Life Cycle
    Gestión del ciclo de vida de desarrollo de un software:
    Donde entendíamos el ciclo de vida de un software como una secuencia de proyectos gestionados mediante una metodología en cascada.

ALM: Application Lifecycle Management
    Gestión del ciclo de vida de una aplicación
    Aquí es donde se mete la parte de SISTEMAS (OPS) en el ciclo de vida de un software.

    vvvv

DEVOPS
    Pues esos pasos, ahora los hacemos todos juntos, y de manera automatizada.


Hoy en día, el crear una infraestructura es definir/configurar un SOFTWARE (script de terraform, vagrant)
    El SYSADMIN hoy en día es un PROGRAMADOR (hace programas que crean infraestructuras)
El ejecutar pruebas es definir/configurar un SOFTWARE (Selenium, postman, etc.)
    El QA hoy en día es un PROGRAMADOR (hace programas que ejecutan pruebas)

Llamarlos desarrolladores es mucho... Hay muchos tipos de software... y un desarrollador tiene conocimiento PROFUNDOS de desarrollo de software.
    Pero sí, todos ellos hacen programas... de un tipo muy concreto: SCRIPTS.

Eso implica de alguna manera, que deben aprender también las formas de trabajo que los desarrolladores de software estamos usando desde hace DECADAS !!!
    - Control de versiones
    - Metodologías ágiles
    - Patrones de diseño
    - Buenas prácticas de programación
    - Pruebas

El código de un programa / software lo dejo donde? En un repositorio de código de un sistema de gestión de código fuente: SCM (hoy en día: GIT)
Quién creo GIT? Linus... para poder continuar con el desarrollo del kernel de Linux.

Y GIT es muy diferente de otros sistemas de control de versiones:
- COMMIT: Es una copia completa del código fuente en un momento dado del tiempo. NO ES UN PAQUETE DE CAMBIOS CON RESPECTO AL COMMIT ANTERIOR! (ésto era un commit en csv... o en svn)
- Descentralizado: El proyecto completo es la UNION de todos los repositorios de todos los desarrolladores.
Los repos de los desarrolladores son diferentes entre sí... en algún momento pueden ser iguales... malo sería!

GITOPS es una adaptación de DEVOPS, pero:
- Por un lado, todo el código del producto/proyecto está en uno o varios repositorios de GIT.
  - Infraestructura incluida.
- GIT se toma como la UNICA FUENTE DE VERDAD del proyecto.
- Toda automatización sale de lo que hay en GIT.

---

# Previos:

- De lo más importante a la hora de comenzar un proyecto de software es definir un GITFLOW.
- La mayoría de las personas / desarrolladores / equipos no tienen claro qué es un GITFLOW o no le dan la importancia suficiente.

## GITFLOW?

El tema aquí es:
- Vamos a jugar con un conjunto determinado de ramas. Cada una sirve a un propósito... No se crean ramas al tun-tun... al menos las importantes.
- Está totalmente definido el flujo de commits entre las ramas.
  - Si consigo ésto ^^^^^ puedo plantearme automatizar desde GIT... si no, no!

## Ramas

Una secuencia paralela en tiempo de evolución de un proyecto.
Un proyecto evoluciona en paralelo de muchas formas diferentes.... Cada una de ellas la recogemos en una rama.

- TRUNK/MASTER/MAIN: Rama principal del proyecto. Características o consideraciones:
  - Lo que hay está listo para producción
  - Nunca se hace un commit en esta rama directamente
- DESARROLLO/DEVELOPMENT/DEVELOP/DEV: Contiene el código que va a ir a la próxima release
- RELEASE: Donde cierro el código que en un momento dado voy a subir a master (va a ir a producción)
- FEATURE: Rama que recoge el desarrollo de una característica concreta
- USER: Rama que recoge el desarrollo de una característica concreta para un usuario concreto
- HOTFIX: Rama que recoge el desarrollo de una corrección de un error en producción (EMERGENCIA)

        hotfix1*-----+---*
              /           v [ff]
---master----*-------------*----------------------*
                                                 /   ^ SISTEMA
                                 ---release-----*
                                               /    ^ INTEGRACION  (NADIE DEBE TENER PERMISO PARA EJECUTAR ESTE
---develop---*---*---*---*---+----*---*------(*)                        MERGE. Ningún humano. Ni un super admin)
                      \   \      /     \     ^ [ff]                             Servidor CI/CD
            feature1---*---\----*---*-  \   /             pruebas? UNITARIAS/INTEGRACION
                            \            v / [recursivo]
                  feature2---*---*--*----(*)
                             qué pruebas voy haciendo? hago pruebas? UNITARIAS

Cualquier subida de una rama feature a la rama develop debe ser mediante un merge de tipo:

Tipos de merge en git?
- fast-forward: SOLO AÑADE A UNA RAMA UNA REFERENCIA A UN COMMIT QUE YA EXISTE EN OTRA RAMA
- recursive:    SE GENERA UN COMMIT DE FUSION DE CAMBIOS NUEVO (pueden generar conflictos)
#- octopus <---- logo / nombre del logo (mascota de github) octocat
Luego están los rebase

Los Rebase son una estrategia de fusión de cambios ideal cuando lo que me interesa es generar un historial de proyecto que NO REFLEJE LA REALIDAD DE LO QUE ACONTECE, sino que identifique los cambios que se van añadiendo en cada commit.

rama1---C1----C2
        \
rama2    \--C1--C3

Quiero traer a la rama 2 el cambio que he hecho en la rama 1 (incluido en el C2)

## Opción 1: merge de la rama1 desde la rama2
    git switch rama2
    git merge rama1
Problema con esta opción: Genera un commit de fusión que no aporta nada a la rama2

        suma  resta
rama1---C1----C2----
        \           \
rama2    \--C1--C3--C4 (merge entre resta y multiplica)
                multiplica
    El commit 4 refleja la realidad... en un momento dado, fusionamos el código de resta con el de multiplica
    Pero funcionalmente no aporta nada... no es un cambio funcional... es un cambio de historia

## Opción 2: rebase de la rama1 sobre la rama2
    git switch rama2
    git rebase rama1

rama1---C1----C2
                \
        rama2    \--C2--C3
                
    Eso me genera un historial que NO REFLEJA LA REALIDAD... pero sí refleja CLARAMENTE  los cambios que se han ido añadiendo en cada commit.
    C1: suma
    C2: resta
    C3: multiplicación
    Esto me permite hacer luego operaciones como: Cherry-pick, revert, bisect, blame, etc.
Problema que tiene esta forma, se reescribe el C3, para que ya incluya el C2 (la resta)
Y si ha había publicado ese commit3, tengo un C3 distinto al de mis compañeros = FOLLON !!!!

Los rebase los usamos "solo" en ramas de features o privadas... y antes de compartir el código con el resto del equipo.

En GITOPS voy a querer que en cuanto un desarrollador haga:
- Un commit
- O asigne un TAG

Arranque un proceso CI/CD en automático... que en última instancia podría acabar con:
- Una nueva versión del sistema desplegado en producción                                            C.Deployment
- Una nueva versión del sistema liberada para despliegue en producción... en manos de mi cliente    C.Delivery

git tag v1.2.3
git push --tags # AQUÍ ME TIEMBLA EL PULSO Si soy humano decente... Si estoy volao no... pero éste no le quiero en la empresa.

LO UNICO QUE ME VA A DAR AQUI EL TEMPLE NECESARIO ES: La confianza en las pruebas que se estén realizando.
Las pruebas se convierten el algo crítico!

En HELM... a pelo, puedo meter una carpeta llamada tests dentro del chart... donde puedo poner archivos de test ejecutables (scripts de la bash, python: kubectl)
 $ helm test

Pero esto no es suficiente... y tenemos frameworks, como en otros lenguajes, que me permiten desarrollar pruebas con más calidad (unitarias...)
A todo esto le puedo sumar el SONAR
---

En nuestro caso... que estamos aplicando todo esto a despliegues en Kubernetes:
- HELM
- KUSTOMIZE

En el caso de HELM, una cosa es el CHART y otra cosa es los archivos de values customizados para distintos entornos.

Quiero todo en el mismo repo? NO
El CHART me sirve para generar ficheros de despliegue de kubernetes parametrizados.
HELM, me permite controlar el ciclo de vida de un despliegue (generado desde un chart).

- Chart de despliegue va por un lado
- El uso que hago del chart para un despliegue X por otro: mi-values.yaml

    helm install MI_NOMBRE_DE_DESPLIEGUE CHART --values mi-values.yaml -n NAMESPACE --create-namespace
    helm upgrade MI_NOMBRE_DE_DESPLIEGUE CHART --values mi-values(2).yaml -n NAMESPACE
    helm upgrade MI_NOMBRE_DE_DESPLIEGUE CHART(2) --values mi-values(2).yaml -n NAMESPACE

    version APP
    version CHART
    version VALUES
    REVISION del despliegue: version CHART + version VALUES
    Las revisiones se me generan de forma secuencial: 1,2...


HELM:
    install         Para instalar un despliegue la primera vez
    uninstall       Para desinstalar un despliegue... CUIDADO SUPREMO
                        Si el helm ha creado pvc, los pvc se borran
                        Si el pvc se borra... y ha sido provisionado por un storageclass dinámico... se borra el volumen (pv)... y los datos (eso depende de la configuración del storageclass)
    upgrade         Para actualizar un despliegue
                        Pero con muchísimo cuidado, que me puede dejar un despliegue a medias
                        Y puede que un rollback no me deje el despliegue como estaba antes
    rollback        Para volver a una REVISION anterior del despliegue
                        Pero... esto SOLO me garantiza que tendré en kubernetes los mismo objetos que tenía antes... pero no es lo único de lo que tengo que preocuparme: DATOS

# EJEMPLO DE CATASTROFE GIGANTESCA!

## Wordpress

Despliego el chart v 1.0 del wp
  - Monta todo lo que hay que montar...
  - Lo pone en marcha
  - Y empiezo a usar el sistema:
    - Creo mi web
    - Subo mis ficheros
Despliego el chart v 1.1 del wp
  - Y se queda a medias
    - Wordpress (le he puesto 20Ji de Memoria)... y el WP no arranca
    - Pero la BBDD se despliega bien... y mira por donde, hemos subido de la version 1.0 a la 2 de la BBDD.
      - Y la propia BBDD actualiza los ficheros de la BBDD a la nueva versión.
  - Si hago un rollback, todo vuelve a estar como estaba antes? NO... los datos NO... los archivos de los volumenes NO!!!
    - Si hago un rollback, la BBDD no arranca... dice que esos ficheros no los reconoce! JODIDO ESTOY!

ISTIO, LINKERD, CILLIUM


---

Una prueba UNITARIA en un chart de HELM???? Cuando ejecuto el chart sin values concretos!
    La más limpia revisar el YAML que se genera!

# Tipos de pruebas

## En base al objeto de prueba
- Funcionales
- No funcionales
    - Rendimiento
    - Carga 
    - Estrés
    - Smoke test
    - UX
    - Seguridad

## En base al nivel de la prueba
- Unitarias         Comprueba una característica de un componente AISLADO del código del que pueda depender.
- Integración       Comprueba la comunicación de 2 componentes
- Sistema
  - Aceptación

Si hago una prueba en un código JAVA y llamo a una única función... qué tipo de prueba es? NPI
Puede ser unitaria, de integración, de sistema... depende del contexto en el que ejecuto la prueba.

## En base al procedimiento de ejecución de la prueba
- Dinámicas
- Estáticas (Sonar)

## En base al conocimiento previo del sistema
- Caja negra
- Caja blanca

TDD = Test-FIRST + Refactoring

# Kustomize:

También me permite generar ficheros de despliegue de kubernetes personalizados.... pero de una forma diferente a HELM.

En HELM montamos plantillas de ficheros de despliegue de kubernetes... y luego los parametrizamos con values.
El fichero values tiene la sintaxis que a mí me de la gana... y en las plantillas, vamos haciendo uso de esos valores.... para:
- Sacarlos directamente
- Usarlos en condicionales
- Aplicarle funciones
- Usarlos en bucles

Además HELM nos ayuda a gestionar el ciclo de vida de un despliegue... y a gestionar las dependencias entre despliegues.

En Kustomize no tengo plantillas... 
- tengo ficheros de despliegue de kubernetes... 
- y tengo un fichero de kustomization que me dice cómo tengo que modificar esos ficheros de despliegue de kubernetes para adaptarlos a un despliegue concreto.

La sintaxis es 100% Kubernetes... y la forma de parametrizar es 100% Kubernetes.
Vamos a poder eso si hacer uso de variables... pero no esperais nada como por ejemplo un bucle.

Vamos a partir de una carpeta que llamaremos base... y en ella vamos a tener los ficheros de despliegue de cada objeto que constituye el despliegue de nuestra aplicación.... al menos un despliegue genérico.

# Estructura de un despliegue con Kustomize:

miwp <- Esta carpeta apunta a otro repo de git: https://github.com/miOtroUsuario/miDespliegueWP
    ├── base -> Apuntaría aun repo de git https://github.com/miUsuario/despliegue-base-wp en una version
    │   ├── database
    │   │   ├── configmap.yaml
    │   │   ├── kustomization.yaml
    │   │   ├── secret.yaml
    │   │   ├── service.yaml
    │   │   └── statefulset.yaml
    │   ├── kustomization.yaml
    │   └── wp
    │       ├── deployment.yaml
    │       ├── ingress.yaml
    │       ├── kustomization.yaml
    │       ├── pvc.yaml
    │       └── service.yaml
    └── overlays
        ├── desarrollo
            └── kustomization.yaml

miwp2 <- Esta carpeta apunta a otro repo de git: https://github.com/miOtroUsuario/miDespliegueWP
    ├── base -> Apuntaría aun repo de git https://github.com/miUsuario/despliegue-base-wp en una version
    └── overlays
        └── produccion
            ├── deployment-patch.yaml
            ├── kustomization.yaml
            └── pvc-patch.yaml

> Cómo me llevo eso a GIT?

Habéis trabajado con sub-módulos de git?


---

#VERSIONADO!

- En el caso de Kustomize, quien lleva en control de la VERSION:
    - Del base
    - De los parches
    Con tags de GIT... Es el único sitio que hay!

Y DEJO GIT COMO única fuente de la verdad!

- En cambio... qué pasa en HELM?
  La version del Chart la defino en el archivo chart.yaml...
  Pero en git puedo llevar un versionado alternativo...
  De hecho lo habitual es que ponga tags en GIT... pero pase del archivo chart.yaml

  Es más, quiero estar modificando / manteniendo sincronizados a manita el archivo chart.yaml con el tag de git? Al final no se hace.... por vaguería

  maven
    pom.xml <<<< version del artifact
    Y la mantenéis sincronizada con el tag de git? NI DE COÑA!

GITOPS lo habitual es dejar a GIT como única fuente de verdad.
No debería ser la herramienta de devops la que se encargue de eso...
GIT DEBERIA ENCARGARSE DE ESO!!!
Y para eso existen los git hooks!
Y en la rama desarrollo, yo voy poniendo tags del tipo v1.2.3-dev
Y git me debe asegurar que mis tags son de ese tipo: GIT !!!! no el server CI/CD
Y al subir un commit a release, git debe etiquetar ese commit como: v1.2.3-RC1 o v1.2.3-rc2
Y al subir ese commit a master, git debe etiquetar ese commit como: v1.2.3
Y en paralelo con eso, git debe ir modificando el archivo chart.yaml a través de un git hook... que me modifique el archivo chart.yaml con la versión que le corresponde a ese commit.
