/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description Class to serialize/desrialize the Links object
*/
public with sharing class Links {
    
    /**
	 * @description the value of Self from the JSONParser
	 */
	public String self {get;set;} 

	/**
	 * @description the value of Related from the JSONParser
	 */
	public String related {get;set;} 

	/**
	 * @description Constructor to create an instance of Links from a JSONParser object
	 * @param JSONParser
	 */
	public Links(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'self') {
						this.self = parser.getText();
					}else if(text == 'related'){
						this.related = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'Links consuming unrecognized property: '+text);
						ConsumeObject.destroy(parser);
					}
				}
			}
		}
	}

	/**
	 * @description public static method to return in instance of Links
	 * @param JSONParser the JSONParser to construct the instance of Links from
	 * @return Type: Links
	 * @example Links.parseLinks(JSONParser);
	 */
    public static Links parseLinks(JSONParser parser){
        return new Links(parser);
    }
}