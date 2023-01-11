public class DependenciesController {
    
    public String componentid { get;set; }
    public String componentidRef { get;set; }
    public String ComponentName { get;set; }
    public String dependenciesString { get;set; }
    public String metadataComponentURL { get;set; }
    public List<records> recordsList1 { get;  set; }
    public List<records> recordsList2 { get;  set; }
    public List<String> sObjectsList {get; set;}
    
    public DependenciesController() {
        recordsList1 = new List<records>();
        recordsList2 = new List<records>();
        List<Schema.SObjectType> sObjTypeList = new List<Schema.SObjectType>();
        Map<String, Schema.SObjectType> objMap = Schema.getGlobalDescribe();
    }
    
    public PageReference save() {
        String outputMember = componentid;
        
        recordsList1.clear();
        recordsList2.clear();
        //////////////////////// for with ids
        Map<String,String> typeMap = new Map<String,String>();
        typeMap.put('01p','ApexClass');
        typeMap.put('00N','CustomField');
        typeMap.put('066','VisualForcePage');
        typeMap.put('00X','EmailTemplate');
        typeMap.put('01I','CustomObject');
        typeMap.put('101','ExternalString - Custom Label');
        typeMap.put('099','ApexComponent');	 
        typeMap.put('00h','PageLayout');	
        typeMap.put('01q','ApexTrigger'); 
        List<String> stringClassList = new List<String>();

        if(componentid != ''){
            ComponentName = null;
            metadataComponentURL = URL.getOrgDomainUrl().toExternalForm()+ '/'+componentid;
        }
        stringClassList.add(ComponentName);
        //idList.add('UnqualifyLead');
        List<String> idList = new List<String>();
        idList.add(outputMember);

        List<String> idsList = new  List<String>();
        List<ApexClass> classesList = new List<ApexClass>([Select id,Name From ApexClass Where Name IN :stringClassList limit 100]);
        List<ApexComponent> componentsList = new List<ApexComponent>([Select id,Name From ApexComponent Where Name IN :stringClassList limit 100]);
        List<ApexPage> apexPageList = new List<ApexPage>([Select id,Name From ApexPage   Where Name IN :stringClassList limit 100]);
        
        for(String clr:idList){
            idsList.add(clr);
        }
        for(ApexClass clr:classesList){
            idsList.add(clr.id);
        }
        for(ApexComponent clr:componentsList){
            idsList.add(clr.id);
        }
        for(ApexPage clr:apexPageList){ 
            idsList.add(clr.id);
        }
        
        for(String strid:idsList){
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+ '/services/data/v55.0/tooling/query/?q=Select+MetadataComponentId,MetadataComponentName,RefMetadataComponentName,RefMetadataComponentId+from+MetadataComponentDependency+where+RefMetadataComponentId=\''+strid+'\'');
            system.debug(UserInfo.getSessionID());
            req.setMethod('GET');
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug(res.getBody());
            JSONResponse result = (JSONResponse) JSON.deserialize(res.getBody(), JSONResponse.class);
            for(records rec:result.records){
                componentid = rec.RefMetadataComponentId;
                ComponentName = rec.RefMetadataComponentName;
                system.debug(rec.MetadataComponentId+','+rec.MetadataComponentName);
                rec.RefMetadataComponentNameType = typeMap.get(rec.MetadataComponentId.left(3));
                rec.RefMetadataComponentURL = URL.getOrgDomainUrl().toExternalForm()+ '/'+rec.MetadataComponentId;
                rec.RefMetadataComponentNameDependency = 'Up';
                recordsList1.add(rec);
                metadataComponentURL = URL.getOrgDomainUrl().toExternalForm()+ '/'+componentid;
            }
            
        }
        
        for(String strid:idsList){
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+ '/services/data/v55.0/tooling/query/?q=Select+MetadataComponentId,MetadataComponentName,RefMetadataComponentName,RefMetadataComponentId+from+MetadataComponentDependency+where+MetadataComponentId=\''+strid+'\'');
            system.debug(UserInfo.getSessionID());
            req.setMethod('GET');
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug(res.getBody());
            JSONResponse result = (JSONResponse) JSON.deserialize(res.getBody(), JSONResponse.class);
            for(records rec:result.records){
                if(rec.RefMetadataComponentId.length()==18){
                    componentid = rec.MetadataComponentId;
                    ComponentName = rec.MetadataComponentName;
                    rec.RefMetadataComponentNameType = typeMap.get(rec.RefMetadataComponentId.left(3));
                    system.debug(rec.RefMetadataComponentId+','+rec.RefMetadataComponentName);
                    rec.RefMetadataComponentNameDependency = 'Down';
                    rec.MetadataComponentId = rec.RefMetadataComponentId;
                    rec.MetadataComponentName = rec.RefMetadataComponentName;
                    rec.RefMetadataComponentURL = URL.getOrgDomainUrl().toExternalForm()+ '/'+rec.RefMetadataComponentId;
                    recordsList1.add(rec);
                    metadataComponentURL = URL.getOrgDomainUrl().toExternalForm()+ '/'+componentid;
                }
                
                
            }
            
        }
        return null;
    }
    public PageReference searchItem() {
        //componentid = String.valueOf(apexpages.currentpage().getparameters().get('componentidRef'));
        componentid = componentidRef;
        system.debug(componentid);
        system.debug(componentidRef);
        System.debug('componentidRef :'+ this.componentidRef);
        save();
        return null;
    }
    public class JSONResponse {
        public List<records> records;
    }
    public class records {
        public String MetadataComponentId { get;set; }
        public String MetadataComponentName { get;set; }
        public String RefMetadataComponentId { get;set; }
        public String RefMetadataComponentName { get;set; }
        public String RefMetadataComponentNameType { get;set; }
        public String RefMetadataComponentNameDependency { get;set; }
        public String RefMetadataComponentURL { get;set; }
    }
}