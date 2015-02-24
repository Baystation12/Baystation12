/client/proc/kaboom()
	var/power = input(src, "power?", "power?") as num
	var/turf/T = get_turf(src.mob)
	explosion_rec(T, power)

/obj
	var/explosion_resistance

/datum/explosion_turf
	var/turf/turf //The turf which will get ex_act called on it
	var/max_power //The largest amount of power the turf sustained
	var/old_power //used to know if the power is still being affected or not
	var/itteration_oldpower //used to know if the power is still being affected or not
	New()
		..()
		max_power = 0
		itteration_oldpower = 0
		old_power = 0

	proc/save_power_if_larger(power)
		if(power > max_power)
			max_power = power
			return 1
		return 0

var/list/datum/explosion_turf/explosion_turfs = list()
var/global/explosion_in_progress = 0
var/global/explosion_animation_in_progress = 0
var/global/explosion_animation_working = 0
var/explosion_iterationcount = 0
/turf/var/explosion_turf = ""
/datum/explosion_turf/var/severityapplied = 4 //used so we dont reapply identical or lower severity since we will do passes as the explosion progress
proc/get_explosion_turf(var/turf/T)
	if (T && T.explosion_turf)
		return T.explosion_turf
	var/datum/explosion_turf/ET = new()
	ET.turf = T
	explosion_turfs += ET
	if (T)
		T.explosion_turf = ET
	return ET

proc/explosion_rec(turf/epicenter, power) //this is now called by a spawn command. so we can sleep without freezing everything
	var/loopbreak = 0
	while(explosion_in_progress > 0)
		if(loopbreak >= 15) return
		sleep(10)
		loopbreak++
		// C4 code: explosion(location, -1, -1, 2, 3) >> This will break the C4 entirely.
	if(power != -1 && power <= 0)
		message_admins("Explosion canceled. no power")
		return
	epicenter = get_turf(epicenter)
	if(!epicenter)
		message_admins("Explosion canceled. no center")
		return
	explosion_animation_working = 0
	message_admins("Explosion with size ([power]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z])")
	log_game("Explosion with size ([power]) in area [epicenter.loc.name] ")

	spawn(0) //Returned these under their paths, this *may* reduce the lag they produce, I don't know for sure, added spawn to get other things out of the way, these can be delayed a bit, I guess.
		playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power*2,1) )
		playsound(epicenter, pick("sound/effects/explosion1.ogg", "sound/effects/explosion2.ogg") , 100, 1, round(power,1) )


	explosion_in_progress = 1
	explosion_turfs = list()
	var/datum/explosion_turf/ETE = get_explosion_turf()
	ETE.turf = epicenter
	ETE.max_power = power
	var/sleeptime = 0
	if (power < 20)
		sleeptime = 2
	else if (power < 40)
		sleeptime = 1
//	spawn(sleeptime)
//		var/obj/fire/ourfire = new(ETE.turf,1000) //BALL OF FIRE WHAHFHUFIAFHIAFHA
//		sleep sleeptime
//		del(ourfire)

	spawn(sleeptime)
	explosion_animation_in_progress = 1
	explosion_animation_working = 1
	spawn(1) //in 0.1 sec, start doing pass until its done exploding
		var/notlastloop = 1
		var/highestseverity = 4 //used to determine how loud the explosion sound is (if any) (lower is higher)
		var/count = 0
		while (explosion_animation_in_progress || notlastloop )
		{
			if (!explosion_animation_in_progress) //doing it this way to ensure one last iteration is done before actually ending it
				notlastloop  = 0
			highestseverity = 4
			//This step applies the ex_act effects for the explosion, as planned in the previous step.
			for( var/datum/explosion_turf/ET in explosion_turfs )
				if(ET.max_power > 0 && ET.turf)
					if (!notlastloop) //its the last iterration. do everything that must be done
					{
						ET.old_power = ET.max_power
						ET.itteration_oldpower = 3
					}
					if (ET.max_power != ET.old_power)
					{
						ET.old_power = ET.max_power
						ET.itteration_oldpower = 0
					}
					else if (ET.max_power == ET.old_power && ET.itteration_oldpower <= 2)
					{
						ET.itteration_oldpower++
					}
					else if (ET.max_power == ET.old_power && ET.itteration_oldpower > 2)
					{
						if (count > 10)
							sleep(1)
							count = 0
						count++
						//Wow severity looks confusing to calculate... Fret not, I didn't leave you with any additional instructions or help. (just kidding, see the line under the calculation)
						var/severity = 4 - round(max(min( 3, (ET.max_power / (max(3,(power/3)))) ) ,1)-0.5, 1)
												//sanity			effective power on tile				divided by either 3 or one third the total explosion power
												//															One third because there are three power levels and I
						 						//															want each one to take up a third of the crater

						if (ET.severityapplied > severity) //ok our severity increased so we reapply it (lower is higher)
							if (highestseverity > severity)
								highestseverity = severity
							var/x = ET.turf.x
							var/y = ET.turf.y
							var/z = ET.turf.z
							ET.severityapplied = severity
							if(!ET.turf)
								ET.turf = locate(x,y,z)

							ET.turf.ex_act(severity)
							for( var/atom/A in ET.turf )
								A.ex_act(severity)
					}
			if (highestseverity < 4 && highestseverity > 0)
				var/vol = 100 * 1/highestseverity
				if (vol > 100)
					vol = 100
				playsound(epicenter, pick("sound/effects/explosion1.ogg", "sound/effects/explosion2.ogg") , 100, 1, round(power,1) )

				if (highestseverity > 1)
					playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power*2,1) )
			sleep(5)

		}
		explosion_animation_working = 0
	//This step handles the gathering of turfs which will be ex_act() -ed in the next step. It also ensures each turf gets the maximum possible amount of power dealt to it.
	var/explosionrange = round(power/2)-1 //center is already dealt with

	var/effectivepower = power - epicenter.explosion_resistance
	for(var/direction in cardinal)
		var/turf/T = get_step(epicenter, direction)
		spawn (1)
			T.explosion_spread(effectivepower, direction, explosionrange, explosionrange)

	sleep(5) //be 100% sure that at least one of the async thread started
	while (explosion_in_progress > 1) //wait for the explosions "thread" to be done (arent thread per say, but close enough for the logic purpose
		sleep(5)
	explosion_animation_in_progress = 0 //tell our loop to stop soon
	sleep (10) //that way were pretty much certain that we wont cancel part of the explosion by reseting the values before our spawned process completed his job.
	while (explosion_animation_working > 0) //wait for the animation update to be done
		sleep(5)
	//cleanup our flags (technically not needed, but well, just in case. Its probably not big enough to register as any kind of lag anyway)
	for( var/datum/explosion_turf/ET in explosion_turfs )
		if (ET.turf.explosion_turf)
			ET.turf.explosion_turf = ""
		ET.severityapplied = 4
		ET.max_power = 0
	explosion_turfs = list()

	explosion_in_progress = 0
	message_admins("Explosion completed")


/turf
	var/explosion_resistance

/turf/space
	explosion_resistance = 10

/turf/simulated/floor
	explosion_resistance = 1

/turf/unsimulated/mineral
	explosion_resistance = 2

/turf/simulated/shuttle/floor
	explosion_resistance = 1

/turf/simulated/shuttle/floor4
	explosion_resistance = 1

/turf/simulated/shuttle/plating
	explosion_resistance = 1

/turf/simulated/shuttle/wall
	explosion_resistance = 5

/turf/simulated/wall
	explosion_resistance = 5

/turf/simulated/wall/r_wall
	explosion_resistance = 25

/turf/simulated/wall/r_wall
	explosion_resistance = 25

//Code-wise, a safe value for power is something up to ~25 or ~30.. This does quite a bit of damage to the station.
//direction is the direction that the spread took to come to this tile. So it is pointing in the main blast direction - meaning where this tile should spread most of it's force.
/turf/proc/explosion_spread(power, direction, distleft, fulldist)
	if(power <= 0)
		return
	if (explosion_iterationcount > 500)
		sleep(1)
		explosion_iterationcount = 0
	explosion_iterationcount++
	if (distleft < 1)
		return //were done here, did power^2 square already
	var/spread_distleft = round(distleft - 1)
	/*

	new/obj/effect/debugging/marker(src)
	*/
	var/spread_power = power - src.explosion_resistance//This is the amount of power that will be spread to the tile in the direction of the blast
	var/datum/explosion_turf/ET = get_explosion_turf(src)
	if(ET.max_power >= power)
		return
	else
		ET.max_power = spread_power
	explosion_in_progress++





	for(var/obj/O in src)
		if(O.explosion_resistance)
			spread_power -= O.explosion_resistance
	var/side_spread_power = spread_power *0.9 //This is the amount of power that will be spread to the side tiles



	/*if (explosion_in_progress > 20) //while yes, too many process would cause some lag. It is still a lot less lag than the old implementation could ever attain so. better leave the potential lag with admin only bomb (need to be stupidly large, like power 150 to even reach those values), than slow all explosions to not lag on those
		sleep(2) //lets take a short break, weve got a lot of process going on right now
	if (explosion_in_progress > 50)
		sleep(20) //lets take a break, weve got a lot of process going on right now
	if (explosion_in_progress > 100)
		sleep(50) //lets take a long break, weve got a lot of process going on right now
	if (explosion_in_progress > 150)
		sleep(100) //lets take a long break, weve got a lot of process going on right now
	if (explosion_in_progress > 200)
		message_admins("WAY TOO MUCH EXPLOSIONS PROCESS.... SOMETHING NOT RIGHTTT !!![explosion_in_progress]")
		explosion_in_progress--
		return
	*/
	var/turf/T = get_step(src, direction)
	var/sleeptime = 0
	if (power < 20)
		sleeptime = 2
	else if (power < 40)
		sleeptime = 1
//	spawn(sleeptime)
//		var/obj/fire/ourfire = new(ET.turf,1000) //BALL OF FIRE WHAHFHUFIAFHIAFHA
//		sleep sleeptime
//		del(ourfire)

	spawn(sleeptime)
		if(T)
			T.explosion_spread(spread_power, direction,spread_distleft, fulldist)
	T = get_step(src, turn(direction,90))
	//spread_distleft-- //half the distance for the sides spread
	spawn(sleeptime)
		if(T)
			T.explosion_spread(side_spread_power, turn(direction,90), spread_distleft, fulldist)
	T = get_step(src, turn(direction,-90))
	spawn(sleeptime)
		if(T)
			T.explosion_spread(side_spread_power, turn(direction,-90), spread_distleft, fulldist)
	sleep(sleeptime)
	explosion_in_progress--

/*
	var/turf/T = get_step(src, direction)

	spawn(0)
		T.explosion_spread(spread_power, direction)
	sleep(-1)
	T = get_step(src, turn(direction,90))
	spawn(0)
		T.explosion_spread(side_spread_power, turn(direction,90))
	sleep(-1)
	T = get_step(src, turn(direction,-90))
	spawn(0)
		T.explosion_spread(side_spread_power, turn(direction,90))
	sleep(1) // Do a backlog check here, get rid of all the pending processes, EG airflow, creating awesome explosions :D
	explosion_in_progress--
*/

/turf/unsimulated/explosion_spread(power)
	return //So it doesn't get to the parent proc, which simulates explosions