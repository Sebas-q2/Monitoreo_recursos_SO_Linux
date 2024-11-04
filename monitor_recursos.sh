#!/bin/bash

# Variables para el monitoreo
tiempo_total=300        # Tiempo total de monitoreo en segundos (5 minutos)
intervalo=60            # Intervalo de captura en segundos (1 minuto)
archivo_reporte="reporte_recursos.txt"

# Encabezado en el archivo de reporte
echo -e "Tiempo(s)\t%CPU Libre\t%Memoria Libre\t%Disco Libre" > "$archivo_reporte"

# Inicializar el contador de tiempo
tiempo=0

# Bucle de monitoreo
while [ "$tiempo" -le "$tiempo_total" ]; do
    # Mostrar mensaje de depuración en la terminal
    echo "Capturando datos para el tiempo: ${tiempo}s"  # Mensaje de depuración

    # Capturar % de CPU Libre (promedio de todos los núcleos)
    cpu_libre=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    
    # Capturar % de Memoria Libre
    memoria_libre_pct=$(free | awk '/^Mem:/ {printf("%.2f", $4/$2 * 100)}')

    # Capturar % de Disco Libre (en la raíz /)
    disco_libre=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    # Guardar los datos en el archivo de reporte
    echo -e "${tiempo}s\t${cpu_libre}\t${memoria_libre_pct}\t${disco_libre}" >> "$archivo_reporte"

    # Incrementar el tiempo en el intervalo especificado
    sleep "$intervalo"
    tiempo=$((tiempo + intervalo))
done

echo -e "Los datos del monitoreo fueron guradados correctamente en $archivo_reporte"
