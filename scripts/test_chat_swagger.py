#!/usr/bin/python3

import os
import sys, getopt
import os.path
from os import path

clean = False
debug = False
warning_color = '\033[91m'
end_color = '\033[0m'

def execute_command(command):
    global debug
    if debug:
        print('Command: {command}'.format(command=command))
        return_value = os.system('%s 2>&1' % command)
    else:
        return_value = os.system('%s > /dev/null 2>&1' % command)
    return return_value

def cleanup(swagger_name):
    os.chdir('test/integration')
    os.system('rm -Rf azure-rest-api-specs')
    os.system('rm -Rf {swagger_name}'.format(swagger_name=swagger_name))
    os.system('rm -Rf azure-sdk-for-ios')
    os.chdir('../..')

def code_gen(swagger_name, swagger_spec_directory):
    print('Generate code for {swagger_name}.json'.format(swagger_name=swagger_name))
    os.chdir('test/integration/azure-rest-api-specs')
    if path.exists('../../{swagger_name}'.format(swagger_name=swagger_name)):
        os.rmdir('../../{swagger_name}'.format(swagger_name=swagger_name))
    os.chdir('{swagger_spec_directory}'.format(swagger_spec_directory=swagger_spec_directory))
    return_value = execute_command('autorest --input-file={swagger_name}.json --output-folder=../../../../../../../{swagger_name} --namespace={swagger_name} --use=../../../../../../../../../'.format(swagger_name=swagger_name))
    if return_value == 0:
        print("Code generation for {swagger_name}.json is sucessfull".format(swagger_name=swagger_name))
    else:
        print(warning_color + "Fail to code gen {swagger_name}.json" + end_color)
        exit(1)
    os.chdir('../../../../../../../../../')

def update_repo():
    execute_command('git stash')
    execute_command('git checkout master')
    execute_command('git pull')

def setup_repo(repo):
    os.chdir('test/integration')

    if path.exists(repo):
        print("==Stach any changes and pull from master {repo}==".format(repo=repo))
        os.chdir(repo)
        update_repo()
        os.chdir('..')
    else:
        print("==Clone {repo} repo==".format(repo=repo))
        execute_command('git clone https://github.com/Azure/{repo}.git'.format(repo=repo))

    os.chdir('../..')

def compile_ios_sdk():
    print("==Compile azure-sdk-for-ios repo before adding generated code==")
    os.chdir('test/integration/azure-sdk-for-ios')
    execute_command('pod install')
    return_value = execute_command('swift build')
    if return_value == 0:
        print("Azure ios sdk sucessfully compiled")
    else:
        print(warning_color + "Azure ios sdk failed to compile" + end_color)
        exit(1)
    os.chdir('../../..')

def compile_ios_sdk_with_generated_code(swagger_name):
    os.chdir('test/integration/azure-sdk-for-ios')
    # Work aroud before the restructed generated code of chat sdk is push
    remove_directories = ["Options" , "Util", "Models"]
    for directory in remove_directories:
        if path.exists('sdk/communication/AzureCommunicationChat/Source/{name}'.format(name=directory)):
            os.system('rm -Rf sdk/communication/AzureCommunicationChat/Source/{name}'.format(name=directory))

    remove_files = ['AzureCommunicationChatClient.swift', 'AzureCommunicationChatService.swift']
    for file in remove_files:
        if path.exists('sdk/communication/AzureCommunicationChat/Source/{name}'.format(name=file)):
            os.remove('sdk/communication/AzureCommunicationChat/Source/{name}'.format(name=file))


    print("==Copy new generated code to azure-sdk-for-ios==")
    execute_command('cp -r ../{swagger_name}/* sdk/communication/AzureCommunicationChat'.format(swagger_name=swagger_name))
    print("==Compile azure-sdk-for-ios repo with generated code==")
    return_value = execute_command('swift build')
    if return_value == 0:
        print("Azure ios sdk with Generated code for communicationserviceschat sucessfully compiled")
    else:
        print(warning_color + "Azure ios sdk with Generated code for communicationserviceschat failed to compile" + end_color)
        exit(1)

def main(argv):
    global clean
    global debug

    try:
        opts, args = getopt.getopt(argv,"dc", ["debug","clean"])
    except getopt.GetoptError:
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("dc", "--debug", "--clean"):
            debug = True
        if opt in ("-c", "--clean"):
            clean = True

    swagger_name = r'communicationserviceschat'
    swagger_spec_directory = r'specification/communication/data-plane/Microsoft.CommunicationServicesChat/preview/2020-09-21-preview2'
    if clean:
        cleanup(swagger_name)
    setup_repo("azure-sdk-for-ios")
    setup_repo("azure-rest-api-specs")
    compile_ios_sdk()
    code_gen(swagger_name, swagger_spec_directory)
    compile_ios_sdk_with_generated_code(swagger_name)

if __name__ == "__main__":
    main(sys.argv[1:])
