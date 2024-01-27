# Virtualbox 192.168.56.x (enp0s3 & sda)
# VMWare 192.168.122.x
# KVM 192.168.122.x (enp1s0 & vda)

# VirtualBox requires NAT Network 
# SET PATH=%PATH%;C:\Program Files\Oracle\VirtualBox (cmd)
# $env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox" (Powershell as admin)
# VBoxManage list natnetworks
# VBoxManage natnetwork add --netname rhsa --network "10.0.2.0/24" --enable
# VBoxManage list natnetworks

cat <<EOF > /etc/motd.d/course
   _   _   _   _     _   _   _   _   _   _  
  / \ / \ / \ / \   / \ / \ / \ / \ / \ / \ 
 ( R | H | S | A ) ( C | o | u | r | s | e )
  \_/ \_/ \_/ \_/   \_/ \_/ \_/ \_/ \_/ \_/ 
   Instructor: Jose Mantilla -- Udemy  $(date +%Y)
   ----------- client machine ------------

EOF
IP1=$(hostname -I|grep -v 127.0.0.1|awk '{ print $1}') 
echo "$(hostname -I|grep -v 127.0.0.1|awk '{ print $1}') $(hostname -s) $(hostname -f)" >> /etc/hosts
#ping -c30 -i3 192.168.122.11
#if [ $? -eq 0 ]
#then 
echo "${IP1%.*}.$((${IP1##*.}-1)) server server.labs.com" >> /etc/hosts
#exit 0
#else echo “fail”
#fi

mkdir -m 0700 /root/.ssh/
cat <<EOF >/root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCKqzDLhgAAjyK4xlu6LzlW8u49RlF6f1AUS26i2geKrNwsUMDEr87egbPRf7d6LV0/sgAUS7my4/eSVihHYpMmu98JhtfJWlJvIe6CIshemBQ6MUFhjCaMNp7K0vfuzfIPPxRUVeCZJGEWL6e4JePnGKyKS+nRWkOImofN8c6QRFyI7gLI3O9G3k/HZyZfU35ww3efBCP68PTYjwTfN10b1QaJpKd70QHJ2RxcQe2N2i0IcdwvO0UwXNl6ftYkf0HeBrUGB9ghmgGfpVFeh0JhxGLT3Z0uOvYvpMSCbIN2S4ITngXqJK5i4DAIwkSPO9pJGKcE2ItgPZT3JSBCZZwHOS5Kh8+64OQObHAMWioYm6x3J3HGxQL2Car3FwQJtt2p7T3i8o0MV6h9Sy4Ij1j6hn4+ZcJ1m+G4ZnNXsFhO5VvndQnL9w76hLh1zz843UuAeTRxYGbyNeuTLbxAuKkQISAq82zT0S/mTpJUZO5sCLY0khkHDKLc2zvS8fxg2BE= student@client.labs.com
EOF
sed -Ei -e 's,^(#|)PermitRootLogin .*,PermitRootLogin yes,' /etc/ssh/sshd_config
restorecon -R /root/.ssh > /dev/null 2>&1

mkdir -m700 /home/student/.ssh
cat <<EOF >/home/student/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCKqzDLhgAAjyK4xlu6LzlW8u49RlF6f1AUS26i2geKrNwsUMDEr87egbPRf7d6LV0/sgAUS7my4/eSVihHYpMmu98JhtfJWlJvIe6CIshemBQ6MUFhjCaMNp7K0vfuzfIPPxRUVeCZJGEWL6e4JePnGKyKS+nRWkOImofN8c6QRFyI7gLI3O9G3k/HZyZfU35ww3efBCP68PTYjwTfN10b1QaJpKd70QHJ2RxcQe2N2i0IcdwvO0UwXNl6ftYkf0HeBrUGB9ghmgGfpVFeh0JhxGLT3Z0uOvYvpMSCbIN2S4ITngXqJK5i4DAIwkSPO9pJGKcE2ItgPZT3JSBCZZwHOS5Kh8+64OQObHAMWioYm6x3J3HGxQL2Car3FwQJtt2p7T3i8o0MV6h9Sy4Ij1j6hn4+ZcJ1m+G4ZnNXsFhO5VvndQnL9w76hLh1zz843UuAeTRxYGbyNeuTLbxAuKkQISAq82zT0S/mTpJUZO5sCLY0khkHDKLc2zvS8fxg2BE= student@client.labs.com
EOF
cat <<EOF >/home/student/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
EOF
chown student.student -R /home/student/.ssh
chmod 600 -R /home/student/.ssh/id_*
rm -f /root/original.cfg
#sed -i '11,19d' anaconda-ks.cfg