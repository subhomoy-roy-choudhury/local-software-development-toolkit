echo "[+] Loading Environment variables"

source utils/load-env.sh .env

# Define two parallel arrays
service_names=("kafka" "mongodb" "postgresql" "rabbitMQ" "redis" "solr")
commands_list=("docker-compose/kafka/docker-compose-kafka.yml" "docker-compose/mongodb/docker-compose-mongo.yml" "docker-compose/postgresql/docker-compose-postgres.yml" "docker-compose/rabbitMQ/docker-compose-rabbitMQ.yml" "docker-compose/redis/docker-compose-redis.yml" "docker-compose/solr/docker-compose-solr.yml")

# Function to get color for a given fruit
get_color() {
    local service=$1
    for i in "${!service_names[@]}"; do
        if [ "${service_names[i]}" == "$service" ]; then
            echo "${commands_list[i]}"
            return
        fi
    done
    echo "Unknown" # Default case if fruit is not found
}

# Create an array with all the arguments
args=("$@")

# Loop over each value in the array
for value in "${args[@]}"; do
    command=$(get_color "$value")
    if [ "$command" != "Unknown" ]; then
        echo "[+] Creating $value container";
        docker-compose -f ${command} up --build -d --remove-orphans
    else
        echo "Unknown service: $value"
    fi
done