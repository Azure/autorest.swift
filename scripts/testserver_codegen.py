#!/usr/bin/python

import sys, getopt
import os

keepChange = False
debug = False
clean = False
createProject = False
code_generated = False

swagger_directory = r'./node_modules/@microsoft.azure/autorest.testserver/swagger/'

working_files = [
    "head",
    "body-file",
    "report",
    "xms-error-responses",
    "body-integer",
    "url",
    "model-flattening",
    "custom-baseUrl"
]

def get_all_files():
    all_files = []
    for filename in os.listdir(swagger_directory):
        if filename.endswith(".json"):
            all_files.append(os.path.splitext(filename)[0])
        else:
            continue
    return all_files

def generate_and_build_code( fileList):
    """Generate code and build code"""
 
    global clean
    global debug
    global keepChange
    global createProject
    generated_directory = r'./test/integration/generated/'

    for file in fileList:
        os.system('echo "== Generate code for test server swagger {file}.json =="'.format(file=file))

        if clean:
            os.system('echo "Remove Package.resolved and .build directory."')
            os.system('rm {generated_directory}{file}/Package.resolved'.format(file=file, generated_directory=generated_directory))
            os.system('rm -Rf {generated_directory}{file}/.build'.format(file=file, generated_directory=generated_directory))

        autorest_command = "autorest --input-file={swagger_directory}{file}.json --output-folder={generated_directory}{file} --namespace={file} --use=.".format(file=file, swagger_directory=swagger_directory, generated_directory=generated_directory)

        os.system('echo "Autorest: %s"' % autorest_command)
        if debug:
            return_value = os.system('%s 2>&1' % autorest_command)
        else:
            return_value = os.system('%s > /dev/null 2>&1' % autorest_command)
    
        if return_value == 0:
            os.system('echo "autorest code generation succeed."')
            code_generated = True
        else:
            code_generated = False
            if keepChange == 0:
                os.system('echo "autorest code generation failed. Revert the generated code."')
                return_value = os.system('git restore {generated_directory}{file}'.format(file=file, generated_directory=generated_directory))
                if return_value == 1:
                    os.system('echo "Revert the generated code failed. Remove the directory"')
                    os.system('rm -Rf  {generated_directory}{file}'.format(file=file, generated_directory=generated_directory))

        if code_generated:
            # Build generated code
            os.chdir('{generated_directory}{file}'.format(file=file, generated_directory=generated_directory))
            build_command = "swift build"

            if debug:
                return_value = os.system('%s 2>&1' % build_command)
            else:
                return_value = os.system('%s > /dev/null 2>&1' % build_command)

            if return_value == 0:
                os.system('echo "swift build succeed."')
                os.chdir('../../../..')
            else:
                os.system('echo "swift build failed. Revert the generated code."')
                os.chdir('../../../..')
                os.system('git restore {generated_directory}{file}'.format(file=file, generated_directory=generated_directory))

            # Create xcode project
            if return_value == 0 and createProject:
                os.system('echo "create XCode project."')
                xcode_gen_proj_command = "swift package generate-xcodeproj"

                if debug:
                    return_value = os.system('%s 2>&1' % xcode_gen_proj_command)
                else:
                    return_value = os.system('%s > /dev/null 2>&1' % xcode_gen_proj_command)


def main(argv):
    allFiles = False
    global clean
    global debug
    global keepChange
    global createProject

    try:
        opts, args = getopt.getopt(argv,"acdkp", ["allFiles", "clean", "debug", "keepChange", "createProject"])
    except getopt.GetoptError:
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-a", "--allFiles"):
            allFiles = True
        elif opt in ("-c", "--clean"):
            clean = True
        elif opt in ("-d", "--debug"):
            debug = True
        elif opt in ("-k", "--keepChange"):
            keepChange = True
        elif opt in ("-p", "--createProject"):
            createProject = True

    if allFiles:
        generate_and_build_code(get_all_files())
    else:
        generate_and_build_code(working_files)

if __name__ == "__main__":
   main(sys.argv[1:])