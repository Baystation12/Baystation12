/obj/item/organ/internal/augment/boost/muscle
	buffs = list(SKILL_HAULING = 1)
	buffpath = /datum/skill_buff/augment/muscle
	name = "mechanical muscles"
	augment_slots = AUGMENT_LEG
	icon_state = "muscule"
	desc = "Nanofiber tendons powered by an array of actuators increase the speed and agility of the user. You may want to install these in pairs to see a result."
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_BIOLOGICAL | AUGMENT_SCANNABLE | AUGMENT_INSPECTABLE
	var/obj/item/organ/internal/augment/boost/muscle/other //we need two for these


/obj/item/organ/internal/augment/boost/muscle/proc/get_acrobatics_modifier()
	if (!other?.is_broken() && !is_broken())
		return 1


/obj/item/organ/internal/augment/boost/muscle/onInstall()
	if (parent_organ == BP_L_LEG)
		other = owner.internal_organs_by_name["[BP_R_LEG]_aug"]
	else if (parent_organ == BP_R_LEG)
		other = owner.internal_organs_by_name["[BP_L_LEG]_aug"]
	if (other && istype(other)) //we must be second to activate buff
		var/succesful = TRUE
		if (owner.get_skill_value(SKILL_HAULING) < SKILL_PROF)
			succesful = FALSE
			var/datum/skill_buff/augment/muscle/A
			A = owner.buff_skill(buffs, 0, buffpath)
			if (A && istype(A))
				succesful = TRUE
				A.id = id
		if (succesful)
			other.other = src
			other.active = TRUE
			active = TRUE


/obj/item/organ/internal/augment/boost/muscle/onRemove()
	if (!active)
		return
	for (var/datum/skill_buff/augment/muscle/D as anything in owner.fetch_buffs_of_type(buffpath, 0))
		if (D.id != id)
			continue
		D.remove()
		break
	if (other)
		other.active = FALSE
		other.other = null
		other = null
	active = FALSE


/obj/item/organ/internal/augment/boost/muscle/Destroy()
	. = ..()
	other = null


/datum/skill_buff/augment/muscle
