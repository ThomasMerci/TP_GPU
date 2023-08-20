#!/bin/bash
export DATA_TP_TOMOGPI="/partage/public/ngac/TomoGPI/data_TP_TomoGPI/"
if [ ! -d "/tmp/data_TP_TomoGPI/data3D_0256" ] 
then
  	cp -r "$DATA_TP_TOMOGPI" /tmp
fi
export CURRENTDIR='pwd'
export TOMO_GPI=/partage/public/ngac/TomoGPI
export MATLABPATH=$TOMO_GPI/Matlab/Tomo8:$MATLABPATH
export MATLABPATH=$TOMO_GPI/build:$MATLABPATH
export MATLABPATH=$CURRENT_DIR:$MATLABPATH
export PATH=$TOMO_GPI/build/:$PATH
alias matlab_TomoGPI='LD_PRELOAD=/usr/lib/gcc/x86_64-linux-gnu/8/libstdc++.so matlab'
cd /tmp/data_TP_TomoGPI/data3D_0128/phantom3D_0006_shepp/
matlab_TomoGPI &
#matlab &
