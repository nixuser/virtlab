# How to update image

Download image from https://app.vagrantup.com/debian/boxes/bookworm64
```
curl -L -O https://app.vagrantup.com/debian/boxes/bookworm64/versions/12.20240503.1/providers/virtualbox/unknown/vagrant.box
```

Add VM box to vagrant and check it in list of boxes. Remove .box file.
```
vagrant box add --name debian/12.20240503.1 vagrant.box
vagrant box list
rm vagrant.box
```

Update image in Vagrantfile
```
```

