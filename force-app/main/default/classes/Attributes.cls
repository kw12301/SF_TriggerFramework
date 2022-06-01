/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description Apex class to Serialize/Deserialize attributes for an Addepar API  
*/
public with sharing class Attributes {

    /**
     * @description A list of Entity_Attributes
     */
    public List<EntityAttribute> entityAttributes { get; set; }

    /**
     * @description The ownership type for the attribute
     */
    public String ownershipType { get; set; }

    /**
     * @description The category for the attribute
     */
    public String category { get; set; }

    /**
     * @description The display name for the attribute
     */
    public String displayName { get; set; }

    /**
     * @description The output type for the attribute
     */
    public String outputType { get; set; }

    /**
     * @description The usage for the attribute
     */
    public List<String> usage { get; set; }
    
    /**
     * @description Constructor for class
     * @param JSONParser the json parser object to construct an instance of Attributes from
     */
    public Attributes(JSONParser parser){
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if(parser.getCurrentToken() == System.JSONToken.FIELD_NAME){
                String text = parser.getText();
                if(parser.nextToken() != System.JSONToken.VALUE_NULL){
                    if(text == 'entity_attributes'){
                        this.entityAttributes = EntityAttribute.parseEntityAttributes(parser);
                    } else if(text == 'ownership_type'){
                        this.ownershipType = parser.getText();
                    } else if(text == 'category'){
                        this.category = parser.getText();
                    } else if(text == 'display_name'){
                        this.displayName = parser.getText();
                    } else if(text == 'output_type'){
                        this.outputType = parser.getText();
                    } else if(text == 'usage'){
                        this.usage = usageList(parser);
                    } else{
                        ConsumeObject.destroy(parser);
                    }
                }
            }
        }
    }

    /**
    *@description static helper method to create a list of usage strings for an attribute
    *@param JSONParser
    *@return Type: List<String>
     */
    private static List<String> usageList(JSONParser parser){
        List<String> results = new List<String>();
        if(parser.getCurrentToken() == null){
            parser.nextToken();
        }
        while(parser.nextToken() != System.JSONToken.END_ARRAY){
            results.add(parser.getText());
        }
        return results;
    }
}