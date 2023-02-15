#!/bin/bash

theme_path=/usr/share/sddm/themes/dark-sddm-theme

echo "Welcome in theme installer"

logos=(
    'Arch Linux'
)
schemes=(
    'Default'
)

# Get favourite logo
echo "Which is your favourite logo?"
i=1
for logo in "${logos[@]}"; do
    echo "($i) $logo"
    let "i=i+1"
done

echo -n "==> "
read image
if (( $image < 1 || $image > ${#logos[@]} ))
then
	echo "Wrong selection. Aborting..."
	exit 1
fi

# Get favourite scheme
echo "Which is your favourite scheme?"
i=1
for scheme in "${schemes[@]}"; do
    echo "($i) $scheme"
    let "i=i+1"
done
echo -n "==> "
read scheme
if (( $scheme < 1 || $scheme > ${#schemes[@]} ))
then
    echo "Wrong selection. Aborting..."
    exit 1
fi

# Install it
sudo rm -rf $theme_path 2> /dev/null
sudo mkdir -p $theme_path 2> /dev/null
sudo cp -r base/* $theme_path

# Install selected logo
case $image in
	1) sudo cp options/logo/arch.png $theme_path/resources/logo.png ;;
	*) echo "Unexpected error!"; exit 1 ;;
esac

# Install scheme
case $scheme in
    1) sudo cp options/scheme/default.qml $theme_path/Main.qml ;;
    *) echo "Unexpected error!"; exit 1 ;;
esac


echo "Theme has been copied to /usr/share/sddm/themes/"
echo "Apply the theme by editing /etc/sddm.conf.d/default.conf"

exit 0
