Features by driver version


| Driver Version ||
| ------------- | ------------- |
| 3.2.3  (Based dentOS v2.5 features) | Based on Linux Kernel 5.15 |

Please use GitHub [issues](../../issues) to report issues/request new enhancements.	
	
	INDEX
	1. Preparation
	2. Build & run with PCI IPC simulation
	3. Build & run with Netlink IPC simulation
	4. Workflow
	5. Use custom sources
	6. Tested host configurations

This is the buildroot-external project to build an image for the Marvell's Prestera Switch.

Preparation
===========

Install OpenSSL on the host.
For debian/Ubuntu:
sudo apt-get install libssl-dev
Make sure cpp and gcc have the same version:
gcc -v && cpp -v

Location of deliverables from GitHub:
Kernel prestera driver:
https://github.com/Marvell-switching/linux/tree/dent-linux-5.15.y

CPSS drivers: https://github.com/Marvell-switching/mrvl-prestera/tree/slim_lk515

CPSS appDemo binary:
https://github.com/Marvell-switching/dent-artifacts/tree/slim

Workflow
========

This section describes the basic development workflow with buildroot
to compile & deploy changes made for appDemo or switchdev driver.

1. In case 2540/2580 PHY is used, the PHY binary (hdr extension)
   needs to be download from the Marvell support website at
   https://www.marvell.com/support/extranets.html
   (signing NDA is required, then you can obtain user and password
   from your Marvell or distributor FAE).
   Downloaded 2540/2580 PHY binary files with the hdr extension
   should be copied to the following directory:

   board/<vendor>/<vendor board name>/rootfs-overlay/etc/mvsw

2. Build required defconfig
First, you need to choose and build a configuration for the target
board, for example, lets it be AC5x board (AC5x SoC):

    $ ./build.sh ac5x_trampoline

For the first time, it may take a long time to download the required packages, kernel
building.

After success, all related files, binaries, and copied sources for a selected build are located
in output/ac5x_trampoline. The folder contains the standard Buildroot layout:

    output/ac5x_trampoline/
                         images/           - generated rootfs, kernel, dtb binaries
                               /rootfs.tar - archived target rootfs
                               /Image     - kernel image
                               /*.dtb      - DTB file.

                         target/ - libs, apps installed for target
                         host/ - libs, apps installed for the host (build machine)
                         build/xxx - xxx package sources with compiled files
                         

3. Build packages: Buildroot has several packages which describe how to build components needed:

    package/cpss/cpss-agent - Firmware Agent (Cloned as binary blob from github)
    package/cpss/cpss-prestera-swdev-kmod - prestera_sw
    package/cpss/cpss-drivers-kmod - Int, Dma, Mbus kernel modules

4. Rebuild sources after modification:

    a) to clean-up and rebuild prestera_sw sources (full rebuild):

      make -C output/ac5x_trampoline prestera-swdev-kmod-dirclean prestera-swdev-kmod-dirclean

5. Deploy rootfs, kernel and dtb to the tftpboot server for NFS boot:

To deploy everything via SSH to the user's home folder on the server for NFS boot, run the following:

    make -C output/ac5x_trampoline deploy

    it will deploy contents of output/<build_name>/images/deploy/* folder to SSH_IP:~/<build_name>

Use custom sources
==================

5.To use custom sources for Buildroot packages (for example linux) it might be specified

from the command line:

    $ LINUX_OVERRIDE_SRCDIR={PATH_TO_LINUX_SRC_DIR} make -C output/ac5x_trampoline

    or

    $ LINUX_OVERRIDE_SRCDIR={PATH_TO_LINUX_SRC_DIR} ./build.sh ac5x_trampoline

This variable should be specified before each Buildroot invocation.

6.Tested host configurations:

6.a. Ubuntu 20.04.1 LTS focal, gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04) , kernel 5.4.0-52-generic x86_64 GNU/Linux

6.b. Ubuntu 18.04.5 LTS bionic, gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04) ,
	kernel 4.15.0-132-generic x86_64 GNU/Linux

