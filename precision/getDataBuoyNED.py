import os


bag_name = 'buoy'
folder = ['ekf_vo', 'ukf_vo']


topics = [
"/sensors/buoy_ned",
"/sensors/buoy_raw_ned",
]

filename =  [
"buoy_ned",
"buoy_raw_ned",
]

for i in range(0, len(folder)):		
	for j in range(0, len(topics)):		
		print "(%s / %s) filter                     (%s / %s) topic" %(i,len(bag_name),j,len(topics))
		os.system("rostopic echo -b "+ folder[i] + "/" + bag_name + ".bag -p "+ topics[j] + " > " + folder[i] +"/data/"+ filename[j] + ".txt")
print "Finish"
