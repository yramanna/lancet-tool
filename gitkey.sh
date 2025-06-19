#/bin/bash!

sh-keygen -t ed25519 -C "yadu.nandan1195@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed2551
ls
ssh-add ~/.ssh/id_ed25519
cat id_ed25519.pub
cd ~
