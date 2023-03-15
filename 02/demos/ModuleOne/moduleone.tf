##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "aws_session_token" {}
variable "aws_region" {}
variable "key_name" {
  default = "demo-keypair"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
  region     = var.aws_region
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_instance" "nginx" {
  ami           = "ami-0841edc20334f9287"
  instance_type = "t3.micro"
  key_name        = var.key_name

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
    host = "self.public_ip"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
    value = "${aws_instance.nginx.public_dns}"
}
