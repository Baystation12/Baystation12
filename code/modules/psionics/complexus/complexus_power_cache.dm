/datum/psi_complexus/proc/rebuild_power_cache()
	if (rebuild_power_cache)

		melee_powers =         list()
		grab_powers =          list()
		ranged_powers =        list()
		manifestation_powers = list()
		powers_by_faculty =    list()

		for(var/faculty in ranks)
			var/relevant_rank = get_rank(faculty)
			var/singleton/psionic_faculty/faculty_singleton = SSpsi.get_faculty(faculty)
			for(var/thing in faculty_singleton.powers)
				var/singleton/psionic_power/power = thing
				if (relevant_rank >= power.min_rank)
					if (!powers_by_faculty[power.faculty]) powers_by_faculty[power.faculty] = list()
					powers_by_faculty[power.faculty] += power
					if (power.use_ranged)
						if (!ranged_powers[faculty]) ranged_powers[faculty] = list()
						ranged_powers[faculty] += power
					if (power.use_melee)
						if (!melee_powers[faculty]) melee_powers[faculty] = list()
						melee_powers[faculty] += power
					if (power.use_manifest)
						manifestation_powers += power
					if (power.use_grab)
						if (!grab_powers[faculty]) grab_powers[faculty] = list()
						grab_powers[faculty] += power
		rebuild_power_cache = FALSE

/datum/psi_complexus/proc/get_powers_by_faculty(faculty)
	rebuild_power_cache()
	return powers_by_faculty[faculty]

/datum/psi_complexus/proc/get_melee_powers(faculty)
	rebuild_power_cache()
	return melee_powers[faculty]

/datum/psi_complexus/proc/get_ranged_powers(faculty)
	rebuild_power_cache()
	return ranged_powers[faculty]

/datum/psi_complexus/proc/get_grab_powers(faculty)
	rebuild_power_cache()
	return grab_powers[faculty]

/datum/psi_complexus/proc/get_manifestations()
	rebuild_power_cache()
	return manifestation_powers
