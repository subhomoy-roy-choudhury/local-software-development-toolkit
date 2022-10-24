package main

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"runtime"

	"github.com/fatih/color"
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

type EnvironmentVariables struct {
	key   string
	value string
}

func init() {
	os_platform := runtime.GOOS
	_ = os_platform
}

func FormatENVFile(context string, key string, default_value string) {
	var value string = default_value

	d := color.New(color.FgCyan, color.Bold)
	d.Print(context)
	fmt.Scanf("%s", &value)

	var env_variables = EnvironmentVariables{key: key, value: value}
	SetENVVariables(env_variables)

	fmt.Printf("%v : %s\n", key, value)
}

func SetENVVariables(env_variables EnvironmentVariables) {
	os.Setenv(env_variables.key, env_variables.value)
	UpdateEnvFile(env_variables.key, env_variables.value)
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
		fmt.Println(err.Error())
		return
	}

	fmt.Print(string(stdout))
}

func main() {

	_, err := os.Stat(ENV_FILE_NAME)
	if errors.Is(err, os.ErrNotExist) {

		FormatENVFile(fmt.Sprintf("Enter the MongoDB version [%v]:", DEFAULT_MONGO_VERSION), "MONGO_VERSION", DEFAULT_MONGO_VERSION)
		FormatENVFile(fmt.Sprintf("Enter the MongoDB container name [%v]:", DEFAULT_MONGO_CONTAINER_NAME), "MONGO_CONTAINER_NAME", DEFAULT_MONGO_CONTAINER_NAME)
		FormatENVFile(fmt.Sprintf("Enter the Solr version [%v]:", DEFAULT_SOLR_VERSION), "SOLR_VERSION", DEFAULT_SOLR_VERSION)
		FormatENVFile(fmt.Sprintf("Enter the Solr container name [%v]:", DEFAULT_SOLR_CONTAINER_NAME), "SOLR_CONTAINER_NAME", DEFAULT_SOLR_CONTAINER_NAME)

		if os_platform == "darwin" {
			docker_platform_value = "linux/amd64"
		} else {
			docker_platform_value = "linux/amd64"
		}
		SetENVVariables(EnvironmentVariables{docker_platform_key, docker_platform_value})
	}

	go_docker_compose()
}
