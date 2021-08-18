FROM mediawiki:1.35.3

# Define the ResourceBasePath in MediaWiki as a variable name: ResourceBasePath
ENV ResourceBasePath /var/www/html

ARG BUILD_SMW

# Make sure that existing software are updated 
RUN apt-get update 
#RUN apt-get install -y ghostscript
#RUN apt-get install -y libmagickwand-dev
#RUN apt-get install -y xpdf
RUN apt-get install -y xvfb
RUN apt-get install -y cron
RUN apt-get install -y nano
RUN apt-get install zlibc zip unzip
RUN rm -rf /var/lib/apt/lists/*


RUN apt-get upgrade

# Change file read/write access for the images directory
RUN chmod -R 777 ${ResourceBasePath}/images

# Define working directory for the following commands
WORKDIR ${ResourceBasePath}/extensions

RUN apt update
#RUN apt install -y nodejs npm
#RUN npm i npm@latest -g
#RUN apt install -y nodejs
#RUN apt-get update
#RUN apt-get -y upgrade

# Copy Math package to extensions/
#COPY ./extensions/Math/ ${ResourceBasePath}/extensions/Math/


# Copy MultimediaViewer package to extensions/
COPY ./extensions/MultimediaViewer/ ${ResourceBasePath}/extensions/MultimediaViewer/


# Copy the BackupAndRestore scripting package to MediaWiki's "extensions/" directory
#COPY ./extensions/BackupAndRestore/ ${ResourceBasePath}/extensions/BackupAndRestore/

# Copy OAuth package to extensions/
COPY ./extensions/OAuth/ ${ResourceBasePath}/extensions/OAuth/


# Copy ExtensionDataAccounting package to extensions/
COPY ./extensions/ExtensionDataAccounting  ${ResourceBasePath}/extensions/ExtensionDataAccounting



# Copy CSS package to extensions/
COPY ./extensions/CSS  ${ResourceBasePath}/extensions/CSS

# Copy Medik package to extensions/
COPY ./extensions/Medik  ${ResourceBasePath}/skins/Medik

# Copy the php.ini with desired upload_max_filesize into the php directory.
ENV PHPConfigurationPath /usr/local/etc/php
COPY ./resources/php.ini ${PHPConfigurationPath}/php.ini

# Copy two $wgLogo images to the container so that we can switch between them
COPY ./resources/xlp.png ${ResourceBasePath}/resources/assets/xlp.png
COPY ./resources/EuMuse.png ${ResourceBasePath}/resources/assets/EuMuse.png
COPY ./resources/toyhouse.png ${ResourceBasePath}/resources/assets/toyhouse.png
COPY ./resources/by-sa.png ${ResourceBasePath}/resources/assets/by-sa.png
COPY ./resources/aqua.png ${ResourceBasePath}/resources/assets/aqua.png

# Copy the mime.types to the container
COPY ./resources/mime.types ${ResourceBasePath}/includes/mime.types

# Copy the mime.info to the container
COPY ./resources/mime.info ${ResourceBasePath}/includes/mime.info

# The service cron start instruction should be kicked off by the "up.sh" script
# Directly use the following CMD here always cause the MediaWiki service to hang.
# CMD service cron start

# Add crontab file in the cron directory
ADD crontab /var/spool/cron/crontab/root

# Give execution rights on the cron job
RUN chmod 0644 /var/spool/cron/crontab/root

# Run the cron job
RUN crontab /var/spool/cron/crontab/root

# Go to the ${ResourceBasePath} for working directory
WORKDIR ${ResourceBasePath}

# Install PHP package manager "Composer"

# Requires v1 instead of v2 for compatibility with Semantic MediaWiki 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer --version=2.1.2


COPY ./composer.local.json ${ResourceBasePath}/composer.local.json

RUN composer update --no-dev