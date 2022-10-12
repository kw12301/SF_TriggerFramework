/**
* @author Addepar
* @date 2022
* @group Parsers
* @description Apex class to handle the response from https://developers.addepar.com/reference#getallarguments
* 
*/
public with sharing class ParseAllArguments {

  /**
  *@description The list of Data from the response
  */
  public List<Data> dataList { get; set; }

  /**
  *@description The Next Link if the response is paged
  */
  public Links nextLink { get; set; }

  /**
  *@description Constructor
  *@param JSONParser the System.JSONParser object containing all arguments
   */
  public ParseAllArguments(JSONParser parser) {
    System.debug(LoggingLevel.INFO,'CPU begin parse args response ' + Limits.getCpuTime());
    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						dataList = Data.parseData(parser);
					} else if (text == 'included') {
						ConsumeObject.destroy(parser);
					} else if (text == 'links') {
						nextLink = new Links(parser);
					} else {
						ConsumeObject.destroy(parser);
					}
				}
			}
		}
    System.debug(LoggingLevel.INFO,'CPU end parse args response ' + Limits.getCpuTime());
  }

  /**
  * @Description static method to return an instance of ParseAllArguments
  * @param String the JSON response from Addepar
  * @return Type:  ParseAllArguments
  * @example ParseAllArguments.parse(jsonResponseFromAddepar);
  */
  public static ParseAllArguments parse(String json) {
	  System.JSONParser parser = System.JSON.createParser(json);
		return new ParseAllArguments(parser);
	}
}