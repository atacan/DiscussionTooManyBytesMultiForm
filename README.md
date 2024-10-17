# Multipart Form decoding Byte Limit

Run the curl command

```bash
curl -v http://127.0.0.1:8080/filepart \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/a/file" \
  -F parameter="something" \
  -F variable="anotherthing"
```

You'll get 

```console
Thread 2: Fatal error: 'try!' expression unexpectedly raised an error: 
NIOCore.NIOTooManyBytesError(maxBytes: Optional(997952))
```

if the file is largen than 997952 bytes.
