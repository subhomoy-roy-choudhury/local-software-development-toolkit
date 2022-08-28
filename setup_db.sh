#!/bin/bash
echo "Database Dump List :-";


container_name='mongodb-fynd';
container_id=$(docker ps -aqf "name=${container_name}");

db_names=();

file_count=0;
for file in db_zip/*.zip
    do

        ((file_count=file_count+1)) #incrementing the file count

        name=${file##*/}
        base=${name%.zip}

        db_names+=($base)

        docker cp db_zip/${base}.zip $container_id:/home/fynd-data/db_zip/${base}.zip &> /dev/null   #Syncing new files
        echo "[$file_count] ${base}"
    done

read -p 'Enter the option :- ' option_key;


function get_db() {
    docker exec -it $container_name bash -c "rm -rf ${1} && unzip -o db_zip/${1}.zip && mongorestore --db ${1} --gzip ${1}" &> /dev/null
}

get_db ${db_names[$option_key - 1]};