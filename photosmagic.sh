#! /usr/bin/env /bin/bash
# Optimize and clean every jpg, JPG, jpeg, JPEG, png, PNG photos of a directory.
# Warning: Can run for hours if the number of photos is too big!

log=/tmp/$(basename $0).log
clear
echo -e "${yellow}Photos magic : in $(pwd)${white}" | tee -a $log
echo -e "${cyan}Currently weighting:${white} $(du -kh)" | tee -a $log
du -kh > du.log~


echo -e "${red}Working with :${black}" | tee -a $log
find ./ -type f -iname '*'.jpeg -o -iname '*'.jpg -o -iname '*'.png | tee -a $log

# FIXME
echo -e "${white}Sure ?"
read

# FIXME do an option here
#simulate_jpeg="--noaction"
#simulate_png="-simulate"

time (
	echo -e "${red}Smoothing names...${white}" | tee -a $log
	Smooth_Name.sh
	read
	echo -e "${red}Compressing all JPEG (*.jpe?g, *.JPE?G) pictures....${white}" | tee -a $log
	( time jpegoptim $simulate_jpeg --max=100 --strip-all --size=50% --threshold=25% --verbose --total $(find ./ -type f -iname '*'.jpeg -o -iname '*'.jpg 2>$log ) ) | tee -a $log
	read
	echo -e "${red}Compressing all PNG (*.png, *.PNG) pictures....${white}" | tee -a $log
	# time ( for i in $(find ./ -type f -iname '*'.png 2>$log ); do
	( time optipng $simulate_png -preserve -o1 $(find ./ -type f -iname '*'.png 2>$log ) ) | tee -a $log
	read
	# done )
	echo -e "${red}Generating glisse index.html...${white}" | tee -a $log
	generateglisse.sh 
) && ( alert ; clear ; notify-send "$(basename $0)" "Done." )


# Comparison of the size
du -kh > du.log
tail -n1 du.log~ > /tmp/du.log~
tail -n1 du.log > /tmp/du.log
echo -e "Size before | size after"
diff -y /tmp/du.log~ /tmp/du.log