#!/bin/bash
set -x
FPCCFG="$1"
CURPATH="$2"
if [[ -z "$FPCCFG" ]]; then FPCCFG=~/.fpc.cfg; fi
if [[ ! -e "$FPCCFG" ]]; then echo '#INCLUDE /etc/fpc.cfg' > $FPCCFG; fi 

if [[ -z "$CURPATH" ]]; then CURPATH=$PWD; fi

echo -Fu$CURPATH/import/flre/src/             >> $FPCCFG
echo -Fu$CURPATH/import/pasdblstrutils/src/   >> $FPCCFG
echo -Fu$CURPATH/import/synapse/              >> $FPCCFG
echo -Fi$CURPATH/internettools/               >> $FPCCFG
echo -Fu$CURPATH/internettools/               >> $FPCCFG
echo -Fu$CURPATH/rcmdline/                    >> $FPCCFG


cat >> $FPCCFG <<EOF
# for cross compiling
-Fu/usr/local/lib/fpc/\$fpcversion/units/\$fpctarget
-Fu/usr/local/lib/fpc/\$fpcversion/units/\$fpctarget/*
-Fu/usr/local/lib/fpc/\$fpcversion/units/\$fpctarget/rtl

-dCOMPILE_SYNAPSE_INTERNETACCESS

#ifdef linux

#ifdef cpui386
-XPi686-linux-gnu-
-Xr/usr/i686-linux-gnu/lib/
-Fl/usr/i686-linux-gnu/lib/
-Fl/usr/lib/gcc-cross/i686-linux-gnu/10/
#endif

#ifdef cpuarm
-XParm-linux-gnueabi-
-Xr/usr/arm-linux-gnueabi/lib/
-Fl/usr/arm-linux-gnueabi/lib/
-Fl/usr/lib/gcc-cross/arm-linux-gnueabi/10
#endif


#ifdef cpuaarch64
-XPaarch64-linux-gnu-
-Xr/usr/aarch64-linux-gnu/lib
-Fl/usr/aarch64-linux-gnu/lib
-Fl/usr/lib/gcc-cross/aarch64-linux-gnu/10/
#endif



#endif
EOF

cp $FPCCFG $FPCCFG.debug
echo '-dDEBUG' >> $FPCCFG.debug
echo '-Crtoi' >> $FPCCFG.debug
echo '-gl' >> $FPCCFG.debug
echo '-O1' >> $FPCCFG.debug

cp $FPCCFG $FPCCFG.release
echo '-dRELEASE' >> $FPCCFG.release
echo '-O4' >> $FPCCFG.release
echo '-Xs' >> $FPCCFG.release
echo '-XX' >> $FPCCFG.release


cat $FPCCFG
