/obj/item/weapon/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	item_state = "electronic"
	w_class = ITEM_SIZE_NO_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTIBLE

	var/hide_on_manifest = 0
	var/channels = list()
	var/networks = list()
	var/languages = list(
		LANGUAGE_HUMAN_EURO = 1,
		LANGUAGE_UNATHI_SINTA = 0,
		LANGUAGE_SKRELLIAN = 0,
		LANGUAGE_SIGN = 0,
		LANGUAGE_HUMAN_RUSSIAN = 1
		)
	var/sprites = list()
	var/can_be_pushed = 1
	var/no_slip = 0
	var/obj/item/borg/upgrade/jetpack = null
	var/list/subsystems = list()
	var/list/obj/item/borg/upgrade/supported_upgrades = list()

	// Module subsystem category and ID vars.
	var/display_name
	var/module_category = ROBOT_MODULE_TYPE_GROUNDED
	var/crisis_locked =   FALSE
	var/upgrade_locked =  FALSE

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

	// Gear lists/types.
	var/obj/item/emag
	// Please note that due to how locate() works, equipments that are subtypes of other equipment need to be placed after their closest parent
	var/list/equipment = list()
	var/list/synths = list()
	var/list/skills = list() // Skills that this module grants. Other skills will remain at minimum levels.

/obj/item/weapon/robot_module/Initialize()

	. = ..()

	var/mob/living/silicon/robot/R = loc
	if(!istype(R))
		return INITIALIZE_HINT_QDEL

	R.module = src

	grant_skills(R)
	add_camera_networks(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)

	if(R.silicon_radio)
		R.silicon_radio.recalculateChannels()

	build_equipment(R)
	build_emag(R)
	build_synths(R)

	finalize_equipment(R)
	finalize_emag(R)
	finalize_synths(R)

	R.set_module_sprites(sprites)
	R.choose_icon(R.module_sprites.len + 1, R.module_sprites)

/obj/item/weapon/robot_module/proc/build_equipment()
	var/list/created_equipment = list()
	for(var/thing in equipment)
		if(ispath(thing, /obj/item))
			created_equipment |= new thing(src)
		else if(isitem(thing))
			var/obj/item/I = thing
			I.forceMove(src)
			created_equipment |= I
		else 
			log_debug("Invalid var type in [type] equipment creation - [thing]")
	equipment = created_equipment

/obj/item/weapon/robot_module/proc/finalize_equipment()
	for(var/obj/item/I in equipment)
		I.canremove = FALSE

/obj/item/weapon/robot_module/proc/build_synths()
	var/list/created_synths = list()
	for(var/thing in synths)
		if(ispath(thing, /datum/matter_synth))
			if(!isnull(synths[thing]))
				created_synths += new thing(synths[thing])
			else
				created_synths += new thing
		else if(istype(thing, /datum/matter_synth))
			created_synths |= thing
		else 
			log_debug("Invalid var type in [type] synth creation - [thing]")
	synths = created_synths

/obj/item/weapon/robot_module/proc/finalize_synths()
	return

/obj/item/weapon/robot_module/proc/build_emag()
	if(ispath(emag))
		emag = new emag(src)

/obj/item/weapon/robot_module/proc/finalize_emag()
	if(istype(emag))
		emag.canremove = FALSE
	else
		log_debug("Invalid var type in [type] emag creation - [emag]")
		emag = null

/obj/item/weapon/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)
	reset_skills(R)

	if(R.silicon_radio)
		R.silicon_radio.recalculateChannels()
	R.choose_icon(0, R.set_module_sprites(list("Default" = initial(R.icon_state))))

/obj/item/weapon/robot_module/Destroy()
	QDEL_NULL_LIST(equipment)
	QDEL_NULL_LIST(synths)
	QDEL_NULL(emag)
	QDEL_NULL(jetpack)
	var/mob/living/silicon/robot/R = loc
	if(istype(R) && R.module == src)
		R.module = null
	. = ..()

/obj/item/weapon/robot_module/emp_act(severity)
	if(equipment)
		for(var/obj/O in equipment)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	if(synths)
		for(var/datum/matter_synth/S in synths)
			S.emp_act(severity)
	..()

/obj/item/weapon/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R, var/rate)
	var/obj/item/device/flash/F = locate() in equipment
	if(F)
		if(F.broken)
			F.broken = 0
			F.times_used = 0
			F.icon_state = "flash"
		else if(F.times_used)
			F.times_used--
	if(!synths || !synths.len)
		return
	for(var/datum/matter_synth/T in synths)
		T.add_charge(T.recharge_rate * rate)

/obj/item/weapon/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/datum/language/language_datum in R.languages)
		original_languages[language_datum] = (language_datum in R.speech_synthesizer_langs)

	for(var/language in languages)
		R.add_language(language, languages[language])

/obj/item/weapon/robot_module/proc/remove_languages(var/mob/living/silicon/robot/R)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		R.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		var/datum/language/language_datum = original_language
		R.add_language(language_datum.name, original_languages[original_language])
	original_languages.Cut()

/obj/item/weapon/robot_module/proc/add_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera && (NETWORK_ROBOTS in R.camera.network))
		for(var/network in networks)
			if(!(network in R.camera.network))
				R.camera.add_network(network)
				added_networks |= network

/obj/item/weapon/robot_module/proc/remove_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera)
		R.camera.remove_networks(added_networks)
	added_networks.Cut()

/obj/item/weapon/robot_module/proc/add_subsystems(var/mob/living/silicon/robot/R)
	for(var/subsystem_type in subsystems)
		R.init_subsystem(subsystem_type)

/obj/item/weapon/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	for(var/subsystem_type in subsystems)
		R.remove_subsystem(subsystem_type)

/obj/item/weapon/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags &= ~CANPUSH

/obj/item/weapon/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags |= CANPUSH

/obj/item/weapon/robot_module/proc/handle_emagged()
	return

/obj/item/weapon/robot_module/proc/grant_skills(var/mob/living/silicon/robot/R)
	reset_skills(R) // for safety
	var/list/skill_mod = list()
	for(var/skill_type in skills)
		skill_mod[skill_type] = skills[skill_type] - SKILL_MIN // the buff is additive, so normalize accordingly
	R.buff_skill(skill_mod, buff_type = /datum/skill_buff/robot)

/obj/item/weapon/robot_module/proc/reset_skills(var/mob/living/silicon/robot/R)
	for(var/datum/skill_buff/buff in R.fetch_buffs_of_type(/datum/skill_buff/robot))
		buff.remove()