/datum/skill_buff/augment/muscle

/obj/item/organ/internal/augment/boost/muscle
	buffs = list(SKILL_HAULING = 1)
	buffpath = /datum/skill_buff/augment/muscle
	name = "mechanical muscles"
	allowed_organs = list(BP_AUGMENT_R_LEG, BP_AUGMENT_L_LEG)
	icon_state = "muscule"
	desc = "Nanofiber tendons powered by an array of actuators to help the wearer mantain speed even while encumbered. You may want to install these in pairs to see a result"
	var/obj/item/organ/internal/augment/boost/muscle/other //we need two for these


/obj/item/organ/internal/augment/boost/muscle/onInstall()

	//1.st Determine where we are and who we should be asking for guidance
	//we must be second to activate buff
	if(organ_tag == BP_AUGMENT_L_LEG)
		other = owner.internal_organs_by_name[BP_AUGMENT_R_LEG]
	else if(organ_tag == BP_AUGMENT_R_LEG)
		other = owner.internal_organs_by_name[BP_AUGMENT_L_LEG]
	if(other && istype(other))
		log_world("Adding buff")
		owner.buff_skill(buffs, 0, buffpath)
		active = 1
		other.active = 1
		other.other = src

/obj/item/organ/internal/augment/boost/muscle/onRemove()
	if(!active)
		return
	var/list/B = owner.fetch_buffs_of_type(buffpath, 0)
	if(B.len)
		B[1].remove()
		if(other)
			other.active = 0
			other.other = null
			other = null
