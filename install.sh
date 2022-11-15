#!/bin/sh

DATABASE_DUMP_FOLDER_NAME="database";
DATABASE_ZIP_FOLDER="db_zip";
ENV_FILE_NAME="local.env";
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

FILE=local.env

if [ -f "$FILE" ]; then
    echo "${RED}[+] $FILE exists.${COLOR_OFF}"
else 
    echo "${GREEN}[+] Creating $FILE${COLOR_OFF}"

    read -p "Enter the MongoDB version [$DEFAULT_MONGO_VERSION]: " MONGO_VERSION;
    echo "MONGO_VERSION=${MONGO_VERSION:-$DEFAULT_MONGO_VERSION}" > $FILE

    read -p "Enter the MongoDB container name [$DEFAULT_MONGO_CONTAINER_NAME]: " MONGO_CONTAINER_NAME;
    echo "MONGO_CONTAINER_NAME=${MONGO_CONTAINER_NAME:-$DEFAULT_MONGO_CONTAINER_NAME}" >> $FILE

    read -p "Enter the Solr version [$DEFAULT_SOLR_VERSION]: " SOLR_VERSION;
    echo "SOLR_VERSION=${SOLR_VERSION:-$DEFAULT_SOLR_VERSION}" >> $FILE

    read -p "Enter the Solr container name [$DEFAULT_SOLR_CONTAINER_NAME]: " SOLR_CONTAINER_NAME;
    echo "SOLR_CONTAINER_NAME=${SOLR_CONTAINER_NAME:-$DEFAULT_SOLR_CONTAINER_NAME}" >> $FILE

    if [ "$UNAMESTR" = 'Linux' ]; then

        echo "DOCKER_PLATFORM=linux/arm64" >> $FILE

    elif [ "$UNAMESTR" = 'FreeBSD' ] || [ "$UNAMESTR" = 'Darwin' ]; then

        echo "DOCKER_PLATFORM=linux/amd64" >> $FILE

    fi

    echo "PROJECT_DIR=$(pwd)" >> $FILE
fi

echo "[+] Loading Environment variables"

source utils/load-env.sh local.env

echo "[+] Building and starting mongo:4.2.2 instance"
docker-compose -f docker-compose.yml \
    -f docker-compose/mongodb/docker-compose-mongo.yml \
    -f docker-compose/solr/docker-compose-solr.yml \
    up --build -d --remove-orphans

# docker-compose -f docker-compose/mongodb/docker-compose-mongo.yml \
#     -f docker-compose/solr/docker-compose-solr.yml \
#     config

echo "[+] Finished"