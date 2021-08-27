/**
 * Variant of the health extension that tracks individual damage types.
 * Separated due to list usage.
 */
/datum/extension/health/damage_sources
	/// List of damage divided into each damage type.
	var/list/damage_sources = list()

/datum/extension/health/damage_sources/New(datum/holder)
	..()
	for (var/damage_type in DAMAGE_ALL)
		damage_sources[damage_type] = 0

/datum/extension/health/damage_sources/current_damage(damage_type)
	return damage_sources[damage_type]

/datum/extension/health/damage_sources/adjust_health(health_mod, damage_type)
	. = ..()
	damage_sources[damage_type] = max(damage_sources[damage_type] - health_mod, 0)

/datum/extension/health/damage_sources/revive()
	..()
	for (var/damage_type in damage_sources)
		damage_sources[damage_type] = 0

/datum/extension/health/damage_sources/set_max_health(new_max_health)
	..()
	return recalculate_health()

/datum/extension/health/damage_sources/copy_from(datum/extension/health/source)
	..()
	if (istype(source, /datum/extension/health/damage_sources))
		var/datum/extension/health/damage_sources/source2 = source
		damage_sources = source2.damage_sources

/// Re-calculates `current_health` based on `damage_sources`.
/datum/extension/health/damage_sources/proc/recalculate_health()
	var/damage = 0
	for (var/damage_type in damage_sources)
		damage += damage_sources[damage_type]
	current_health = max(max_health() - damage, 0)
	return update_death_state()
