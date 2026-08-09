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
  memory = "4096 mib"
  
  network_adapter {
    type           = "bridged"
    host_interface = "Realtek Gaming 2.5GbE Family Controller"
  }
}

resource "null_resource" "ansible_provisioner" {
  depends_on = [virtualbox_vm.coolify_node]

  connection {
    type     = "ssh"
    host     = virtualbox_vm.coolify_node.network_adapter[0].ipv4_address
    user     = "vagrant"
    password = "vagrant"
  }

  provisioner "file" {
    source      = "playbook.yml"
    destination = "/home/vagrant/playbook.yml"
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
  description = "The IP address of the VirtualBox VM"
  value       = virtualbox_vm.coolify_node.network_adapter[0].ipv4_address
}