/datum/event/gravity
	announceWhen = 5

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	priority_announcement.Announce("Feedback surge detected in the gravity generation systems. Artificial gravity has been disabled whilst the system reinitializes.", "Gravity Failure", zlevels = affecting_z)

/datum/event/gravity/start()
	gravity_is_on = 0
	if(SSmachines.gravity_generators.len)
		for(var/obj/machinery/gravity_generator/main/B in SSmachines.gravity_generators)
			if(B.z in affecting_z && !(B.stat & BROKEN))
				B.eventshutofftoggle()
	else
		for(var/area/A in world)
			if(A.z in GLOB.using_map.station_levels)
				A.gravitychange(gravity_is_on)

/datum/event/gravity/end()
	if(!gravity_is_on)
		gravity_is_on = 1
		if(SSmachines.gravity_generators.len)
			for(var/obj/machinery/gravity_generator/main/B in SSmachines.gravity_generators)
				if(B.z in affecting_z && B.stat & BROKEN) // small chance to fix broken one, it's anomaly?
					if(prob(25))
						B.set_fix()
						command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "Gravity Restored", zlevels = affecting_z)
					else
						priority_announcement.Announce("Reinitialization of gravity subsystems failed. Engineering personal should check system inspection and fix the problem.", "Fatal Gravity Failure", zlevels = affecting_z)
		else
			for(var/area/A in world)
				if((A.z in GLOB.using_map.station_levels) && initial(A.has_gravity))
					A.gravitychange(gravity_is_on)
