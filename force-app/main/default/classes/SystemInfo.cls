/**
* @author Kevin Winn
* @date 12/31/2019
* @group Framework
* @description contains helper methods to identify system state, org information, and limit usage rates
*/
public with sharing class SystemInfo {
        
    /**
    * @description method to identify is system is running async processes            
    * @return Type: Boolean
    */
    public static Boolean isAsync() {
        if(System.isBatch() || System.isFuture() || System.isScheduled()) {
            return true;
        }
        return false;
    }

    /**
    * @description method to identify is system is in ready only mode.  
                    Callouts should not be made if true            
    * @return Type: Boolean
    */
    public static Boolean isReadOnly() {
        ApplicationReadWriteMode mode = System.getApplicationReadWriteMode();
        if(mode == ApplicationReadWriteMode.READ_ONLY) {
            return true;
        }
        return false;
    }

    /**
    * @description method to identify is person account is enabled for org             
    * @return Type: Boolean
    */
    public static Boolean isPersonAccountEnabled() {
        return Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount');
    }

    /**
    * @description method to percent usage of aggregate queries             
    * @return Type: Decimal
    */
    public static Decimal useOfAggregateQueries() {
        return Decimal.valueOf((Double)Limits.getAggregateQueries()/Limits.getLimitAggregateQueries());
    }

    /**
    * @description method to percent usage of callouts         
    * @return Type: Decimal
    */
    public static Decimal useOfCallouts(){
        return Decimal.valueOf((Double)Limits.getCallouts()/Limits.getLimitCallouts());
    }

    /**
    * @description method to percent usage of DML rows         
    * @return Type: Decimal
    */
    public static Decimal useOfDmlRows(){
        return Decimal.valueOf((Double)Limits.getDMLRows()/Limits.getLimitDMLRows());
    }

    /**
    * @description method to percent usage of DML statements         
    * @return Type: Decimal
    */
    public static Decimal useOfDmlStatements() {
        return Decimal.valueOf((Double)Limits.getDMLStatements()/Limits.getLimitDMLStatements());
    }

    /**
    * @description method to percent usage of queries         
    * @return Type: Decimal
    */
    public static Decimal useOfQueries() {
        return Decimal.valueOf((Double)Limits.getQueries()/Limits.getLimitQueries());
    }

    /**
    * @description method to percent usage of query rows         
    * @return Type: Decimal
    */
    public static Decimal useOfQueryRows() {
        return Decimal.valueOf((Double)Limits.getQueryRows()/Limits.getLimitQueryRows());
    }

    /**
    * @description method to percent usage of query locator rows         
    * @return Type: Decimal
    */
    public static Decimal useOfQueryLocatorRows() {
        return Decimal.valueOf((Double)Limits.getQueryLocatorRows()/Limits.getLimitQueryLocatorRows());
    }

    /**
    * @description method to percent usage of save points         
    * @return Type: Decimal
    */
    public static Decimal useOfSavepoints() {
        return Decimal.valueOf((Double)Limits.getSavepoints()/Limits.getLimitSavepoints());
    }

    /**
    * @description method to percent usage of CPU time         
    * @return Type: Decimal
    */
    public static Decimal useOfCpuTime() {
        return Decimal.valueOf((Double)Limits.getCpuTime()/Limits.getLimitCpuTime());
    }

    /**
    * @description method to percent usage of email invocations         
    * @return Type: Decimal
    */
    public static Decimal useOfEmailInvocations() {
        return Decimal.valueOf((Double)Limits.getEmailInvocations()/Limits.getLimitEmailInvocations());
    }
}