/obj/item/mech_component/sensors
	name = "head"
	icon_state = "loader_head"
	gender = NEUTER

	var/vision_flags = 0
	var/see_invisible = 0
	var/obj/item/robot_parts/robot_component/radio/radio
	var/obj/item/robot_parts/robot_component/camera/camera
	var/obj/item/mech_component/control_module/software
	/// Takes /obj/item/circuitboard/exosystem type paths for what boards get put in for prefabs
	var/list/prebuilt_software = list()
	has_hardpoints = list(HARDPOINT_HEAD)
	var/active_sensors = 0
	power_use = 15
	w_class = ITEM_SIZE_NORMAL

/obj/item/mech_component/sensors/Destroy()
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	QDEL_NULL(software)
	. = ..()

/obj/item/mech_component/sensors/show_missing_parts(mob/user)
	if(!radio)
		to_chat(user, SPAN_WARNING("It is missing a radio."))
	if(!camera)
		to_chat(user, SPAN_WARNING("It is missing a camera."))
	if(!software)
		to_chat(user, SPAN_WARNING("It is missing a software control module."))

/obj/item/mech_component/sensors/prebuild()
	radio = new(src)
	camera = new(src)
	software = new(src)
	for(var/board in prebuilt_software)
		software.install_software(new board)

/obj/item/mech_component/sensors/update_components()
	radio = locate() in src
	camera = locate() in src
	software = locate() in src

/obj/item/mech_component/sensors/proc/get_sight(powered)
	var/flags = 0
	if(total_damage >= 0.8 * max_damage || !powered)
		flags |= BLIND
	else if(active_sensors && powered)
		flags |= vision_flags

	return flags

/obj/item/mech_component/sensors/proc/get_invisible(powered)
	var/invisible = 0
	if((total_damage <= 0.8 * max_damage) && active_sensors && powered)
		invisible = see_invisible
	return invisible



/obj/item/mech_component/sensors/ready_to_install()
	return (radio && camera)

/obj/item/mech_component/sensors/use_tool(obj/item/thing, mob/living/user, list/click_params)
	if(istype(thing, /obj/item/mech_component/control_module))
		if(software)
			to_chat(user, SPAN_WARNING("\The [src] already has a control modules installed."))
			return TRUE
		if(install_component(thing, user))
			software = thing
			return TRUE

	else if(istype(thing,/obj/item/robot_parts/robot_component/radio))
		if(radio)
			to_chat(user, SPAN_WARNING("\The [src] already has a radio installed."))
			return TRUE
		if(install_component(thing, user))
			radio = thing
			return TRUE

	else if(istype(thing,/obj/item/robot_parts/robot_component/camera))
		if(camera)
			to_chat(user, SPAN_WARNING("\The [src] already has a camera installed."))
			return TRUE
		if(install_component(thing, user))
			camera = thing
			return TRUE
	else
		return ..()

/obj/item/mech_component/sensors/return_diagnostics(mob/user)
	..()
	if(software)
		to_chat(user, SPAN_NOTICE(" Installed Software"))
		for(var/exosystem_software in software.installed_software)
			to_chat(user, SPAN_NOTICE(" - <b>[capitalize(exosystem_software)]</b>"))
	else
		to_chat(user, SPAN_WARNING(" Control Module Missing or Non-functional."))
	if(radio)
		to_chat(user, SPAN_NOTICE(" Radio Integrity: <b>[round((((radio.max_dam - radio.total_dam) / radio.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Radio Missing or Non-functional."))
	if(camera)
		to_chat(user, SPAN_NOTICE(" Camera Integrity: <b>[round((((camera.max_dam - camera.total_dam) / camera.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Camera Missing or Non-functional."))


/obj/item/mech_component/control_module
	name = "exosuit control module"
	desc = "A clump of circuitry and software chip docks, used to program exosuits."
	icon_state = "control"
	icon = 'icons/mecha/mech_equipment.dmi'
	gender = NEUTER
	color = COLOR_WHITE
	var/list/installed_software = list()
	var/max_installed_software = 2

/obj/item/mech_component/control_module/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has [max_installed_software - LAZYLEN(installed_software)] empty slot\s remaining out of [max_installed_software]."))

/obj/item/mech_component/control_module/use_tool(obj/item/thing, mob/living/user, list/click_params)
	if(istype(thing, /obj/item/circuitboard/exosystem))
		install_software(thing, user)
		return TRUE

	if(isScrewdriver(thing))
		var/result = ..()
		update_software()
		return result
	else
		return ..()

/obj/item/mech_component/control_module/proc/install_software(obj/item/circuitboard/exosystem/software, mob/user)
	if(length(installed_software) >= max_installed_software)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] can only hold [max_installed_software] software modules."))
		return
	if(user && !user.unEquip(software))
		return

	if(user)
		to_chat(user, SPAN_NOTICE("You load \the [software] into \the [src]'s memory."))

	software.forceMove(src)
	update_software()

/obj/item/mech_component/control_module/proc/update_software()
	installed_software = list()
	for(var/obj/item/circuitboard/exosystem/program in contents)
		installed_software |= program.contains_software


/obj/item/mech_component/sensors/powerloader
	name = "exosuit sensors"
	gender = PLURAL
	exosuit_desc_string = "simple collision detection sensors"
	desc = "A primitive set of sensors designed to work in tandem with most MKI Eyeball platforms."
	max_damage = 100
	power_use = 0
	prebuilt_software = list(/obj/item/circuitboard/exosystem/utility, /obj/item/circuitboard/exosystem/engineering)

/obj/item/mech_component/sensors/light
	name = "light sensors"
	gender = PLURAL
	exosuit_desc_string = "advanced sensor array"
	icon_state = "light_head"
	max_damage = 30
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	power_use = 50
	desc = "A series of high resolution optical sensors. They can overlay several images to give the pilot a sense of location even in total darkness. "
	prebuilt_software = list(/obj/item/circuitboard/exosystem/medical, /obj/item/circuitboard/exosystem/utility)

/obj/item/mech_component/sensors/heavy
	name = "heavy sensors"
	exosuit_desc_string = "a reinforced monoeye"
	desc = "A solitary sensor moves inside a recessed slit in the armour plates."
	icon_state = "heavy_head"
	max_damage = 120
	power_use = 0
	prebuilt_software = list(/obj/item/circuitboard/exosystem/weapons)

/obj/item/mech_component/sensors/combat
	name = "combat sensors"
	gender = PLURAL
	exosuit_desc_string = "high-resolution thermal sensors"
	icon_state = "combat_head"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	power_use = 200
	prebuilt_software = list(/obj/item/circuitboard/exosystem/weapons)
