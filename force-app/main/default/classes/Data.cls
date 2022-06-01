/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description Apex Class to serialize/deserialize the Data object
*/
public with sharing class Data {
    
    /**
	 * @description:  The Id for this data element
	 */
	public String id {get;set;} 

	/**
	 * @description:  The Type for this data element
	 */
	public String type {get;set;} 

	/**
	 * @description:  The Attributes for this data element.  See Attributes.cls
	 */
	public Attributes attributes {get;set;} 

	/**
	 * @description:  The Relationships for this data element.  See Relationships.cls
	 */
	public Relationships relationships {get;set;} 

	/**
	 * @description:  The Links for this data element.  See Links.cls
	 */
	public Links links {get;set;} 

	/**
	 * @description  Constructor for the Data.cls
	 * @param JSONParser the parser to use to create an instance of this class
	 */
	public Data(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'id') {
						this.id = parser.getText();
					} else if (text == 'type') {
						this.type = parser.getText();
					} else if (text == 'attributes') {
						this.attributes = new Attributes(parser);
					} else if (text == 'relationships') {
						this.relationships = new Relationships(parser);
					} else if (text == 'links') {
						this.links = new Links(parser);
					} else {
						ConsumeObject.destroy(parser);
					}
				}
			}
		}
	}

	/**
	 * @Description public static method to return a list of Data objects
	 * @param System.JSONParser the JSONParser object to consume
	 * @return Type:  List<Data>
	 * @example Data.parseData(System.JSONParser);
	 */
    public static List<Data> parseData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null){
            p.nextToken();
        } 
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
        res.add(new Data(p));
        }
        return res;
    }
}