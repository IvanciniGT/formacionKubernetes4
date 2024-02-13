Los valores de las variables de entorno de un Pod/PodTemplate se pueden sacar de:


    apiVersion: v1
    kind: ConfigMap
    metadata:
        name: mi-configmap
    data:
        mi-variable: "mi-valor"
        mi-variable2: "mi-valor2"
    ---

    # Esta configuración la podemos estar haciendo dentro de un POD_TEMPLATE (StatefulSet, Deployment, etc)
    env:
        # OPCION 1: Indicar el valor a fuego! Directamente en el archivo de manifiesto
        - name: MI_VARIABLE
          value: "mi-valor"
        # OPCION 2: De un configMap
        - name: MI_VARIABLE2
          valueFrom: 
            configMapKeyRef:
              name: mi-configmap    # Nombre del configMap
              key: mi-variable      # Nombre de la clave en el data del configMap que tiene el valor: 
                                    # El valor sería: "mi-valor"
        # OPCION 3: Lo mismo pero con secret: configMapKeyRef -> secretKeyRef
        # OPCION 4: Del mismo manifiesto que se hgenera
        - name: MI_VARIABLE3
          valueFrom:
            fieldRef:
              fieldPath: metadata.name # El valor sería el nombre del pod
    # Opción 5:
    envFrom:
      - configMapRef:   # En este caso se cargan como variables de entorno TODAS las variables del secret o del configMap, con el mismo nombre que allí haya definido
          name: mi-configmap
                                            # mi-variable: "mi-valor"
                                            # mi-variable2: "mi-valor2"
      - secretRef:
          name: mi-secret