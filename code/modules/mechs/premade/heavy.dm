/mob/living/exosuit/premade/heavy
	name = "Heavy exosuit"
	desc = "A heavily armored combat exosuit."

/mob/living/exosuit/premade/heavy/New()
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

	..()

	install_system(new /obj/item/mech_equipment/mounted_system/taser/laser(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/ion(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/manipulators/heavy
	name = "combat arms"
	exosuit_desc_string = "super-heavy reinforced manipulators"
	icon_state = "heavy_arms"
	desc = "Designed to function where any other piece of equipment would have long fallen apart, the Hephaestus Superheavy Lifter series can take a beating and excel at delivering it."
	melee_damage = 25
	action_delay = 15
	max_damage = 70

/obj/item/mech_component/propulsion/heavy
	name = "heavy legs"
	exosuit_desc_string = "heavy hydraulic legs"
	desc = "Oversized acutators struggle to move these armoured legs. "
	icon_state = "heavy_legs"
	move_delay = 5
	max_damage = 80

/obj/item/mech_component/sensors/heavy
	name = "heavy sensors"
	exosuit_desc_string = "reinforced monoeye"
	desc = "A solitary sensor moves inside a recessed slit in the armour plates."
	icon_state = "heavy_head"
	max_damage = 70

/obj/item/mech_component/sensors/heavy/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS, MECH_SOFTWARE_ADVWEAPONS)

/obj/item/mech_component/chassis/heavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "The HI-Koloss chassis is a veritable juggernaut, capable of protecting a pilot even in the most hostile of environments. It handles like a battlecruiser, however"
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "heavy_body"
	max_damage = 100
	mech_health = 500

/obj/item/mech_component/chassis/heavy/New()
	..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit
	set_extension(src, /datum/extension/armor, /datum/extension/armor, armour.armor)


