const { handler } = require('./index'); 

const event = {
    "Records": [
        {
            "cf": {
                "config": {
                    "distributionDomainName": "d1g979fqjgk8jl.cloudfront.net",
                    "distributionId": "E1X78RJSEZVAB2",
                    "eventType": "viewer-request",
                    "requestId": "UUoxKcF2lcVEiEvpLAL1cyrYWNgLf7N-1ElysX2S4g671Ez-eZEL8w=="
                },
                "request": {
                    "body": {
                        "action": "read-only",
                        "data": "eyJvYmplY3QiOiJ3aGF0c2FwcF9idXNpbmVzc19hY2NvdW50IiwiZW50cnkiOlt7ImlkIjoiMCIsImNoYW5nZXMiOlt7ImZpZWxkIjoibWVzc2FnZXMiLCJ2YWx1ZSI6eyJtZXNzYWdpbmdfcHJvZHVjdCI6IndoYXRzYXBwIiwibWV0YWRhdGEiOnsiZGlzcGxheV9waG9uZV9udW1iZXIiOiIxNjUwNTU1MTExMSIsInBob25lX251bWJlcl9pZCI6IjEyMzQ1NjEyMyJ9LCJjb250YWN0cyI6W3sicHJvZmlsZSI6eyJuYW1lIjoidGVzdCB1c2VyIG5hbWUifSwid2FfaWQiOiIxNjMxNTU1MTE4MSJ9XSwibWVzc2FnZXMiOlt7ImZyb20iOiIxNjMxNTU1MTE4MSIsImlkIjoiQUJHR0ZsQTVGcGEiLCJ0aW1lc3RhbXAiOiIxNTA0OTAyOTg4IiwidHlwZSI6InRleHQiLCJ0ZXh0Ijp7ImJvZHkiOiJ0aGlzIGlzIGEgdGV4dCBtZXNzYWdlIn19XX19XX1dfQ==",
                        "encoding": "base64",
                        "inputTruncated": false
                    },
                    "clientIp": "2a03:2880:13ff:14::face:b00c",
                    "headers": {
                        "host": [
                            {
                                "key": "Host",
                                "value": "d1g979fqjgk8jl.cloudfront.net"
                            }
                        ],
                        "user-agent": [
                            {
                                "key": "User-Agent",
                                "value": "facebookexternalua"
                            }
                        ],
                        "content-length": [
                            {
                                "key": "content-length",
                                "value": "421"
                            }
                        ],
                        "accept": [
                            {
                                "key": "Accept",
                                "value": "*/*"
                            }
                        ],
                        "accept-encoding": [
                            {
                                "key": "Accept-Encoding",
                                "value": "deflate, gzip"
                            }
                        ],
                        "content-type": [
                            {
                                "key": "Content-Type",
                                "value": "application/json"
                            }
                        ],
                        "x-hub-signature": [
                            {
                                "key": "X-Hub-Signature",
                                "value": "sha1=3fea6ed27adec7439f0a349dd928b9e0c4d6aebb"
                            }
                        ],
                        "x-hub-signature-256": [
                            {
                                "key": "X-Hub-Signature-256",
                                "value": "sha256=6129a4c7d2d7789b9aedc7e0d161ac1a7ccc5fe6bc3124d2be0255dbaf18f35b"
                            }
                        ]
                    },
                    "method": "POST",
                    "querystring": "",
                    "uri": "/dev/api/inbound-ai/whatsapp"
                }
            }
        }
    ]
};

(async () => {
  const result = await handler(event);
  console.log("Result:", JSON.stringify(result, null, 2));
})();