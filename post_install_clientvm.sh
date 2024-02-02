# Virtualbox 192.168.56.x (enp0s3 & sda)
# VMWare 192.168.122.x
# KVM 192.168.122.x (enp1s0 & vda)

# VirtualBox requires NAT Network 
# SET PATH=%PATH%;C:\Program Files\Oracle\VirtualBox (cmd)
# $env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox" (Powershell as admin)
# VBoxManage list natnetworks
# VBoxManage natnetwork add --netname rhsa --network "10.0.2.0/24" --enable
# VBoxManage list natnetworks
# VBoxManage natnetwork remove --netname rhsa-lab
