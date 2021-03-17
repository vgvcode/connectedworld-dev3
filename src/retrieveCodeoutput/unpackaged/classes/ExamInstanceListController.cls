public with sharing class ExamInstanceListController {
    // ApexPages.StandardSetController must be instantiated
    // for standard list controllers
    public ApexPages.StandardSetController setCon {
        get {
            String uName = UserInfo.getName();
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT id, descriptive_name__c, test_taker__r.name, start_time__c, 
                     time_taken__c, duration__c, fCorrect__c, fNetScore__c, fTtotal__c
                     FROM Exam_Instance__c WHERE test_taker__r.name = :uName ORDER BY createddate DESC]));
                this.sizeOfPage = 20;
                setCon.setPageSize(this.sizeOfPage);
            }
            return setCon;
        }
        set;
    }
    
    public List<Exam_Instance__c> getExamInstances() {
        return setCon.getRecords();
    }
    
    public Integer sizeOfPage { get; set; }
    
    public void next() {
        setcon.next();
    }
    
    public void previous() {
        setcon.previous();
    }

    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
    public Integer resultSize {
        get {
            return setCon.getResultSize();
        }
        set;
    }

    public Integer pageSize {
        get {
            return setCon.getPageSize();
        }
        set;
    }
    
    public void setSize() {
        setCon.setPageSize(this.sizeOfPage);
    }

    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }

    /*    
    public String localTime {
        get {
            //System.debug(ApexPages.currentPage().getParameters().get('utc_dt'));
            //Datetime dt = DateTime.parse(ApexPages.currentPage().getParameters().get('utc_dt'));
            //System.debug(dt);
            //return dt.format('MM/dd/yyyy hh:mm zz');  
            String d = ApexPages.currentPage().getParameters().get('utc_dt');
            return d;
            //return 'hello';         
        }
        set;
    }
    */
}