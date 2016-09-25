import numpy as np
import matplotlib.pyplot as plt

# Vars
plt_traj = 1
plt_error = 0
plt_traj_boxes = 0
plt_boxes = 0

filename =  ["odometry",
		  "map",
		  "ros_odom_to_pat",
		  "modem_raw",
		  "error_modem_raw",
		  "error_ekf_odom",
		  "error_ekf_map",
		  ]

trajectories = 4

# Functions
def plotTraj(gt, ekfodom, ekfmap, modem_raw):
	fig = plt.figure(1)
	fig.suptitle('Trajectory %s / %s' %(i+1, trajectories), fontsize=14, fontweight='bold')
	plt.subplot(121)
	plt.plot(gt[:,1], gt[:,2], 'k', label= 'GT')
	plt.plot(ekfodom[:,1], ekfodom[:,2], 'r', label= 'odom')
	plt.plot(ekfmap[:,1], ekfmap[:,2], 'g', label= 'map')
	plt.plot(modem_raw[:,1], modem_raw[:,2], 'b', label= 'usbl')
	legend = plt.legend()

	time = gt[:,0]*10e-9
	time = [x-time[0] for x in time]
	plt.subplot(222)
	plt.plot(time, gt[:,1], 'k', ekfodom[:,0], ekfodom[:,1], 'r', ekfmap[:,0], ekfmap[:,1], 'g', modem_raw[:,0], modem_raw[:,1], 'b')

	plt.subplot(224)
	plt.plot(time, gt[:,2], 'k', ekfodom[:,0], ekfodom[:,2], 'r', ekfmap[:,0], ekfmap[:,2], 'g',modem_raw[:,0], modem_raw[:,2], 'b')
	plt.show()

def plotError(time, error_raw, error_ekfodom, error_ekfmap):
	fig = plt.figure(1)
	fig.suptitle('Trajectory Error %s / %s' %(i+1, trajectories), fontsize=14, fontweight='bold')
	plt.plot(time, error_ekfodom, 'r', label= 'odom')
	plt.plot(time, error_ekfmap, 'g', label= 'map')
	plt.plot(time, error_raw, 'b', label= 'usbl')
	legend = plt.legend()
	plt.show()


def plotBoxes(error_raw, error_ekfodom, error_ekfmap):
	# Plot Trajectory
	fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, 5))
	# rectangular box plot
	bplot = axes[0].boxplot([error_raw, error_ekfodom, error_ekfmap],
	                         vert=True,   # vertical box aligmnent
	                         patch_artist=True)   # fill with color

	# fill with colors
	colors = ['pink', 'lightblue', 'lightgreen']
	
	for patch, color in zip(bplot['boxes'], colors):
		patch.set_facecolor(color)

	# adding horizontal grid lines
	for ax in axes:
	    ax.yaxis.grid(True)
	    ax.set_xticks([y+1 for y in range(3)], )
	    ax.set_ylabel('error')


	# add x-tick labels
	plt.setp(axes, xticks=[y+1 for y in range(3)],
	         xticklabels=['usbl', 'odom', 'map'])
	plt.show()



def plotBoxes2(traj_error_raw, traj_error_ekfodom, traj_error_ekfmap):
	# Plot Trajectory
	fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, 5))
	# rectangular box plot
	bplot1 = axes[0].boxplot([traj_error_raw[:,0], traj_error_ekfodom[:,0], traj_error_ekfmap[:,0]],
	                         vert=True,   # vertical box aligmnent
	                         patch_artist=True)   # fill with color

	# rectangular box plot
	bplot2 = axes[1].boxplot([traj_error_raw[:,1], traj_error_ekfodom[:,1], traj_error_ekfmap[:,1]],
	                         vert=True,   # vertical box aligmnent
	                         patch_artist=True)   # fill with color


	# fill with colors
	colors = ['pink', 'lightblue', 'lightgreen']
	for bplot in (bplot1, bplot2):
		for patch, color in zip(bplot['boxes'], colors):
		    patch.set_facecolor(color)

	# adding horizontal grid lines
	for ax in axes:
	    ax.yaxis.grid(True)
	    ax.set_xticks([y+1 for y in range(3)], )
	    ax.set_ylabel('error')


	# add x-tick labels
	plt.setp(axes, xticks=[y+1 for y in range(3)],
	         xticklabels=['usbl', 'odom', 'map'])
	plt.show()


#Main

#Initialize matrices
mean_traj_error_raw 	= np.empty([trajectories,3])
mean_traj_error_ekfodom = np.empty([trajectories,3])
mean_traj_error_ekfmap 	= np.empty([trajectories,3])
std_traj_error_raw 		= np.empty([trajectories,3])
std_traj_error_ekfodom 	= np.empty([trajectories,3])
std_traj_error_ekfmap 	= np.empty([trajectories,3])

traj_error_raw 		= np.array([])
traj_error_ekfodom 	= np.array([])
traj_error_ekfmap 	= np.array([])


# For each trajectory
for i in range(0, trajectories):
	# Import data
	traj 			= "T%s" %(i+1) 
	header			= np.loadtxt(traj+"_"+filename[4]+".txt", delimiter=',', skiprows=1, usecols=(1,2))
	time = header[:,1]*10e-9
	time = [x-time[0] for x in time]
	ekfodom 		= np.loadtxt(traj+"_"+filename[0]+".txt", delimiter=',', skiprows=1, usecols=(2,5,6,7))
	ekfmap 			= np.loadtxt(traj+"_"+filename[1]+".txt", delimiter=',', skiprows=1, usecols=(2,5,6,7))
	gt 				= np.loadtxt(traj+"_"+filename[2]+".txt", delimiter=',', skiprows=1, usecols=(2,5,6,7))
	modem_raw 		= np.loadtxt(traj+"_"+filename[3]+".txt", delimiter=',', skiprows=1, usecols=(2,4,5,6))
	error_raw 		= np.absolute(np.loadtxt(traj+"_"+filename[4]+".txt", delimiter=',', skiprows=1, usecols=(4,5,6)))
	error_ekfodom 	= np.absolute(np.loadtxt(traj+"_"+filename[5]+".txt", delimiter=',', skiprows=1, usecols=(4,5,6)))
	error_ekfmap 	= np.absolute(np.loadtxt(traj+"_"+filename[6]+".txt", delimiter=',', skiprows=1, usecols=(4,5,6)))

	if plt_traj == 1: plotTraj(gt, ekfodom, ekfmap, modem_raw)


	if i==0:
		traj_error_raw 		= error_raw
		traj_error_ekfodom 	= error_ekfodom
		traj_error_ekfmap 	= error_ekfmap
	else:
		traj_error_raw 		= np.concatenate((traj_error_raw, error_raw), axis=0)
		traj_error_ekfodom 	= np.concatenate((traj_error_ekfodom, error_ekfodom), axis=0)
		traj_error_ekfmap 	= np.concatenate((traj_error_ekfmap, error_ekfmap), axis=0)
	dist_error_raw = np.linalg.norm([error_raw[:,0],error_raw[:,1]], axis=0)
	dist_error_ekfodom = np.linalg.norm([error_ekfodom[:,0],error_ekfodom[:,1]], axis=0)
	dist_error_ekfmap = np.linalg.norm([error_ekfmap[:,0],error_ekfmap[:,1]], axis=0)
	if plt_traj_boxes == 1: plotBoxes(dist_error_raw, dist_error_ekfodom, dist_error_ekfmap)
	if plt_error == 1: plotError(time, dist_error_raw, dist_error_ekfodom, dist_error_ekfmap)



# Save results
dist_traj_error_raw = np.linalg.norm([traj_error_raw[:,0],traj_error_raw[:,1]], axis=0)
dist_traj_error_ekfodom = np.linalg.norm([traj_error_ekfodom[:,0],traj_error_ekfodom[:,1]], axis=0)
dist_traj_error_ekfmap = np.linalg.norm([traj_error_ekfmap[:,0],traj_error_ekfmap[:,1]], axis=0)

mean_dist_traj_error_raw = np.mean(dist_traj_error_raw)
mean_dist_traj_error_ekfodom = np.mean(dist_traj_error_ekfodom)
mean_dist_traj_error_ekfmap = np.mean(dist_traj_error_ekfmap)
std_dist_traj_error_raw = np.std(dist_traj_error_raw)
std_dist_traj_error_ekfodom = np.std(dist_traj_error_ekfodom)
std_dist_traj_error_ekfmap = np.std(dist_traj_error_ekfmap)


f = open('../results.txt','w')
f.write('%s,%s,%s,%s,%s,%s' %(mean_dist_traj_error_raw,
mean_dist_traj_error_ekfodom,
mean_dist_traj_error_ekfmap,
std_dist_traj_error_raw,
std_dist_traj_error_ekfodom,
std_dist_traj_error_ekfmap))
f.close()

# Plot Boxes
if plt_boxes == 1:
	plotBoxes(dist_traj_error_raw, dist_traj_error_ekfodom, dist_traj_error_ekfmap) # TODO: plot dist


