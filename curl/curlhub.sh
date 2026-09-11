$ curl curlhub.sh

  curlhub.sh — developer tools you curl
  ──────────────────────────────────────
  generate   uuid  pass  hash  b64  json  jwt  qr  md
  inspect    ssl  whois  cidr  cron  status  headers  ua  ip
  ephemeral  p  u  hook            (https only)
  docs       man  help  spec

  # try one
  curl curlhub.sh/uuid
  # or pipe data in
  cat cert.pem | curl --data-binary @- curlhub.sh/ssl

  no accounts · no tracking cookies · Tuxxin LLC
