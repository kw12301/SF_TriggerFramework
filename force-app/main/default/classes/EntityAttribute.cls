/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description Apex class to serialize/deserialize the EntityAttribute object
*/
public with sharing class EntityAttribute {

    /**
     * @description The key for the entity attribute
     */
    public String key { get; set; }

    /**
     * @description Identifies if the attribute is required on the entity
     */
    public Boolean required { get; set; }

    /**
     * @description The CRUD rights for the attribute on the entity
     */
    public String writability { get; set; }

    /**
     * @description The constructor for this class.
     * @param JSONParser the json parser to construct in instance of Entity Attribute from
     */
    public EntityAttribute(JSONParser parser){
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if(parser.getCurrentToken() == System.JSONToken.FIELD_NAME){
                String text = parser.getText();
                if(parser.nextToken() != System.JSONToken.VALUE_NULL){
                    if(text == 'key'){
                        this.key = parser.getText();
                    } else if(text == 'required'){
                        this.required = parser.getBooleanValue();
                    } else if(text == 'writability'){
                        this.writability = parser.getText();
                    } else{
                        ConsumeObject.destroy(parser);
                    }
                }
            }
        }
    }

    /**
     * @description public static method to create a list of Entity Attributes
     * @param JSONParser the JSON Parser object to parse the list from
     * @return Type: List<EntityAttribute>
     * @example EntityAttribute.parseEntityAttributes(JSONParser);
     */
    public static List<EntityAttribute> parseEntityAttributes(JSONParser parser){
        List<EntityAttribute> results = new List<EntityAttribute>();
        if (parser.getCurrentToken() == null){
            parser.nextToken();
        } 
        while (parser.nextToken() != System.JSONToken.END_ARRAY) {
            results.add(new EntityAttribute(parser));
        }
        return results;
    }
}