provider "aws"{
    region = var.aws_region
}


resource "aws_key_pair" "ssh_key" {
    key_name = "ansible-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAaYcyn84zNJ3uO/af4h+R3L8AvWqepPbxfKDmUaAItzun9XDqiGDpxju5zgE1UCFKilwKGVjfFuzkZRIXGgBLpf7KZ9w7BYXVshB1KROci11/UxPY/368UoXDaATTeA5mboGiw1ciLg/BoymoOQjHAWeO1ZcA3kNwblC84rbQ0BCMcZJAFKiBeDXlBlTrb1U1kD53mF1dKzfEsP9kOSw2Bt3ahqAKGjMCtxT+l0dRCYr3zP1fRXRxbQ5fjb0s0iIvhquZ9Z1kbAtLHIHmNmGSD5aueNVbl7qvaclqQjRE5OumHpSHBYAW3HDLfufH8PFglYpe3oJRAKmwS0Hy0VJkc1sXTeMN6ZvOumBhOrUEgvGQMYpssCPwVVLNsCDN0/BAILDLeLhfUowq/Pk6vnndFLfIhEVwsVyJFlbhhQk60xMneYAFMggF8cVp012DmTuEwGqAZiqJEaQqd9PkOvvtB4sFh+IrTDvk1XkyKAKXvypaPnHvUiSv6VzomRyw3os= danil@danil-HP-250-G5-Notebook-PC"
}

# Instance ====================================
resource "aws_instance" "webserver"{
    count = var.az_count
    key_name = aws_key_pair.ssh_key.key_name
    ami = "ami-0245697ee3e07e755" //Debian 10
    availability_zone = data.aws_availability_zones.avaliable.names[count.index]
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnets[count.index].id
    vpc_security_group_ids = [aws_security_group.sg_webserver.id]
    user_data = templatefile("user_data.tpl",{
      name = "Danil",
      l_name = "Ignatushkun"
  }
  )

    associate_public_ip_address = true

  tags = {
      Name = "WebServer-${var.app}-${var.env}"
  }
}

# ignatdom.website


# Security group====================================
resource "aws_security_group" "sg_webserver"{
    name = "SG-${var.app}-${var.env}"
    vpc_id = aws_vpc.main_vpc.id
    description = "SG for Debian web server"

    ingress = [
        {
            description      = "TLS from VPC"
            from_port        = 80
            to_port          = 80
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            prefix_list_ids  = []
            security_groups  = []
            self = false 
        },
        {
            description      = "SSH from VPC"
            from_port        = 22
            to_port          = 22
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            prefix_list_ids  = []
            security_groups  = []
            self = false 
        },
        {
            description      = "SSH from VPC"
            from_port        = 443
            to_port          = 443
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            prefix_list_ids  = []
            security_groups  = []
            self = false 
        }
    ]

    egress {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }

    tags = {
        Name = "SG for Debian web server"
    }
}

# Output============================
