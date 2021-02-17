# imagem base
FROM php:7.3.6-fpm-alpine3.9

RUN apk add --no-cache shadow openssl bash mysql-client

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN docker-php-ext-install pdo pdo_mysql

# apagando todo o conteudo da html
RUN rm -rf /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# copiando tudo para a pasta de destino
# COPY . /var/www

# A instalação do pacote shadow para habilitar o comando usermod
RUN chown -R www-data:www-data /var/www
RUN chmod 755 /var/www

# criando um link simbolico para a pasta html (recurso do linux)
RUN ln -s public html

# Atribuir a arquivos e pastas que a propriedade é do usuário www-data, como foi feito um COPY antes com o root, os arquivos são dele e o www-data não teria permissão para escrever e modificar arquivos.
RUN usermod -u 1000 www-data

# Atribuição do grupo 1000 ao usuário www-data
USER www-data

# assumindo que esta na pasta
WORKDIR /var/www

# expondo a porta 9000
EXPOSE 9000

# executando o comando
ENTRYPOINT ["php-fpm"]
