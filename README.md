# PackerBuilds
Packer build files for automated operating system template builds in a VMware vSphere environment, using both the older .JSON code as well as the newer .HCL format.

## HCL Builds

The HCL build uses the new Hashicorp HCL format for packer and seems to work more seamlessly with newer operating system releases.

## HCL Builds with Vault

If you are interested in hiding your credentials and pulling these from Hashicorp Vault, the HCL Builds with Vault example code shows how to integrate Vault into your Packer build and pull your vCenter Server credentials from Vault on the fly.

## Instructions

In each example build, replace the variables in the example code with values from your own environment, including vCenter Server address, SSO user, etc.
