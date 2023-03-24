/datum/stings/silence
	name = "Silence Sting (10)"
	desc = "Sting target"
	icon_state = "sting_mute"
	chemical_cost = 10

/datum/stings/silence/sting_action(mob/user, mob/living/T)
	. = ..()
	T.silent += 30
