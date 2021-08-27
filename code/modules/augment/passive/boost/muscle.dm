//This one must do special handling because you need 2, so other than vars it doesn't share tht much
/datum/skill_buff/augment/muscle

/obj/item/organ/internal/augment/boost/muscle
	buffs = list(SKILL_HAULING = 1)
	buffpath = /datum/skill_buff/augment/muscle
	name = "mechanical muscles"
	allowed_organs = list(BP_AUGMENT_R_LEG, BP_AUGMENT_L_LEG)
	icon_state = "muscule"
	desc = "Nanofiber tendons powered by an array of actuators increase the speed and agility of the user. You may want to install these in pairs to see a result."
	discoverable = TRUE
	var/obj/item/organ/internal/augment/boost/muscle/other //we need two for these

/obj/item/organ/internal/augment/boost/muscle/proc/get_acrobatics_modifier()
	if(!is_broken() && other && !other.is_broken())
		return 1

/obj/item/organ/internal/augment/boost/muscle/onInstall()

	//1.st Determine where we are and who we should be asking for guidance
	//we must be second to activate buff
	if(organ_tag == BP_AUGMENT_L_LEG)
		other = owner.internal_organs_by_name[BP_AUGMENT_R_LEG]
	else if(organ_tag == BP_AUGMENT_R_LEG)
		other = owner.internal_organs_by_name[BP_AUGMENT_L_LEG]
	if(other && istype(other))
		var/succesful = TRUE
		if(owner.get_skill_value(SKILL_HAULING) < SKILL_PROF)
			succesful = FALSE
			var/datum/skill_buff/augment/muscle/A
			A = owner.buff_skill(buffs, 0, buffpath)
			if(A && istype(A))
				succesful = TRUE
				A.id = id

		if(succesful)
			other.other = src
			other.active = TRUE
			active = TRUE

/obj/item/organ/internal/augment/boost/muscle/onRemove()
	if(!active)
		return
	var/list/B = owner.fetch_buffs_of_type(buffpath, 0)
	for(var/datum/skill_buff/augment/muscle/D in B)
		if(D.id == id)
			D.remove()
			break

	if(other)
		other.active = FALSE
		other.other = null
		other = null
	active = FALSE

/obj/item/organ/internal/augment/boost/muscle/Destroy()
	. = ..()
	other = null //If somehow onRemove didn't handle it
