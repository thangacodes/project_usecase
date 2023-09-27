resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.amazon-ami.id
  instance_type          = local.vm_size
  key_name               = aws_key_pair.generated_key.id
  vpc_security_group_ids = local.sgpid
  subnet_id              = aws_subnet.public.id
  availability_zone      = local.avail_zone
  connection {
    type        = "ssh"
    user        = "ec2-user"
    agent       = false
    private_key = file("ansible/sshkey.pem")
    host        = aws_instance.jenkins.public_ip
  }

  provisioner "file" {
    source      = "ansible/install_jenkins.yml"
    destination = "/tmp/install_jenkins.yml"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo yum update -y",
      "sudo yum install python3",
      "python --version",
      "echo 'Installing ansible2 on remote machine'",
      "sudo amazon-linux-extras install ansible2 -y",
      "echo 'ansible version checking'",
      "ansible --version",
      "ansible -m ping localhost",
      "echo 'Installing Git on remote machine'",
      "sudo yum install git -y",
      "echo 'Git version checking'",
      "git --version",
      "echo 'Listing files in /tmp/ directory on remote machine...'",
      "ls -lart /tmp/",
      "sleep 10",
      "echo 'Playbook execution begins in shortly..'",
      "sudo ansible-playbook /tmp/install_jenkins.yml --syntax-check",
      "sudo ansible-playbook /tmp/install_jenkins.yml",
    ]
  }
  tags = merge(var.identity, { Name = "Jenkins-Server" })
}

