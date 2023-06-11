#! /bin/bash

PYTHON=$(which python3)

function setup_keys()
{
    echo "Creating secret keys"  && echo ""

    SECRET_KEY=${SECRET_KEY:-$(mcookie)}
    SITE_SETTINGS_KEY=${SITE_SETTINGS_KEY:-$(mcookie)}
    sed -i "s/^SECRET_KEY.*/SECRET_KEY='$SECRET_KEY'/" \
       "$TENDENCI_PROJECT_ROOT/conf/settings.py"
    echo "SECRET_KEY: $SECRET_KEY" && echo ""
    sed -i "s/^SITE_SETTINGS_KEY.*/SITE_SETTINGS_KEY='$SITE_SETTINGS_KEY'/" \
        "$TENDENCI_PROJECT_ROOT/conf/settings.py"
    echo "SITE_SETTINGS_KEY: $SITE_SETTINGS_KEY" && echo ""
}

function create_settings
{
    echo "Creating settings"  && echo ""

     sed -i "s/^#DATABASES\['default'\]\['NAME'\].*/DATABASES\['default'\]\['NAME'\] = '${DB_NAME:-tendenci}'/" \
        "$TENDENCI_PROJECT_ROOT/conf/settings.py"

     sed -i "s/^#DATABASES\['default'\]\['HOST'\].*/DATABASES\['default'\]\['HOST'\] = '${DB_HOST:-localhost}'/" \
        "$TENDENCI_PROJECT_ROOT/conf/settings.py"

     sed -i "s/^#DATABASES\['default'\]\['USER'\].*/DATABASES\['default'\]\['USER'\] = '${DB_USER:-tendenci}'/" \
        "$TENDENCI_PROJECT_ROOT/conf/settings.py"

     sed -i "s/^#DATABASES\['default'\]\['PASSWORD'\].*/DATABASES\['default'\]\['PASSWORD'\] = '${DB_PASS:-password}'/" \
        "$TENDENCI_PROJECT_ROOT/conf/settings.py"

     sed -i "s/^#DATABASES\['default'\]\['PORT'\].*/DATABASES\['default'\]\['PORT'\] = '${DB_PORT:-5432}'/" \
        "$TENDENCI_PROJECT_ROOT/conf/settings.py"

     sed -i "s/TIME_ZONE.*/TIME_ZONE='${TIME_ZONE:-GMT+0}'/" \
        "$TENDENCI_PROJECT_ROOT/conf/settings.py"

     sed -i "s/ALLOWED_HOSTS =.*/ALLOWED_HOSTS = \[${ALLOWED_HOSTS:-'\*'}\]/" \
        "$TENDENCI_PROJECT_ROOT/conf/settings.py"

    echo "Finished creating settings" && echo ""
}


function create_superuser
{
    echo "Starting super user set-up" && echo ""
    
    cd "$TENDENCI_PROJECT_ROOT"
    echo "from django.contrib.auth import get_user_model; \
        User = get_user_model(); User.objects.create_superuser( \
        '${ADMIN_USER:-admin}', \
        '${ADMIN_MAIL:-admin@example.com}', \
        '${ADMIN_PASS:-password}')" \
        | "$PYTHON" manage.py shell
    
    echo "Finished super user set-up" && echo ""

}

function initial_setup
{

    cd "$TENDENCI_PROJECT_ROOT"
    
    "$PYTHON" manage.py initial_migrate 
    "$PYTHON" manage.py deploy
    "$PYTHON" manage.py load_tendenci_defaults
    "$PYTHON" manage.py update_dashboard_stats
    "$PYTHON" manage.py set_setting site global siteurl "$SITE_URL" 	

    create_superuser
    
    touch "$TENDENCI_PROJECT_ROOT/conf/first_run"
    echo  "Intital set up completed" && echo ""

}

function run
{
    cd "$TENDENCI_PROJECT_ROOT" \
    && "$PYTHON" manage.py runserver 0.0.0.0:8000
}


if [ ! -f "$TENDENCI_PROJECT_ROOT/conf/first_run" ]; then
    setup_keys
    create_settings
    initial_setup
    run "$@"
else
    run "$@"
fi
