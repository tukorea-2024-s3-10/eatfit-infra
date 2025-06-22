resource "aws_instance" "eatfit-backend" {
  ami = "ami-0c593c3690c32e925"
  instance_type = "t2.micro"
  key_name = "eatfit"

  subnet_id = "subnet-00389885a11689564"

  tags = {
    Name = "eatfit-backend"
  }
}
