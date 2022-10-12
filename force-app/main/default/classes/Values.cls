/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description Apex class to serialize/deserialize the Values object from an Addepar API 
*/
public with sharing class Values {
	/**
	*@description identifies this value as a boolean
	 */
	public Boolean isBoolean { get; set; }
    
    /**
    *@description the string value for this value
     */
    public String value {get;set;} 

	/**
	@description String list of values
	 */
	public List<String> valueStrings { public get; private set; }

	/**
	@description Boolean list of values
	 */
	public List<Boolean> valueBooleans { public get; private set; }

    /**
    *@description the display name for this value
     */
	public String displayName {get;set;} 

	public Values(JSONParser parser) {
		while(parser.nextTOken() != System.JSONTOken.END_OBJECT){
			if(parser.getCurrentToken() == SYstem.JSONToken.FIELD_NAME){
				String text = parser.getText();
				if(!expectedNames().contains(text)){
					ConsumeObject.destroy(parser);
				} else{
					System.debug(LoggingLevel.INFO,'Field Name ' + text);
					if(parser.nextToken() != System.JSONToken.VALUE_NULL){
						if(text == 'value'){
							isBoolean = false;
							value = parser.getText();
						} else if(text == 'display_name'){
							displayName = parser.getText();
							isBoolean = false;
						}else{
							ConsumeObject.destroy(parser);
						}
					}
				}
			}
		}
	}

	private Set<String> expectedNames(){
		Set<String> results = new Set<String>();
		results.add('value');
		//results.add('values');
		results.add('display_name');
		return results;
	}

	private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

	private static List<Boolean> arrayOfBoolean(System.JSONParser p) {
        List<Boolean> res = new List<Boolean>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getBooleanValue());
        }
        return res;
    }

	public static List<Values> parseValues(JSONParser parser){
		System.debug(LoggingLevel.INFO,'CPU begin parsing values ' + Limits.getCpuTime());
		List<Values> results = new List<Values>();
		if (parser.getCurrentToken() == null) {
			parser.nextToken();
		}
        while (parser.nextToken() != System.JSONToken.END_ARRAY) {
			results.add(new Values(parser));			
        }
		System.debug(LoggingLevel.INFO,'CPU end parsing values ' + Limits.getCpuTime());
		return results;
	}
}