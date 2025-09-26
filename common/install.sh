sel_res() {
	unset SIZE
	ui_print "-> 1080x1920"
	if chooseport; then
		SIZE=1080x1920
	fi
	if [[ -z $SIZE ]]; then
		ui_print "-> 1080x2408"
		if chooseport; then
			SIZE=1080x2408
		fi
	fi
	if [[ -z $SIZE ]]; then
		ui_print "-> No valid choice, using 1080x1920"
		SIZE=1080x1920
	fi
}

sel_fps() {
	unset FPS
	ui_print "-> 25"
	if chooseport; then
		FPS=25
	fi
	if [[ -z $FPS ]]; then
		ui_print "-> 30"
		if chooseport; then
			FPS=30
		fi
	fi
	if [[ -z $FPS ]]; then
		ui_print "-> 60"
		if chooseport; then
			FPS=60
		fi
	fi
	if [[ -z $FPS ]]; then
		ui_print "-> 90"
		if chooseport; then
			FPS=90
		fi
	fi
	if [[ -z $FPS ]]; then
		ui_print "-> 120"
		if chooseport; then
			FPS=120
		fi
	fi
	if [[ -z $FPS ]]; then
		ui_print "-> No valid choice, using 25"
		FPS=25
	fi
}

sel_type() {
	unset TYPE
	unset SRCDIR
	ui_print "-> 1) Normal Nethunter"
	if chooseport; then
		TYPE=1
		SRCDIR="$MODPATH/common/src"
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> 2) Burning NetHunter"
		if chooseport; then
			TYPE=2
			SRCDIR="$MODPATH/common/src_mk"
		fi
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> 3) New Kali Boot"
		if chooseport; then
			TYPE=3
			SRCDIR="$MODPATH/common/src_kali"
		fi
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> 4) ct-OS"
		if chooseport; then
			TYPE=4
			SRCDIR="$MODPATH/common/src_ctos"
		fi
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> No valid choice, using ct-OS"
		TYPE=4
		SRCDIR="$MODPATH/common/src_ctos"
	fi
}

#sel_conv() {
#	unset CONVERT
#	ui_print "-> No"
#	if chooseport; then
#		CONVERT="n"
#	fi
#	if [[ -z $CONVERT ]]; then
#		ui_print "-> Yes"
#		if chooseport; then
#			CONVERT="y"
#		fi
#	fi
#	if [[ -z $TYPE ]]; then
#		ui_print "-> No valid choice, converting"
#		CONVERT="y"
#	fi
#}

finish() {
# // converting doesn't work on android //
# // without extra binaries //

#	cd $TMPDIR
#	if [ "$CONVERT" == "y" ]; then
#		mkdir -p new/part0
#		mkdir -p new/part1
#		if [ "$TYPE" == "1" ] || [ "$TYPE" == "3" ]; then
#			mkdir -p new/part2;
#		fi
#		ui_print "[i] Converting images.."
#		for i in {0000..0100}; do
#			convert -resize $SIZE $SRCDIR/part0/$i.jpg new/part0/$i.jpg >/dev/null 2>&1;
#		done
#		ui_print "[+] part0 done"
#		for i in {0000..0200}; do
#			convert -resize $SIZE $SRCDIR/part1/$i.jpg new/part1/$i.jpg >/dev/null 2>&1;
#		done
#		ui_print "[+] part1 done"
#		if [ "$TYPE" == "1" ] || [ "$TYPE" == "3" ]; then
#			for i in {0000..0300}; do
#				convert -resize $SIZE $SRCDIR/part2/$i.jpg new/part2/$i.jpg >/dev/null 2>&1;
#			done
#			ui_print "[+] part2 done"
#		fi
#		ui_print "[+] Convert done"
#	else
#		ui_print "[i] Adding source parts.."
#		mkdir new
#		cp -r $SRCDIR/part* new/
#		ui_print "[+] parts copied"
#	fi

	ui_print "[i] Adding source parts.."
	mkdir new
	cp -r $SRCDIR/part* new/
	ui_print "[+] parts copied"
	cp $SRCDIR/desc.txt new/
	sed -i "1s/.*/$SIZE $FPS/" new/desc.txt
	sed -i 's/x/ /g' new/desc.txt
	ui_print "[+] Setting resolution and fps in desc "
	cd new
	zip -0 -FSr -q ../bootanimation.zip *
	mkdir -p $MODPATH/system/media
	cp_ch ../bootanimation.zip $MODPATH/system/media/bootanimation.zip
	ui_print "[+] bootanimation.zip succesfully installed"
	cd ..
	rm -r new
}

# default values
export TYPE=4
export SIZE=1080x1920
export FPS=25
# export CONVERT="n"
export SRCDIR="$MODPATH/common/src_ctos"

ui_print " "
ui_print "  ██████╗████████╗ ██████╗ ███████╗"
ui_print " ██╔════╝╚══██╔══╝██╔═══██╗██╔════╝"
ui_print " ██║        ██║   ██║   ██║███████╗"
ui_print " ██║        ██║   ██║   ██║╚════██║"
ui_print " ╚██████╗   ██║   ╚██████╔╝███████║"
ui_print "  ╚═════╝   ╚═╝    ╚═════╝ ╚══════╝"
ui_print "            [ c t O S ]"
ui_print " "
ui_print "|| NetHunter bootanimation install script ||"
ui_print "     || by yesimxev and fluffball3 ||"
ui_print " "
ui_print " "
ui_print "Default options are: ct-OS, 1080x1920, 25fps"
ui_print "Do you want to change them?"
ui_print "-> No"
if chooseport; then
	finish
else
	ui_print "Please select from the following styles"
	sel_type
	ui_print " "
	ui_print "Please enter the target resolution"
	sel_res
	ui_print " "
	ui_print "Please enter the target fps. Higher values than 30 might look weird"
	sel_fps
	ui_print " "
#	ui_print "Do you need the images to be converted? Select no if unsure"
#	sel_conv
#	ui_print " "
	finish
fi
