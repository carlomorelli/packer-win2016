# Packer script for Windows Server 2016 images

This repository contains the Packer script and Vagrant exporter that generate a (virtualbox-based) Windows Server 2016 image ready to be provisioned with Vagrant.

The script has been tested with Packer 1.0.0 and Vagrant 2.0.0.

## Requirements
* Packer
* Vagrant
* Virtualbox (as vagrant backend)

## Build box

```
packer build -force -only virtualbox-iso ./win2016.json
```
Packer will download an evaluation ISO from Microsoft, run an autoattended installation (check out `installer/autounattend.xml` file) that will install Windows Server Core (no GUI and GUI tools), and then provision Windows Updates and optimizations before bumping a Box.

## VM Backend

Currently only Virtualbox is considered. According to the Packer documentation at <https://www.packer.io/docs/post-processors/vagrant.html> also KVM/qemu, HyperV, VMWare and AWS AMIs are supported.

## Publish to Artifactory

In my usecase I needed to publish to our corporate Jfrog Artifactory installation. Other workflows may require Hashicorp Vagrant Cloud for this -- I guess the mechanism is mostly the same.
 
First retrieve the ${apikey} of a write-enabled user. Then run
```
curl -H 'X-JFrog-Art-Api: ${apikey}' -T ${box_filename} "https://my.artifactory.address/Vagrant-Repository/${box_name}-${box_provider}-${box_version}.box;box_name=${box_name};box_provider=${box_provider};box_version=${box_version}"
```
where `box_provider`, `box_version` and `box_name` are tags that will identify the box when Metadata is retrieved (e.g. with Vagrant)

## Use the box

To use the box, make reference to the `Vagrantfile` in `vagrant-test/` directory. 

In case of Artifactory, you must define a valid `ATLAS_TOKEN` and `VAGRANT_SERVER_URL` env variables inside the Vagrantfile, in case your remote repository requires authentication. More infos here: <https://www.jfrog.com/confluence/display/RTF/Vagrant+Repositories>

Run
```
cd vagrant-test
vagrant up
```

## Update the box

The publishing rule on the box repository will create a new box for every version. 

However, regardless of what the Vagrant documentation said, I found out that the latest version of the box was not automatically pulled when running `vagrant up`. So the solution that works for me is
```
vagrant box update
vagrant box prune
vagrant up
```
If a version must be forced, use `vagrant box update --version=...` option.

If someone has a better solution for this, please drop me a message ;)


## Kudos

This work is totally inspired by the amazing Matt Wrock. Please check his blog at <https://www.hurryupandwait.io> and his GitHub repository <https://github.com/mwrock/packer-templates>. His templates cover the full range of Windowses, and use also configuration management tools during provisioning (namely: Chef and Boxstarter).

The work in this repo is actually just a small bit in comparrison, it only checks out on Windows Server 2016 and uses purely Powershell 5.x scripting.


