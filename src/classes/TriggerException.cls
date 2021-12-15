/**
 *@author Kevin Winn
 *@date 12/31/2019
 *@group Trigger Framework
 *@description custom exception class for error logging
**/
public class TriggerException extends Exception{

	public class CustomExceptionTest{
		String message { get; set; }
		public CustomExceptionTest(String message){
			this.message = message;
		}
	}
}