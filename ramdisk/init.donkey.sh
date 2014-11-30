#!/system/bin/sh
# Copyright (c) 2014, DonkeyKang <fermasia@hotmail.com>
# Copyright (c) 2009-2014, The Linux Foundation. All rights reserved.
#
#!/sbin/bbx sh
#
# Checks for power hal and makes a backup
#

# Interactive tunables;
echo 30000 1094000:40000 1190000:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo 85 1094000:80 1190000:95 > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo 30000 1094000:20000 1190000:10000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
echo 50000 1094000:30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack

# Disable PoweHAL from the rom-side;
/sbin/bbx mount -o rw,remount /system;
if /sbin/bbx [ -e /system/lib/hw/power.msm8226.so ]; then
  /sbin/bbx [ -e /system/lib/hw/power.msm8226.so.backup ] || /sbin/bbx cp /system/lib/hw/power.msm8226.so /system/lib/hw/power.msm8226.so.backup;
  /sbin/bbx [ -e /system/lib/hw/power.msm8226.so ] && /sbin/bbx rm -f /system/lib/hw/power.msm8226.so;
fi;

# Enable powersuspend
if [ -e /sys/kernel/power_suspend/power_suspend_mode ]; then
	echo "1" > /sys/kernel/power_suspend/power_suspend_mode
	echo "Powersuspend enabled" | tee /dev/kmsg
else
	echo "Failed to set powersuspend" | tee /dev/kmsg

# Enable init.d with permissions;
if /sbin/bbx [ ! -e /system/etc/init.d ]; then
  /sbin/bbx mkdir /system/etc/init.d;
  /sbin/bbx chown -R root.root /system/etc/init.d;
  /sbin/bbx chmod -R 755 /system/etc/init.d;
fi;
/sbin/bbx mount -o ro,remount /system;

# Setting DEFAULTS
echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 
echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo "192000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "192000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo "192000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo "192000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
echo "55" > /sys/kernel/hotplug_control/all_cpus_threshold
echo "6" > /sys/kernel/hotplug_control/hotplug_sampling

