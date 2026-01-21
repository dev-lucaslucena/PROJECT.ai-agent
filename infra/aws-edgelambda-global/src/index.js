const { SSMClient, GetParameterCommand } = require("@aws-sdk/client-ssm");
const { SecretsManagerClient, GetSecretValueCommand } = require("@aws-sdk/client-secrets-manager");
const crypto = require("crypto");

const ssmClient = new SSMClient({ region: "us-east-1" });
const secretsManager = new SecretsManagerClient({ region: "us-east-1" });

async function getParameter(parameterName) {
  console.log("getParameter", parameterName);
  const command = new GetParameterCommand({ Name: parameterName });
  const data = await ssmClient.send(command);
  return data.Parameter.Value;
}

async function getSecret(secretName) {
  console.log("getSecret", secretName);
  const command = new GetSecretValueCommand({ SecretId: secretName });
  const data = await secretsManager.send(command);
  return JSON.parse(data.SecretString);
}

exports.handler = async (event) => {
  console.log("Event:", JSON.stringify(event, null, 2));
  const request = event.Records[0].cf.request;

  try {
    const headers = request.headers;
    const apiKey = headers["x-api-key"] ? headers["x-api-key"][0].value : null;
    const validApiKeys = await getParameter("VALID_API_KEYS"); 

    const originVerify = await getParameter("APIGTW_CLOUDFRONT_SECRET");
    const facebookWebhookVerifyToken = await getParameter("FACEBOOK_WEBHOOK_VERIFY_TOKEN");

    request.headers['x-origin-verify'] = [{
      key: 'x-origin-verify',
      value: originVerify
    }];

    let isAuth = knownServicesAuthentications(request, validApiKeys, facebookWebhookVerifyToken);
    if (isAuth && isAuth.status == '200') {
      console.log("Known service authenticated");
      return request;
    }

    if (apiKey) {
      let isAuth = handleApiKeyAuth(apiKey, validApiKeys, request);

      if (isAuth && isAuth.status === '200') {
        console.log("ApiKey service authenticated");
        return request;
      }
    }

    return generateDenyResponse(request);
  } catch (error) {
    console.error("Authorization failed:", error);
    return generateDenyResponse(request);
  }
};

function knownServicesAuthentications(request, validApiKeys, facebookWebhookVerifyToken) {
  console.log("knownServicesAuthentications");
  let faceAuth = facebookAuth(request, validApiKeys, facebookWebhookVerifyToken);
  if (faceAuth) {
    return faceAuth;
  }
  // Add more services here
  return null;
}

function facebookAuth(request, validApiKeys, facebookWebhookVerifyToken) {
  console.log("facebookAuth");
  if (isFacebookRequest(request)) {
    const method = request.method;
    let requestBody = request.body ? request.body.data : null;
    // Ensure requestBody is a string and decode it if it's base64 encoded
    if (request.body && typeof requestBody == "string" && request.body.encoding === 'base64') {
      // Decode the base64 encoded body
      requestBody = Buffer.from(request.body.data, 'base64').toString('utf8');
    }
    console.log("Decoded body:", requestBody);

    const query = new URLSearchParams(request.querystring);
    const verifyTokenQuery = query.get("hub.verify_token");
    const xHubSignature = request.headers["x-hub-signature-256"] ? request.headers["x-hub-signature-256"][0].value : null;

    if (method === "GET") {
      return handleFacebookWebhookVerification(
        verifyTokenQuery,
        facebookWebhookVerifyToken,
        request
      );
    } else if (method === "POST") {
      if (xHubSignature && requestBody) {
        const secretsStartingWithFacebookAppSecret = Object.keys(validApiKeys)
          .filter(key => key.startsWith("FACEBOOK_APP_SECRET_"))
          .map(key => validApiKeys[key]);

        const isValid = validateFacebookSignature(
          requestBody,
          xHubSignature,
          secretsStartingWithFacebookAppSecret
        );
        if (!isValid) {
          console.error("Invalid Facebook signature");
          return generateDenyResponse(request);
        }
      } else {
        console.error("Missing Facebook signature or request body");
        return generateDenyResponse(request);
      }
      return generateAllowResponse(request);
    }
  }
  return null;
}

function isFacebookRequest(request) {
  console.log("isFacebookRequest");
  const userAgent = request.headers["user-agent"] ? request.headers["user-agent"][0].value : "";
  return userAgent.includes("facebook");
}

function handleFacebookWebhookVerification(verifyToken, storedToken, request) {
  console.log("handleFacebookWebhookVerification");
  if (verifyToken === storedToken) {
    return generateAllowResponse(request);
  }
  return generateDenyResponse(request);
}

function handleApiKeyAuth(apiKey, validApiKeys, request) {
  console.log("handleApiKeyAuth");
  if (validApiKeys.includes(apiKey)) {
    return generateAllowResponse(request);
  }
  return generateDenyResponse(request);
}

function generateAllowResponse(request) {
  console.log("generateAllowResponse");
  return {
    status: '200',
    statusDescription: 'OK',
    headers: {
      'content-type': [{ key: 'Content-Type', value: 'text/plain' }],
    },
    body: 'Authorized',
  };
}

function generateDenyResponse(request) {
  console.log("generateDenyResponse");
  return {
    status: '403',
    statusDescription: 'Forbidden',
    headers: {
      'content-type': [{ key: 'Content-Type', value: 'text/plain' }],
    },
    body: 'Unauthorized',
  };
}

function validateFacebookSignature(payload, signatureHeader, appSecrets) {
  console.log("validateFacebookSignature");
  const signature = signatureHeader.split("sha256=")[1];
  for (const appSecret of appSecrets) {
    const expectedSignature = crypto
      .createHmac("sha256", appSecret)
      .update(payload, "utf8")
      .digest("hex");
    const isValid = signature === expectedSignature;
    if (isValid) {
      return true;
    }
  }
  return false;
}