FROM php:8.3-fpm

# Instalar dependências
RUN apt-get update && apt-get install -y \ 
    git \ 
    curl \ 
    zip \ 
    unzip \ 
    libfreetype6-dev \ 
    libjpeg62-turbo-dev \ 
    libpng-dev \ 
    libzip-dev \ 
    && docker-php-ext-configure gd --with-freetype --with-jpeg \ 
    && docker-php-ext-install -j$(nproc) gd \ 
    && docker-php-ext-install pdo pdo_mysql zip \ 
    && curl -sS https://get.symfony.com/cli/installer | bash

# Configurar a pasta de trabalho
WORKDIR /var/www/app

# Copiar os arquivos da aplicação
COPY app/ /var/www/app

# Definir variáveis de ambiente 
ENV COMPOSER_ALLOW_SUPERUSER=1 
ENV GIT_HTTP_LOW_SPEED_LIMIT=0 
ENV GIT_HTTP_LOW_SPEED_TIME=999

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install

CMD ["php-fpm"]

EXPOSE 9000
