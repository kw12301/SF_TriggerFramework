/**
* @author Kevin Winn
* @date 12/31/2019
* @group Metadata Tooling
* @description contains methods to deploy Custom Metadata Records for package
*/
public with sharing class MetadataManager implements Metadata.DeployCallback {
    public Boolean isSuccess = false;
    public Boolean isCanceled = false;
    public Boolean isCanceling = false;
    public Boolean isFailed = false;
    public Boolean isInProgress = false;
    public Boolean isPending = false;
    public Boolean isPartialSuccess = false;
    public Id canceledBy;
    public String canceledByName;
    public Boolean isCheckOnly = false;
    public Boolean isDone = false;
    public String errorMessage;
    public String errorStatusCode;

    public MetadataManager() {}

    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if(result.status == Metadata.DeployStatus.Succeeded) {
            isSuccess = true;
            isDone = true;
        } else {
            isSuccess = false;
            if(result.status == Metadata.DeployStatus.Canceled) {
                isCanceled = true;
                canceledBy = result.canceledBy;
                canceledByName = result.canceledByName;
                isDone = true;
            } else if(result.status == MetaData.DeployStatus.Canceling) {
                isCanceling = true;
                canceledBy = result.canceledBy;
                canceledByName = result.canceledByName;
            } else if(result.status == Metadata.DeployStatus.Failed) {
                isFailed = true;
                isDone = true;
                errorMessage = result.errorMessage;
                errorStatusCode = String.valueOf(result.errorStatusCode);
            } else if(result.status == Metadata.DeployStatus.InProgress) {
                isInProgress = true;
            } else if(result.status == Metadata.DeployStatus.Pending) {
                isPending = true;
            } else if(result.status == MetaData.DeployStatus.SucceededPartial) {
                isPartialSuccess = true;
                isDone = true;
                errorMessage = result.errorMessage;
                errorStatusCode = String.valueOf(result.errorStatusCode);
            }
        }
    }
    /*

    public static Id createUserConnection(String userName,Boolean isTestData)
    {
        System.debug(LoggingLevel.INFO,'createUserConnection init');
        String jobId;
        MetaConnectionSetting settings = new MetaConnectionSetting();
        settings.prepareUpdateEmailAddress(UserInfo.getUserEmail());
        settings.prepareUpdateUsername(userName);
        settings.prepareUpdatePassword('PLACEHOLDER');
        MetadataHelper.prepareAsTestData(settings.FieldMap,isTestData);
        Metadata.DeployContainer container = MetadataHelper.getContainer();
        container.addMetadata(MetadataHelper.newMetadataInstance(settings.FieldMap));
        MetadataManager mgr = new MetadataManager();
        jobId = Metadata.Operations.enqueueDeployment(container,mgr);
        System.debug(LoggingLevel.INFO,'job Id: ' + jobId);
        return jobId;
    }

    public static Id createSObjectSetting(Map<String,Object> fieldMap,Boolean isTestData)
    {
        String jobId;
        MetaSObjectSetting settings = new MetaSObjectSetting();
        settings.FieldMap = fieldMap;
        MetadataHelper.prepareAsTestData(fieldMap,isTestData);
        MetadataHelper.prepareIsActiveSetting(fieldMap, true);
        Metadata.DeployContainer container = MetadataHelper.getContainer();
        container.addMetadata(MetadataHelper.newMetadataInstance(fieldMap));
        MetadataManager mgr = new MetadataManager();
        jobId = Metadata.Operations.enqueueDeployment(container,mgr);
        return jobId;
    }

    public static Id createSObjectFieldMappings(List<MetaSObjectFieldMapSetting> settings, Boolean isTestData)
    {
        String jobId;
        Metadata.DeployContainer container = MetadataHelper.getContainer();
        for(MetaSObjectFieldMapSetting fms : settings)
        {
            MetadataHelper.prepareAsTestData(fms.FieldMap,isTestData);
            container.addMetadata(MetadataHelper.newMetadataInstance(fms.fieldMap));
        }
        MetadataManager mgr = new MetadataManager();
        jobId = Metadata.Operations.enqueueDeployment(container,mgr);
        return jobId;
    }

    public static Id updateUsername(String userName)
    {
        String jobId;
        MetaConnectionSetting settings = new MetaConnectionSetting();
        settings.prepareUpdateUsername(userName);
        Metadata.DeployContainer container = MetadataHelper.getContainer();
        container.addMetadata(MetadataHelper.newMetadataInstance(settings.FieldMap));
        MetadataManager mgr = new MetadataManager();
        jobId = Metadata.Operations.enqueueDeployment(container,mgr);
        return jobId;
    }

    public static Id updateEmail(String email)
    {
        String jobId;
        MetaConnectionSetting settings = new MetaConnectionSetting();
        settings.prepareUpdateEmailAddress(email);
        Metadata.DeployContainer container = MetadataHelper.getContainer();
        container.addMetadata(MetadataHelper.newMetadataInstance(settings.FieldMap));
        MetadataManager mgr = new MetadataManager();
        jobId = Metadata.Operations.enqueueDeployment(container,mgr);
        return jobId;
    }

    public static Id updateToken(String token)
    {
        String jobId;
        MetaConnectionSetting settings = new MetaConnectionSetting();
        settings.prepareUpdateToken(token);
        Metadata.DeployContainer container = MetadataHelper.getContainer();
        container.addMetadata(MetadataHelper.newMetadataInstance(settings.FieldMap));
        MetadataManager mgr = new MetadataManager();
        jobId = Metadata.Operations.enqueueDeployment(container,mgr);
        return jobId;
    }
    */
}