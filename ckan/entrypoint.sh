#!/bin/bash
set -e

ckan-paster --plugin=ckan db init -c "/etc/ckan/configuration.ini"
exec "$@"