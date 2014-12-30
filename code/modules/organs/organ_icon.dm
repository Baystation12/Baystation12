/obj/item/organ/proc/get_icon(var/icon/race_icon, var/icon/deform_icon)
	return icon('icons/mob/human.dmi',"blank")

/obj/item/organ/external/get_icon(var/icon/race_icon, var/icon/deform_icon,gender="")

	if(mob_icon)
		return mob_icon

	if(!owner)
		return ..()

	//TODO: cache these icons
	if (status & ORGAN_ROBOT && !(owner.species && owner.species.flags & IS_SYNTHETIC))
		mob_icon = new /icon('icons/mob/human_races/robotic.dmi', "[icon_name][gender ? "_[gender]" : ""]")
	if (status & ORGAN_MUTATED)
		mob_icon = new /icon(deform_icon, "[icon_name][gender ? "_[gender]" : ""]")
	if(!mob_icon)
		mob_icon = new /icon(race_icon, "[icon_name][gender ? "_[gender]" : ""]")
	if(owner.species)
		if(owner.species.flags & HAS_SKIN_TONE)
			if(owner.s_tone >= 0)
				mob_icon.Blend(rgb(owner.s_tone, owner.s_tone, owner.s_tone), ICON_ADD)
			else
				mob_icon.Blend(rgb(-owner.s_tone,  -owner.s_tone,  -owner.s_tone), ICON_SUBTRACT)
		if(owner.species.flags & HAS_SKIN_COLOR)
			mob_icon.Blend(rgb(owner.r_skin, owner.g_skin, owner.b_skin), ICON_ADD)
	return mob_icon

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/obj/item/organ/external/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/obj/item/organ/external/proc/damage_state_text()
	if(status & ORGAN_DESTROYED)
		return "--"

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam > (max_health * 0.25 / 2))
		tburn = 1
	else if (burn_dam > (max_health * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam > (max_health * 0.25 / 2))
		tbrute = 1
	else if (brute_dam > (max_health * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"