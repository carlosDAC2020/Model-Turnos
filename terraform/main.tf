    # Definición de los proveedores requeridos y la versión de Terraform mínima
terraform {
  required_providers {
    aws = {
      # Origen del proveedor de AWS
      source  = "hashicorp/aws"  
      # Versión mínima del proveedor de AWS
      version = "~> 4.16"         
    }
  }
  # Versión mínima de Terraform requerida
  required_version = ">= 1.2.0"   
}

# Configuración del proveedor de AWS
provider "aws" {
  # Región de AWS a utilizar
  region     = "us-east-2"           
  access_key = var.access_key
  secret_key = var.secret_key
}

# Definición de un par de claves SSH para la instancia
resource "aws_key_pair" "my_key_pair" {
  # Nombre de la clave
  key_name   = "my-key-pair"          
  # Ruta del archivo de clave pública SSH    
  public_key = file("~/.ssh/id_rsa.pub")   
}

# Definición de un grupo de seguridad para la instancia
resource "aws_security_group" "turnos" {
  # Nombre del grupo de seguridad
  name        = "turnos"            
  # Descripción del grupo de seguridad  
  description = "grupo de seguridad para el modelo de turnos "  

  # Reglas de entrada (permisos de acceso a la instancia)
    
  ingress {
    # Permitir acceso desde cualquier IP (para conexiones SSH)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]            
  }

  ingress {
    # Permitir acceso desde cualquier IP (para solicitudes HTTP)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]            
  }
  ingress {
    # Permitir acceso desde cualquier IP (para solicitudes HTTP)
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]            
  }
  # Reglas de salida (permisos de salida desde la instancia)
  egress {
    # Permitir salida a cualquier IP
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]            
  }
}

# Definición de la instancia EC2 --------------------

    # cliente angular
resource "aws_instance" "turnos_client" {
  # ID de la AMI a utilizar
  ami             = "ami-037774efca2da0726"     
  
  # Tipo de instancia   
  instance_type   = "t2.micro"                  
  # Nombre de la clave SSH a asociar    
  key_name        = aws_key_pair.my_key_pair.key_name  
  # Grupo de seguridad asociado
  security_groups = [ aws_security_group.turnos.name ]  
  # Etiqueta de la instancia
  tags = {
    Name = "turnos-client"                      
  }

  provisioner "local-exec" {
    command = "echo 'server ansible_host=${self.public_ip} ansible_ssh_private_key_file=~/.ssh/id_rsa' >> ../ansible/inventory"
  }

}


# outputs -------------------------------------------
    # cliente angular
output "public_ip_angular_client" {
  # IP pública de la instancia
  value = aws_instance.turnos_client.public_ip         
}


