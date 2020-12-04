resource "null_resource" "metalb" {
  count = var.metalb_enabled ? 1 : 0

  connection {
    host        = hcloud_server.master.0.ipv4_address
    private_key = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml",
      "kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml",
      "kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey='$(openssl rand -base64 128)'",
    ]
  }

  depends_on = ["hcloud_server.master"]
}

