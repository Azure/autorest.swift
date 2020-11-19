#!/usr/bin/python3

import os
import sys, getopt

debug = False
warning_color = '\033[91m'
end_color = '\033[0m'

def execute_command(command):
    global debug
    if debug:
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
    os.chdir('azure-rest-api-specs')
    os.chdir('{swagger_spec_directory}'.format(swagger_spec_directory=swagger_spec_directory))
    execute_command('autorest --input-file={swagger_name}.json --output-folder=../../../../../../../{swagger_name} --namespace={swagger_name} --use=../../../../../../../../../'.format(swagger_name=swagger_name))
   
def clone_repo():
    print("==Clone azure-rest-api-specs repo==")
    os.chdir('test/integration')
    execute_command('git clone https://github.com/Azure/azure-rest-api-specs.git')
    print("==Clone azure-sdk-for-ios repo==")
    execute_command('git clone https://github.com/Azure/azure-sdk-for-ios.git')

def compile_ios_sdk():
    print("==Compile azure-sdk-for-ios repo before adding generated code==")
    os.chdir('../../../../../../../azure-sdk-for-ios')
    execute_command('pod install')
    return_value = execute_command('swift build')
    if return_value == 0:
        print("Azure ios sdk sucessfully compiled")
    else:
        print(warning_color + "Azure ios sdk failed to compile" + end_color)

def compile_ios_sdk_with_generated_code(swagger_name):
    print("==Copy new generated code to azure-sdk-for-ios==")
    execute_command('cp -r ../{swagger_name}/* sdk/communication/AzureCommunicationChat'.format(swagger_name=swagger_name))
    print("==Compile azure-sdk-for-ios repo with enerated code==")
    return_value = execute_command('swift build')
    if return_value == 0:
        print("Azure ios sdk with Generated code for communicationserviceschat sucessfully compiled")
    else:
        print(warning_color + "Azure ios sdk with Generated code for communicationserviceschat failed to compile" + end_color)

def main(argv):
    try:
        opts, args = getopt.getopt(argv,"d", ["debug"])
    except getopt.GetoptError:
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-d", "--debug"):
            debug = True

    swagger_name = r'communicationserviceschat'
    swagger_spec_directory = r'specification/communication/data-plane/Microsoft.CommunicationServicesChat/preview/2020-09-21-preview2'
    cleanup(swagger_name)
    clone_repo()
    code_gen(swagger_name, swagger_spec_directory)
    compile_ios_sdk()
    compile_ios_sdk_with_generated_code(swagger_name)



if __name__ == "__main__":
    main(sys.argv[1:])