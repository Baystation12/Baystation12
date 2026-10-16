GLOBAL_ALIST_EMPTY(cosmic_cult_power_instances)

// gets the power instance for the given typepath
/datum/cosmic_cultist/proc/get_power_instance(T)
	RETURN_TYPE(/datum/power/cosmic_cult)

	if (!GLOB.cosmic_cult_power_instances[T])
		GLOB.cosmic_cult_power_instances[T] = new T

	return GLOB.cosmic_cult_power_instances[T]

// grants a power to the cosmic cultist
/datum/cosmic_cultist/proc/grant_power(T)
	if (!ispath(T, /datum/power/cosmic_cult))
		return

	if (active_powers[T])
		return

	var/datum/power/cosmic_cult/power = get_power_instance(T)
	active_powers[T] = power

	if (!isnull(owning_mind.current))
		grant_power_to_body(T, owning_mind.current)

// grants a power to the cosmic cultist's body
/datum/cosmic_cultist/proc/grant_power_to_body(T, mob/living/body)
	if (!ispath(T, /datum/power/cosmic_cult))
		return

	if (!active_powers[T])
		return

	var/datum/action/cosmic_cult/action = active_powers[T]
	if (!istype(action))
		var/datum/power/cosmic_cult/power = get_power_instance(T)

		action = new
		action.name = power.name
		action.desc = power.desc
		action.button_icon_state = power.ability_icon_state
		action.power = power
		action.cultist = src
		action.cooldown = power.cooldown

		active_powers[T] = action

	action.Grant(body)

// revokes a power from the cosmic cultist
/datum/cosmic_cultist/proc/revoke_power(T)
	if (!ispath(T, /datum/power/cosmic_cult))
		return

	if (!active_powers[T])
		return

	if (!isnull(owning_mind.current))
		revoke_power_from_body(T, owning_mind.current)

	active_powers -= T

// revokes a power from the cosmic cultist's body
/datum/cosmic_cultist/proc/revoke_power_from_body(T, mob/living/body)
	if (!ispath(T, /datum/power/cosmic_cult))
		return

	var/datum/action/cosmic_cult/action = active_powers[T]
	if (!istype(action))
		return

	action.Remove(body)
