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
{{- $prohibidas := dict "MARIADB_ROOT_PASSWORD" "database.config.rootPassword" }}
{{- $_ := set $prohibidas "MARIADB_PASSWORD" "database.config.password" }}
{{- $_ := set $prohibidas "MARIADB_USER" "database.config.user" }}
{{- $_ := set $prohibidas "MARIADB_DATABASE" "database.config.name" }}
{{- /* include "extra-env-vars" (merge . (dict  "prohibidas" $prohibidas) ) */ -}}
{{- include "extra-env-vars" (dict "extraEnv" .extraEnv "prohibidas" $prohibidas) -}}
{{- end -}}

{{- define "extra-env-vars" -}}
{{- $prohibidas := .prohibidas -}}
{{- range $clave, $valor := .extraEnv -}}
{{- if hasKey $prohibidas $clave -}}
{{ fail (printf "No puede usar la variable de entorno '%s' en el extraEnv. Utilice la propiedad '%s' del fichero Values.yaml en su lugar." $clave (get $prohibidas $clave) ) }}
{{- else -}}
- name: {{ $clave }}
  value: {{ $valor }}
{{ end -}}
{{- end -}}
{{- end -}}













{{- define "extra-env-vars-wordpress" -}}
{{ include "extra-env-vars" . }}
{{- end -}}
