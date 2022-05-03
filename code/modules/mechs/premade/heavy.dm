/mob/living/exosuit/premade/heavy
	name = "Heavy exosuit"
	desc = "A heavily armored combat exosuit."

/mob/living/exosuit/premade/heavy/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/heavy(src)
		arms.color = COLOR_TITANIUM
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/heavy(src)
		legs.color = COLOR_TITANIUM
	if(!head)
		head = new /obj/item/mech_component/sensors/heavy(src)
		head.color = COLOR_TITANIUM
	if(!body)
		body = new /obj/item/mech_component/chassis/heavy(src)
		body.color = COLOR_TITANIUM

	. = ..()

/mob/living/exosuit/premade/heavy/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/mounted_system/taser/laser(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/ion(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/shields(src), HARDPOINT_BACK)

/mob/living/exosuit/premade/heavy/merc/Initialize()
	. = ..()
	if(arms)
		arms.color = COLOR_RED
	if(legs)
		legs.color = COLOR_RED
	if(head)
		head.color = COLOR_RED
	if(body)
		body.color = COLOR_DARK_GUNMETAL

/mob/living/exosuit/premade/heavy/merc/spawn_mech_equipment()
	install_system(new /obj/item/mech_equipment/mounted_system/taser(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/laser(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/shields(src), HARDPOINT_BACK)