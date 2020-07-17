// A script to parse code model schema file (code-mode.json) and map out which schema 
// are inherited by other schema and how many of them.
// To run, type 'node read-code-mode.js'

var fs = require('fs');


fs.readFile('code-mode.json', 'utf8', function (err, data) {
    var interfaceMapping = {};

    if (err) throw err;

    var codeModel = JSON.parse(data)
    var definitions = codeModel["definitions"]

    for (var definitionName in definitions) {
        var definition = definitions[definitionName]

        if (definition.hasOwnProperty("allOf")) {
            var allOfValues = definition["allOf"]

            allOfValues.forEach((element, index, array) => {
                var name = element["$ref"]
                if (interfaceMapping.hasOwnProperty(name)) {
                    interfaceMapping[name].push(definitionName)
                } else {
                    interfaceMapping[name] = [definitionName]
                }
            });
        }
    }

    console.log(interfaceMapping)
});
