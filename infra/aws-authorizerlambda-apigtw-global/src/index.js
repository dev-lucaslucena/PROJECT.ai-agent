const { SSMClient, GetParameterCommand } = require("@aws-sdk/client-ssm");
const { SecretsManagerClient, GetSecretValueCommand } = require("@aws-sdk/client-secrets-manager");
const crypto = require("crypto");
const secretsManager = new SecretsManagerClient();

async function getParameter(parameterName) {
  console.log("getParameter", parameterName);
  const command = new GetParameterCommand({ Name: parameterName });
  const data = await ssmClient.send(command);
  return data.Parameter.Value;
}

async function getSecret(secretName) {
    console.log("getSecret");
    const command = new GetSecretValueCommand({ SecretId: secretName });
    const data = await secretsManager.send(command);
    return JSON.parse(data.SecretString);
  }


exports.handler = async (event) => {
  console.log("Event:", JSON.stringify(event, null, 2));
  try {
    const originVerifyHeader = event?.headers["x-origin-verify"];
    if (!originVerifyHeader) {
      console.error("Missing x-origin-verify header");
      return generatePolicy("user", "Deny", "*");
    }

    const validSecret = await getParameter("APIGTW_CLOUDFRONT_SECRET");

    if (originVerifyHeader == validSecret) {
      return generatePolicy("user", "Allow", "*");
    } else {
      console.error("Invalid x-origin-verify header");
      return generatePolicy("user", "Deny", "*");
    }
  } catch (error) {
    console.error("Authorization failed:", error);
    return generatePolicy("user", "Deny", "*");
  }
};

function generatePolicy(principalId, effect, resource) {
  console.log("generatePolicy");
  const policyDocument = {
    Version: "2012-10-17",
    Statement: [
      {
        Action: "execute-api:Invoke",
        Effect: effect,
        Resource: resource,
      },
    ],
  };

  const result = {
    principalId: principalId,
    policyDocument: policyDocument,
  };

  console.log("Authorization result:", JSON.stringify(result, null, 2));
  return result;
}