/**
* @author Addepar
* @date 2022
* @group Apex Objects
* @description Apex class to serialize/deserialize the Arguments object from an Addepar API
*/
public with sharing class Arguments {

    /**
    *@description the Links for the Argument
     */
    public Links links { get; set; }

    /**
    *@description the Data for the argument
     */
    public List<Data> dataList { get; set; }
    
    /**
    *@description constructor
    *@param JSONParser the System.JSONParser object containing the arguments
     */
    public Arguments(JSONParser parser) {
        while(parser.nextToken() != System.JSONToken.END_OBJECT){
            if(parser.getCurrentToken() == System.JSONToken.FIELD_NAME){
                String text = parser.getText();
                if(parser.nextToken() != System.JSONToken.VALUE_NULL){
                    if(text == 'links'){
                        this.links = new Links(parser);
                    } else if(text == 'data'){
                        this.dataList = Data.parseData(parser);
                    } else{
                        ConsumeObject.destroy(parser);
                    }
                }
            }
        }
    }

    /**
    *@description Static method to instantiate an instance of Arguments
    *@param JSONParser the System.JSONParser object containing the arguments
    *@return Type: Arguments
     */
    public static Arguments parseArguments(JSONParser parser){
        return new Arguments(parser);
    }
}
