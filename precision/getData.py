import os


bag_name = ['2_ukf_vo']


topics = [
"/control/trajectory_path",
"/control/waypoint_marker",
"/ekf_map/odometry",
"/ekf_odom/odometry",
"/orb_tracker/altitude",
"/orb_tracker/odometry",
"/sensors/buoy",
"/sensors/buoy_raw",
"/sensors/dvl",
"/sensors/dvl_altitude",
"/sensors/dvl_raw",
"/sensors/gps",
"/sensors/gps_raw",
"/sensors/imu",
"/sensors/imu_data",
"/sensors/imu_raw",
"/sensors/modem",
"/sensors/modem_delayed",
"/sensors/modem_delayed_acoustic",
"/sensors/modem_position_delay",
"/sensors/modem_raw",
"/sensors/modem_used_positions_per",
"/sensors/usblangles",
"/sensors/usbllong",
"/sensors/vo_raw",
]

filename =  [
"path",
"waypoint",
"map",
"odom",
"orb_altitude",
"orb_odometry",
"buoy",
"buoy_raw",
"dvl",
"dvl_altitude",
"dvl_raw",
"gps",
"gps_raw",
"imu",
"imu_data",
"imu_raw",
"modem",
"modem_delayed",
"modem_delayed_acoustic",
"modem_position_delay",
"modem_raw",
"modem_used_positions_per",
"usblangles",
"usbllong",
"vo_raw",
]

for i in range(0, len(bag_name)):		
	for j in range(0, len(topics)):		
		print "(%s / %s) filter                     (%s / %s) topic" %(i,len(bag_name),j,len(topics))
		os.system("rostopic echo -b "+ bag_name[i] + "/" + bag_name[i] + ".bag -p "+ topics[j] + " > " + bag_name[i] +"/data/"+ filename[j] + ".txt")
print "Finish"
