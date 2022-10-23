import os
import io
import tarfile
import docker

class DockerUtil(object):
    def __init__(self) -> None:
        self.client = docker.from_env()

    def get_container(self,container_name: str):
        container_list = self.client.containers.list()
        for i in container_list:
            if i.name == container_name:
                return i

    def copy_to_container(self, src: str, dst_dir: str):
        """ src shall be an absolute path. Reference Link :- https://stackoverflow.com/questions/46390309/how-to-copy-a-file-from-host-to-container-using-docker-py-docker-sdk """
        name, dst_dir = dst_dir.split(':')
        container = self.client.containers.get(name)
        stream = io.BytesIO()
        with tarfile.open(fileobj=stream, mode='w|') as tar, open(src, 'rb') as f:
            info = tar.gettarinfo(fileobj=f)
            info.name = os.path.basename(src)
            tar.addfile(info, f)

        container.put_archive(dst_dir, stream.getvalue())

        