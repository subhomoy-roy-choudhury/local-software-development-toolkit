import os, signal, sys, time
import json
from dotenv import load_dotenv
from pathlib import Path
from rich import print as rprint
from rich.console import Console
import pysolr

from local_mongo.main import LocalMongo
from utils.docker import DockerUtil

console = Console()

class LocalSolr(object):
    def __init__(self) -> None:
        self.docker_client = DockerUtil()
        self.local_solr_container = self.docker_client.get_container('local-solr')

    def insert_data(self,solr_engine: object):
        with open('solr_config/products/data.json','r') as file:
            data = json.load(file)
        
        for i in data:
            del i['_version_']

        solr_engine.add(data)
    
    def delete_core(self, core: str):
        res = self.local_solr_container.exec_run(f'solr delete -c {core}')
        return 0

    def add_core(self, core: str):
        res = self.local_solr_container.exec_run(f'solr create -c {core}')
        return 0

    def exec(self):
        self.add_core('test')
        solr_engine = pysolr.Solr('http://localhost:8985/solr/test', search_handler='/update', use_qt_param=False, verify=False)
        self.insert_data(solr_engine)
        

        
def run():
    def handler(signum, frame):
        '''Handling Keyboard Interrupts'''
        rprint("\n[red]Sorry for the inconvinience !!")
        sys.exit()

    signal.signal(signal.SIGINT, handler)

    rprint("[green][+] Loading Environment variables")

    LocalSolr().exec()

if __name__=='__main__':
    run()
