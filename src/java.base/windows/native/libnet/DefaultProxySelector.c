 int defport = 80;
         int nr_elems = 24;
 
         /* Set the default port value & proxy type from protocol. */
         if ((wcscmp(lpProto, L"http") == 0) ||
-            (wcscmp(lpProto, L"ftp") == 0) ||
-            (wcscmp(lpProto, L"gopher") == 0))
+            (wcscmp(lpProto, L"ftp") == 0))
             defport = 80;
         if (wcscmp(lpProto, L"https") == 0)
             defport = 443;
         if (wcscmp(lpProto, L"socks") == 0) {
             defport = 6080;
