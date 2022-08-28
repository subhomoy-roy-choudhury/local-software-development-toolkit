DATABASE_DUMP_FOLDER_NAME="database";
DATABASE_ZIP_FOLDER="db_zip";
env_file_name="local.env";
unamestr=$(uname)

echo "[+] Creating database folder";

{
mkdir $DATABASE_ZIP_FOLDER
mkdir $DATABASE_DUMP_FOLDER_NAME
} &> /dev/null

echo "[+] Checking for local.env file"

FILE=local.env
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist."
fi

echo "[+] Loading Environment variables"

if [ "$unamestr" = 'Linux' ]; then

  export $(grep -v '^#' $env_file_name | xargs -d '\n')

elif [ "$unamestr" = 'FreeBSD' ] || [ "$unamestr" = 'Darwin' ]; then

  export $(grep -v '^#' $env_file_name | xargs -0)

fi

echo "[+] Building and starting mongo:4.2.2 instance"
docker-compose up --build -d

echo "[+] Finished"