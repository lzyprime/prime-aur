#!/bin/bash

# This is a default template for a post-install scriptlet.
# Uncomment only required functions and remove any functions
# you don't need (and this header).

## arg 1:  the new package version
#pre_install() {
	# do something here
#}

## arg 1:  the new package version
post_install() {
	for theme in /usr/share/grub/themes/prime-themes/*; do
		update-alternatives --install /usr/share/grub/themes/prime-grub-theme prime-grub-theme "$theme" 20
	done
	sed -i "/GRUB_THEME/d" /etc/default/grub 2>/dev/null || true
	echo "GRUB_THEME=/usr/share/grub/themes/prime-grub-theme/theme.txt" >> /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
}

## arg 1:  the new package version
## arg 2:  the old package version
#pre_upgrade() {
	# do something here
#}

## arg 1:  the new package version
## arg 2:  the old package version
#post_upgrade() {
	# do something here
#}

## arg 1:  the old package version
pre_remove() {
	update-alternatives --remove-all prime-grub-theme
	sed -i '/GRUB_THEME/d' /etc/default/grub || true
	grub-mkconfig -o /boot/grub/grub.cfg
}

## arg 1:  the old package version
#post_remove() {
	# do something here
#}
