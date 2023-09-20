/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY

/obj/item/clothing/accessory/stethoscope/use_before(mob/living/target, mob/living/user)
	. = FALSE
	if (!ishuman(target) || !istype(user))
		return FALSE
	if (user.a_intent != I_HELP)
		return FALSE
	var/mob/living/carbon/human/H = target
	var/obj/item/organ/organ = H.get_organ(user.zone_sel.selecting)
	if (!organ)
		return TRUE
	user.visible_message(
		SPAN_ITALIC("\The [user] places \the [src] against \the [target]'s [organ.name]."),
		SPAN_NOTICE("You place \the [src] against \the [target]'s [organ.name]. You hear [english_list(organ.listen())].")
	)
	return TRUE
