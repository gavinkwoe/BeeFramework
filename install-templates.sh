#!/bin/bash

echo 'beeframework-ios template installer'

BEE_IOS_VER='beeframework-ios 0.3-beta2'
SCRIPT_DIR=$(dirname $0)

BEE_IOS_DST_DIR='beeframework-ios v0.x'

force=

usage(){
cat << EOF
usage: $0 [options]
 
Install / update templates for ${BEE_IOS_VER}
 
OPTIONS:
   -f	force overwrite if directories exist
   -h	this help
EOF
}

while getopts "fhu" OPTION; do
	case "$OPTION" in
		f)
			force=1
			;;
		h)
			usage
			exit 0
			;;
		u)
			;;
	esac
done

# Make sure root is not executed
if [[ "$(id -u)" == "0" ]]; then
	echo ""
	echo "Error: Do not run this script as root." 1>&2
	echo ""
	echo "'root' is no longer supported" 1>&2
	echo ""
	echo "RECOMMENDED WAY:" 1>&2
	echo " $0 -f" 1>&2
	echo ""
exit 1
fi


copy_files(){
    SRC_DIR="${SCRIPT_DIR}/${1}"
	rsync -r --exclude=.svn "$SRC_DIR" "$2"
}

check_dst_dir(){
	if [[ -d $DST_DIR ]];  then
		if [[ $force ]]; then
			echo "removing old libraries: ${DST_DIR}"
			rm -rf "$DST_DIR"
		else
			echo "templates already installed. To force a re-install use the '-f' parameter"
			exit 1
		fi
	fi
	
	echo ...creating destination directory: $DST_DIR
	mkdir -p "$DST_DIR"
}

copy_beeframework_files(){
	echo ...copying Beeframework files
	copy_files BeeFramework "$LIBS_DIR"
}

copy_beedebuger_files(){
	echo ...copying BeeDebugger files
	copy_files BeeDebugger "$LIBS_DIR"
}

copy_beetemplates_files(){
	echo ...copying BeeTemplates files
	copy_files BeeTemplates "$LIBS_DIR"
}

print_template_banner(){
	echo ''
	echo ''
	echo ''
	echo "$1"
	echo '----------------------------------------------------'
	echo ''
}

# BeeDebugger
# BeeFramework
# BeeTemplates
# Example/Lessons
# External
# BeeUnitTest


# lib_beeframework.xctemplate



# Xcode4 templates
copy_xcode4_project_templates(){
	TEMPLATE_DIR="$HOME/Library/Developer/Xcode/Templates/$BEE_IOS_DST_DIR/"

	print_template_banner "Installing Xcode 4 Beeframework iOS template"

	DST_DIR="$TEMPLATE_DIR"
    check_dst_dir

	# copy_beeframework_files
	LIBS_DIR="$DST_DIR""lib_beeframework.xctemplate/libs/"
	mkdir -p "$LIBS_DIR"
	copy_beeframework_files

	# BeeDebugger
	LIBS_DIR="$DST_DIR""lib_beedebugger.xctemplate/libs/"
	mkdir -p "$LIBS_DIR"
	copy_beedebuger_files

	# BeeTemplates
	LIBS_DIR="$DST_DIR""lib_beetemplates.xctemplate/libs/"
	mkdir -p "$LIBS_DIR"
	copy_beetemplates_files

	echo ...copying template files
	copy_files templates/Xcode4_templates/ "$DST_DIR"

	echo done!

	# External
	# - asi
	# - fmdb
	# - jsonkit
	# - reachabilitiy
	# - touchXML
	print_template_banner "Installing Xcode 4 ASI iOS template"
	LIBS_DIR="$DST_DIR""lib_asi.xctemplate/libs/"
    mkdir -p "$LIBS_DIR"
	echo ...copying ASI files
	copy_files External/ASI "$LIBS_DIR"
	echo done!
	
	print_template_banner "Installing Xcode 4 fmdb iOS template"
	LIBS_DIR="$DST_DIR""lib_fmdb.xctemplate/libs/"
	mkdir -p "$LIBS_DIR"
	echo ...copying fmdb files
	copy_files External/FMDB "$LIBS_DIR"
	echo done!
	

	print_template_banner "Installing Xcode 4 jsonkit iOS template"
	LIBS_DIR="$DST_DIR""lib_jsonkit.xctemplate/libs/"
	mkdir -p "$LIBS_DIR"
	echo ...copying jsonkit files
	copy_files External/JSONKit "$LIBS_DIR"
	echo done!
	
	print_template_banner "Installing Xcode 4 reachabilitiy iOS template"
	LIBS_DIR="$DST_DIR""lib_reachabilitiy.xctemplate/libs/"
	mkdir -p "$LIBS_DIR"
	echo ...copying reachabilitiy files
	copy_files External/Reachability "$LIBS_DIR"
	echo done!
	
	print_template_banner "Installing Xcode 4 touchXML iOS template"
	LIBS_DIR="$DST_DIR""lib_touchXML.xctemplate/libs/"
	mkdir -p "$LIBS_DIR"
	echo ...copying touchXML files
	copy_files External/TouchXML "$LIBS_DIR"
	echo done!
	
	
	print_template_banner "Installing Xcode 4 Examples Lessons iOS template"
	LIBS_DIR="$DST_DIR""lib_examples.xctemplate/libs/"
	mkdir -p "$LIBS_DIR"
	echo ...copying touchXML files
	copy_files Example/Lessons "$LIBS_DIR"
	echo done!

	# Move File Templates to correct position
	DST_DIR="$HOME/Library/Developer/Xcode/Templates/File Templates/$BEE_IOS_DST_DIR/"
	OLD_DIR="$HOME/Library/Developer/Xcode/Templates/$BEE_IOS_DST_DIR/"
	
	print_template_banner "Installing Xcode 4 CCNode file templates..."

	check_dst_dir
	
	mv -f "$OLD_DIR""/CCNode class.xctemplate" "$DST_DIR"
	
	echo done!
}

# copy Xcode4 templates
copy_xcode4_project_templates

