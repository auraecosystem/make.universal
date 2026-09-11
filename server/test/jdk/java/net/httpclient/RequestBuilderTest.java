assertThrows(ISE, () -> newBuilder().build());
         List<URI> uris = List.of(
                 URI.create("ws://foo.com"),
                 URI.create("wss://foo.com"),
                 URI.create("ftp://foo.com"),
-                URI.create("gopher://foo.com"),
                 URI.create("mailto:a@b.com"),
                 URI.create("scheme:example.com"),
                 URI.create("scheme:example.com"),
                 URI.create("scheme:example.com/path"),
                 URI.create("path"),
