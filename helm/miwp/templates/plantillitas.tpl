{{- define "nombre-servicio-bbdd" -}}
{{ include "release-prefijo" . }}mariadb-service
{{- end -}}

{{- define "nombre-secreto-bbdd" -}}
{{ include "release-prefijo" . }}mariadb-secreto
{{- end -}}

{{- define "nombre-configmap-bbdd" -}}
{{ include "release-prefijo" . }}mariadb-configmap
{{- end -}}

{{- define "nombre-statefulset-bbdd" -}}
{{ include "release-prefijo" $ }}mariadb-statefulset
{{- end -}}

{{- define "release-prefijo" -}}
{{ $.Release.Name }}-
{{- end -}}

{{- define "db-password" -}}
{{ include "encriptarConValorPorDefecto" (dict "defecto" (randAscii 15) "valor" .) }}
{{- end }}

{{- define "db-user" -}}
{{ include "encriptarConValorPorDefecto" (dict "defecto" "wordpress" "valor" .) }}
{{- end }}

{{- define "encriptarConValorPorDefecto" -}}
{{- default (.defecto) $.valor | b64enc | quote }}
{{- end }}

{{- define "database-labels" -}}
app:     mariadb
{{ include "extra-labels" $.Values.database }}
{{- end -}}

{{- define "wp-labels" }}
app:     wp
{{- include "extra-labels" $.Values.wordpress }}
{{- end -}}

{{- define "extra-labels" }}
{{- $.extraLabels | toYaml }}
{{- end -}}

{{- define "imagen" }}
{{- with .image -}}
    {{- $invalidPullPolicy := printf "El valor de imagePullPolicy suministrado no es válido: '%s'. Debe ser uno de: 'Always', 'Never' o 'IfNotPresent'" .pullPolicy  -}}
    {{- $requiredRepo := "El repositorio de la imagen es obligatorio" -}}
    {{- $requiredTag := "El tag de la imagen es obligatorio" -}}

    {{- if not (regexMatch "^((IfNotPresent)|(Always)|(Never))$" .pullPolicy ) }}
        {{ fail $invalidPullPolicy }}
    {{ end -}}

image:                  {{ required $requiredRepo .repo }}:{{ required $requiredTag .tag }}
imagePullPolicy:        {{ .pullPolicy }}
{{- end -}}
{{- end -}}





{{- define "extra-env-vars-database" -}}
{{- $prohibidas := dict "MARIADB_ROOT_PASSWORD" (dict "equivalentField" "database.config.rootPassword") }}
{{- $_ := set $prohibidas "MARIADB_PASSWORD" (dict "equivalentField" "database.config.password") }}
{{- $_ := set $prohibidas "MARIADB_USER" (dict "equivalentField" "database.config.user") }}
{{- $_ := set $prohibidas "MARIADB_DATABASE" (dict "equivalentField" "database.config.name") }}
{{- /* include "extra-env-vars" (merge . (dict  "prohibidas" $prohibidas) ) */ -}}
{{- include "extra-env-vars" (dict "extraEnv" .extraEnv "prohibidas" $prohibidas) -}}
{{- end -}}



{{- define "extra-env-vars-wordpress" -}}
{{- $prohibidas := dict "WORDPRESS_DB_HOST" (dict "customErrorMessage" "La variable de entorno 'WORDPRESS_DB_HOST' no puede establecerse." )}}
{{- $_ := set $prohibidas "WORDPRESS_DB_USER" (dict "equivalentField" "database.config.user") }}
{{- $_ := set $prohibidas "WORDPRESS_DB_PASSWORD" (dict "equivalentField" "database.config.password") }}
{{- $_ := set $prohibidas "WORDPRESS_DB_NAME" (dict "equivalentField" "database.config.name") }}
{{- /* include "extra-env-vars" (merge . (dict  "prohibidas" $prohibidas) ) */ -}}
{{- include "extra-env-vars" (dict "extraEnv" .extraEnv "prohibidas" $prohibidas) -}}
{{- end -}}



{{- define "extra-env-vars" -}}
{{- $prohibidas := .prohibidas -}}
{{- range $clave, $valor := .extraEnv -}}
{{- if hasKey $prohibidas $clave -}}
{{- if hasKey (get $prohibidas $clave) "equivalentField" -}}
{{ fail (printf "No puede usar la variable de entorno '%s' en el extraEnv. Utilice la propiedad '%s' del fichero Values.yaml en su lugar." $clave (get (get $prohibidas $clave) "equivalentField") ) }}
{{- else -}}
{{ fail ( get (get $prohibidas $clave) "customErrorMessage") }}
{{- end -}}
{{- else -}}
- name: {{ $clave }}
  value: {{ $valor }}
{{ end -}}
{{- end -}}
{{- end -}}


{{- define "define-resources" -}}
{{- if and . (gt (len .) 0) -}}
    {{- $invalidKey := "Clave no válida: '%s'. Solo se permiten las claves 'requests' y 'limits' dentro del bloque resources." -}}

    {{- range $clave, $valor := . -}}
        {{- if or (eq $clave "requests") (eq $clave "limits")  -}}
            {{- include "validate-cpu-memory" $valor -}}
        {{- else -}}
            {{- fail (printf $invalidKey $clave ) -}}
        {{- end -}}
    {{- end -}}
resources:
{{- . | toYaml | nindent 4 -}}

{{- end -}}
{{- end -}}



{{- define "validate-cpu-memory" -}}

    {{- $invalidCPUValue := printf "El valor suministrado para CPU no es válido: '%s'. Debe ser un número entero opcionalmente seguido de la letra 'm'" .cpu -}}
    {{- $invalidMemoryValue := printf "El valor suministrado para memory no es válido: '%s'. Debe ser un número entero seguido de la unidad 'Mi', 'Gi' o 'Ki'" .memory -}}
    {{- $invalidResource := "Clave no válida: '%s'. Solo se permiten los recursos 'cpu' y 'memory' dentro del bloque resources." -}}

    {{- range $clave, $valor := . -}}
        {{- if eq $clave "cpu" -}}
            {{- if not (regexMatch "^[1-9][0-9]*m?$" ($valor|toString) ) }}
                {{ fail $invalidCPUValue }}
            {{ end -}}
        {{- else if eq $clave "memory" -}}
            {{- if not (regexMatch "^[1-9][0-9]*[KMG]i$" ($valor|toString) ) }}
                {{ fail $invalidMemoryValue }}
            {{ end -}}
        {{- else -}}
            {{- fail (printf $invalidResource $clave ) -}}
        {{- end -}}
    {{- end -}}
{{- end -}}


            {{- /*
                not condicion1
                and condicion1 condicion2
                or condicion1 condicion2
                eq Igual
                ne Distinto
                lt Menor
                gt Mayor
                le Menor o igual
                ge Mayor o igual
            */ -}}


{{- define "nombre-servicio-wp" -}}
{{ include "release-prefijo" . }}wordpress-service
{{- end -}}

{{- define "nombre-deployment-wp" -}}
{{ include "release-prefijo" . }}wordpress-deployment
{{- end -}}

{{- define "nombre-pvc-wp" -}}
{{ include "release-prefijo" . }}wordpress-pvc
{{- end -}}

{{- define "nombre-hpa-wp" -}}
{{ include "release-prefijo" . }}wordpress-hpa
{{- end -}}

{{- define "nombre-ingress-wp" -}}
{{ include "release-prefijo" . }}wordpress-ingress
{{- end -}}
