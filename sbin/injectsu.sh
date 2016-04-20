#!/system/bin/sh

mount -o remount,rw /system

if [ ! -f /system/xbin/su ]; then
	#make necessary folders
	mkdir /system/etc/init.d

	#extract SU from ramdisk to correct locations
	rm -rf /system/bin/app_process
	rm -rf /system/bin/install-recovery.sh
	cp /sbin/su/supolicy /system/xbin/
	cp /sbin/su/su /system/xbin/
	cp /sbin/su/chattr /system/xbin/
	cp /sbin/su/chattr.pie /system/xbin/
	cp /sbin/su/libsupol.so /system/lib/
	cp /sbin/su/install-recovery.sh /system/etc/
	cp /sbin/su/init.sec.boot.sh /system/etc/
#	cp /sbin/su/99SuperSUDaemon /system/etc/init.d/

	#begin supersu install process
	cp /system/xbin/su /system/xbin/daemonsu
	cp /system/xbin/su /system/xbin/sugote
	cp /system/bin/sh /system/xbin/sugote-mksh
	mkdir -p /system/bin/.ext
	cp /system/xbin/su /system/bin/.ext/.su

	cp /system/bin/app_process32 /system/bin/app_process_init
	mv /system/bin/app_process32 /system/bin/app_process32_original

	echo 1 > /system/etc/.installed_su_daemon

	chmod 755 /system/xbin/su
	chmod 755 /system/xbin/daemonsu
	chmod 755 /system/xbin/sugote
	chmod 755 /system/xbin/sugote-mksh
	chmod 755 /system/xbin/supolicy
	chmod 755 /system/xbin/chattr
	chmod 755 /system/xbin/chattr.pie
	chmod 777 /system/bin/.ext
	chmod 755 /system/bin/.ext/.su
	chmod 755 /system/bin/app_process_init
	chmod 755 /system/bin/app_process32_original
	chmod 644 /system/lib/libsupol.so
	chmod 755 /system/etc/install-recovery.sh
	chmod 644 /system/etc/.installed_su_daemon
	chmod 755 /system/etc/init.d
	chmod 755 /system/etc/init.d/*
	chmod 644 /system/etc/init.sec.boot.sh
	chmod 755 /system/app/SuperSU
	chmod 644 /system/app/SuperSU/SuperSU.apk
	
	ln -s /system/etc/install-recovery.sh /system/bin/install-recovery.sh
	ln -s /system/xbin/daemonsu /system/bin/app_process
	ln -s /system/xbin/daemonsu /system/bin/app_process32

	/system/xbin/su --install
fi

#enforce init.d script perms on any post-root added files
chmod 755 /system/etc/init.d
chmod 755 /system/etc/init.d/*

#inject busybox if not present
if [ ! -f /system/xbin/busybox ]; then
	cp /sbin/busybox /system/xbin/
	chmod 755 /system/xbin/busybox
	/system/xbin/busybox --install -s /system/xbin
fi

