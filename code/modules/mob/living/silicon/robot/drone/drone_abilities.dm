// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Silicon Commands"

	var/new_tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in GLOB.tagger_locations

	if(!new_tag)
		mail_destination = ""
		return

	to_chat(src, SPAN_NOTICE("You configure your internal beacon, tagging yourself for delivery to '[new_tag]'."))
	mail_destination = new_tag

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/machinery/disposal/D = src.loc
	if(istype(D))
		to_chat(src, SPAN_NOTICE("\The [D] acknowledges your signal."))
		D.flush_count = D.flush_every_ticks

	return

/mob/living/silicon/robot/drone/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object

	if(istype(H) && Adjacent(H) && (usr == H) && (H.a_intent == "grab") && hat && H.HasFreeHand())
		H.put_in_hands(hat)
		H.visible_message(SPAN_DANGER("\The [H] removes \the [src]'s [hat]."))
		hat = null
		update_icons()
		return

	return ..()
