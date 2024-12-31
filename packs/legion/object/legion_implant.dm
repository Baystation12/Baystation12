/obj/item/implant/legion
	name = "odd implant"
	icon_state = "implant_legion"
	desc = "An odd, small chip-like device clearly meant to be compatible with an implanting device."
	known = FALSE
	hidden = TRUE
	implant_color = "y"


/obj/item/implant/legion/get_data()
	return "<b>Error: Unrecognized device.</b>"


/obj/item/implant/legion/emp_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return


/obj/item/implant/legion/implanted(mob/source)
	var/mob/living/carbon/human/human = source
	if (!istype(human))
		return FALSE
	to_chat(human, FONT_LARGE(SPAN_DANGER("Your mind is suddenly overtaken by a single, driving directive: [SPAN_LEGION("Serve the Legion, serve your Shepherd.")]")))
	log_and_message_admins("was implanted with a legion implant.", source)
	return TRUE


/obj/item/implant/legion/removed()
	to_chat(imp_in, SPAN_WARNING("A wave of nausea comes over you."))
	to_chat(imp_in, SPAN_GOOD("Your mind becomes clear and free, no longer driven to serve the Legion or Shepherd that had enslaved you."))
	..()


/obj/item/implant/legion/meltdown()
	to_chat(imp_in, SPAN_WARNING("A wave of nausea comes over you."))
	to_chat(imp_in, SPAN_GOOD("Your mind becomes clear and free, no longer driven to serve the Legion or Shepherd that had enslaved you."))
	return ..()


/obj/item/implant/legion/can_implant(mob/M, mob/user, target_zone)
	if (!ishuman(M))
		USE_FEEDBACK_FAILURE("\The [M] cannot be imprinted.")
		return FALSE
	var/mob/living/carbon/human/human = M
	var/obj/item/organ/internal/brain/brain = human.internal_organs_by_name[BP_BRAIN]
	if (!brain)
		USE_FEEDBACK_FAILURE("\The [M] has no brain to imprint.")
		return FALSE
	if (brain.parent_organ != check_zone(target_zone))
		USE_FEEDBACK_FAILURE("\The [src] must be implanted in [human.get_organ(brain.parent_organ)].")
		return FALSE
	return TRUE


/obj/item/implanter/legion
	imp = /obj/item/implant/legion


/obj/item/implantcase/legion
	imp = /obj/item/implant/legion
