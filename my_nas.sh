ip=
name=
dst="/media/$USER/$name"
cred="/$HOME/.smbcred"

mkdir -p "$dst"
sudo mount -t cifs //$ip/$name "$dst" -o vers=1.0,_netdev,credentials=$cred,user,uid=1000,gid=1000,iocharset=utf8,file_mode=0774,dir_mode=0775
