/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description An ApexObject representing the Next object in the response body from an endpoint.
*       Contains a boolean identifier indicating if the next link is populated
*/
public with sharing class NextLink {
    
    /**
     * @Description an Object representation of the Next object in the JSON:API body
     */
    public Object nextObject { get; set; }
    /**
     * @Description boolean identifier indicating if the next link is populated
     */
    public Boolean exists { get; set; }
    /**
     * @Description the string value of the next link if it exists, otherwise an empty string.
     */
    public String value { get; set; }
    /**
     * @Description Constructor for the NextLink object
     * @param JSONParser the parser to consume
     */
    public NextLink(JSONParser parser){
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if(parser.getCurrentToken() == System.JSONToken.FIELD_NAME){
                String text = parser.getText();
                if(parser.nextToken() != System.JSONToken.VALUE_NULL){
                    if(text == 'next'){
                            this.nextObject = parser.readValueAs(Object.class);
                            getValue(this.nextObject);    
                    } else{
                        ConsumeObject.destroy(parser);
                    }
                }
            }
        }
    }

    /**
     * @Description private method to get the String value of the Next link and set boolean flag
     * @param Object the next object from the parser
     */
    private String getValue(Object nextObject){
        String val = '';
        if(null == String.valueOf(nextObject) || String.valueOf(nextObject).length() < 1){
            this.exists = false;
            this.value = val;
        }else{
            this.exists = true;
            val = String.valueOf(nextObject);
        }
        return val;
    }

    /**
     * @Description public static method to return an instance of this class
     * @param JSONParser the System.JSONParser object
     * @return Type:  NextLink
     */
    public static NextLink parseNextLink(JSONParser parser){
        return new NextLink(parser);
    }
}