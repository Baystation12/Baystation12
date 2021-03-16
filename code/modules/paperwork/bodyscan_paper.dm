/obj/item/paper/bodyscan
	color = COLOR_OFF_WHITE
	scan_file_type = /datum/computer_file/data/bodyscan

/obj/item/paper/bodyscan/examine(mob/user)
	set_content(display_medical_data(metadata, user.get_skill_value(SKILL_MEDICAL), TRUE))
	. = ..()

/obj/item/paper/bodyscan/show_info(var/mob/user)
	set_content(display_medical_data(metadata, user.get_skill_value(SKILL_MEDICAL), TRUE))
	. = ..()