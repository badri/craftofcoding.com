// infa domain
resource "dnsimple_record" "openshift_base" {
  domain = var.tld
  value  = aws_eip.infra_eip.public_ip
  type   = "A"
  name   = var.domain
}

// console url
resource "dnsimple_record" "openshift_web_console" {
  domain = dnsimple_record.openshift_base.domain
  type   = "A"
  name   = format("console.%s", var.domain)
  value  = aws_eip.master_eip.public_ip
}


// apps subdomains
resource "dnsimple_record" "openshift_apps" {
  domain = dnsimple_record.openshift_base.domain
  type   = "CNAME"
  name   = format("*.apps.%s", var.domain)
  value  = format("%s.%s", var.domain, var.tld)
}
