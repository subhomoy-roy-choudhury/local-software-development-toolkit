#!/bin/sh

DATABASE_DUMP_FOLDER_NAME="database";
DATABASE_ZIP_FOLDER="db_zip";
ENV_FILE_NAME=".env";
UNAMESTR=$(uname);

DEFAULT_MONGO_VERSION="4.2.2";
DEFAULT_MONGO_CONTAINER_NAME="local-mongo";

DEFAULT_SOLR_VERSION="8.11.2";
DEFAULT_SOLR_CONTAINER_NAME="local-solr";

#Finding Colors
COLORS_FILE_PATH='./utils/find-colors.sh'

COLOR_OFF=$(source $COLORS_FILE_PATH Color_Off);
GREEN=$(source $COLORS_FILE_PATH Green);
RED=$(source $COLORS_FILE_PATH Red);

echo "${GREEN}[+] Creating database folder${COLOR_OFF}";      # printf is also used instead of echo -e

{
    
mkdir $DATABASE_ZIP_FOLDER
# mkdir $DATABASE_DUMP_FOLDER_NAME

} &> /dev/null   # hide stderr and stdout output using /dev/null

echo "${GREEN}[+] Checking for local.env file${COLOR_OFF} "

if [ -f "$ENV_FILE_NAME" ]; then
    echo "${RED}[+] $ENV_FILE_NAME exists.${COLOR_OFF}"
else 
    echo "${GREEN}[+] Creating $ENV_FILE_NAME${COLOR_OFF}"

    read -p "Enter the MongoDB version [$DEFAULT_MONGO_VERSION]: " MONGO_VERSION;
    echo "MONGO_VERSION=${MONGO_VERSION:-$DEFAULT_MONGO_VERSION}" > $ENV_FILE_NAME

    read -p "Enter the MongoDB container name [$DEFAULT_MONGO_CONTAINER_NAME]: " MONGO_CONTAINER_NAME;
    echo "MONGO_CONTAINER_NAME=${MONGO_CONTAINER_NAME:-$DEFAULT_MONGO_CONTAINER_NAME}" >> $ENV_FILE_NAME

    read -p "Enter the Solr version [$DEFAULT_SOLR_VERSION]: " SOLR_VERSION;
    echo "SOLR_VERSION=${SOLR_VERSION:-$DEFAULT_SOLR_VERSION}" >> $ENV_FILE_NAME

    read -p "Enter the Solr container name [$DEFAULT_SOLR_CONTAINER_NAME]: " SOLR_CONTAINER_NAME;
    echo "SOLR_CONTAINER_NAME=${SOLR_CONTAINER_NAME:-$DEFAULT_SOLR_CONTAINER_NAME}" >> $ENV_FILE_NAME

    if [ "$UNAMESTR" = 'Linux' ]; then

        echo "DOCKER_PLATFORM=linux/arm64" >> $ENV_FILE_NAME

    elif [ "$UNAMESTR" = 'FreeBSD' ] || [ "$UNAMESTR" = 'Darwin' ]; then

        echo "DOCKER_PLATFORM=linux/amd64" >> $ENV_FILE_NAME

    fi

    echo "PROJECT_DIR=$(pwd)" >> $ENV_FILE_NAME
fi

echo "[+] Loading Environment variables"

# source utils/load-env.sh .env

echo "[+] Building and starting mongo:4.2.2 - postgres:latest - solr:8.11.2 instance"
docker-compose -f docker-compose.yml \
    -f docker-compose/mongodb/docker-compose-mongo.yml \
    -f docker-compose/solr/docker-compose-solr.yml \
    -f docker-compose/postgresql/docker-compose-postgres.yml \
    up --build -d --remove-orphans

# docker-compose -f docker-compose/mongodb/docker-compose-mongo.yml \
#     -f docker-compose/solr/docker-compose-solr.yml \
#     config

echo "[+] Finished"