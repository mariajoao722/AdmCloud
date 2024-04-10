data "tls_public_key" "public_key_data" {
  private_key_pem = tls_private_key.ssh_key_pk.private_key_pem
}
