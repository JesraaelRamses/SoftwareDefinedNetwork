#!/bin/bash
# 1. Agregar todos los cambios 
git add .

# 2. Crear commit 
msg="Avance automatico: $(date +'%d-%m-%Y %H:%M:%S')"
git commit -m "$msg"

# Empujar los cambios a Git Hub
git push origin main

echo "------------------------------------------"
echo "   RESPALDO COMPLETADO: $msg "
echo "------------------------------------------"