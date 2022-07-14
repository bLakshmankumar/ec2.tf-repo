####################### provider ###########################
provider "aws" {
  access_key = "${var.myaccess_key}"
  secret_key = "${var.mysecret_key}"
  region = "us-west-2"
}

######################## Resources ##########################

resource "aws_instance" "mytfserver" {
    ami = "ami-075200050e2c8899b"
    instance_type = "t2.micro"
    key_name = "oregonkey.pem"
    tags = {
      "Name" = "mytfserver"
    }

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("oregonkey.pem")}"
      host = aws_instance.mytfserver.public_ip
      agent = false
      timeout = "300"
      
    }

    provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y",
    ]
  }
}

######################### Output #########################

output "myInstanceId" {value = aws_instance.mytfserver.public_ip}
