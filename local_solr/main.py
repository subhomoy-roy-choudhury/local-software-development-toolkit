from configparser import ExtendedInterpolation
import os, signal, sys, time
import json
from urllib import response
import requests
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
        self.solr_base_url = 'http://localhost:8985/'

    def insert_data(self, core: str, solr_engine: object):
        with open('solr_config/products/data.json','r') as file:
            data = json.load(file)
        
        for i in data:
            del i['_version_']

        solr_engine.add(data)
    
    def _request_solr(self,endpoint: str, params: dict = {}, headers: dict = {}, payload: dict = {}, write_type: str = 'json'):
        url = f"{self.solr_base_url}solr{endpoint}"

        payload=payload
        params=params.update({'wt':write_type})
        headers=headers

        response = requests.request("GET", url, params=params, headers=headers, data=payload)
        if response.status_code != 200:
            raise Exception('Solr Request Failed !!')

        return response

    def solr_system_info(self):
        response = self._request_solr(
            endpoint='/info/system',
        )
        return response

    def reload_solr_core(self, core: str):
        self._request_solr(
            endpoint='/admin/cores',
            params={
                'action': 'RELOAD',
                'core': core,
                'wt':'json'
            },
        )
        return 0

    def delete_core(self, core: str):
        res = self.local_solr_container.exec_run(f'solr delete -c {core}')
        return 0

    def add_core(self, core: str):
        res = self.local_solr_container.exec_run(f'solr create -c {core}')
        return 0

    def setup_products_core(self, core: str):
        self.docker_client.copy_to_container('solr_config/products/managed-schema', f'local-solr:/var/solr/data/{core}/conf/')
        self.docker_client.copy_to_container('solr_config/products/currency.xml', f'local-solr:/var/solr/data/{core}/conf/')
        self.docker_client.copy_to_container('solr_config/products/data-config.xml', f'local-solr:/var/solr/data/{core}/conf/')
        self.reload_solr_core(core)

    def delete_documents(self, solr_engine: object):
        solr_engine.delete(q='*:*')

    def exec(self):
        
        # self.delete_core('test')
        core='test6'
        self.add_core(core)

        self.setup_products_core(core)
        solr_engine = pysolr.Solr(f'{self.solr_base_url}solr/{core}', use_qt_param=False, verify=False)
        self.insert_data(core,solr_engine)

        # self.delete_documents(solr_engine)
        

        
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
