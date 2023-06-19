<!--
{% comment %}
Copyright 2017-2023 Elyra Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
{% endcomment %}
-->

# pipeline-schemas
Location for the common pipeline JSON schemata and examples

## Contents
This repository contains the JSON schema files pertaining to pipeline job flow authoring and execution:

### The 'common-pipeline' directory

Common schemas related to pipeline definition and execution:

  * [Operators](https://github.com/elyra-ai/pipeline-schemas/tree/main/common-pipeline/operators): Contains the base operator, uihints, and condition schemas and examples
  * [Pipeline-flow](https://github.com/elyra-ai/pipeline-schemas/tree/main/common-pipeline/pipeline-flow): Common pipeline-flow and pipeline-flow-ui JSON schemas
  * [Dataset-metadata](https://github.com/elyra-ai/pipeline-schemas/tree/main/common-pipeline/dataset-metadata): JSON dataset metadata definition

### The 'common-canvas' directory

Schema and example files for driving the Common Canvas and Property Editor tooling

  * [Parameter-defs](https://github.com/elyra-ai/pipeline-schemas/tree/main/common-canvas/parameter-defs): Common Properties parameter editing schema and examples
  * [Form](https://github.com/elyra-ai/pipeline-schemas/tree/main/common-canvas/form): Common Properties low-level form JSON specification
  * [Palette](https://github.com/elyra-ai/pipeline-schemas/tree/main/common-canvas/palette): Canvas palette JSON definition
  * [Diagram](https://github.com/elyra-ai/pipeline-schemas/tree/main/common-canvas/diagram): Older (e.g. pre-pipeline-flow) internal canvas diagram specification
