/mob/living/heavy_vehicle/premade/ripley
	name = "power loader"
	desc = "An ancient but well-liked cargo handling exosuit."

/mob/living/heavy_vehicle/premade/ripley/New()
	if(!arms) arms = new /obj/item/mech_component/manipulators/ripley(src)
	if(!legs) legs = new /obj/item/mech_component/propulsion/ripley(src)
	if(!head) head = new /obj/item/mech_component/sensors/ripley(src)
	if(!body) body = new /obj/item/mech_component/chassis/ripley(src)
	..()
	install_system(new /obj/item/mecha_equipment/mounted_system/rcd(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mecha_equipment/clamp(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/manipulators/ripley
	name = "power loader arms"
	color = "#ffbc37"
/obj/item/mech_component/propulsion/ripley
	name = "power loader legs"
	color = "#ffbc37"
/obj/item/mech_component/sensors/ripley
	name = "power loader sensors"
	gender = PLURAL
	color = "#ffbc37"

/obj/item/mech_component/sensors/ripley/prebuild()
	..()
	software = new(src)
	software.installed_software |= MECH_SOFTWARE_UTILITY
	software.installed_software |= MECH_SOFTWARE_ENGINEERING

/obj/item/mech_component/chassis/ripley
	name = "power loader chassis"
	color = "#ffdc37"
	hatch_descriptor = "roll cage"
	open_cabin = 1
	pilot_offset_y = 8
	pilot_offset_x = 8
	pilot_coverage = 40

/mob/living/heavy_vehicle/premade/ripley/flames_red
	name = "APLU \"Firestarter\""
	desc = "An ancient but well-liked cargo handling exosuit. This one has cool red flames."
	decal = "flames_red"

/mob/living/heavy_vehicle/premade/ripley/flames_blue
	name = "APLU \"Burning Chrome\""
	desc = "An ancient but well-liked cargo handling exosuit. This one has cool blue flames."
	decal = "flames_blue"