/**********************
 * ENDGAME STUFF
 **********************/

 // Universal State
 // Handles stuff like space icon_state, constants, etc.
 // Essentially a policy manager.  Once shit hits the fan, this changes its policies.
 // Called by master controller.

 // Default shit.
/datum/universal_state
	// Just for reference, for now.
	// Might eventually add an observatory job.
 	var/name = "Normal"
 	var/desc = "Nothing seems awry."

 	// Sets world.turf, replaces all turfs of type /turf/space.
 	var/space_type         = /turf/space

 	// Replaces all turfs of type /turf/space/transit
 	var/transit_space_type = /turf/space/transit

 	// Chance of a floor or wall getting damaged [0-100]
 	// Simulates stuff getting broken due to molecular bonds decaying.
 	var/decay_rate = 0

// Actually decay the turf.
/datum/universal_state/proc/DecayTurf(turf/T)
	if (istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W=T
		W.melt()
		return
	if (istype(T,/turf/simulated/floor))
		var/turf/simulated/floor/F=T
		// Burnt?
		if (!F.burnt)
			F.burn_tile()
		else
			F.ReplaceWithLattice()
		return

// Return 0 to cause shuttle call to fail.
/datum/universal_state/proc/OnShuttleCall(mob/user)
	return 1

// Processed per tick
/datum/universal_state/proc/OnTurfTick(turf/T)
	if (decay_rate && prob(decay_rate))
		DecayTurf(T)

// Apply changes when exiting state
/datum/universal_state/proc/OnExit()
 	// Does nothing by default

// Apply changes when entering state
/datum/universal_state/proc/OnEnter()
 	// Does nothing by default

// Apply changes to a new turf.
/datum/universal_state/proc/OnTurfChange(turf/NT)
 	return

/datum/universal_state/proc/OverlayAndAmbientSet()
	return

/datum/universal_state/proc/OnPlayerLatejoin(mob/living/M)
	return

/datum/universal_state/proc/OnTouchMapEdge(atom/A)
	return TRUE //return FALSE to cancel map edge handling

/proc/SetUniversalState(newstate,on_exit=1, on_enter=1, list/arguments=null)
	if (on_exit)
		GLOB.universe.OnExit()
	if (arguments)
		GLOB.universe = new newstate(arglist(arguments))
	else
		GLOB.universe = new newstate
	if (on_enter)
		GLOB.universe.OnEnter()
