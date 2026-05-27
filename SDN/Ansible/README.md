# AWX Automation Server (SRE Lab)

## Descripción
Este repositorio contiene el despliegue de **AWX** 
(versión open source de Ansible Tower) usando 
`docker-compose`. 

AWX permite centralizar y ejecutar playbooks de Ansible, 
gestionar inventarios y programar tareas.

Forma parte de mi portafolio como 
**Site Reliability Engineer**, 
demostrando habilidades en automatización, 
gestión de contenedores y orquestación.

## Tecnologías utilizadas
- AWX 23.0.0
- PostgreSQL 15
- Redis 7
- Docker / Podman (docker-compose)
- Ansible (jobs ejecutados desde AWX)

## ¿Qué demuestra este proyecto?

### 1. Automatización con AWX
- Capacidad para desplegar un servidor
  de automatización completo.
- Configuración de tareas programadas,
  inventarios dinámicos y lanzamiento de playbooks.

### 2. Gestión de secretos mediante variables de entorno
- Uso de `.env` para contraseñas y claves (nunca hardcodeadas).
- Archivo `.env.example` para facilitar la replicación.

### 3. Contenerización y orquestación
- Servicios separados (web, task, redis, postgres)
  con dependencias controladas.
- Volúmenes persistentes para base de datos y configuración.

### 4. Resolución de problemas (troubleshooting)
- Script para cambiar contraseña de admin si es necesario
  (`scripts/changepassword.sh`).
- Monitoreo de logs y verificación de salud de servicios.

## Cómo usar este repositorio

1. Clonar:
   ```bash
   git clone https://github.com/JesraaelRamses/awx-automation-sre
   cd awx-automation-sre
   ```
---

2. Copiar y editar variables:
  ```bash

    cp .env.example .env
    nano .env   # cambiar contraseñas y secret key

  ```
  ---

3. Iniciar servicios:

```sh

docker-compose up -d

```
---


4. Acceder a AWX: 

```sh
http://localhost:8080
Usuario: admin (o el que definiste en .env)
```
---


# Lecciones aprendidas

```sh
AWX requiere que la contraseña del superusuario
se asigne manualmentesi usas --noinput.
Lo resolví con awx-manage changepassword.

Es mejor usar variables de entorno
que credenciales fijas, sobre todo
en repositorios públicos.

Separar el contenedor awx-task del web
mejora el rendimiento y la escalabilidad.

```
---




## Autor
### Jesraael Ramses González González
***SRE | CCNA | CCNP (en curso)***
***LinkedIn | GitHub***
