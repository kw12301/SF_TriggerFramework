/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description Apex class to serialize/deserialize the Relationships object from an Addepar API
*/
public with sharing class Relationships {

    /**
    *@description The Arguments object for the relationships
     */
    public Arguments arguments { get; set; }
    
    public Relationships(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
		    if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'arguments') {
						this.arguments = new Arguments(parser);
					} else {
						ConsumeObject.destroy(parser);
					}
				}
			}
		}
    }
}
