var/global/list/limb_icon_cache = list()

/obj/item/organ/proc/get_icon(var/icon/race_icon, var/icon/deform_icon)
	return icon('icons/mob/human.dmi',"blank")

/obj/item/organ/external/proc/compile_icon()
	overlays.Cut()
	get_icon()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				overlays += child.get_icon()
		overlays += organ.get_icon()

/obj/item/organ/external/head/get_icon(var/skeletal)
	if(skeletal)
		return ..()

	..()

	if(!istype(owner))
		return

	//Add (facial) hair.
	if(owner.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[owner.f_style]
		if(facial_hair_style)
			var/icon/facial = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), ICON_ADD)

			mob_icon.Blend(facial, ICON_OVERLAY)

	if(owner.h_style && !(owner.head && (owner.head.flags & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[owner.h_style]
		if(hair_style)
			var/icon/hair = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair.Blend(rgb(owner.r_hair, owner.g_hair, owner.b_hair), ICON_ADD)

			mob_icon.Blend(hair, ICON_OVERLAY)

	icon = mob_icon
	dir = EAST
	return icon

/obj/item/organ/external/get_icon(var/skeletal)

	if(!owner)
		mob_icon = new /icon('icons/mob/human_races/r_human.dmi', "[icon_name][gendered_icon ? "_f" : ""]")
	else

		var/gender
		if(gendered_icon)
			if(owner.gender == FEMALE)
				gender = "f"
			else
				gender = "m"

		//TODO: cache these icons
		if(skeletal)
			mob_icon = new /icon('icons/mob/human_races/r_skeleton.dmi', "[icon_name][gender ? "_[gender]" : ""]")
		else if (status & ORGAN_ROBOT && !(owner.species && owner.species.flags & IS_SYNTHETIC))
			mob_icon = new /icon('icons/mob/human_races/robotic.dmi', "[icon_name][gender ? "_[gender]" : ""]")
		else
			if (status & ORGAN_MUTATED)
				mob_icon = new /icon(owner.species.deform, "[icon_name][gender ? "_[gender]" : ""]")
			else
				mob_icon = new /icon(owner.species.icobase, "[icon_name][gender ? "_[gender]" : ""]")

			if(status & ORGAN_DEAD)
				mob_icon.ColorTone(rgb(10,50,0))
				mob_icon.SetIntensity(0.7)

			if(owner.species.flags & HAS_SKIN_TONE)
				if(owner.s_tone >= 0)
					mob_icon.Blend(rgb(owner.s_tone, owner.s_tone, owner.s_tone), ICON_ADD)
				else
					mob_icon.Blend(rgb(-owner.s_tone,  -owner.s_tone,  -owner.s_tone), ICON_SUBTRACT)
			else if(owner.species.flags & HAS_SKIN_COLOR)
				mob_icon.Blend(rgb(owner.r_skin, owner.g_skin, owner.b_skin), ICON_ADD)

	icon = mob_icon
	dir = EAST
	return icon

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