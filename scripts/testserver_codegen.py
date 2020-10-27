#!/usr/bin/python

import sys, getopt
import os

keepChange = False
debug = False
clean = False
createProject = False
code_generated = False

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

all_files = [
    "additionalProperties",
    "azure-parameter-grouping",
    "azure-report",
    "azure-resource-x",
    "azure-resource",
    "azure-special-properties",
    "body-array",
    "body-boolean",
    "body-boolean.quirks",
    "body-byte",
    "body-complex",
    "body-date",
    "body-datetime-rfc1123",
    "body-datetime",
    "body-dictionary",
    "body-duration",
    "body-file",
    "body-formdata-urlencoded",
    "body-formdata",
    "body-integer",
    "body-number",
    "body-number.quirks",
    "body-string",
    "body-string.quirks",
    "body-time",
    "complex-model",
    "constants",
    "custom-baseUrl-more-options",
    "custom-baseUrl-paging",
    "custom-baseUrl",
    "extensible-enums-swagger",
    "head-exceptions",
    "head",
    "header",
    "httpInfrastructure",
    "httpInfrastructure.quirks",
    "lro",
    "media_types",
    "model-flattening",
    "multiapi-v1-custom-base-url",
    "multiapi-v1",
    "multiapi-v2-custom-base-url",
    "multiapi-v2",
    "multiapi-v3",
    "multiple-inheritance",
    "non-string-enum",
    "object-type",
    "paging",
    "parameter-flattening",
    "report",
    "required-optional",
    "storage",
    "subscriptionId-apiVersion",
    "url-multi-collectionFormat",
    "url",
    "validation",
    "xml-service",
    "xms-error-responses"
]

def generate_and_build_code( fileList):
    """Generate code and build code"""
 
    global clean
    global debug
    global keepChange
    global createProject

    for file in fileList:
        os.system('echo "== Generate code for test server swagger {file}.json =="'.format(file=file))
        
        if clean:
            os.system('echo "Remove Package.resolved and .build directory."')
            os.system('rm ./test/integration/generated/{file}/Package.resolved'.format(file=file))
            os.system('rm -Rf ./test/integration/generated/{file}/.build'.format(file=file))

        autorest_command = "autorest --input-file=./node_modules/@microsoft.azure/autorest.testserver/swagger/{file}.json --output-folder=./test/integration/generated/{file} --namespace={file} --use=.".format(file=file)

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
                return_value = os.system('git restore ./test/integration/generated/{file}'.format(file=file))
                if return_value == 1:
                    os.system('echo "Revert the generated code failed. Remove the directory"')
                    os.system('rm -Rf  ./test/integration/generated/{file}'.format(file=file))

        if code_generated:
            # Build generated code
            os.chdir('./test/integration/generated/{file}'.format(file=file))
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
                os.system('git restore ./test/integration/generated/{file}'.format(file=file))

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
        generate_and_build_code(all_files)
    else:
        generate_and_build_code(working_files)

if __name__ == "__main__":
   main(sys.argv[1:])