#!/usr/bin/python3

import sys, getopt
import os
import subprocess
import os.path

keepChange = False
debug = False
clean = False
createProject = False
code_generated = False

generated_directory = r'./test/integration/generated/'
swagger_directory = r'./node_modules/@microsoft.azure/autorest.testserver/swagger/'
warning_color = '\033[91m'
end_color = '\033[0m'

working_files = [
    "head",
    "body-file",
    "report",
    "xms-error-responses",
    "body-integer",
    "url",
    "model-flattening",
    "custom-baseUrl",
    "body-string",
    "body-byte"
]

def get_all_files():
    global swagger_directory
    all_files = []
    for filename in os.listdir(swagger_directory):
        if filename.endswith(".json"):
            all_files.append(os.path.splitext(filename)[0])
        else:
            continue
    return all_files

def revert_generated_code(file):
    global warning_color
    global end_color
    global generated_directory
    print(warning_color + "Revert the generated code." + end_color)
    git_restore_call = subprocess.run(["git", "restore", '{generated_directory}{file}'.format(file=file, generated_directory=generated_directory)], stderr=subprocess.PIPE, text=True)

    if "error" in git_restore_call.stderr:
        print(warning_color + "Revert the generated code failed. Remove the directory" + end_color)
        os.system('rm -Rf  {generated_directory}{file}'.format(file=file, generated_directory=generated_directory))
    else:
        print(git_restore_call.stdout)

def execute_command(command):
    global debug
    if debug:
        return_value = os.system('%s 2>&1' % command)
    else:
        return_value = os.system('%s > /dev/null 2>&1' % command)
    return return_value

def check_xcode_project_exists():
    for fname in os.listdir('.'):
        if fname.endswith('.xcodeproj'):
            return True

    return False

def generate_and_build_code(fileList):
    """Generate code and build code"""
 
    global clean
    global keepChange
    global createProject
    global warning_color
    global end_color
    global generated_directory

    for file in fileList:
        print('== Generate code for test server swagger {file}.json =='.format(file=file))

        if clean:
            print("Remove Package.resolved and .build directory.")
            os.system('rm {generated_directory}{file}/Package.resolved'.format(file=file, generated_directory=generated_directory))
            os.system('rm -Rf {generated_directory}{file}/.build'.format(file=file, generated_directory=generated_directory))

        autorest_command = "autorest --input-file={swagger_directory}{file}.json --output-folder={generated_directory}{file} --namespace={file} --use=.".format(file=file, swagger_directory=swagger_directory, generated_directory=generated_directory)

        print("Autorest command: %s" % autorest_command)
        return_value = execute_command(autorest_command)

        if return_value == 0:
            print("autorest code generation succeed.")
            code_generated = True
        else:
            print(warning_color + "autorest code generation failed." + end_color)
            code_generated = False
            if keepChange == 0:
                revert_generated_code(file)

        if code_generated:
            # Build generated code
            os.chdir('{generated_directory}{file}'.format(file=file, generated_directory=generated_directory))

            build_command = "swift build"
            return_value = execute_command(build_command)

            if return_value == 0:
                print("swift build succeed.")

                # Create xcode project
                if return_value == 0 and createProject:
                    if check_xcode_project_exists() == False:
                        print("create XCode project.")
                        xcode_gen_proj_command = "swift package generate-xcodeproj"
                        return_value = execute_command(xcode_gen_proj_command)

                os.chdir('../../../..')
            else:
                print(warning_color + "swift build failed." +  end_color)
                os.chdir('../../../..')
                if keepChange == 0:
                    revert_generated_code(file)


def main(argv):
    allFiles = False
    global clean
    global debug
    global keepChange
    global createProject

    try:
        opts, args = getopt.getopt(argv,"acdkp", ["all-files", "clean", "debug", "keep-change", "create-project"])
    except getopt.GetoptError:
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-a", "--all-files"):
            allFiles = True
        elif opt in ("-c", "--clean"):
            clean = True
        elif opt in ("-d", "--debug"):
            debug = True
        elif opt in ("-k", "--keep-change"):
            keepChange = True
        elif opt in ("-p", "--create-project"):
            createProject = True

    if allFiles:
        generate_and_build_code(get_all_files())
    else:
        generate_and_build_code(working_files)

if __name__ == "__main__":
   main(sys.argv[1:])
