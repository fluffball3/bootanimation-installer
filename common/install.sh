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
		ui_print "-> 1440x2560"
		if chooseport; then
			SIZE=1440x2560
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
		ui_print "-> No valid choice, using 60"
		FPS=60
	fi
}

sel_type() {
	unset TYPE
	unset SRCDIR
	unset SIZE
	unset FPS
	unset FINISHED
	ui_print "-> 1) Normal Nethunter"
	if chooseport; then
		SRCDIR="$MODPATH/common/src"
		SIZE=1440x2560
		FPS=30
		TYPE=1
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> 2) Burning NetHunter"
		if chooseport; then
			SRCDIR="$MODPATH/common/src_mk"
			SIZE=1080x1920
			FPS=60
			TYPE=2
		fi
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> 3) New Kali Boot"
		if chooseport; then
			SRCDIR="$MODPATH/common/src_kali"
			SIZE=1080x1920
			FPS=60
			TYPE=3
		fi
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> 4) ct-OS"
		if chooseport; then
			SRCDIR="$MODPATH/common/src_ctos"
			SIZE=1080x1920
			FPS=30
			TYPE=4
		fi
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> 5) Import Custom"
		if chooseport; then
			SRCDIR="$MODPATH/common/src_custom"
			SIZE=1080x1920
			FPS=30
			TYPE=5
			FINISHED=1
			cp_ch $SRCDIR/bootanimation.zip $MODPATH/system/media/bootanimation.zip || unset FINISHED
			if [[ -z $FINISHED ]]; then
				FINISHED=1
				cp_ch $SRCDIR/system/media/bootanimation.zip $MODPATH/system/media/bootanimation.zip || unset FINISHED
			fi
		fi
	fi
	if [[ -z $TYPE ]]; then
		ui_print "-> No valid choice, using ct-OS"
		SRCDIR="$MODPATH/common/src_ctos"
		SIZE=1080x1920
		FPS=30
		TYPE=4
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
	cp -r $SRCDIR/part* new/ || ui_print "Custom directory empty! Make sure animations are imported then try again"
	ui_print "[+] parts copied"

	cp $SRCDIR/desc.txt new/
	if [ "$TYPE" != "5" ] || [ "$CHANGEANYWAY" == "1" ]; then
		sed -i "1s/.*/$SIZE $FPS/" new/desc.txt
		sed -i 's/x/ /g' new/desc.txt
		ui_print "[+] Setting resolution and fps in desc "
	fi

	cd new
	chmod -R 0755 $MODPATH/common/addon/magisk-zip-binary/zip-arm64
	$MODPATH/common/addon/magisk-zip-binary/zip-arm64 -0 -FSr -q ../bootanimation.zip *
	mkdir -p $MODPATH/system/media
	cp_ch ../bootanimation.zip $MODPATH/system/media/bootanimation.zip
	ui_print "[+] bootanimation.zip succesfully installed"
	cd ..
	rm -r new
}

# default values
export SRCDIR="$MODPATH/common/src_ctos"
export SIZE=1080x1920
export FPS=30
export TYPE=4
export CHANGEANYWAY
export FINISHED
# export CONVERT

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
ui_print "Build default option ct-OS?"
ui_print "-> Yes"
if chooseport; then
	finish
else
	ui_print "Please select from the following styles"
	sel_type
	ui_print " "
	if [ "$FINISHED" == "1" ]; then
		ui_print "[+] bootanimation.zip detected...."
		ui_print "[+] bootanimation.zip succesfully installed"
	else
		if [ "$TYPE" == "5" ]; then
			ui_print "Changing values of custom animations might result in worse quality"
			ui_print "Do you wish to change them?"
			ui_print "-> No"
		else
			ui_print "Use default values? (recommended)"
			ui_print "-> Yes"
		fi
		ui_print " "
		if chooseport; then
			if [ "$TYPE" == "5" ]; then
				CHANGEANYWAY=1
				finish
			fi
		else
			ui_print "Please enter the target resolution"
			sel_res
			ui_print " "
			ui_print "Please enter the target fps. Higher values than 60 might look weird"
			sel_fps
			ui_print " "
#			ui_print "Do you need the images to be converted? Select no if unsure"
#			sel_conv
#			ui_print " "
			finish
		fi
	fi
fi

