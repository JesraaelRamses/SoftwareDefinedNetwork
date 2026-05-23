#!/bin/bash

echo "=== Extracción y preparación de backup ==="

if [ -z "$1" ]; then
  echo "Uso: $0 <archivo-backup.tar.gz>"
  echo "Ejemplo: $0 backup/extracted/monitoring-backup-20260206_150814.tar.gz"
  exit 1
fi

BACKUP_FILE="$1"
EXTRACT_DIR="./backup/extracted_temp"

echo "1. Extrayendo $BACKUP_FILE..."
# Limpiar directorio temporal si existe
rm -rf $EXTRACT_DIR 2>/dev/null
mkdir -p $EXTRACT_DIR

# Extraer el backup
tar -xzf "$BACKUP_FILE" -C $EXTRACT_DIR --strip-components=1

echo "2. Preparando estructura para Podman..."

# Limpiar directorios de configuración (opcional, tener cuidado)
echo "¿Deseas limpiar los directorios existentes? (s/n) [n]: "
read -r respuesta
if [[ "$respuesta" =~ ^[Ss]$ ]]; then
  echo "Limpiando directorios..."
  rm -rf ./prometheus/* ./grafana/* 2>/dev/null
fi

echo "3. Copiar configuración de Prometheus..."
# Crear directorios necesarios
mkdir -p ./prometheus/rules ./prometheus/file_sd ./prometheus/consoles ./prometheus/console_libraries

# Copiar archivos de configuración
if [ -f "$EXTRACT_DIR/prometheus.yml" ]; then
  cp "$EXTRACT_DIR/prometheus.yml" ./prometheus/
  echo "  ✓ prometheus.yml copiado"
fi

# Copiar directorios
for dir in rules rules.d file_sd console_libraries consoles; do
  if [ -d "$EXTRACT_DIR/$dir" ]; then
    cp -r "$EXTRACT_DIR/$dir"/* ./prometheus/$dir/ 2>/dev/null
    echo "  ✓ $dir copiado"
  fi
done

echo "4. Copiar configuración de Grafana..."
# Crear directorios necesarios
mkdir -p ./grafana/provisioning/datasources ./grafana/provisioning/dashboards

# Copiar archivos de configuración
for file in grafana.ini ldap.toml; do
  if [ -f "$EXTRACT_DIR/$file" ]; then
    cp "$EXTRACT_DIR/$file" ./grafana/
    echo "  ✓ $file copiado"
  fi
done

# Copiar directorio provisioning si existe
if [ -d "$EXTRACT_DIR/provisioning" ]; then
  cp -r "$EXTRACT_DIR/provisioning"/* ./grafana/provisioning/ 2>/dev/null
  echo "  ✓ provisioning copiado"
fi

echo "5. Copiar configuraciones de systemd para referencia..."
mkdir -p ./backup/systemd
for service_file in prometheus.service node_exporter.service grafana-server; do
  if [ -f "$EXTRACT_DIR/$service_file" ]; then
    cp "$EXTRACT_DIR/$service_file" ./backup/systemd/
    echo "  ✓ $service_file copiado para referencia"
  fi
done

echo "6. Crear archivos de configuración básicos si faltan..."
# Verificar datasource
if [ ! -f "./grafana/provisioning/datasources/datasources.yml" ]; then
  cat > ./grafana/provisioning/datasources/datasources.yml << 'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
EOF
  echo "  ✓ datasources.yml creado"
fi

# Verificar dashboards
if [ ! -f "./grafana/provisioning/dashboards/dashboards.yml" ]; then
  cat > ./grafana/provisioning/dashboards/dashboards.yml << 'EOF'
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    editable: true
    options:
      path: /etc/grafana/provisioning/dashboards
EOF
  echo "  ✓ dashboards.yml creado"
fi

echo "7. Ajustar permisos..."
chmod -R 755 ./prometheus ./grafana 2>/dev/null
find ./prometheus -type f -name "*.yml" -o -name "*.yaml" | xargs chmod 644 2>/dev/null
find ./grafana -type f -name "*.ini" -o -name "*.toml" -o -name "*.yml" | xargs chmod 644 2>/dev/null

echo "8. Limpiar temporal..."
rm -rf $EXTRACT_DIR

echo ""
echo "=== Preparación completada ==="
echo ""
echo "Estructura resultante:"
tree -L 3 --dirsfirst

echo ""
echo "Revisa los siguientes archivos:"
echo "1. ./prometheus/prometheus.yml - Ajustar IPs de targets si es necesario"
echo "2. ./grafana/grafana.ini - Configuración de Grafana"
echo "3. ./grafana/ldap.toml - Configuración LDAP (si existe)"
echo ""
echo "Cuando estés listo, ejecuta: podman-compose up -d"