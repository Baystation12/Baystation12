/mob/living/exosuit/premade/light
	name = "light exosuit"
	desc = "A light and agile exosuit."

/mob/living/exosuit/premade/light/New()
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

	..()

	install_system(new /obj/item/mech_equipment/catapult(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)

/obj/item/mech_component/manipulators/light
	name = "light arms"
	exosuit_desc_string = "lightweight, segmented manipulators"
	icon_state = "light_arms"
	melee_damage = 5
	action_delay = 15
	max_damage = 40

/obj/item/mech_component/propulsion/light
	name = "light legs"
	exosuit_desc_string = "aerodynamic electromechanic legs"
	icon_state = "light_legs"
	move_delay = 2
	max_damage = 40

/obj/item/mech_component/sensors/light
	name = "light sensors"
	gender = PLURAL
	exosuit_desc_string = "minimalistic sensors"
	icon_state = "light_head"
	max_damage = 30
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/mech_component/sensors/light/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_MEDICAL)

/obj/item/mech_component/chassis/light
	name = "light exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	transparent_cabin =  FALSE
	exosuit_desc_string = "an open and light chassis"
	icon_state = "light_body"
	max_damage = 50

/obj/item/mech_component/chassis/light/New()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = -2),
			"[SOUTH]" = list("x" = 8,  "y" = -2),
			"[EAST]"  = list("x" = 1,  "y" = -2),
			"[WEST]"  = list("x" = 9,  "y" = -2)
		)
	)
	..()
