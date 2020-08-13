# Autorest.Swift

## Issues
**Please file issues for the repository in one of the following repositories** as appropriate:

  - [Azure/azure-sdk-for-ios](https://github.com/Azure/azure-sdk-for-ios/issues) : When you're experiencing trouble with the Swift SDK, but not with other languages, this is the repository to report bugs to. i.e. What we generate for Paged Operations doesn't make sense or there's something hard coded that shouldn't be.
  - [Azure/autorest](https://github.com/Azure/autorest) : Should you run into duplicated types, or fundamentally flawed enums, and it seems consistent across languages, but doesn't seem like the problems lies with the actual Azure Service, the problem could lie with how we're modeling the problem as we see it in the Open API Spec. File bugs matching this description to our parent project, "Autorest".
  - [Azure/azure-rest-api-specs](https://github.com/Azure/azure-rest-api-specs) : If you're getting an error message from the service, saying that it requires a different set of parameters, or you're targeting the wrong endpoint, the problem is likely with the Azure OpenAPI Specs repository. i.e. It seems like the service isn't acurately described.

## Contributing

For details on contributing to this repository, see the [contributing guide](CONTRIBUTING.md).

This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit
https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repositories using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Autorest plugin configuration

Please don't edit this section unless you're re-configuring how the Swift extension plugs in to AutoRest. AutoRest needs the below config to pick this up as a plug-in - see https://github.com/Azure/autorest/blob/master/docs/developer/architecture/AutoRest-extension.md

**Swift code gen**

``` yaml
version: 3.0.6267
use-extension:
  "@autorest/modelerfour": "4.15.410"

modelerfour:
  # this runs a pre-namer step to clean up names
  prenamer: true

  # this will flatten models marked with 'x-ms-client-flatten'
  flatten-models: true

  # TODO: What does this do?
  flatten-payloads: false

  # this will make the content-type parameter always specified
  always-create-content-type-parameter: true

  # TODO: What does this do?
  multiple-request-parameter-flattening: false

  # enables parameter grouping via x-ms-parameter-grouping
  group-parameters: true

naming:
  parameter: camelcase
  property: camelcase
  operation: camelcase
  operationGroup:  pascalcase
  choice:  pascalcase
  choiceValue:  camelcase
  constant:  camelcase
  constantParameter:  camelcase
  type:  pascalcase
  local: _ + camelcase # TODO: Is this right?
  global: camelcase
  preserve-uppercase-max-length: 6
  override:
    $host: $host

pass-thru:
  - model-deduplicator
  - subset-reducer

pipeline:
  swift: # <- name of plugin 
    input: modelerfour/identity
    output-artifact: swift-files

  swift/emitter:
    input: swift
    scope: swift-scope/emitter

swift-scope/emitter:
  input-artifact: swift-files

output-artifact: swift-files
```

![Impressions](https://azure-sdk-impressions.azurewebsites.net/api/impressions/azure-sdk-for-ios%2FREADME.png)
