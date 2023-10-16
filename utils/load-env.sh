ENV_FILE_NAME=$1
UNAMESTR=$(uname)

# For All Platform (MacOS, Windows, Linux)
while IFS= read -r line
do
    if [[ ! "$line" =~ ^\# && -n "$line" ]]; then
        export "$line"
    fi
done < $ENV_FILE_NAME