public with sharing class StringUtils {
  public static String secureString(String stringInput) {
    String response = String.escapeSingleQuotes(stringInput);
    response.escapeHtml3();
    response.escapeHtml4();
    response.escapeJava();
    response.escapeUnicode();
    response.escapeXml();
    return response;
  }

  public static String escapeCSV(String csv) {
    return csv.escapeCsv();
  }
}
