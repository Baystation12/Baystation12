/mob/living/exosuit/premade/combat
	name = "combat exosuit"
	desc = "A sleek, modern combat exosuit."

/mob/living/exosuit/premade/combat/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/combat(src)
		arms.color = COLOR_GUNMETAL
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/combat(src)
		legs.color = COLOR_GUNMETAL
	if(!head)
		head = new /obj/item/mech_component/sensors/combat(src)
		head.color = COLOR_GUNMETAL
	if(!body)
		body = new /obj/item/mech_component/chassis/combat(src)
		body.color = COLOR_GUNMETAL

	. = ..()

/mob/living/exosuit/premade/combat/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/mounted_system/taser(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/ion(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/flash(src), HARDPOINT_LEFT_SHOULDER)
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_RIGHT_SHOULDER)

/mob/living/exosuit/premade/combat/military
	decal = "cammo1"

/mob/living/exosuit/premade/combat/military/alpine
	decal = "cammo2"

/mob/living/exosuit/premade/combat/military/Initialize()
	. = ..()
	for(var/obj/thing in list(arms,legs,head,body))
		thing.color = COLOR_WHITE

