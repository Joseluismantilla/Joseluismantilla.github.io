cat <<EOF > /etc/motd.d/course
   _   _   _   _     _   _   _   _   _   _  
  / \ / \ / \ / \   / \ / \ / \ / \ / \ / \ 
 ( R | H | S | A ) ( C | o | u | r | s | e )
  \_/ \_/ \_/ \_/   \_/ \_/ \_/ \_/ \_/ \_/ 
   Instructor: Jose Mantilla -- Udemy $(date +%Y)
                            Server machine
EOF
IP1=$(hostname -I|grep -v 127.0.0.1|awk '{ print $1}')
echo "$(hostname -I|grep -v 127.0.0.1|awk '{ print $1}') $(hostname -s) $(hostname -f)" >> /etc/hosts
echo "${IP1%.*}.$((${IP1##*.}+1)) client client.labs.com" >> /etc/hosts

mkdir -m 0700 /root/.ssh/
cat <<EOF >/root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCKqzDLhgAAjyK4xlu6LzlW8u49RlF6f1AUS26i2geKrNwsUMDEr87egbPRf7d6LV0/sgAUS7my4/eSVihHYpMmu98JhtfJWlJvIe6CIshemBQ6MUFhjCaMNp7K0vfuzfIPPxRUVeCZJGEWL6e4JePnGKyKS+nRWkOImofN8c6QRFyI7gLI3O9G3k/HZyZfU35ww3efBCP68PTYjwTfN10b1QaJpKd70QHJ2RxcQe2N2i0IcdwvO0UwXNl6ftYkf0HeBrUGB9ghmgGfpVFeh0JhxGLT3Z0uOvYvpMSCbIN2S4ITngXqJK5i4DAIwkSPO9pJGKcE2ItgPZT3JSBCZZwHOS5Kh8+64OQObHAMWioYm6x3J3HGxQL2Car3FwQJtt2p7T3i8o0MV6h9Sy4Ij1j6hn4+ZcJ1m+G4ZnNXsFhO5VvndQnL9w76hLh1zz843UuAeTRxYGbyNeuTLbxAuKkQISAq82zT0S/mTpJUZO5sCLY0khkHDKLc2zvS8fxg2BE= student@client.labs.com
EOF
sed -Ei -e 's,^(#|)PermitRootLogin .*,PermitRootLogin yes,' /etc/ssh/sshd_config
restorecon -R /root/.ssh > /dev/null 2>&1

mkdir -m0700 /home/student/.ssh/
cat <<EOF >/home/student/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCKqzDLhgAAjyK4xlu6LzlW8u49RlF6f1AUS26i2geKrNwsUMDEr87egbPRf7d6LV0/sgAUS7my4/eSVihHYpMmu98JhtfJWlJvIe6CIshemBQ6MUFhjCaMNp7K0vfuzfIPPxRUVeCZJGEWL6e4JePnGKyKS+nRWkOImofN8c6QRFyI7gLI3O9G3k/HZyZfU35ww3efBCP68PTYjwTfN10b1QaJpKd70QHJ2RxcQe2N2i0IcdwvO0UwXNl6ftYkf0HeBrUGB9ghmgGfpVFeh0JhxGLT3Z0uOvYvpMSCbIN2S4ITngXqJK5i4DAIwkSPO9pJGKcE2ItgPZT3JSBCZZwHOS5Kh8+64OQObHAMWioYm6x3J3HGxQL2Car3FwQJtt2p7T3i8o0MV6h9Sy4Ij1j6hn4+ZcJ1m+G4ZnNXsFhO5VvndQnL9w76hLh1zz843UuAeTRxYGbyNeuTLbxAuKkQISAq82zT0S/mTpJUZO5sCLY0khkHDKLc2zvS8fxg2BE= student@client.labs.com
EOF

disk=$(lsblk -l |grep disk |cut -d ' ' -f1)
parted -s /dev/${disk} mkpart primary xfs 18.2G 100%
udevadm settle
partition=$(lsblk -l|grep p3 |awk '{ print $1}')
mkfs.xfs /dev/${partition} -f
chown student.student -R /home/student/.ssh
chmod -R 600 /home/student/.ssh/*
