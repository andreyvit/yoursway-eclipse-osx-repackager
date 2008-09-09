SET	app_name	Eclipse OS X Repackager

FILE	CocoaDialog.zip	-	CocoaDialog.zip	megabox-eclipses
NEWDIR	CocoaDialog.app	temp	CocoaDialog.app	-

VERSION	repackager.cur	repackager	heads/master
VERSION	create-dmg.cur	create-dmg	heads/master

NEWDIR	build.dir	temp	%-build	-

NEWFILE	repackager-core.zip	featured	%.zip	% cross-platform console tool
NEWDIR	repackager.app	temp	%.app	% application bundle
NEWFILE	repackager.dmg	featured	%.dmg	% for Mac OS X


COPYTO	[build.dir]
	INTO	EclipseOSXRepackager	[repackager.cur]/EclipseOSXRepackager
	INTO	EclipseOSXRepackagerUI	[repackager.cur]/EclipseOSXRepackagerUI
	
SUBSTVARS	[build.dir<alter>]/EclipseOSXRepackager	[[]]
SUBSTVARS	[build.dir<alter>]/EclipseOSXRepackagerUI	[[]]

##############################################################################################################
# Cross-platform ZIP
##############################################################################################################

ZIP	[repackager-core.zip]
	INTO	[build-files-prefix]/EclipseOSXRepackager	[build.dir]/EclipseOSXRepackager


##############################################################################################################
# Mac application
##############################################################################################################

UNZIP	[CocoaDialog.zip]	[CocoaDialog.app]
	INTO	/	CocoaDialog.app

INVOKE	platypus
	ARGS	-FD
	ARGS	-a	Eclipse OS X Repackager
	ARGS	-o	None
	ARGS	-p	/bin/bash
	ARGS	-V	[ver]
	ARGS	-f	[build.dir]/EclipseOSXRepackager
	ARGS	-f	[CocoaDialog.app]
	ARGS	-I	org.andreyvit.EclipseOSXRepackager
	ARGS	-c	[build.dir]/EclipseOSXRepackagerUI
	ARGS	[repackager.app]


##############################################################################################################
# Mac DMG
##############################################################################################################

NEWDIR	dmg_temp_dir	temp	%-dmg.tmp	-

COPYTO	[dmg_temp_dir]
	SYMLINK	Applications	/Applications
	INTO	[app_name].app	[repackager.app]

INVOKE	[create-dmg.cur]/create-dmg
	ARGS	--window-size	500	310
	ARGS	--icon-size	96
	ARGS	--background	[repackager.cur]/build/background.gif
	ARGS	--volname	YourSway Eclipse Repackager v.[ver]
	ARGS	--icon	Applications	380	205
	ARGS	--icon	[app_name]	110	205
	ARGS	[repackager.dmg]
	ARGS	[dmg_temp_dir]


##############################################################################################################
# Upload
##############################################################################################################

PUT	megabox-builds	repackager-core.zip
PUT	megabox-builds	repackager.dmg
PUT	megabox-builds	build.log

PUT	s3-builds	repackager-core.zip
PUT	s3-builds	repackager.dmg
PUT	s3-builds	build.log
