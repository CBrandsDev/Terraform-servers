terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 1.0"
    }
  }
}

# Configuração de conexão com o Windows Server
provider "hyperv" {
  user     = "Usuario" # Mude para o seu usuário do Windows Server
  password = "SenhaDoUsuario" # Mude para a senha do seu usuário do Windows Server
  host     = "192.168.x.x"
  port     = 5985
  https    = false
  insecure = true
}

# ==========================================
# Nó Master (Control Plane) - 4GB RAM / 2 vCPU
# ==========================================
resource "hyperv_machine_instance" "k8s_master" {
  name                 = "K8s-Master"
  generation           = 2
  processor_count      = 2
  static_memory        = true
  memory_startup_bytes = 4294967296 

  network_adaptors {
    name        = "eth0"
    switch_name = "Nome do Adaptador de Rede" # Mude para o seu adaptador de rede
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    controller_number   = 0
    controller_location = 0
    path                = "C:\\VMs\\K8s-Master\\K8s-Master.vhdx" # Caminho para salvar o disco no windows server
  }

  dvd_drives {
    controller_number   = 0
    controller_location = 1
    path                = "C:\\Templates\\cloud-init-master.iso" # Caminho onde o template do cloud-init-master.iso está localizado no windows server 
  }
}

# ==========================================
# Worker 01 (Banco de Dados) - 10GB RAM / 2 vCPU
# ==========================================
resource "hyperv_machine_instance" "k8s_worker_01" {
  name                 = "K8s-Worker-01"
  generation           = 2
  processor_count      = 2
  static_memory        = true
  memory_startup_bytes = 10737418240 

  network_adaptors {
    name        = "eth0"
switch_name = "Nome do Adaptador de Rede" # Mude para o seu adaptador de rede

  }

  hard_disk_drives {
    controller_type     = "Scsi"
    controller_number   = 0
    controller_location = 0
    path                = "C:\\VMs\\K8s-Worker-01\\K8s-Worker-01.vhdx" # Caminho para salvar o disco no windows server
  }

  dvd_drives {
    controller_number   = 0
    controller_location = 1
    path                = "C:\\Templates\\cloud-init-worker1.iso" # Caminho onde o template do cloud-init-worker1.iso está localizado no windows server
  }
}

# ==========================================
# Worker 02 (Aplicações) - 6GB RAM / 2 vCPU
# ==========================================
resource "hyperv_machine_instance" "k8s_worker_02" {
  name                 = "K8s-Worker-02"
  generation           = 2
  processor_count      = 2
  static_memory        = true
  memory_startup_bytes = 6442450944 

  network_adaptors {
    name        = "eth0"
    switch_name = "Nome do Adaptador de Rede" # Mude para o seu adaptador de rede
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    controller_number   = 0
    controller_location = 0
    path                = "C:\\VMs\\K8s-Worker-02\\K8s-Worker-02.vhdx" # Caminho para salvar o disco no windows server
  }

  dvd_drives {
    controller_number   = 0
    controller_location = 1
    path                = "C:\\Templates\\cloud-init-worker2.iso" # Caminho onde o template do cloud-init-worker2.iso está localizado no windows server
  }
}
