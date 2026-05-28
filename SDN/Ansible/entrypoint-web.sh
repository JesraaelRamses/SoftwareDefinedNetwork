#!/bin/bash
set -e

awx-manage migrate --noinput

# Asegurar que admin existe con la contraseña correcta
echo "from django.contrib.auth import get_user_model; User = get_user_model(); user = User.objects.filter(username='${ADMIN_USER}').first(); user and user.set_password('${ADMIN_PASSWORD}') and user.save()" | awx-manage shell || \
awx-manage createsuperuser --noinput --username ${ADMIN_USER} --email admin@example.com 2>/dev/null || true

echo "from django.contrib.auth import get_user_model; User = get_user_model(); user = User.objects.get(username='${ADMIN_USER}'); user.set_password('${ADMIN_PASSWORD}'); user.save()" | awx-manage shell

exec awx-manage runserver 0.0.0.0:8052
