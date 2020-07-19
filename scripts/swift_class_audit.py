import os
import json

class ItemResult:
    def __init__(self, name, schema, done):
        self.name = name
        self.schema = schema
        self.done = done

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

swift_code_path = os.path.abspath(os.path.join(repo_root, 'src', 'AutorestSwift', 'Models'))

# analyze results
results = []
for name, metadata in json_obj['definitions'].items():
    schema = 'struct'
    if metadata.get('enum'):
        schema = 'enum'

    swift_name = "{}.swift".format(name)
    swift_path = os.path.join(swift_code_path, swift_name)
    try:
        with open(swift_path, 'r') as swift_file:
            results.append(ItemResult(name=name, schema=schema, done=True))
    except IOError:
        results.append(ItemResult(name=name, schema=schema, done=False))

print(json.dumps(results, default=dumper, indent=4, sort_keys=True))

finished = [r for r in results if r.done]
unfinished = [r for r in results if not r.done]
finished_count = len(finished)
unfinished_count = len(unfinished)
total = finished_count + unfinished_count

print('{} / {} files written ({:.0f}%)'.format(finished_count, total, finished_count * 100.0 / total))
