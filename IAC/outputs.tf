output "instance_ip" {
  value = aws_instance.minikube.public_ip
}

output "private_key_file" {
  value     = local_file.private_key.filename
  sensitive = true
}
