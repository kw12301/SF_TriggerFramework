/**
* @author Addepar
* @date 2022
* @group Parsers
* @description Class to parse GET response from /v1/entity_types
* 
*/
public with sharing class ParseEntityTypes {
    /**
     * @Description Contains the deserialized array of Data objects in JSON body.  See Data.cls
     */
    public List<Data> dataList { get; set; }
    /**
     * @Description Contains the deserialized Next link object.  See NextLink.cls
     */
    public Links nextLink { get; set; } 
    
    /**
     * @Description Constructor to parse the Entity Types response body
     * @param JSONParser the System.JSONParser object
     */
    public ParseEntityTypes(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						this.dataList = Data.parseData(parser);
					} else if (text == 'included') {
						ConsumeObject.destroy(parser);
					} else if (text == 'links') {
						this.nextLink = new Links(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'EntityTypesParser consuming unrecognized property: '+text);
						ConsumeObject.destroy(parser);
					}
				}
			}
        }
    }
    /**
     * @Description static method to return an instance of ParseEntityTypes
     * @param String the JSON response from Addepar
     * @return Type:  ParseEntityTypes
     * @example ParseEntityTypes.parse(jsonResponseFromAddepar);
     */
    public static ParseEntityTypes parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ParseEntityTypes(parser);
	}
}