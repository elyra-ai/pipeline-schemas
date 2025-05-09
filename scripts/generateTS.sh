#!/bin/bash
#
# Copyright 2025 Elyra Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This script generates Typescript declarations files from the JSON schemas
# contained in this repo. It does this by:
# 1. Copying all schemas to the ../schemas directory
# 2. Changing any references to child schemas in this form:
#       "$ref": "https://api.dataplatform.ibm.com/schemas/common-pipeline/parameters/parametersets-v3-schema.json#/definitions/paramset_ref"
#     to look like this:
#       "$ref": "./parametersets-v3-schema.json#/definitions/paramset_ref"
#     This makes the schemas like pipeline-flow-v3-schema.json have correct
#     references to its child schemas like parametersets-v3-schema.json.
# 3. Runs the json2ts utility command on each of the top level schemas to
#    generate the typescript declaration files.
# 4. For the generated canvas-info.ts file, it looks for '@readonly' in
#    any of the comments for properties and, if that is found, it
#    prefixes the property name with the 'readonly' keyword.
#

#---------------------------------------------------------------
# Function: Replaces the lines in the file beginning with "$ref"
#---------------------------------------------------------------
replace_string_in_file() {
  local file_path="$1"
  local url="$2"

  # Look for old strings of this form:
  #   "$ref": "https://api.dataplatform.ibm.com/schemas/common-pipeline/ + $url + /
  # and replaces them with:
  #   "$ref": "./
  local old_string="\"\$ref\":\ \"https:\/\/api.dataplatform.ibm.com\/schemas\/common-pipeline\/"$url"\/"
  local old_string_with_common_canvas_path="\"\$ref\":\ \"https:\/\/api.dataplatform.ibm.com\/schemas\/common-canvas\/"$url"\/"
  local new_string="\"\$ref\":\ \"\.\/"

  sed -i '' "s/$old_string/$new_string/g" "$file_path"
  sed -i '' "s/$old_string_with_common_canvas_path/$new_string/g" "$file_path"
  # Warning: The above command runs OK on the build machine without a
  # space between the -i and the double quotes. However, if running
  # locally on a Mac a space is needed.

}
#---------------------------------------------------------------
# Function: Call the replace string for each of the types of child schema
#---------------------------------------------------------------
replace_string_schema() {
  local file=$1
  replace_string_in_file "$file" "datarecord-metadata"
  replace_string_in_file "$file" "pipeline-flow"
  replace_string_in_file "$file" "parameters"
  replace_string_in_file "$file" "pipeline-connection"
  replace_string_in_file "$file" "operators"
  replace_string_in_file "$file" "expression"
}

#---------------------------------------------------------------
# Function: For each JSON schema file replace the contents of
# that starts with "http;//"
#---------------------------------------------------------------
replace_http_refs() {
  replace_string_schema "canvas-info-v3-schema.json"
  replace_string_schema "pipeline-flow-v3-schema.json"
  replace_string_schema "palette-v3-schema.json"
  replace_string_schema "datarecord-metadata-v3-schema.json"
  replace_string_schema "parameters-v3-schema.json"
  replace_string_schema "parametersets-v3-schema.json"
  replace_string_schema "pipeline-connection-v3-schema.json"
  replace_string_schema "pipeline-flow-ui-v3-schema.json"
  replace_string_schema "pipeline-flow-v3-schema.json"
  replace_string_schema "expression-info-v3-schema.json"
  replace_string_schema "function-list-v3-schema.json"
  replace_string_schema "parameter-defs-v3-schema.json"
  replace_string_schema "conditions-v3-schema.json"
  replace_string_schema "operator-v3-schema.json"
  replace_string_schema "uihints-v3-schema.json"
}

#---------------------------------------------------------------
# Function: Copy all JSON schemas to the schemas directory
#---------------------------------------------------------------
copy_all_schemas() {
  cp ../common-canvas/canvas-info/canvas-info-v3-schema.json .
  cp ../common-canvas/expression/expression-info-v3-schema.json .
  cp ../common-canvas/expression/function-list-v3-schema.json .
  cp ../common-canvas/palette/palette-v3-schema.json .
  cp ../common-canvas/parameter-defs/parameter-defs-v3-schema.json .
  cp ../common-pipeline/pipeline-flow/pipeline-flow-v3-schema.json .
  cp ../common-pipeline/pipeline-flow/pipeline-flow-ui-v3-schema.json .
  cp ../common-pipeline/datarecord-metadata/datarecord-metadata-v3-schema.json .
  cp ../common-pipeline/parameters/parameters-v3-schema.json .
  cp ../common-pipeline/parameters/parametersets-v3-schema.json .
  cp ../common-pipeline/pipeline-connection/pipeline-connection-v3-schema.json .
  cp ../common-pipeline/operators/conditions-v3-schema.json .
  cp ../common-pipeline/operators/operator-v3-schema.json .
  cp ../common-pipeline/operators/uihints-v3-schema.json .
}

set -e

WORKING_DIR="$PWD"

echo "Generating Typescript declarations."

# Install json-schema-to-typescript utility
echo "npm install"
npm install

# Make sure we're in the scripts directory
cd ./scripts

# Make sure we have an empty ../schemas directory and change to it
rm -rf ../schemas
mkdir ../schemas
cd ../schemas

# Copy all JSON schemas into the ../schemas directory
copy_all_schemas

# Replace the "ref": "http://...  references to become "ref": "./...
replace_http_refs

# Create a prologue to use for our TS declaration files
prologue1="
/*
 * Copyright 2025 Elyra Authors
 *
 * Licensed under the Apache License, Version 2.0 (the \"License\");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an \"AS IS\" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */"
 prologue2="
/**
 * This file was automatically generated by json-schema-to-typescript.
 * DO NOT MODIFY IT BY HAND. Instead, modify the source JSONSchema file,
 * and run the ../script/generateTS.sh script to regenerate all TS files.
 */
/* eslint-disable */"
prologue3="
/**
 * This file was automatically generated by the generateTS.sh script.
 * DO NOT MODIFY IT BY HAND. Instead, modify the source script file,
 * and run ../script/generateTS.sh to regenerate all TS files.
 */
/* eslint-disable */"

# Makes sure we have an empty  ../types directory
rm -rf ../types
mkdir ../types

# Run the json2ts utilities for the top level schemas
ts_prologue="$prologue1 $prologue2"
npx json2ts --bannerComment "$ts_prologue" canvas-info-v3-schema.json ../types/canvas-info-v3.ts
npx json2ts --bannerComment "$ts_prologue" pipeline-flow-v3-schema.json ../types/pipeline-flow-v3.ts
npx json2ts --bannerComment "$ts_prologue" palette-v3-schema.json ../types/palette-v3.ts
# npx json2ts --bannerComment "$ts_prologue" expression-info-v3-schema.json ../types/expression-info-v3.ts
# npx json2ts --bannerComment "$ts_prologue" function-list-v3-schema.json ../types/function-list-v3.ts
npx json2ts --bannerComment "$ts_prologue" parameter-defs-v3-schema.json ../types/parameter-defs-v3.ts

# The canvas-info schema may include readonly properties for objects. json2ts does not
# currently convert these to readonly keywords in the TS file. The line below looks for
# @readonly which must be added to the description of the property and then prefixes
# the line two below the comment with the 'readonly' keyword.
sed  -i '' '/@readonly/ { n; n; s/^/readonly/; }'  "../types/canvas-info-v3.ts"

# Create an Typescript index file
# We have to export explicitely from canvas-info and palete because they reference
# objects already exported from pipeline-flow.
index_file_text="$prologue1
$prologue3
export {
  HttpsApiDataplatformIbmComSchemasCommonPipelinePipelineFlowPipelineFlowV3SchemaJson as PipelineFlowDef,
  PipelineFlowUiDef,
  PipelineDef,
  PipelineUiDef,
  NodeTypeDef,
  NodeUiDef,
  ExecutionNodeDef,
  SupernodeDef,
  BindingEntryNodeDef,
  BindingExitNodeDef,
  ModelNodeDef,
  PortsDef,
  PortDef,
  BoundPortsDef,
  BoundPortDef,
  PortUiDef,
  ZoomObjectDef,
  NodeDecorationDef,
  LinkDecorationDef,
  ImageDecorationDef,
  LabelDecorationDef,
  ShapeDecorationDef,
  JsxDecorationDef,
  DecorationSharedProperties,
  NodeLinkDef,
  NodeLinkUiDef,
  AssociationLinkDef,
  CommentLinkDef,
  CommentDef,
  AppDataDef,
  MessageDef,
  RuntimeDef,
  RuntimeUiDef,
  ParamsetRef,
  CommonPipelineConnectionDef,
  CommonPipelineDataAssetDef,
  RecordSchema,
  Field,
  Metadata
} from \"./pipeline-flow-v3.ts\";
export {
  HttpsApiDataplatformIbmComSchemasCommonCanvasCanvasInfoCanvasInfoV3SchemaJson as CanvasInfo,
  CanvasPipeline,
  CanvasNode,
  CanvasExecutionNode,
  CanvasSupernode,
  CanvasBindingEntryNode,
  CanvasBindingExitNode,
  CanvasModelNode,
  CanvasPort,
  CanvasPorts,
  CanvasBoundPort,
  CanvasBoundPorts,
  CanvasComment,
  CanvasLink,
  CanvasNodeLink,
  CanvasAssociationLink,
  CanvasCommentLink
} from \"./canvas-info-v3.ts\";
export {
  HttpsApiDataplatformIbmComSchemasCommonCanvasPalettePaletteV3SchemaJson as PipelineFlowPalette,
  CategoryDef
} from \"./palette-v3.ts\";"

# Write out the TS index file.
echo "$index_file_text"  > ../types/index.d.ts

# Now remove the copies of the schema files
rm -rf ../schemas

# Return to the directory we began at.
cd $WORKING_DIR

echo "TS declarations generated successfully"
