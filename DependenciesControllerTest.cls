@istest
public class DependenciesControllerTest {
    static testMethod void searchMetadataUp(){
        Test.setMock(HttpCalloutMock.class, new DependenciesSearchMock());
        Test.startTest();
        Pagereference testPage = Page.Dependencies;
        Test.setCurrentPagereference(testPage);
        ApexPages.currentPage().getParameters().put('componentid','classid');
        DependenciesController depSearch = new DependenciesController(); 
        depSearch.save(); 
        depSearch.searchItem();
        Test.stopTest();
    }

}