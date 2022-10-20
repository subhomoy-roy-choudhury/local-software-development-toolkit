import docker

class DockerUtil(object):
    def __init__(self) -> None:
        self.client = docker.from_env()

    def get_container(self,container_name: str):
        container_list = self.client.containers.list()
        for i in container_list:
            if i.name == container_name:
                return i

        