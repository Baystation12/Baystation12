/datum/sun
	var/angle
	var/dx
	var/dy
//	var/counter = 50		// to make the vars update during 1st call
	var/rate
	var/list/solars			// for debugging purposes, references solars_list at the constructor
	var/nexttime = 3600		// Replacement for var/counter to force the sun to move every X IC minutes

/datum/sun/New()

	solars = solars_list
	rate = rand(750,1250)/1000			// 75.0% - 125.0% of standard rotation
	if(prob(50))
		rate = -rate

// calculate the sun's position given the time of day

/datum/sun/proc/calc_position()

/*	counter++
	if(counter<50)		// count 50 pticks (50 seconds, roughly - about a 5deg change)
		return
	counter = 0 */

	angle = ((rate*world.time/100)%360 + 360)%360
	/*
		Yields a 45 - 75 IC minute rotational period
		Rotation rate can vary from 4.8 deg/min to 8 deg/min (288 to 480 deg/hr)
	*/

	//  To prevent excess server load the server only updates the sun's sight lines every 6 minutes
	if(nexttime < world.time)
		return
	nexttime = nexttime + 3600	// 600 world.time ticks = 1 minute, 3600 = 6 minutes.

	// now calculate and cache the (dx,dy) increments for line drawing

	var/s = sin(angle)
	var/c = cos(angle)

	if(c == 0)

		dx = 0
		dy = s

	else if( abs(s) < abs(c))

		dx = s / abs(c)
		dy = c / abs(c)

	else
		dx = s/abs(s)
		dy = c / abs(s)


	for(var/obj/machinery/power/M in solars_list)

		if(!M.powernet)
			solars_list.Remove(M)
			continue

		// Solar Tracker
		if(istype(M, /obj/machinery/power/tracker))
			var/obj/machinery/power/tracker/T = M
			T.set_angle(angle)

		// Solar Panel
		else if(istype(M, /obj/machinery/power/solar))
			var/obj/machinery/power/solar/S = M
			if(S.control)
				occlusion(S)



// for a solar panel, trace towards sun to see if we're in shadow

/datum/sun/proc/occlusion(var/obj/machinery/power/solar/S)

	var/ax = S.x		// start at the solar panel
	var/ay = S.y

	for(var/i = 1 to 20)		// 20 steps is enough
		ax += dx	// do step
		ay += dy

		var/turf/T = locate( round(ax,0.5),round(ay,0.5),S.z)

		if(T.x == 1 || T.x==world.maxx || T.y==1 || T.y==world.maxy)		// not obscured if we reach the edge
			break

		if(T.density)			// if we hit a solid turf, panel is obscured
			S.obscured = 1
			return

	S.obscured = 0		// if hit the edge or stepped 20 times, not obscured
	S.update_solar_exposure()




