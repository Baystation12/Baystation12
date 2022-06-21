//proxima //from infinity
/mob/living/exosuit/premade/combat/merc/Initialize()
	. = ..()
	if(arms)
		arms.color = COLOR_WALL_GUNMETAL
	if(legs)
		legs.color = COLOR_WALL_GUNMETAL
	if(head)
		head.color = COLOR_WALL_GUNMETAL
	if(body)
		body.color = COLOR_WALL_GUNMETAL

/mob/living/exosuit/premade/combat/merc/spawn_mech_equipment()
	install_system(new /obj/item/mech_equipment/mounted_system/taser/plasma_rifle(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/machinegun(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/shields(src), HARDPOINT_BACK)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/plasma(src), HARDPOINT_LEFT_SHOULDER)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/plasma(src), HARDPOINT_RIGHT_SHOULDER)

/obj/item/mech_component/chassis/combat/merc/prebuild()
	. = ..()
	armor = new /obj/item/robot_parts/robot_component/armour/exosuit/combat/syndie(src)
