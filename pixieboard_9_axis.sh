#!/bin/bash
echo 1 > /sys/devices/virtual/misc/FreescaleAccelerometer/enable
echo 1 > /sys/devices/virtual/misc/FreescaleMagnetometer/enable
echo 1 > /sys/devices/virtual/misc/FreescaleGyroscope/enable

secs=$(perl -e 'print time(), "\n"')
targetsecs=$( expr $secs + 5 )

while [ $secs -lt $targetsecs ]; do
	# accelerometer vector
	a_x=$(( $( i2cget -f -y 1 0x1e 0x01 ) << 8 | $( i2cget -f -y 1 0x1e 0x02 ) ))
	a_y=$(( $( i2cget -f -y 1 0x1e 0x03 ) << 8 | $( i2cget -f -y 1 0x1e 0x04 ) ))
	a_z=$(( $( i2cget -f -y 1 0x1e 0x05 ) << 8 | $( i2cget -f -y 1 0x1e 0x06 ) ))
	# magnetometer vector
	m_x=$(( $( i2cget -f -y 1 0x1e 0x33 ) << 8 | $( i2cget -f -y 1 0x1e 0x34 ) ))
	m_y=$(( $( i2cget -f -y 1 0x1e 0x35 ) << 8 | $( i2cget -f -y 1 0x1e 0x36 ) ))
	m_z=$(( $( i2cget -f -y 1 0x1e 0x37 ) << 8 | $( i2cget -f -y 1 0x1e 0x38 ) ))
	# gyroscope vector
	g_x=$(( $( i2cget -f -y 1 0x20 0x01 ) << 8 | $( i2cget -f -y 1 0x1e 0x02 ) ))
	g_y=$(( $( i2cget -f -y 1 0x20 0x03 ) << 8 | $( i2cget -f -y 1 0x1e 0x04 ) ))
	g_z=$(( $( i2cget -f -y 1 0x20 0x05 ) << 8 | $( i2cget -f -y 1 0x1e 0x06 ) ))

	echo "Gyroscope: x:$g_x  y:$g_y  z:$g_z "
	echo "Accelerometer: x:$a_x  y:$a_y  z:$a_z "
	echo "Magnetometer: x:$m_x  y:$m_y  z:$m_z "
	
	sleep 1
	secs=$(perl -e 'print time(), "\n"')
done

