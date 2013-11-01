include ../module.mk

module: thttpd.so bootfs.manifest usr.manifest

thttpd-objects = thttpd.o libhttpd.o fdwatch.o mmc.o timers.o match.o tdate_parse.o

define thttpd-includes
endef

cflags-thttpd-include = $(foreach path, $(strip $(thttpd-includes)), -isystem $(src)/$(path))

$(thttpd-objects): local-includes += $(cflags-thttpd-include)
$(thttpd-objects): post-includes-bsd =
$(thttpd-objects): kernel-defines =
$(thttpd-objects): CFLAGS += -Wno-unknown-pragmas -DHAVE__PROGNAME=1 -DHAVE_FCNTL_H=1 -DHAVE_GRP_H=1 -DHAVE_MEMORY_H=1 -DHAVE_PATHS_H=1 -DHAVE_POLL_H=1 -DHAVE_SYS_POLL_H=1 -DTIME_WITH_SYS_TIME=1 -DHAVE_DIRENT_H=1 -DHAVE_LIBCRYPT=1 -DHAVE_STRERROR=1 -DHAVE_WAITPID=1 -DHAVE_VSNPRINTF=1 -DHAVE_DAEMON=1 -DHAVE_GETADDRINFO=1 -DHAVE_GETNAMEINFO=1 -DHAVE_GAI_STRERROR=1 -DHAVE_ATOLL=1 -DHAVE_UNISTD_H=1 -DHAVE_GETPAGESIZE=1 -DHAVE_MMAP=1 -DHAVE_SELECT=1 -DHAVE_POLL=1 -DHAVE_TM_GMTOFF=1 -DHAVE_INT64T=1 -DHAVE_SOCKLENT=1 

thttpd.so: $(thttpd-objects)
	$(makedir)
	$(q-build-so)

mime_encodings.h:	mime_encodings.txt
	rm -f mime_encodings.h
	sed < mime_encodings.txt > mime_encodings.h \
	  -e 's/#.*//' -e 's/[ 	]*$$//' -e '/^$$/d' \
	  -e 's/[ 	][ 	]*/", 0, "/' -e 's/^/{ "/' -e 's/$$/", 0 },/'

mime_types.h:	mime_types.txt
	rm -f mime_types.h
	sed < mime_types.txt > mime_types.h \
	  -e 's/#.*//' -e 's/[ 	]*$$//' -e '/^$$/d' \
	  -e 's/[ 	][ 	]*/", 0, "/' -e 's/^/{ "/' -e 's/$$/", 0 },/'

thttpd.o:	config.h version.h libhttpd.h fdwatch.h mmc.h timers.h match.h
libhttpd.o:	config.h version.h libhttpd.h mime_encodings.h mime_types.h \
		mmc.h timers.h match.h tdate_parse.h
fdwatch.o:	fdwatch.h
mmc.o:		mmc.h libhttpd.h
timers.o:	timers.h
match.o:	match.h
tdate_parse.o:	tdate_parse.h

bootfs.manifest: thttpd.so
	echo "/thttpd.so: module/osv-thttpd/thttpd.so" > $@

usr.manifest:
	echo "" > $@
