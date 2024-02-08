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
{{ include "release-prefijo" . }}mariadb-statefulset
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
{{- default (.defecto) .valor | b64enc | quote }}
{{- end }}

