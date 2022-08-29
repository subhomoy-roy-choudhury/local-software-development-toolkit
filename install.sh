DATABASE_DUMP_FOLDER_NAME="database";
DATABASE_ZIP_FOLDER="db_zip";
env_file_name="local.env";
unamestr=$(uname)

DEFAULT_MONGO_VERSION=4.2.2;
DEFAULT_CONTAINER_NAME=local-mongo

echo "[+] Creating database folder";

{
mkdir $DATABASE_ZIP_FOLDER
mkdir $DATABASE_DUMP_FOLDER_NAME
} &> /dev/null   # hide stderr and stdout output using /dev/null

echo "[+] Checking for local.env file"

FILE=local.env
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "Creating $FILE"

    read -p "Enter the MongoDB version [$DEFAULT_MONGO_VERSION]: " MONGO_VERSION;
    echo "MONGO_VERSION=${MONGO_VERSION:-$DEFAULT_MONGO_VERSION}" > $FILE

    read -p "Enter the Container Name [$DEFAULT_CONTAINER_NAME]: " CONTAINER_NAME;
    echo "CONTAINER_NAME=${CONTAINER_NAME:-$DEFAULT_CONTAINER_NAME}" >> $FILE
fi

echo "[+] Loading Environment variables"

if [ "$unamestr" = 'Linux' ]; then

  export $(grep -v '^#' $env_file_name | xargs -d '\n')

elif [ "$unamestr" = 'FreeBSD' ] || [ "$unamestr" = 'Darwin' ]; then

  export $(grep -v '^#' $env_file_name | xargs -0)

fi

# echo "[+] Building and starting mongo:4.2.2 instance"
# docker-compose up --build -d

# echo "[+] Finished"