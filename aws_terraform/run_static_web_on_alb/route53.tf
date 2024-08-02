data "aws_vpc" "r53test" {
  id = aws_vpc.lab.id
}
output "check_my_vpc_id" {
  value = aws_vpc.lab.id
}

resource "aws_route53_zone" "my-test-zone" {
  name = "cloudbird.fun"
  vpc {
    vpc_id = data.aws_vpc.r53test.id
  }
  comment = "cloudbird_r53 dns"
  tags    = merge(var.common_tag, { Name = "Cloudbird.fun " })
}

resource "aws_route53_record" "insrec" {
  count   = length(aws_instance.labvm)
  zone_id = aws_route53_zone.my-test-zone.id
  name    = "web-${count.index}.cloudbird.fun"
  type    = "A"
  ttl     = 300
  records = [for p in aws_instance.labvm : p.private_ip]
}

resource "aws_route53_record" "dnsrecord" {
  zone_id = aws_route53_zone.my-test-zone.id
  name    = "www.cloudbird.fun"
  type    = "A"

  alias {
    name                   = aws_lb.labalb.dns_name
    zone_id                = aws_lb.labalb.zone_id
    evaluate_target_health = true
  }
}
