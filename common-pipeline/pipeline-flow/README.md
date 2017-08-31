## The WDP Common Pipeline Flow Specification

### Overview
This note contains an overview of a version 1 proposal for a Common Pipeline JSON specification. The purpose of the common specification is to enable interoperability between various data processing and modeling applications within the Watson Data Platform. The eventual goal is to standardize on this format across WDP applications.

Previously there existed the notion of two separate document types: One for pipeline flow authoring and another for execution. The Common Pipeline Flow specification was designed with both use cases in mind, such that it can be used as both a persistence format in flow authoring tools and as the executable pipeline format for backend processors.


### Scope
Documents adhering to the Common Pipeline Flow specification contain one or more pipelines. A pipeline is a container with one or more DAGs (Directed Acyclic Graph) of nodes. Nodes represent operations within data flows that can be executed in backend runtimes.

Common Pipeline documents contain a primary pipeline and zero or more sub-pipelines. Sub-pipelines are typically bound to the primary pipeline within a document via a super node, but they do not have to be.

Pipeline flows within a document are self-contained such that they can be deployed and reused elsewhere. Although multiple runtimes can be combined within a single document via different pipelines, each pipeline is bound to a single runtime.

Pipeline flows optionally contain application-specific information at every level. Although not required to recognize and support application-specific data, document processors are required to maintain and pass this information through document modifications without a loss of information.


### Node Types
There are three types of node within pipeline flows:
1. Data binding nodes, which connect the inputs and outputs of a pipeline to the outside world
2. Data execution nodes, which are the actual executable portion of a pipeline as run in a backend
3. Supernodes, which are the mechanism by which sub-pipelines are bound to parent pipelines


### Data Bindings
Data is bound to Common Pipeline Flow documents in one of three different ways. The first two exist within pipeline flow documents, the third exists for optional dynamic binding overrides from outside of the document:
 - Explicitly via reference from within the document to an external data source or sink
 - Internally via reference to binding nodes in another pipeline
 - Implicitly via an external pipeline flow configuration that overrides equivalent bindings within the document

This flexibility enables flow reuse by supporting both static and dynamic binding, or any combination thereof.


### Internal Linkage
Nodes contain input and output ports. Nodes are connected to each other via links between ports. Linkage flow is from end to start node, allowing processors to easily trace backwards for executing sub-pipelines. The exception to this rule is for supernodes, which contain sub-flow linkage for both input and output ports.

Most nodes have only a single port and thus port references can usually be omitted in links. The sole exception to this comes when a node has multiple output ports, in which case node links connected downstream must refer explicitly to the node and port ids.


### Datarecord Schema
Ports on node inputs and outputs support optional datarecord schema definitions (see datarecord-metadata-v1-schema.json in the current repository). This aids processors in easily determining datarecord metadata requirements. There is a "schemas" array at the end of each common pipeline document in which datarecord schemata are optionally stored and referred to from node ports.


### An Example
 See the 'pipeline-flow-v1-example.png' diagram describing the pipeline-flow-v1-example.json file in the examples folder that accompanies this note. The data binding nodes are expressed as circles on the edges of each pipeline and the super node uses a rounded rectangle, although physically they are all just types of node in the DAG.

Shaded binding nodes are statically bound at design time in the example. The external binding is overridden externally in the "External binding" directive. Node bindings can also be overridden in an external configuration as well, although they are not overridden in this diagram. Note the dashed arrow links in green which represent the linkage between the super node and the sub-pipeline that it refers to.
