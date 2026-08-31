terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

resource "virtualbox_vm" "coolify_node" {
  name   = "coolify-debian"
  image  = "./debian-12.box"
  cpus   = 2
  memory = "4096 mib" # memoria RAM
  
  network_adapter {
    type           = "bridged"
    host_interface = "Seu adaptador de rede" # Substitua pelo nome do seu adaptador de rede
  }
}

resource "null_resource" "ansible_provisioner" {
  depends_on = [virtualbox_vm.coolify_node]

  connection {
    type     = "ssh"
    host     = virtualbox_vm.coolify_node.network_adapter[0].ipv4_address
    user     = "user"
    password = "SenhaSegura"
  }

  provisioner "file" {
    source      = "playbook.yml"
    destination = "/home/user/playbook.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ansible",
      "ansible-playbook /home/vagrant/playbook.yml"
    ]
  }
}
output "vm_ip_address" {
  description = "Sua maquina virtual está rodando em: "
  value       = virtualbox_vm.coolify_node.network_adapter[0].ipv4_address
}