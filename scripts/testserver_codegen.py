#!/usr/bin/python3

import sys, getopt
import os
import subprocess
import os.path

keep_change = False
debug = False
clean = False
code_generated = False
skip_build = False

generated_directory = r'./test/integration/generated/'
swagger_directory = r'./node_modules/@microsoft.azure/autorest.testserver/swagger/'
warning_color = '\033[91m'
end_color = '\033[0m'

working_files = [
    "body-array",
    "body-boolean",
    "body-byte",
    "body-date",
    "body-datetime",
    "body-datetime-rfc1123",
    "body-file",
    "body-number",
    "body-integer",
    "body-string",
    "body-time",
    "custom-baseUrl",
    "custom-baseUrl-more-options",
    "head",
    "header",
    "model-flattening",
    "paging",
    "report",
    "required-optional",
    "url",
    "url-multi-collectionFormat",
    "xms-error-responses"
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
    global keep_change
    global warning_color
    global end_color
    global generated_directory

    for file in fileList:
        print('== Generate code for test server swagger {file}.json =='.format(file=file))

        if clean:
            print("Remove `Package.resolved` and `.build` and `Generated` directories.")
            os.system('rm {generated_directory}{file}/Package.resolved'.format(file=file, generated_directory=generated_directory))
            os.system('rm -Rf {generated_directory}{file}/.build'.format(file=file, generated_directory=generated_directory))
            os.system('rm -Rf {generated_directory}{file}/Source/Generated'.format(file=file, generated_directory=generated_directory))

        autorest_command = "autorest --input-file={swagger_directory}{file}.json --output-folder={generated_directory}{file} --namespace={file} --use=.".format(file=file, swagger_directory=swagger_directory, generated_directory=generated_directory)

        print("Autorest command: %s" % autorest_command)
        return_value = execute_command(autorest_command)

        if return_value == 0:
            print("autorest code generation succeed.")
            code_generated = True
        else:
            print(warning_color + "autorest code generation failed." + end_color)
            code_generated = False
            if keep_change == 0:
                revert_generated_code(file)

        if code_generated and not skip_build:
            # Build generated code
            os.chdir('{generated_directory}{file}'.format(file=file, generated_directory=generated_directory))

            build_command = "swift build"
            return_value = execute_command(build_command)

            if return_value == 0:
                print("swift build succeed.")
                os.chdir('../../../..')
            else:
                print(warning_color + "swift build failed." +  end_color)
                os.chdir('../../../..')
                if keep_change == 0:
                    revert_generated_code(file)


def main(argv):
    all_files = False
    global clean
    global debug
    global keep_change
    global skip_build
    input_file = ''

    try:
        opts, args = getopt.getopt(argv,"acdksi:", ["all-files", "clean", "debug", "keep-change", "skip-build", "input-file"])
    except getopt.GetoptError as error:
        print("Error: {}".format(error))
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-a", "--all-files"):
            all_files = True
        if opt in ("-c", "--clean"):
            clean = True
        if opt in ("-d", "--debug"):
            debug = True
        if opt in ("-k", "--keep-change"):
            keep_change = True
        if opt in ("-i", "--input-file"):
            input_file = argv[1]
        if opt in ("-s", "--skip-build"):
            skip_build = True

    print("== make install ==")
    execute_command("make install")
    if input_file != '':
        generate_and_build_code([input_file])
    elif all_files:
        generate_and_build_code(get_all_files())
    else:
        generate_and_build_code(working_files)

if __name__ == "__main__":
   main(sys.argv[1:])
