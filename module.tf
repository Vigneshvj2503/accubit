data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
  encrypted         = "true"
  
  tags = {
    provider      = var.cloud_provider
  }
}

resource "aws_volume_attachment" "volume_attachment" {
  device_name  = var.ebs_device_name
  volume_id    = aws_ebs_volume.ebs_volume.id
  instance_id  = aws_instance.instance.id
  skip_destroy = true
}

resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  iam_instance_profile   = var.default_instance_profile
  private_ip             = var.private_ip
  user_data              = var.user_data

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }

  volume_tags = {
    provider      = var.cloud_provider
      }

  tags = {
    provider      = var.cloud_provider
     }
  lifecycle {
        ignore_changes = ["ami", "user_data"]
      }
}
