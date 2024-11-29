region            = "ap-south-1"
access_key        = ""
secret_access_key = ""
sgp               = "sg-0fb1052b659369aa8"
keypair           = "mac"
vmspec            = "t2.micro"
cluster_name      = "td-msk-cluster"
kafka_version     = "3.6.0"
kafka_ins_type    = "kafka.t3.small"
security_groups   = ["sg-0fb1052b659369aa8", "sg-f2b58c94"]
tagging = {
  CreationDate = "29/11/2024"
  Environment  = "Development"
  Owner        = "td@cloudbird.fun"
  Name         = "client_to_kafka_cluster_access"
}
