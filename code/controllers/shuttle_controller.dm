//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

// Controls the emergency shuttle


// these define the time taken for the shuttle to get to SS13
// and the time before it leaves again
#define SHUTTLE_PREPTIME 				300	// 5 minutes = 300 seconds - after this time, the shuttle cannot be recalled
#define SHUTTLE_LEAVETIME 				180	// 3 minutes = 180 seconds - the duration for which the shuttle will wait at the station
#define SHUTTLE_TRANSIT_DURATION		300	// 5 minutes = 300 seconds - how long it takes for the shuttle to get to the station
#define SHUTTLE_TRANSIT_DURATION_RETURN 120	// 2 minutes = 120 seconds - for some reason it takes less time to come back, go figure.

var/global/datum/shuttle_controller/emergency_shuttle/emergency_shuttle

/datum/shuttle_controller/emergency_shuttle
	var/datum/shuttle/ferry/emergency/shuttle
	var/list/escape_pods
	
	var/launch_time			//the time at which the shuttle will be launched
	var/auto_recall = 0		//if set, the shuttle will be auto-recalled
	var/auto_recall_time	//the time at which the shuttle will be auto-recalled
	var/evac = 0			//1 = emergency evacuation, 0 = crew transfer
	var/wait_for_launch = 0	//if the shuttle is waiting to launch
	
	var/deny_shuttle = 0	//allows admins to prevent the shuttle from being called
	var/departed = 0		//if the shuttle has left the station at least once

/datum/shuttle_controller/emergency_shuttle/proc/setup_pods()
	escape_pods = list()
	
	var/datum/shuttle/ferry/escape_pod/pod
	
	pod = new()
	pod.location = 0
	pod.warmup_time = 0
	pod.area_station = locate(/area/shuttle/escape_pod1/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod1/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod1/transit)
	pod.travel_time = SHUTTLE_TRANSIT_DURATION_RETURN
	escape_pods += pod

	pod = new()
	pod.location = 0
	pod.warmup_time = 0
	pod.area_station = locate(/area/shuttle/escape_pod2/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod2/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod2/transit)
	pod.travel_time = SHUTTLE_TRANSIT_DURATION_RETURN
	escape_pods += pod
	
	pod = new()
	pod.location = 0
	pod.warmup_time = 0
	pod.area_station = locate(/area/shuttle/escape_pod3/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod3/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod3/transit)
	pod.travel_time = SHUTTLE_TRANSIT_DURATION_RETURN
	escape_pods += pod
	
	//There is no pod 4, apparently.
	
	pod = new()
	pod.location = 0
	pod.warmup_time = 0
	pod.area_station = locate(/area/shuttle/escape_pod5/station)
	pod.area_offsite = locate(/area/shuttle/escape_pod5/centcom)
	pod.area_transition = locate(/area/shuttle/escape_pod5/transit)
	pod.travel_time = SHUTTLE_TRANSIT_DURATION_RETURN
	escape_pods += pod


/datum/shuttle_controller/emergency_shuttle/proc/process()
	if (wait_for_launch)
		if (auto_recall && world.time >= auto_recall_time)
			recall()
		if (world.time >= launch_time)	//time to launch the shuttle
			wait_for_launch = 0
			
			//set the travel time
			if (!shuttle.location)	//leaving from the station
				//launch the pods!
				for (var/datum/shuttle/ferry/escape_pod/pod in escape_pods)
					pod.launch(src)
				
				shuttle.travel_time = SHUTTLE_TRANSIT_DURATION_RETURN
			else
				shuttle.travel_time = SHUTTLE_TRANSIT_DURATION
			
			shuttle.launch(src)
	
	//process the shuttles
	if (shuttle.in_use)
		shuttle.process_shuttle()
	for (var/datum/shuttle/ferry/escape_pod/pod in escape_pods)
		if (pod.in_use) 
			pod.process_shuttle()

//called when the shuttle has arrived.
/datum/shuttle_controller/emergency_shuttle/proc/shuttle_arrived()
	if (!shuttle.location)	//at station
		launch_time = world.time + SHUTTLE_LEAVETIME*10
		wait_for_launch = 1		//get ready to return

//so we don't have emergency_shuttle.shuttle.location everywhere
/datum/shuttle_controller/emergency_shuttle/proc/location()
	if (!shuttle)
		return 1 	//if we dont have a shuttle datum, just act like it's at centcom
	return shuttle.location

//calls the shuttle for an emergency evacuation
/datum/shuttle_controller/emergency_shuttle/proc/call_evac()
	if(!can_call()) return
	
	//set the launch timer
	launch_time = world.time + get_shuttle_prep_time()*10
	auto_recall_time = rand(world.time + 300, launch_time - 300)
	wait_for_launch = 1
	
	evac = 1
	captain_announce("An emergency evacuation shuttle has been called. It will arrive in approximately [round(estimate_arrival_time()/60)] minutes.")
	world << sound('sound/AI/shuttlecalled.ogg')
	for(var/area/A in world)
		if(istype(A, /area/hallway))
			A.readyalert()

//calls the shuttle for a routine crew transfer
/datum/shuttle_controller/emergency_shuttle/proc/call_transfer()
	if(!can_call()) return

	//set the launch timer
	launch_time = world.time + get_shuttle_prep_time()
	auto_recall_time = rand(world.time + 300, launch_time - 300)
	wait_for_launch = 1
	
	captain_announce("A crew transfer has been initiated. The shuttle has been called. It will arrive in [round(estimate_arrival_time()/60)] minutes.")

//recalls the shuttle
/datum/shuttle_controller/emergency_shuttle/proc/recall()
	if (!can_recall()) return

	wait_for_launch = 0
	shuttle.cancel_launch(src)

	if (evac)
		captain_announce("The emergency shuttle has been recalled.")
		world << sound('sound/AI/shuttlerecalled.ogg')
		
		for(var/area/A in world)
			if(istype(A, /area/hallway))
				A.readyreset()
		evac = 0
	else
		captain_announce("The scheduled crew transfer has been cancelled.")

/datum/shuttle_controller/emergency_shuttle/proc/can_call()
	if (deny_shuttle)
		return 0
	if (shuttle.moving_status != SHUTTLE_IDLE || !shuttle.location)	//must be idle at centcom
		return 0
	if (wait_for_launch)	//already launching
		return 0
	return 1

//this only returns 0 if it would absolutely make no sense to recall
//e.g. the shuttle is already at the station or wasn't called to begin with
//other reasons for the shuttle not being recallable should be handled elsewhere
/datum/shuttle_controller/emergency_shuttle/proc/can_recall()
	if (shuttle.moving_status == SHUTTLE_INTRANSIT)	//if the shuttle is already in transit then it's too late
		return 0
	if (!shuttle.location)	//already at the station.
		return 0
	if (!wait_for_launch)	//we weren't going anywhere, anyways...
		return 0
	return 1

/datum/shuttle_controller/emergency_shuttle/proc/get_shuttle_prep_time()
	// During mutiny rounds, the shuttle takes twice as long.
	if(ticker && istype(ticker.mode,/datum/game_mode/mutiny))
		return SHUTTLE_PREPTIME * 3		//15 minutes

	return SHUTTLE_PREPTIME
	

/*
	These procs are not really used by the controller itself, but are for other parts of the
	game whose logic depends on the emergency shuttle.
*/

//returns the time left until the shuttle arrives at it's destination, in seconds
/datum/shuttle_controller/emergency_shuttle/proc/estimate_arrival_time()
	var/eta
	if (isnull(shuttle.jump_time))
		eta = launch_time + shuttle.travel_time
	else
		eta = shuttle.jump_time + shuttle.travel_time
	return (eta - world.time)/10

//returns the time left until the shuttle launches, in seconds
/datum/shuttle_controller/emergency_shuttle/proc/estimate_launch_time()
	return (launch_time - world.time)/10

/datum/shuttle_controller/emergency_shuttle/proc/has_eta()
	return (wait_for_launch || shuttle.moving_status != SHUTTLE_IDLE)

//returns 1 if the shuttle has gone to the station and come back at least once,
//used for game completion checking purposes
/datum/shuttle_controller/emergency_shuttle/proc/returned()
	return (departed && shuttle.moving_status != SHUTTLE_IDLE && shuttle.location)	//we've gone to the station at least once, no longer in transit and are idle back at centcom

//returns 1 if the shuttle is not idle at centcom
/datum/shuttle_controller/emergency_shuttle/proc/online()
	if (!shuttle.location)	//not at centcom
		return 1
	if (wait_for_launch || shuttle.moving_status != SHUTTLE_IDLE)
		return 1
	return 0

//returns 1 if the shuttle is currently in transit (or just leaving) to the station
/datum/shuttle_controller/emergency_shuttle/proc/going_to_station()
	return (!shuttle.direction && shuttle.moving_status != SHUTTLE_IDLE)

//returns 1 if the shuttle is currently in transit (or just leaving) to centcom
/datum/shuttle_controller/emergency_shuttle/proc/going_to_centcom()
	return (shuttle.direction && shuttle.moving_status != SHUTTLE_IDLE)

//returns 1 if the shuttle is docked at the station and waiting to leave
/datum/shuttle_controller/emergency_shuttle/proc/waiting_to_leave()
	if (shuttle.location)
		return 0	//not at station
	if (!wait_for_launch)
		return 0	//not going anywhere
	if (shuttle.moving_status != SHUTTLE_IDLE)
		return 0	//shuttle is doing stuff
	return 1

/*
	Some slapped-together star effects for maximum spess immershuns. Basically consists of a
	spawner, an ender, and bgstar. Spawners create bgstars, bgstars shoot off into a direction
	until they reach a starender.
*/

/obj/effect/bgstar
	name = "star"
	var/speed = 10
	var/direction = SOUTH
	layer = 2 // TURF_LAYER

/obj/effect/bgstar/New()
	..()
	pixel_x += rand(-2,30)
	pixel_y += rand(-2,30)
	var/starnum = pick("1", "1", "1", "2", "3", "4")

	icon_state = "star"+starnum

	speed = rand(2, 5)

/obj/effect/bgstar/proc/startmove()

	while(src)
		sleep(speed)
		step(src, direction)
		for(var/obj/effect/starender/E in loc)
			del(src)


/obj/effect/starender
	invisibility = 101

/obj/effect/starspawner
	invisibility = 101
	var/spawndir = SOUTH
	var/spawning = 0

/obj/effect/starspawner/West
	spawndir = WEST

/obj/effect/starspawner/proc/startspawn()
	spawning = 1
	while(spawning)
		sleep(rand(2, 30))
		var/obj/effect/bgstar/S = new/obj/effect/bgstar(locate(x,y,z))
		S.direction = spawndir
		spawn()
			S.startmove()


