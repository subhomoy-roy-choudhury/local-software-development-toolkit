ENV_FILE_NAME=$1
UNAMESTR=$(uname)

if [ "$UNAMESTR" = 'Linux' ]; then

  export $(grep -v '^#' $ENV_FILE_NAME | xargs -d '\n')

elif [ "$UNAMESTR" = 'FreeBSD' ] || [ "$UNAMESTR" = 'Darwin' ]; then

  export $(grep -v '^#' $ENV_FILE_NAME | xargs -0)

fi