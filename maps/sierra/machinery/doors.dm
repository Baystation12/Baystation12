/obj/machinery/door/airlock/medical/mortus
	door_color = COLOR_DARK_GUNMETAL
	stripe_color = COLOR_SKY_BLUE

/obj/machinery/door/airlock/multi_tile/glass/medical/mortus
	door_color = COLOR_DARK_GUNMETAL
	stripe_color = COLOR_SKY_BLUE

/obj/machinery/door/airlock/antagonist
	door_color = COLOR_WALL_GUNMETAL
	stripe_color = COLOR_RED_LIGHT

/obj/machinery/door/airlock/multi_tile/antagonist
	door_color = COLOR_WALL_GUNMETAL
	stripe_color = COLOR_RED_LIGHT

/obj/machinery/door/airlock/glass/medical/mortus
	door_color = COLOR_DARK_GUNMETAL
	stripe_color = COLOR_SKY_BLUE

/obj/machinery/door/blast/regular/lockdown
	name = "Security Lockdown"
	desc = "That looks like it doesn't open easily. \
	But that one has NFC sign. May be my ID can help?"
	req_access = list(list(access_sec_doors, access_engine, access_medical))
	begins_closed = FALSE
	icon_state = "pdoor0"
	health_min_damage = 50
	health_max = 5000

/obj/machinery/door/blast/regular/lockdown/emag_act(remaining_charges)
	. = ..(remaining_charges, TRUE)
	if(.)
		for(var/obj/machinery/door/blast/regular/lockdown/door as anything in SSmachines.get_machinery_of_type(/obj/machinery/door/blast/regular/lockdown))
			if(door.id_tag == id_tag && door.density && door.operable())
				invoke_async(door, TYPE_PROC_REF(/obj/machinery/door, do_animate), "emag")

/obj/machinery/door/blast/regular/lockdown/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if(isid(tool) || istype(tool, /obj/item/modular_computer/pda))
		if(allowed(user))
			for(var/obj/machinery/door/blast/regular/lockdown/door as anything in SSmachines.get_machinery_of_type(/obj/machinery/door/blast/regular/lockdown))
				if(door.id_tag == id_tag)
					invoke_async(door, TYPE_PROC_REF(/obj/machinery/door, open))
		return TRUE
	return ..()

/obj/machinery/door/blast/regular/lockdown/attack_ai()
	for(var/obj/machinery/door/blast/regular/lockdown/door as anything in SSmachines.get_machinery_of_type(/obj/machinery/door/blast/regular/lockdown))
		if(door.id_tag == id_tag)
			if(door.density)
				invoke_async(door, TYPE_PROC_REF(/obj/machinery/door, open))
			else
				invoke_async(door, TYPE_PROC_REF(/obj/machinery/door, close))
