[TOC]

### Prepare config file

We have to copy the variables.auto.pkrvars.hcl.sample to variables.auto.pkrvars.hcl to have the local file where to store our environment variables.

### API key

We need to create an API key to be able to proceed with the template creation, it's the method packer is using to manage proxmox. There's a good guide [here](https://www.virtualizationhowto.com/2024/04/proxmox-packer-template-for-ubuntu-24-04/). Once the credentials are created, we have to modify the variables.auto.pkrvars.hcl file with those values.

### Modify the cloud init config

In the http/user-data file we have to modify probably the hashed password and the username

To generate the hashed password on linux we can use mkpasswd (part of whois package)

    mkpasswd --method=SHA-512 --rounds=4096

### Create the templates

Now we have only to launch the build, it should take about 10 minutes, you can see the progress in the proxmox screen.

    packer init . 
    packer build .
