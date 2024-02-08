# HELM

Helm no es SOLO un programa que me ayuda a generar archivos de despliegue de kubernetes desde una plantilla. 
Es un programa que me permite controlar el ciclo de vida de esos despliegues, desde la creación hasta la eliminación.

En HELM el concepto clave es el de CHART.

Un CHART es un paquete de despliegue de kubernetes que contiene plantillas para todos los recursos necesarios para ejecutar una aplicación, herramienta o servicio en un cluster de kubernetes.

En ocasiones solo uso HELM para desplegar aplicaciones que ya están empaquetadas en un CHART, pero en otras ocasiones, tengo que crear mis propios CHARTS.

Si uso apps comerciales, seguro que ya tienen su propio CHART, pero si tengo que desplegar una aplicación que he desarrollado, tendré que crear mi propio CHART.

Por qué eso de las plantillas? Una aplicación querré desplegarla en distintos entornos ... con distintas configuraciones.
En ese escenario una plantilla personalizable me viene guay!

# PASO 1... vamos a usar helm para instalar algo en nuestro cluster

Lo primero que hacemos para usar un chart, es dar de alta el repositorio que contiene el chart.
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
                                                # Es la URL del repo que contiene el chart
                # es un nombre que yo le doy a ese repo en mi máquina

Para que helm se entere de que tenemos un repo nuevo y mire a ver que paquetes (charts) hay disponibles
$ helm repo update  

Me voy a descargar en mi máquina el chart de helm
$ helm pull nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
            # nombre del repo en mi máquina
                                            # nombre del chart en el repo           

---
$ helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=x.x.x.x \
    --set nfs.path=/exported/path