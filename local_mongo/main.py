import docker

class LocalMongo(object):
    def __init__(self,client) -> None:
        self.client=client
        
    def exec(self):
        print(self.client.containers.list())

def run():
    print("Local Mongo CLI")
    client = docker.from_env()
    local_mongo_obj = LocalMongo(client).exec()