
## Wayland compositor

THERE SEEMS TO BE A DEPENDENCY ISSUE WITH SWAY UNTIL ITS RESOOVED OR YOUSELF MANUEL INTERVENE, THIS SCRIPT WILL FAIL!!!


This is a Port for Gentoo of a Sway Setup script. Dont expect everything to work i havent completly tested it. This script wants to install a small number of masked packages else the script fails so first equery must be installed amd in your /etc/portage/make.conf this line:

ACCEPT_KEYWORDS="~amd64" 

must be added so the masked packages can be installed. The Tilix Terminal doesnt work right now and Redshift too. But i havent removed them from the options yet so firstly check out the package list if its even in their. The init System is zhe Standard i will most likely later on add systemd support.
The series of shell scripts are intended to facilitate installing popular window managers.

Within the install.sh file, you can choose to install the following window managers:

* sway

**User can select between vanilla(non-customized) and completely customized (my personal customization)** 

# Installation

``` 
wget https://github.com/silverhadch/sway-Gentoo/raw/main/install.sh

chmod +x install.sh

./install.sh

rm install.sh

```

Recently, I have been thinking about getting a jump on adding a window manager for Wayland.  Fortunately, there is a good "compositor" for this purpose.
Added scripts:

* nwg-look - installs an lxappearance program to use GTK themes and icons in Wayland.
* rofi-wayland - designed to behave like rofi(xorg) but in Wayland.

NOTE:  The recommended login manager will be gdm3 or sddm.
