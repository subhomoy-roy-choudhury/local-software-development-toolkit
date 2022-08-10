#!/bin/bash

db_names=("orbis" "silverbolt");

echo "[1] orbis";
echo "[2] silverbolt";

read -p 'Enter the option :- ' option_key;

function get_db() {
    wget --no-check-certificate --header 'Authorization: token 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' https://raw.githubusercontent.com/subhomoy-roy-choudhury/fynd-local-db-setup/master/db_zip/${1}.zip -O ${1}.zip
    unzip ${1}.zip
    mongorestore --db ${1} --gzip ${1}
}

get_db ${db_names[$option_key - 1]};