import os
import json

class ResultData:
    def __init__(self):
        self.enums = []
        self.simple = []
        self.complex = {}

def dumper(obj):
    return obj.__dict__

# find project root folder
repo_root = os.path.abspath(os.getcwd())
levels = []
found = False
while len(levels) < 3:
    all_files = os.listdir(repo_root)
    if 'Package.swift' in all_files:
        found = True
        break
    levels.append('..')
    repo_root = os.path.abspath(os.path.join(repo_root, *levels))

if not found:
    raise Exception('Could not determine repo root.')

# open and parse code model
code_model_path = os.path.abspath(os.path.join(repo_root, 'misc', 'codeModel.json'))
with open(code_model_path, 'r') as json_file:
    json_obj = json.load(json_file)

# analyze results
results = ResultData()
for name, metadata in json_obj['definitions'].items():
    # find enum values
    if metadata.get('enum'):
        results.enums.append(name)
        continue

    # find items with 'allOf' properties
    all_of_items = metadata.get('allOf')
    if all_of_items:
        for item in metadata.get('allOf', []):
            parent = item['$ref'].rsplit('/', 1)[1]
            if parent not in results.complex:
                results.complex[parent] = {}
            if parent in results.simple:
                results.simple.remove(parent)
            if name in results.simple:
                results.simple.remove(name)
            results.complex[parent][name] = []
    else:
        results.simple.append(name)

# now go back and up-level any instances of multiple inheritance
for name, children in results.complex.items():
    for child in children:
        # if a complex type is a child of another complex type, move it into that type
        if child in results.complex:
            children[child] = results.complex[child]
            del results.complex[child]

results.simple.sort()
results.enums.sort()
print(json.dumps(results, default=dumper, indent=4, sort_keys=True))