#! /usr/bin/env /bin/bash
# By: Lilian BESSON
# Email: Lilian.BESSON[AT]ens-cachan[DOT]fr
# Date: 09-12-2014
#
# photosmagic.sh, a small tool to optimize and clean every jpg, JPG, jpeg, JPEG, png, PNG photos of a directory.
#
# Warning: Can run for hours if the number of photos is too big!
# Warning: should not be ran twice on the same photos (optimizing an optimize photo reduces significantly the quality!).
#
# Online: https://bitbucket.org/lbesson/bin/src/master/photosmagic.sh
#
# Licence: [GPLv3](http://besson.qc.to/LICENCE.html)
version='0.4'

log=/tmp/$(basename $0).log
logjpeg=/tmp/$(basename $0)_jpeg.log
logpng=/tmp/$(basename $0)_png.log

clear
echo -e "${yellow}Photos magic : in $(pwd) ($(date))${white}" | tee $log
echo -e "${cyan}Currently weighting:${white} $(du -kh)" | tee -a $log
du -kh > du.log~

echo -e "${red}Working with :${black}" | tee -a $log
find ./ -type f -iname '*'.jpeg -o -iname '*'.jpg -o -iname '*'.png | tee -a $log

echo -e "${white}Sure ?"
# FIXME
# read

# FIXME do an option here
#simulate_jpeg="--noaction"
#simulate_png="-simulate"

time (
	echo -e "${red}Smoothing names...${white}" | tee -a $log
	Smooth_Name.sh
	notify-send "$(basename $0)" "I am done <b>smoothing the name</b> (in $(pwd))."
	# read
	echo -e "${red}Compressing all JPEG (*.jpe?g, *.JPE?G) pictures....${white}" | tee -a $log
	( time jpegoptim $simulate_jpeg --max=85 --strip-all --size=50% --threshold=25% --verbose --total $(find ./ -type f -iname '*'.jpeg -o -iname '*'.jpg 2>$logjpeg ) ) | tee -a $log
	notify-send "$(basename $0)" "I am done <b>compressing all JPEG pictures</b> (in $(pwd))."
	# read
	echo -e "${red}Compressing all PNG (*.png, *.PNG) pictures....${white}" | tee -a $log
	# # time ( for i in $(find ./ -type f -iname '*'.png 2>$log ); do
	( time optipng $simulate_png -preserve $(find ./ -type f -iname '*'.png 2>$logpng ) ) | tee -a $log
	notify-send "$(basename $0)" "I am done <b>compressing all PNG pictures</b> (in $(pwd))."
	# read
	# # done )
	echo -e "${red}Generating glisse index.html...${white}" | tee -a $log
	generateglisse.sh | tee -a $log
	notify-send "$(basename $0)" "I am done <b>generating glisse index.html</b> (in $(pwd))."
) && ( alert ; clear ; notify-send "$(basename $0)" "And now I am completely done :)" )


# Comparison of the size
du -kh > du.log
tail -n1 du.log~ > /tmp/du.log~
tail -n1 du.log > /tmp/du.log
echo -e "${red}Size before | Size after${cyan}" | tee -a $log
rm -vf du.log~
diff -y /tmp/du.log~ /tmp/du.log
echo -e "${white}\n\nDone :)" | tee -a $log
