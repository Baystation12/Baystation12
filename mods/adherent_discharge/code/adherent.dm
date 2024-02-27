/obj/item/organ/internal/cell/adherent
	var/ready_to_charge


/mob/living/carbon/human/proc/toggle_emergency_discharge()
	set category = "Abilities"
	set name = "Toggle emergency discharge"
	set desc = "Allows you to overload your piezo capacitors."

	var/mob/living/carbon/human/adherent = src
	var/obj/item/organ/internal/cell/adherent/adherent_core = adherent.internal_organs_by_name[BP_CELL]
	if(!adherent_core.ready_to_charge)
		adherent_core.ready_to_charge = TRUE
		to_chat(src, SPAN_WARNING("The emergency discharge is ready for use."))
		to_chat(src, SPAN_GOOD("You are ready to discharge, use alt+click on target to electrocute them."))
		adherent.visible_message(SPAN_WARNING("You hear silent crackle sounds from [adherent] tentacles"))
		playsound(loc, 'mods/adherent_discharge/sounds/discharge_on.ogg', 40, 1)
		return

	adherent_core.ready_to_charge = FALSE
	to_chat(src, SPAN_WARNING("You have relieved the tension of your tentacles."))
