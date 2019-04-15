/obj/item/organ/internal/augment/active/skrell_colorchange
	name = "dynamic chromatophores"
	action_button_name = "Change Skin Color"
	roundstart = TRUE
	known = FALSE

/obj/item/organ/internal/augment/active/skrell_colorchange/activate()
	if(!can_activate())
		return
	
	var/chosen_color = input(owner, "Choose a color.", "Change Skin Color") as color|null

	if((!chosen_color) || (!can_activate()))
		return

	owner.r_skin = hex2num(copytext(chosen_color, 2, 4))
	owner.g_skin = hex2num(copytext(chosen_color, 4, 6))
	owner.b_skin = hex2num(copytext(chosen_color, 6, 8))

	owner.r_hair = owner.r_skin
	owner.b_hair = owner.b_skin
	owner.g_hair = owner.g_skin

	for(var/obj/item/organ/external/E in owner)
		E.sync_colour_to_human(owner)

	owner.regenerate_icons()