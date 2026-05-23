# Prometheus + Grafana Monitoring Stack (SRE Lab)

## Descripción
Este repositorio contiene la infraestructura como código para desplegar un stack completo de monitoreo y observabilidad usando **Prometheus** y **Grafana**, orquestado con **Podman**. Incluye:

- Configuración automatizada de datasources y dashboards en Grafana (provisioning)
- Reglas de alerta en Prometheus (si las tienes)
- Scripts de utilería para extracción de backups y solución de autenticación
- Archivos systemd para gestión de servicios en producción

## Tecnologías
- Prometheus (métricas, alertas, consolas)
- Grafana (visualización, provisioning)
- Podman (contenedores rootless)
- Node Exporter (métricas del sistema)

## ¿Qué demuestra este proyecto?

### 1. Observabilidad como código
- Datasources y dashboards se definen en YAML/JSON y se aplican automáticamente.
- Configuración de Prometheus versionada.

### 2. Automatización y scripting
- Script `extract-and-prepare.sh`: prepara backups de monitoreo.
- Script `fix-auth-final.sh`: resuelve problemas de autenticación en Grafana.

### 3. Gestión de servicios con systemd
- Archivos `.service` listos para producción en RHEL.

### 4. Portabilidad con Podman
- `podman-compose.yml` para levantar todo el stack en cualquier entorno.

## Cómo usar (clonar y ejecutar)
```bash
git clone https://github.com/JesraaelRamses/SoftwareDefinedNetwork/
cd prometheus-grafana-sre
cp .env.example .env   # edita variables necesarias
podman-compose up -d