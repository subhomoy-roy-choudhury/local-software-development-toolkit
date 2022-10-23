package main

import (
	"errors"
	"fmt"
	"log"
	"os"
	"os/exec"
	"runtime"

	"github.com/spf13/viper"
)

var DATABASE_DUMP_FOLDER_NAME string = "database"
var DATABASE_ZIP_FOLDER string = "db_zip"
var ENV_FILE_NAME string = "local.env"

var DEFAULT_MONGO_VERSION string = "4.2.2"
var DEFAULT_MONGO_CONTAINER_NAME string = "local-mongo"

var DEFAULT_SOLR_VERSION string = "8.11.2"
var DEFAULT_SOLR_CONTAINER_NAME string = "local-solr"

var os_platform string

var docker_platform_key string = "DOCKER_PLATFORM"
var docker_platform_value string

func init() {
	os_platform := runtime.GOOS
	_ = os_platform
}

func viperEnvVariable(key string) string {
	viper.SetConfigFile(ENV_FILE_NAME)

	err := viper.ReadInConfig()

	if err != nil {
		log.Fatalf("Error while reading config file %s", err)
	}

	value, ok := viper.Get(key).(string)

	if !ok {
		log.Fatalf("Invalid type assertion")
	}

	return value

}

func FormatENVFile(context string, key string, default_value string) {
	var value string = default_value
	fmt.Print(context)
	fmt.Scanf("%s", &value)
	SetENVVariables(key, value)
	fmt.Printf("%v : %s\n", key, value)
}

func SetENVVariables(key string, value string) {
	os.Setenv(key, value)
	UpdateEnvFile(key, value)
}

func UpdateEnvFile(key string, value string) {
	file, err := os.OpenFile(ENV_FILE_NAME, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)

	if err != nil {
		fmt.Printf("Could not open %s", ENV_FILE_NAME)
		return
	}

	defer file.Close()

	fmt.Fprintf(file, "%v=%v\n", key, value)
}

func go_docker_compose() {

	cmd := exec.Command("docker-compose", "up", "--build", "-d", "--remove-orphans")
	stdout, err := cmd.Output()

	if err != nil {
		fmt.Print("test")
		fmt.Println(err.Error())
		return
	}

	fmt.Print(string(stdout))
}

func main() {
	// color.Cyan("Prints text in cyan.")

	_, err := os.Stat(ENV_FILE_NAME)
	if errors.Is(err, os.ErrNotExist) {
		// handle the case where the file doesn't exist
		FormatENVFile(fmt.Sprintf("Enter the MongoDB version [%v]:", DEFAULT_MONGO_VERSION), "MONGO_VERSION", DEFAULT_MONGO_VERSION)

		if os_platform == "darwin" {
			docker_platform_value = "linux/amd64"
		} else {
			docker_platform_value = "linux/amd64"
		}
		SetENVVariables(docker_platform_key, docker_platform_value)
	}

	value := viperEnvVariable("DOCKER_PLATFORM")
	fmt.Printf("%v\n", value)

	go_docker_compose()
}
