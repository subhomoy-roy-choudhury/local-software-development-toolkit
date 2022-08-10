#!/bin/bash

echo "[1] orbis";
echo "[2] silverbolt";

read -p 'Enter the option :- ' option_key;

if [[ $option_key == 1 ]];
    then 
        echo 'orbis';
        echo mongo localhost:27017 --eval 'db.getMongo().getDBNames().indexOf("orbis")';
        wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1T8oqhWnmO3JtyYpXT3dftwt-F9vyC3Li' -O orbis.zip
        unzip orbis.zip
        mongorestore --db orbis --gzip orbis
elif [[ $option_key == 2 ]];
    then 
        echo 'silverbolt';
        echo mongo localhost:27017 --eval 'db.getMongo().getDBNames().indexOf("silverbolt")';
        wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1tRzIuHXDKRAEQdD0Kw5jmhLwQaWIcsoh' -O silverbolt.zip
        unzip silverbolt.zip 
        mongorestore --db silverbolt --gzip silverbolt
fi