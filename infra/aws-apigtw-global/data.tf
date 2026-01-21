# Crie um hash do conteúdo do arquivo de origem
data "external" "file_hash" {
  program = ["bash", "-c", <<EOT
    if command -v sha256sum >/dev/null 2>&1; then
      HASH=$(sha256sum ${path.module}/${var.gtw_name}.yaml | cut -d' ' -f1)
    else
      HASH=$(shasum -a 256 ${path.module}/${var.gtw_name}.yaml | cut -d' ' -f1)
    fi
    echo "{\"hash\":\"$HASH\"}"
  EOT
  ]
}



# Leia o conteúdo do arquivo bundled
data "external" "openapi_bundle_content" {
  program = ["bash", "-c", <<EOT
    CONTENT=$(cat ${path.module}/bundle/${var.gtw_name}-bundled.yaml | base64 -w 0)
    echo "{\"content\":\"$CONTENT\"}"
  EOT
  ]

  # Isso garante que o conteúdo seja lido após o bundle ser gerado
  depends_on = [null_resource.openapi_bundle_trigger]
}