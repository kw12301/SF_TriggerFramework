/**
* @author Addepar
* @date 2022
* @group Logging
* @description Helper methods for DocumentWriter.cls
*/
public with sharing class DocumentHelper {
    
    /**
     * @description method to determine the file extension for the path on client.
     *              defaults to .txt for all unhandled extensions.  See DocumentWriter.FileType for supported types.
     * @param String the desired file type to create.   
     * @return Type: String 
     * @example DocumentHelper.setExtension(DocumentWriter.FileType.PDF);
     */
    public static String getExtension(DocumentWriter.FileType fileType){
        String ftName = '';
        String extension = '';
        try{
            ftName = fileType.name();
            ftName = ftName.toLowerCase();
        }catch(Exception ex){
            LoggingHandler.debugException(ex, StaticResources.SALESFORCE_EXCEPTION, 'FileType');
            LoggingHandler.popAll();
        }finally{
            if(ftName == ''){
                return '.txt';
            }else if(ftName == 'csv' || ftName == 'pdf' || ftName == 'png' || ftName == 'zip'){
                extension = '.' + ftName;
            } else if(ftName == 'excel'){
                extension = '.xlsx';
            } else if(ftName == 'text'){
                extension = '.txt';
            } else if(ftName == 'word'){
                extension = '.docx';
            }  
        }
        return extension;
    }

    /**
     * @description method to determine the file extension for the path on client.
     *              defaults to .txt for all unhandled extensions.  See DocumentWriter.FileType for supported types.
     * @param Long the long value of the file size to check   
     * @return Type: Boolean 
     * @example DocumentHelper.fileSizeCheck(2048);
     */
    public static boolean fileSizeCheck(Long size){
        if(size < 1024){
            System.debug(LoggingLevel.INFO,'File Size: ' + String.valueOf(size) + ' Bytes');
            return true;
        } else if(size >= 1024 && size < (1024*1024)){
            Decimal kb = Decimal.valueOf(size);
            kb = kb.divide(1024,2);
            System.debug(LoggingLevel.INFO,'File Size: ' + String.valueOf(kb) + ' KB');
            return true;
        } else if(size >= (1024*1024) && size < (1024*1024*1024)){
            Decimal mb = Decimal.valueOf(size);
            mb = mb.divide((1024*1024),2);
            System.debug(LoggingLevel.INFO,'File Size: ' + String.valueOf(mb) + ' MB');
            return mb >= 5 ? false : true;
        } else{
            Decimal gb = Decimal.valueOf(size);
            gb = gb.divide((1024*1024*1024),2);
            System.debug(LoggingLevel.INFO,'File Size: ' + String.valueOf(gb) + ' GB');
            return false;
        }   
    }
}