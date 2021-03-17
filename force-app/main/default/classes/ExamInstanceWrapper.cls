global class ExamInstanceWrapper implements Comparable {
        public Exam_Instance__c ei;
        // Constructor
        public ExamInstanceWrapper(Exam_Instance__c e) {
            ei = e;
        }
        // Compare opportunities based on the opportunity amount.
        global Integer compareTo(Object compareTo) {
            // Cast argument to OpportunityWrapper
            ExamInstanceWrapper compareToExam = (ExamInstanceWrapper)compareTo;
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            System.debug('Left:' + ei.start_time__c);
            System.debug('Right:' + compareToExam.ei.start_time__c);
            if (ei.start_time__c > compareToExam.ei.start_time__c) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (ei.start_time__c < compareToExam.ei.start_time__c) {
                // Set return value to a negative value.
                returnValue = -1;
            }           
            System.debug('Return value:' + returnValue);
            return returnValue;      
        }

        public String getName() { return this.ei.Descriptive_Name__c; }
        public String getTestTaker() { return this.ei.Test_Taker__r.name; }
        public DateTime getStartTime() { return this.ei.start_time__c; }
        public Decimal getTimeTaken() { return this.ei.time_taken__c; }
        public Decimal getDuration() { return this.ei.Duration__c; }
        public Decimal getRawScore() { return this.ei.fCorrect__c; }
        public Decimal getNetScore() { return this.ei.fNetScore__c; }
        public Decimal getTotal() { return this.ei.fTtotal__c; } 
}