/datum/ailment/fault/visual_impair
	name = "visual impairment"
	applies_to_organ = list(
		BP_HEAD, 
		BP_AUGMENT_HEAD
	)
	
/datum/ailment/fault/visual_impair/New()
	..()
	if(organ?.owner)
		organ.owner.add_client_color(/datum/client_color/monochrome)

/datum/ailment/fault/visual_impair/Destroy(force)
	if(organ?.owner)
		organ.owner.remove_client_color(/datum/client_color/monochrome)
	. = ..()
