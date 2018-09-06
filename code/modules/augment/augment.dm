/obj/item/organ/internal/augment
	name = "embedded augment"
	desc = "Embedded augment."
	icon = 'icons/obj/augment.dmi'
	//By default these fit on both flesh and robotic organs and are robotic
	status = ORGAN_ROBOTIC
	var/augment_flags = AUGMENTATION_MECHANIC | AUGMENTATION_ORGANIC
	var/list/allowed_organs = list(BP_R_ARM, BP_L_ARM)
	default_action_type = /datum/action/item_action/organ/augment

/obj/item/organ/internal/augment/Initialize()
	..()
	parent_organ = pick(allowed_organs)
	organ_tag = get_organtag()

//General expectation is onInstall and onRemoved are overwritten to add effects to augmentee
/obj/item/organ/internal/augment/replaced(var/mob/living/carbon/human/target)
	..()

	if(istype(owner))
		onInstall()

/obj/item/organ/internal/augment/proc/onInstall()


/obj/item/organ/internal/augment/removed(var/mob/living/user, var/drop_organ=1)
	onRemove()
	..()

/obj/item/organ/internal/augment/proc/onRemove()


/obj/item/organ/internal/augment/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isScrewdriver(W) && allowed_organs.len > 1)
		//Here we can adjust location for implants that allow multiple slots
		parent_organ = input(user, "Adjust installation parameters") as null|anything in allowed_organs
		organ_tag = get_organtag()
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		return
	..()


/obj/item/organ/internal/augment/proc/get_organtag()
	//This tries to match a parent organ to an augment slot
	//This is intended for limb augs that can go on either
	if(parent_organ == BP_L_LEG)
		return BP_AUGMENT_L_LEG
	if(parent_organ == BP_R_LEG)
		return BP_AUGMENT_R_LEG
	if(parent_organ == BP_L_HAND)
		return BP_AUGMENT_L_HAND
	if(parent_organ == BP_R_HAND)
		return BP_AUGMENT_R_HAND
	if(parent_organ == BP_L_ARM)
		return BP_AUGMENT_L_ARM
	if(parent_organ == BP_R_ARM)
		return BP_AUGMENT_R_ARM
	return ""