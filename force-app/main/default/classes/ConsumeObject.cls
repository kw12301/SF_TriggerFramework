/**
* @author Addepar
* @date 2022
* @group Parsers
* @description Class to handle unknown properties in parsers
*/
public with sharing class ConsumeObject {

    /**
     * @description executes the consumption of unknown properties from JSONParser object
     * @param JSONParser the parser with the unknown properties
     */
    public static void destroy(JSONParser parser){
        Integer depth = 0;
        do{
            System.JSONToken curr = parser.getCurrentToken();
            if(curr == System.JSONToken.START_OBJECT || curr == System.JSONToken.START_ARRAY){
                depth++;
            } else if(curr == System.JSONToken.END_OBJECT || curr == System.JSONToken.END_ARRAY){
                depth--;
            }
        } while(depth > 0 && parser.nextToken() != null);
    }
}