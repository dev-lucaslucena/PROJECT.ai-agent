# AWS-EdgeLambda-Global

## Setup Facebook Webhook authentication

Use app secret to verify the webhook signature, do not confuse with others type of token.

Correct value:
![alt text](/static/2024-10-04_23-53.png)

Wrongs values:
![alt text](/static/2024-10-04_23-54.png) 

![alt text](/static/2024-10-04_23-53_1.png)

After you have the correct value, you have to set it in the secret manager, with the name `FACEBOOK_APP_SECRET_{{APPNAME}}`.

Then the edge lambda shoud correctly verify the signature of the webhook.