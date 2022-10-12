/**
* @author Addepar
* @date 2022
* @group Parsers
* @description Class to parse GET response from /v1/attributes
* 
*/
public with sharing class ParseAllAttributes {
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
    public ParseAllAttributes(JSONParser parser) {
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
						ConsumeObject.destroy(parser);
					}
				}
			}
        }
    }

    /**
     * @Description static method to return an instance of ParseAllAttributes
     * @param String the JSON response from Addepar
     * @return Type:  ParseAllAttributes
     * @example ParseAllAttributes.parse(jsonResponseFromAddepar);
     */
    public static ParseAllAttributes parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ParseAllAttributes(parser);
	}
}