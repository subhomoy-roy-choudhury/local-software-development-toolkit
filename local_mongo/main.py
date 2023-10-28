import os, signal, sys
from dotenv import load_dotenv
from pathlib import Path
import docker
import glob
from rich import print as rprint
from rich.console import Console

from utils.docker import DockerUtil

console = Console()

class LocalMongo(DockerUtil):
    def __init__(self,client) -> None:
        self.DB_DUMP_PATH = "db_zip/*.zip"
        self.client=client

    def get_db_dump(self):
        db_zip_gen = glob.iglob(self.DB_DUMP_PATH, recursive=True)
        db_zip_list = list()
        for idx,file in enumerate(db_zip_gen):
            base_name = os.path.basename(file)
            db_name = os.path.splitext(base_name)[0]
            rprint(f'[{idx+1}] [green]{db_name}')
            db_zip_list.append(db_name)

        selected_db = int(input('Enter the option : '))
        return db_zip_list[selected_db-1]

        
    def exec(self,container_name: str):
        local_mongo_container = self.get_container(container_name)
        db_dump = self.get_db_dump()
        res = local_mongo_container.exec_run(f'bash -c "rm -rf {db_dump} && unzip -o db_zip/{db_dump}.zip && mongorestore --db {db_dump} --gzip {db_dump}"',stream=True)
        
        '''
        Reference Links for cli-spinner :- 
        https://github.com/Textualize/rich
        https://github.com/pavdmyt/yaspin
        '''
        with console.status("[bold green]Loading...") as status:
            for console_output in list(res.output):
                console.log(console_output.decode())

def run():
    def handler(signum, frame):
        '''Handling Keyboard Interrupts'''
        rprint("\n[red]Sorry for the inconvinience !!")
        sys.exit()

    signal.signal(signal.SIGINT, handler)

    rprint("[green][+] Loading Environment variables")

    dotenv_path = Path('local.env')
    load_dotenv(dotenv_path=dotenv_path)

    client = docker.from_env()
    container_name = os.getenv('CONTAINER_NAME')
    LocalMongo(client).exec(container_name)