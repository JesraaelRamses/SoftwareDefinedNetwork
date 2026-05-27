from awx.settings.production import *

# Configuración mínima para entorno de desarrollo/pruebas
ALLOWED_HOSTS = ['*']
SECRET_KEY = os.environ.get('SECRET_KEY', 'fallback-dev-key')
DEBUG = True # Solo para desarrollo

DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DATABASE_NAME', 'awx'),
        'USER': os.environ.get('DATABASE_USER', 'awx'),
        'PASSWORD': os.environ.get('DATABASE_PASSWORD', ''),
        'HOST': os.environ.get('DATABASE_HOST', 'postgres'),
        'PORT': os.environ.get('DATABASE_PORT', 5432),
    }
}

BROKER_URL = os.environ.get('BROKER_URL', 'redis://redis:6379/0')