meta:
  id: avatar
  endian: le
seq:
  - id: magic
    contents: "AVTR"
  - id: username
    type: str
    size: 16
    encoding: UTF-8
  - id: age
    type: u4
