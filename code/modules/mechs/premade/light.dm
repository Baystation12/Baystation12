/mob/living/exosuit/premade/light
	name = "light exosuit"
	desc = "A light and agile exosuit."

/mob/living/exosuit/premade/light/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/light(src)
		arms.color = COLOR_OFF_WHITE
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/light(src)
		legs.color = COLOR_OFF_WHITE
	if(!head)
		head = new /obj/item/mech_component/sensors/light(src)
		head.color = COLOR_OFF_WHITE
	if(!body)
		body = new /obj/item/mech_component/chassis/light(src)
		body.color = COLOR_OFF_WHITE

	. = ..()

/mob/living/exosuit/premade/light/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/catapult(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/sleeper(src), HARDPOINT_BACK)
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mech_equipment/mender(src), HARDPOINT_RIGHT_HAND)
