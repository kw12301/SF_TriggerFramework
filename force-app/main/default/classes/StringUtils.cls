/**
 * @author Kevin Winn
 * @date 04/11/2022
 * @group Utilities
 * @description Utilities for String manipulation
 */
public with sharing class StringUtils {
  /**
   * @description method to escape all known formats from a string
   * @param String the string input to escape all known formats
   * @return Type: String
   * @example StringUtils.secureString('"/<Hello>/"'');
   */
  public static String secureString(String stringInput) {
    String response = String.escapeSingleQuotes(stringInput);
    response.escapeHtml3();
    response.escapeHtml4();
    response.escapeJava();
    response.escapeUnicode();
    response.escapeXml();
    return response;
  }

  /**
   * @description method to escape csv
   * @param String the csv list
   * @return Type: String
   * @example StringUtils.escapeCSV('a,b,c');
   */
  public static String escapeCSV(String csv) {
    return csv.escapeCsv();
  }
}