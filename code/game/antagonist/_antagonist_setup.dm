/*
 MODULAR ANTAGONIST SYSTEM

 Attempts to move all the bullshit snowflake antag tracking code into its own system, which
 has the added bonus of making the display procs consistent. Still needs work/adjustment/cleanup
 but should be fairly self-explanatory with a review of the procs. Will supply a few examples
 of common tasks that the system will be expected to perform below. ~Z

 To use:
   - Get the appropriate datum via get_antag_data("antagonist id")
     using the id var of the desired /datum/antagonist ie. var/datum/antagonist/A = get_antag_data("traitor")
   - Call add_antagonist() on the desired target mind ie. A.add_antagonist(mob.mind)
   - To ignore protected roles, supply a positive second argument.
   - To skip equipping with appropriate gear, supply a positive third argument.
*/

// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB        1 // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB        2 // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT     4 // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME         8 // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE     16 // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS         32 // Shows up on roundstart report.
#define ANTAG_HAS_LEADER         64 // Generates a leader antagonist.
#define ANTAG_HAS_NUKE          128 // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN         256 // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE           512 // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE   1024 // Causes antagonists to use an appearance modifier on spawn.
#define ANTAG_RANDOM_EXCEPTED  2048 // If a game mode randomly selects antag types, antag types with this flag should be excluded.

// Global procs.
/proc/get_antag_data(var/antag_type)
	if(all_antag_types()[antag_type])
		return all_antag_types()[antag_type]
	else
		var/list/all_antag_types = all_antag_types()
		for(var/cur_antag_type in all_antag_types)
			var/datum/antagonist/antag = all_antag_types[cur_antag_type]
			if(antag && antag.is_type(antag_type))
				return antag

/proc/clear_antag_roles(var/datum/mind/player, var/implanted)
	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(!implanted || !(antag.flags & ANTAG_IMPLANT_IMMUNE))
			antag.remove_antagonist(player, 1, implanted)

/proc/update_antag_icons(var/datum/mind/player)
	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(player)
			antag.update_icons_removed(player)
			if(antag.is_antagonist(player))
				antag.update_icons_added(player)
		else
			antag.update_all_icons()

/proc/get_antags(var/atype)
	var/datum/antagonist/antag = all_antag_types()[atype]
	if(antag && islist(antag.current_antagonists))
		return antag.current_antagonists
	return list()

/proc/player_is_antag(var/datum/mind/player, var/only_offstation_roles = 0)
	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(only_offstation_roles && !(antag.flags & ANTAG_OVERRIDE_JOB))
			continue
		if(player in antag.current_antagonists)
			return 1
		if(player in antag.pending_antagonists)
			return 1
	return 0

var/list/all_antag_types_
var/list/all_antag_spawnpoints_
var/list/antag_names_to_ids_

/proc/all_antag_types()
	populate_antag_type_list()
	return all_antag_types_

/proc/all_antag_spawnpoints()
	populate_antag_type_list()
	return all_antag_spawnpoints_

/proc/antag_names_to_ids()
	populate_antag_type_list()
	return antag_names_to_ids_

/proc/populate_antag_type_list()
	if(all_antag_types_ || all_antag_spawnpoints_ || antag_names_to_ids_)
		return
	all_antag_types_ = list()
	all_antag_spawnpoints_ = list()
	antag_names_to_ids_ = list()

	for(var/antag_type in subtypesof(/datum/antagonist))
		var/datum/antagonist/A = new antag_type
		all_antag_types_[A.id] = A
		all_antag_spawnpoints_[A.landmark_id] = list()
		antag_names_to_ids_[A.role_text] = A.id
