@isTest
global class DependenciesSearchMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        
        HttpResponse response = new HttpResponse();
        
        response.setHeader('Accept', 'application/json');
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"size":3,"totalSize":3,"done":true,"queryLocator":null,"entityTypeName":"MetadataComponentDependency","records":[{"attributes":{"type":"MetadataComponentDependency","url":"/services/data/v55.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA"},"MetadataComponentId":"01p3h00000FXJOPAA5","MetadataComponentName":"DependenciesController","RefMetadataComponentName":"ApexClass","RefMetadataComponentId":"01p3h00000FXJOPAA5"},{"attributes":{"type":"MetadataComponentDependency","url":"/services/data/v55.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA"},"MetadataComponentId":"01p3h00000FXJOPAA5","MetadataComponentName":"DependenciesController","RefMetadataComponentName":"ApexComponent","RefMetadataComponentId":"ApexComponent"},{"attributes":{"type":"MetadataComponentDependency","url":"/services/data/v55.0/tooling/sobjects/MetadataComponentDependency/000000000000000AAA"},"MetadataComponentId":"01p3h00000FXJOPAA5","MetadataComponentName":"DependenciesController","RefMetadataComponentName":"ApexPage","RefMetadataComponentId":"ApexPage"}]}');
        response.setStatusCode(200);
        return response; 
    }
}