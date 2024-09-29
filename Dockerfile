FROM php:5.6.11-apache

# Download the libaio1 package
RUN curl -o libaio1_0.3.112-3_amd64.deb http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio1_0.3.112-3_amd64.deb && \
    dpkg -i libaio1_0.3.112-3_amd64.deb && \
    rm libaio1_0.3.112-3_amd64.deb

# Copy the pre-downloaded files into the image
COPY oci8-2.0.12.tgz /tmp/
COPY instantclient-sdk-linux.x64-12.2.0.1.0.zip /tmp/
COPY instantclient-basic-linux.x64-12.2.0.1.0.zip /tmp/
COPY unzip.tar /tmp/

RUN cd /tmp && tar -xf unzip.tar && mv unzip /usr/local/bin/ && chmod +x /usr/local/bin/unzip && rm -f unzip.tar

ENV ORACLE_HOME=/opt/oracle

# Install unzip and Oracle Instant Client
RUN mkdir -p $ORACLE_HOME && \
    cd $ORACLE_HOME && \
    unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip && \
    unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip && \
    rm /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip && \
    ln -s $ORACLE_HOME/instantclient_12_2/libclntsh.so.12.1 $ORACLE_HOME/instantclient_12_2/libclntsh.so && \
    ln -s $ORACLE_HOME/instantclient_12_2/libocci.so.12.1 $ORACLE_HOME/instantclient_12_2/libocci.so && \
    echo "$ORACLE_HOME/instantclient_12_2" > /etc/ld.so.conf.d/oracle-instantclient_12_2.conf && \
    ldconfig

# Install the OCI8 extension from the pre-downloaded file
RUN tar -xzf /tmp/oci8-2.0.12.tgz -C /tmp/ && \
    (cd /tmp/oci8-2.0.12 && phpize && ./configure --with-oci8=instantclient,$ORACLE_HOME/instantclient_12_2 && make && make install) && \
    docker-php-ext-enable oci8

RUN echo "export LD_LIBRARY_PATH=$ORACLE_HOME/instantclient_12_2" >> /etc/apache2/envvars && \
    echo "export ORACLE_HOME=$ORACLE_HOME/instantclient_12_2" >> /etc/apache2/envvars && \
    echo "LD_LIBRARY_PATH=$ORACLE_HOME/instantclient_12_2:$LD_LIBRARY_PATH" >> /etc/environment

# Install comopser
COPY --from=composer/composer:2.2-bin /composer /usr/bin/composer

# Enable mod_rewrite
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]
