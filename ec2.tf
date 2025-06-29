resource "aws_instance" "eatfit-backend" {
  ami           = "ami-0c593c3690c32e925"
  instance_type = "t2.micro"
  key_name      = "eatfit"

  subnet_id = "subnet-00389885a11689564"

  vpc_security_group_ids = [aws_security_group.eatfit_backend_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y

              # 스왑 메모리 2GB 설정
              sudo dd if=/dev/zero of=/swapfile bs=128M count=16
              sudo chmod 600 /swapfile
              sudo mkswap /swapfile
              sudo swapon /swapfile
              echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

              # JDK 21 설치
              sudo dnf install -y java-21-amazon-corretto-headless

              # systemd 서비스 등록
              sudo tee /etc/systemd/system/eatfit-backend.service > /dev/null <<EOL
              [Unit]
              Description=EatFit Spring Boot Backend
              After=network.target

              [Service]
              User=ec2-user
              ExecStart=/usr/bin/java -jar /home/ec2-user/eatfit-backend.jar
              Restart=always
              RestartSec=10

              [Install]
              WantedBy=multi-user.target
              EOL

              sudo systemctl daemon-reload
              sudo systemctl enable eatfit-backend

              # deploy.sh 스크립트 생성
              cat <<'EODEPLOY' > /home/ec2-user/deploy.sh
              #!/bin/bash

              SERVICE_NAME=eatfit-backend
              APP_JAR=/home/ec2-user/eatfit-backend.jar

              sudo systemctl stop $SERVICE_NAME
              sudo systemctl start $SERVICE_NAME
              EODEPLOY

              chmod +x /home/ec2-user/deploy.sh

              EOF

  tags = {
    Name = "eatfit-backend"
  }
}
