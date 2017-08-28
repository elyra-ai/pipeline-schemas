## The WDP Common Pipeline Connection Specification

Pipeline connections can comprise of either a reference to an existing connection asset stored in the catalog, or a reference to a dataset in the catalog. The following examples show how these different pipeline connections can be specified.

### Reference to connection asset (relational database)
In example [pipeline-connection-v1-schema_example1_connection.json](./pipeline-connection-v1-schema_example1_connection.json) the connection asset being referenced contains the definition for a relational database (ie host, user name, password etc). This would be have previously created and stored using the WDP connections service. The properties defined in this example define the specific schema and table to use.

### Reference to connection asset (flat file)
In example [pipeline-connection-v1-schema_example2_connection.json](./pipeline-connection-v1-schema_example2_connection.json) the connection asset being referenced contains the definition for an object storage system such as IBM Cloud Object Storage or Amazon S3. This would be have previously created and stored using the WDP connections service. The properties defined in this example define the specific file name and it's format to use.

### Reference to dataset contained in a project or catalog
In example [pipeline-connection-v1-schema_example1_data_asset.json](./pipeline-connection-v1-schema_example1_data_asset.json) the dataset being referenced is contained in a WDP project. This would be have previously created using other WDP services. Note that the attachment_ref here has also been set since a dataset may have more than one attachments, and it is the attachment which is read or written to.

### Reference to dataset contained in a project or catalog
In example [pipeline-connection-v1-schema_example2_data_asset.json](./pipeline-connection-v1-schema_example2_data_asset.json) the dataset being referenced is contained in the same WDP catalog or project as that which contains the pipeline. At runtime the dataset ID is found by searching for a dataset with the given name.