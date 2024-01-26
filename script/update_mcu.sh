#!/bin/bash

#chmod u+x /home/biqu/printer_data/config/script/update_mcu.sh

#mkdir ~/firmware

#sudo service klipper stop

cd ~/klipper
make clean
#make menuconfig KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.manta723.CAN
make -j4 KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.manta723.CAN
mv ~/klipper/out/klipper.bin ~/firmware/manta_klipper.bin

make clean
#make menuconfig KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.ebb36.CAN
make -j4 KCONFIG_CONFIG=/home/biqu/printer_data/config/script/config.ebb36.CAN
mv ~/klipper/out/klipper.bin ~/firmware/ebb36_klipper.bin

cd ~/katapult/scripts
# Update MCU Manta M8P
echo "Start update MCU Manta M8P"
echo ""
python3 flash_can.py -i can0 -u ae4b3775ca3f -f ~/firmware/manta_klipper.bin
python3 flash_can.py -f ~/firmware/manta_klipper.bin -d /dev/serial/by-id/usb-katapult_stm32h723xx_390025000D51313236343430-if00
sleep 2
read -p "MCU Manta M5P firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
echo "Finish update MCU Manta M8P"

# Update MCU EBB36
echo "Start update MCU EBB36"
echo ""
python3 flash_can.py -i can0 -u 28c5348109be -f ~/firmware/ebb36_klipper.bin
sleep 2
#read -p "MCU EBB36 firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
echo "Finish update MCU EBB36"

echo ""

#sudo service klipper start
