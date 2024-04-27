#!/bin/sh


echo "server {\
    listen 443 ssl http2;\
    server_name pgorner.42.fr;\
    root /var/www/html;\
    index index.php;\
\
    ssl_certificate /etc/nginx/ssl/ssl_final_cert.crt;\
    ssl_certificate_key /etc/nginx/ssl/ssl_priv_key.key;\
    ssl_protocols TLSv1.3;\
\
    location / {\
        try_files \$uri \$uri/ /index.php\$is_args\$args;\
    }\
\
    location ~ \.php$ {\
        include fastcgi_params; \
        fastcgi_pass wordpress:9000; \
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\
    }\
\
    error_log /var/log/nginx/error.log;\
}" > /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"