first run:
# build container:
docker-compose up --build -d
# generate artisan key and add to .env:
docker exec -it snipeit php artisan key:generate --show


# in case key error: 500 Internal Server Error
# check log first:
docker exec -it snipeit tail -n 100 /var/www/html/storage/logs/laravel.log

# if error contains public and auth.key remove and recreate it as a file
rm -rf /docker-inventory/files/oauth/oauth-public.key
rm -rf /docker-inventory/files/oauth/oauth-private.key
touch /docker-inventory/files/oauth/oauth-private.key
chown 33:33 /docker-inventory/files/oauth/oauth-private.key
chmod 600 /docker-inventory/files/oauth/oauth-private.key
# clear artisan cache
docker exec -it snipeit php artisan config:clear
docker exec -it snipeit php artisan cache:clear