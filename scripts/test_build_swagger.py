#!/usr/bin/python3

import json
import logging
import os
import shutil
import subprocess
import sys
import tempfile

warning_color = '\033[91m'
end_color = '\033[0m'

repos_to_clone = ['azure-rest-api-specs']

cwd = os.getcwd()


class SwaggerInfo:
    """ Metadata describing a Swagger to generate. """

    def __init__(self, **kwargs):
        self.path = kwargs.get('path', None)
        self.namespace = kwargs.get('namespace', None)
        self.name = kwargs.get('name', None)

    def __repr__(self):
        return f'{self.namespace}.{self.name}: {self.path}'

def load_swagger_info():
    """ Load swagger metadata from swagger_info.json file. """
    json_path = os.path.join(cwd, 'scripts', 'swagger_info.json')
    with open(json_path) as f:
        data = json.load(f)
    swagger_info = []
    for item in data:
        swagger = SwaggerInfo(**item)
        swagger_info.append(swagger)
    return swagger_info


def run_command(command):
    """ Run a command in a subprocess and return stderr and stdout. """
    result = subprocess.run(command.split(' '), capture_output=True)
    return (result.stdout, result.stderr, result.returncode)


def log_error_and_quit(msg, out, err, code):
    """ Log an error message and exit. """
    if err:
        logging.error(f'{err}')
    elif out:
        logging.error(f'{out}')
    logging.error(f'{warning_color}{msg} ({code}){end_color}')
    sys.exit(code)


def generate(item, *, src, dest):
    """ Generate the SDK for the SwaggerInfo object and return the output. """
    print(f'Generating: {item.namespace}.{item.name}...')
    command = f'autorest --input-file={src} --output-folder={dest} --namespace={item.namespace} --use={cwd} --package-name={item.name}CI'
    out, err, code = run_command(command)
    if code:
        log_error_and_quit(f'Error generating: {item.namespace}.{item.name}', out, err, code)
    return out


def main(argv):

    swagger_data = load_swagger_info()
    with tempfile.TemporaryDirectory() as tempdir:
        rest_api_specs_path = f'{tempdir}/azure-rest-api-specs'
        for repo in repos_to_clone:
            print(f'Cloning: {repo}...')
            out, err, code = run_command(f'git clone https://github.com/Azure/{repo}.git {rest_api_specs_path}')

        for item in swagger_data:
            src = os.path.join(rest_api_specs_path, item.path)
            dest = os.path.join(tempdir, 'generated', item.namespace, f'{item.name}CI')
            out = generate(item, src=src, dest=dest)
            print(f'Building: {item.namespace}.{item.name}...')
            out, err, code = run_command(f'swift build --package-path={dest}')
            if code:
                log_error_and_quit(f'Error building {item.namespace}.{item.name}', out, err, code)
        print('== PACKAGES GENERATED AND BUILT SUCCESSFULLY! ==')
        sys.exit(code)

if __name__ == '__main__':
    main(sys.argv[1:])
