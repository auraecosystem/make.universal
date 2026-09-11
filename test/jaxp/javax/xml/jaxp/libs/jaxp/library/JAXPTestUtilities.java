      */
     protected static boolean isCommonURL(String s) {
         if (null == s)
             return false;
-        return Pattern.compile("^(file:|http:|ftp:|gopher:|mailto:|news:|telnet:)")
+        return Pattern.compile("^(file:|http:|ftp:|mailto:|news:|telnet:)")
                 .matcher(s).matches();
     }
 
     /**
      * Utility method to translate a String filename to URL().
<
