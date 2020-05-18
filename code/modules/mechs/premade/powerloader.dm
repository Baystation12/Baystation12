/mob/living/exosuit/premade/powerloader
	name = "power loader"
	desc = "An ancient, but well-liked cargo handling exosuit."

/mob/living/exosuit/premade/powerloader/Initialize()
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

	. = ..()

/mob/living/exosuit/premade/powerloader/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/drill(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/clamp(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/manipulators/powerloader
	name = "exosuit arms"
	exosuit_desc_string = "heavy-duty industrial lifters"
	max_damage = 70
	power_use = 30
	desc = "The Xion Industrial Digital Interaction Manifolds allow you poke untold dangers from the relative safety of your cockpit."

/obj/item/mech_component/propulsion/powerloader
	name = "exosuit legs"
	exosuit_desc_string = "reinforced hydraulic legs"
	desc = "Wide and stable but not particularly fast."
	max_damage = 70
	move_delay = 4
	turn_delay = 4
	power_use = 10

/obj/item/mech_component/sensors/powerloader
	name = "exosuit sensors"
	gender = PLURAL
	exosuit_desc_string = "simple collision detection sensors"
	desc = "A primitive set of sensors designed to work in tandem with most MKI Eyeball platforms."
	max_damage = 100
	power_use = 0

/obj/item/mech_component/sensors/powerloader/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_ENGINEERING)

/obj/item/mech_component/chassis/powerloader
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial rollcage"
	desc = "A Xion industrial brand roll cage. Technically OSHA compliant. Technically."
	max_damage = 100
	power_use = 0
	climb_time = 6

/obj/item/mech_component/chassis/powerloader/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit(src)

/obj/item/mech_component/chassis/powerloader/Initialize()
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
	. = ..()

/mob/living/exosuit/premade/powerloader/flames_red
	name = "APLU \"Firestarter\""
	desc = "An ancient, but well-liked cargo handling exosuit. This one has cool red flames."
	decal = "flames_red"

/mob/living/exosuit/premade/powerloader/flames_blue
	name = "APLU \"Burning Chrome\""
	desc = "An ancient, but well-liked cargo handling exosuit. This one has cool blue flames."
	decal = "flames_blue"


/mob/living/exosuit/premade/firefighter
	name = "firefighting exosuit"
	desc = "A mix and match of industrial parts designed to withstand fires."

/mob/living/exosuit/premade/firefighter/New()
	if(!arms) 
		arms = new /obj/item/mech_component/manipulators/powerloader(src)
		arms.color = "#385b3c"
	if(!legs) 
		legs = new /obj/item/mech_component/propulsion/powerloader(src)
		legs.color = "#385b3c"
	if(!head) 
		head = new /obj/item/mech_component/sensors/powerloader(src)
		head.color = "#385b3c"
	if(!body) 
		body = new /obj/item/mech_component/chassis/heavy(src)
		body.color = "#385b3c"

	..()

	material = SSmaterials.get_material_by_name(MATERIAL_OSMIUM_CARBIDE_PLASTEEL)

/mob/living/exosuit/premade/firefighter/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/drill(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/extinguisher(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/sensors/firefighter/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_ENGINEERING)

/mob/living/exosuit/premade/powerloader/old
	name = "weathered power loader"
	desc = "An ancient, but well-liked cargo handling exosuit. The paint is starting to flake. Perhaps some maintenance is in order?"

/mob/living/exosuit/premade/powerloader/old/Initialize()
	. = ..()
	var/list/parts = list(arms,legs,head,body)
	for(var/obj/item/mech_component/MC in parts)
		if(prob(35))
			MC.color = rgb(255,rand(188, 225),rand(55, 136))
	//Damage it
	var/obj/item/mech_component/damaged = pick(parts)
	damaged.take_brute_damage((damaged.max_damage / 4 ) * MECH_COMPONENT_DAMAGE_DAMAGED)
	if(prob(33))
		parts -= damaged
		damaged = pick(parts)
		damaged.take_brute_damage((damaged.max_damage / 4 ) * MECH_COMPONENT_DAMAGE_DAMAGED)

/mob/living/exosuit/premade/powerloader/old/spawn_mech_equipment()
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mech_equipment/clamp(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/clamp(src), HARDPOINT_RIGHT_HAND)