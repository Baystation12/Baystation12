/mob/living/exosuit/premade/powerloader
	name = "power loader"
	desc = "An ancient but well-liked cargo handling exosuit."

/mob/living/exosuit/premade/powerloader/New()
	if(!arms) 
		arms = new /obj/item/mech_component/manipulators/powerloader(src)
		arms.color = "#ffbc37"
	if(!legs) 
		legs = new /obj/item/mech_component/propulsion/powerloader(src)
		legs.color = "#ffbc37"
	if(!head) 
		head = new /obj/item/mech_component/sensors/powerloader(src)
		head.color = "#ffbc37"
	if(!body) 
		body = new /obj/item/mech_component/chassis/powerloader(src)
		body.color = "#ffdc37"

	..()

	install_system(new /obj/item/mech_equipment/mounted_system/rcd(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/clamp(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/manipulators/powerloader
	name = "exosuit arms"
	exosuit_desc_string = "heavy-duty industrial lifters"

/obj/item/mech_component/propulsion/powerloader
	name = "exosuit legs"
	exosuit_desc_string = "reinforced hydraulic legs"

/obj/item/mech_component/sensors/powerloader
	name = "exosuit sensors"
	gender = PLURAL
	exosuit_desc_string = "simple collision detection sensors"

/mob/living/exosuit/premade/powerloader/firefighter
	name = "firefighter exosuit"

/obj/item/mech_component/sensors/powerloader/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_ENGINEERING)

/obj/item/mech_component/chassis/powerloader
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial rollcage"

/obj/item/mech_component/chassis/powerloader/New()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 8,  "y" = 8),
			"[WEST]"  = list("x" = 8,  "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 16),
			"[SOUTH]" = list("x" = 8,  "y" = 16),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16, "y" = 16)
		)
	)
	..()

/mob/living/exosuit/premade/powerloader/flames_red
	name = "APLU \"Firestarter\""
	desc = "An ancient but well-liked cargo handling exosuit. This one has cool red flames."
	decal = "flames_red"

/mob/living/exosuit/premade/powerloader/flames_blue
	name = "APLU \"Burning Chrome\""
	desc = "An ancient but well-liked cargo handling exosuit. This one has cool blue flames."
	decal = "flames_blue"