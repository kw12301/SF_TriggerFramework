/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description An Apex class to serialize and deserialize the EntityTypes JSON:API  
*/
public with sharing class EntityType {

    /**
     * @description The Id for the entity type
     */
    public String id { get; set; }

    /**
     * @description The type for this entity type
     */
    public String type { get; set; }

    /**
     * @description The Attributes for this entity type.  See Attributes.cls
     */
    public Attributes attributes { get; set; }

    /**
     * @description The links for the entity type.  See Links.cls
     */
    public Links links { get; set; }
    
    /**
     * @description Constructor for class
     * @param JSONParser the JSONParser to construct an instance of EntityType from
     */
    public EntityType(JSONParser parser) {
        while (parser.nextToken() != System.JSONTOken.END_OBJECT){
            if(parser.getCurrentToken() == System.JSONToken.FIELD_NAME){
                String text = parser.getText();
                if(parser.nextToken() != System.JSONToken.VALUE_NULL){
                    if(text == 'id'){
                        this.id = parser.getText();
                    } else if(text == 'type'){
                        this.type = parser.getText();
                    } else if(text == 'attributes'){
                        this.attributes = new Attributes(parser);
                    } else if(text == 'links'){
                        this.links = new Links(parser);
                    } else{
                        ConsumeObject.destroy(parser);
                    }
                }
            }
        }
    }

    /**
     * @description public static method to construct a list of Entity Types
     * @param JSONParser the JSONParser to construct a list of EntityType from
     * @return Type: List<EntityType>
     * @example EntityTypes.parseEntityTypes(JSONParser);
     */
    public static List<EntityType> parseEntityTypes(JSONParser parser){
        List<EntityType> results = new List<EntityType>();
        if(parser.getCurrentToken() == null){
            parser.nextToken();
        }
        while (parser.nextToken() != System.JSONToken.END_ARRAY){
            results.add(new EntityType(parser));
        }
        return results;
    }
}