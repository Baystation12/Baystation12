/singleton/submap_archetype
	var/map
	var/descriptor = "generic ship archetype"
	var/list/whitelisted_species = UNRESTRICTED_SPECIES
	var/list/blacklisted_species = RESTRICTED_SPECIES
	var/call_webhook
	var/list/crew_jobs = list(
		/datum/job/submap
	)

// Generic ships to populate the list.
/singleton/submap_archetype/derelict
	descriptor = "drifting wreck"

/singleton/submap_archetype/abandoned_ship
	descriptor = "abandoned ship"
