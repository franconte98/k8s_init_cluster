swapoff -a
sudo su
cd ..
cd ..
sed -i '/[/]swap.img/ s/^/#/' /etc/fstab
exit
