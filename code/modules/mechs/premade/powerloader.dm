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
		body.color = "#ffbc37"

	. = ..()

/mob/living/exosuit/premade/powerloader/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/drill/steel(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/clamp(src), HARDPOINT_RIGHT_HAND)

/mob/living/exosuit/premade/powerloader/mechete/Initialize()
	. = ..()

	if (arms)
		arms.color = "#6c8aaf"
	if (legs)
		legs.color = "#6c8aaf"
	if (head)
		head.color = "#6c8aaf"
	if (body)
		body.color = "#6c8aaf"

/mob/living/exosuit/premade/powerloader/mechete/spawn_mech_equipment()
	install_system(new /obj/item/mech_equipment/ballistic_shield(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/melee/mechete(src), HARDPOINT_RIGHT_HAND)


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
	install_system(new /obj/item/mech_equipment/drill/steel(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/extinguisher(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/atmos_shields(src), HARDPOINT_BACK)

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
