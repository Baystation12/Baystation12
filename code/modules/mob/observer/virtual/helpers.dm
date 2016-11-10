/*
* These calls could easily be setup to be a bunch of call()() with relevant procs and predicates but performance is a concern.
* BYOND is also a bit inflexible, as some predicates are of the sort /proc/name(host), others host.proc_name(), and some even do host.proc_name(parameter).
* Nothing that cannot be worked around, but it'd be a little messy. I miss C# lambdas...
*
* It would also be possible to acquire virtual mobs in a separate call but that would result in multiple loops,
*  ,even if the virtual mob loop is presumably much smaller than, for example, a range() one,
*	again resulting in performance loss.
*/

// Procs are arranged by "in range/hearers/viewers()" usage, as opposed to virtual mob hear/see abilities.
// Most of these procs can technically take any atom but what is then returned is undefined (but likely usually the same as what a virtual mob would return).

/****************
* Range Helpers *
****************/
/proc/clients_in_range(var/atom/center_vmob)
	. = list()

	for(var/mob/observer/virtual/v_mob in range(world.view, center_vmob))
		var/client/C = v_mob.get_client()
		if(C)
			. |= C

/proc/hearers_in_range(var/atom/center_vmob)
	. = list()

	for(var/mob/observer/virtual/v_mob in range(world.view, center_vmob))
		if(v_mob.abilities & VIRTUAL_ABILITY_HEAR)
			. += v_mob.host

/proc/viewers_in_range(var/atom/center_vmob)
	. = list()

	for(var/mob/observer/virtual/v_mob in range(world.view, center_vmob))
		if(v_mob.abilities & VIRTUAL_ABILITY_SEE)
			. += v_mob.host

/***************
* Hear Helpers *
***************/
// A mob hears another mob if they have direct line of sight, ignoring turf luminosity.
// If there is an opaque object beteween the mobs then they cannot hear each other no matter if the object can be seen through or not.
// Thus, unlike viewing hearing is communicative. I.e. if Mob A can hear Mob B then Mob B can also hear Mob A.

// Gets the hosts of all the virtual mobs that can hear the given virtual mob
/proc/all_hearers(var/atom/heard_vmob)
	. = list()

	for(var/mob/observer/virtual/v_mob in hearers(world.view, heard_vmob))
		if(v_mob.abilities & VIRTUAL_ABILITY_HEAR)
			. += v_mob.host

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

// Gets the hosts of all virtual mobs that can see the given virtual mob
/proc/all_viewers(var/atom/viewing_vmob)
	. = list()
	var/turf/T = get_turf(viewing_vmob) // get_turf() isn't necessary for a virtual mob but someone might feed us a general atom
	if(!T)
		return

	for(var/mob/observer/virtual/v_mob in viewers(world.view, T))
		if(!(v_mob.abilities & VIRTUAL_ABILITY_SEE))
			continue
		var/atom/movable/host = v_mob.host
		if(host.virtual_can_see_turf(T))
			. += host

// Gets the hosts of all the virtual mobs that the given virtual mob can see.
// It's up to the caller to check if VIRTUAL_ABILITY_SEE is applicable or not.
/proc/all_in_view(var/mob/observer/virtual/viewing_vmob)
	. = list()

	var/atom/movable/viewing_host = viewing_vmob.host
	for(var/mob/observer/virtual/seen_vmob in view(world.view, get_turf(viewing_vmob)))
		if(viewing_host.virtual_can_see_turf(get_turf(seen_vmob)))
			. += seen_vmob.host

// This proc is mainly a helper to get clients but where a client might be 'owner' of multiple mobs
//  which need to be handled differently, see /decl/communication_channel/ooc/looc.
// In most cases you actually want the all_* procs above.
/proc/mobs_in_viewing_range(var/atom/viewing_vmob)
	. = list()

	for(var/mob/observer/virtual/v_mob in viewers(world.view, get_turf(viewing_vmob)))
		if(ismob(v_mob.host)) // Also note how we don't check for VIRTUAL_ABILITY_SEE
			. += v_mob.host

/*
	Misc. helper
*/

// Eye mobs technically see everything always, the owner just has an overlay applied, thus this helper
/atom/movable/proc/virtual_can_see_turf(var/turf/T)
	return TRUE // We assume objects have already been filtered using viewers() or similar proc

/mob/observer/eye/virtual_can_see_turf(var/turf/T)
	return visualnet.is_turf_visible(T)
