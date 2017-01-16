/*
* These calls could easily be setup to be a bunch of call()() with relevant procs and predicates but performance is a concern.
* BYOND is also a bit inflexible, as some predicates are of the sort /proc/name(host), others host.proc_name(), and some even do host.proc_name(parameter).
* Nothing that cannot be worked around, but it'd be a little messy. I miss C# lambdas...
*/

// Procs are arranged by "in range/hearers/viewers()" usage, as opposed to virtual mob hear/see abilities.
// Most of these procs can technically take any movable atom but unless they have a virtual mob the returned objects may not be the expected ones

#define ACQUIRE_VIRTUAL_OR_TURF(A) A = (isvirtualmob(A) ? A : (((istype(A) && A.virtual_mob) ? A.virtual_mob : get_turf(A)))) ; if(!A) return
#define ACQUIRE_VIRTUAL_OR_RETURN(A) A = (isvirtualmob(A) ? A : (((istype(A) && A.virtual_mob) ? A.virtual_mob : null))) ; if(!A) return

/****************
* Range Helpers *
****************/
/proc/clients_in_range(var/atom/movable/center_vmob)
	. = list()

	ACQUIRE_VIRTUAL_OR_TURF(center_vmob)
	for(var/mob/observer/virtual/v_mob in range(world.view, center_vmob))
		var/client/C = v_mob.get_client()
		if(C)
			. |= C

/proc/hearers_in_range(var/atom/movable/center_vmob)
	. = list()

	ACQUIRE_VIRTUAL_OR_TURF(center_vmob)
	for(var/mob/observer/virtual/v_mob in range(world.view, center_vmob))
		if(v_mob.abilities & VIRTUAL_ABILITY_HEAR)
			. |= v_mob.host

/proc/viewers_in_range(var/atom/movable/center_vmob)
	. = list()

	ACQUIRE_VIRTUAL_OR_TURF(center_vmob)
	for(var/mob/observer/virtual/v_mob in range(world.view, center_vmob))
		if(v_mob.abilities & VIRTUAL_ABILITY_SEE)
			. |= v_mob.host

/***************
* Hear Helpers *
***************/
// A mob hears another mob if they have direct line of sight, ignoring turf luminosity.
// If there is an opaque object beteween the mobs then they cannot hear each other no matter if the object can be seen through or not.
// Thus, unlike viewing hearing is communicative. I.e. if Mob A can hear Mob B then Mob B can also hear Mob A.

// Gets the hosts of all the virtual mobs that can hear the given movable atom (or rather, it's virtual mob or turf in that existence order)
/proc/all_hearers(var/atom/movable/heard_vmob)
	. = list()

	ACQUIRE_VIRTUAL_OR_TURF(heard_vmob)
	for(var/mob/observer/virtual/v_mob in hearers(world.view, heard_vmob))
		if(v_mob.abilities & VIRTUAL_ABILITY_HEAR)
			. |= v_mob.host

/***************
* View Helpers *
***************/
// A mob can see another mob if:
// * Within visual range, with the following differences for (N)PCs.
//		* PCs: Target is within client.view range, with center originating from either the mob or client.eye depending on client.eye_perspective.
//		* NPCs: Target is within world.view range, with center always originating from the mob.
// * Either of the following is true:
//		* The target mob is in direct line of sight and not standing on a turf with luminosity = 0 unless the viewing mob is close enough for see_in_dark to also be in range
//		* The viewing mob has the SEE_MOBS sight flag.

// Gets the hosts of all virtual mobs that can see the given atom movable as well as its turf
/proc/all_viewers(var/mob/observer/virtual/viewed_atom)
	. = list()

	viewed_atom = istype(viewed_atom) ? viewed_atom.host : viewed_atom
	var/turf/T = get_turf(viewed_atom)
	if(!T)
		return

	for(var/mob/observer/virtual/seeing_v_mob in viewers(world.view, viewed_atom))
		if(!(seeing_v_mob.abilities & VIRTUAL_ABILITY_SEE))
			continue
		var/atom/movable/host = seeing_v_mob.host
		if(host.virtual_can_see_turf(T))
			. |= host

// This proc returns all hosts of virtual mobs in the given atom's view range (using its turf), ignoring invisibility, VIRUAL_ABILITY_SEE, and most other restrictions.
// In most cases you actually want the all_* procs above. This helper was designed with LOOC in mind.
/proc/hosts_in_view_range(var/atom/movable/viewing_atom)
	. = list()

	ACQUIRE_VIRTUAL_OR_TURF(viewing_atom)
	// As per http://www.byond.com/docs/ref/info.html#/proc/view by using a non-mob/client this automatically skips the vast majority of sight checks
	for(var/mob/observer/virtual/v_mob in viewers(world.view, get_turf(viewing_atom.loc)))
		. |= v_mob.host

/*
	Misc. helper
*/

// Eye mobs technically see everything always, the owner just has an overlay applied, thus this helper
/atom/movable/proc/virtual_can_see_turf(var/turf/T)
	return TRUE // We assume objects have already been filtered using viewers() or similar proc

/mob/observer/eye/virtual_can_see_turf(var/turf/T)
	return visualnet.is_turf_visible(T)

#undef ACQUIRE_VIRTUAL_OR_TURF
#undef ACQUIRE_VIRTUAL_OR_RETURN
