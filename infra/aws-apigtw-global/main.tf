# Use o null_resource com triggers para forçar a reexecução quando o arquivo mudar
resource "null_resource" "openapi_bundle_trigger" {
  triggers = {
    file_hash = data.external.file_hash.result.hash
  }

  provisioner "local-exec" {
    command = "redocly bundle ${path.module}/${var.gtw_name}.yaml -o ${path.module}/bundle/${var.gtw_name}-bundled.yaml"
  }
}

resource "aws_apigatewayv2_api" "apigtw_global" {
  name          = "${var.gtw_name}"
  protocol_type = "HTTP"
  body          = base64decode(data.external.openapi_bundle_content.result.content)

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"]
    allow_headers = ["Content-Type"]
    max_age       = 300
  }  

  depends_on = [null_resource.openapi_bundle_trigger]
}