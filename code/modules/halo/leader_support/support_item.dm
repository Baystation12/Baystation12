
GLOBAL_LIST_INIT(support_options_global,list())
GLOBAL_LIST_INIT(support_pads_global,list())

/obj/item/support_pad
	name = "TACpad"
	desc = "Allows you to call in various supportive options from orbiting stealth ships and other hidden craft."
	anchored = 1
	mouse_opacity = 0

	var/list/options_init = list(\
	/datum/support_option/supply_drop/mass_ammo,
	/datum/support_option/supply_drop/medical_drop,
	/datum/support_option/supply_drop/vehicle_drop,
	/datum/support_option/supply_drop/construction_drop,
	)
	var/stored_user
	var/list/options = list()
	var/cooldown_msg = "Stealth ships are still repositioning from last request."
	var/next_use = 0

/obj/item/support_pad/Initialize()
	. = ..()
	for(var/option in options_init)
		var/datum/support_option/o = new option (src)
		options += o.name
		if(!(o.name in GLOB.support_options_global))
			GLOB.support_options_global[o.name] = o
		else
			qdel(o)
	options_init.Cut()

/obj/item/support_pad/proc/have_required_rank(var/mob/m,var/datum/support_option/o)
	if(o && m && m.mind)
		var/datum/job/j = job_master.occupations_by_title[m.mind.assigned_role]
		if(j && j.command_rank >= o.rank_required)
			return 1
	return 0

/obj/item/support_pad/proc/is_user_valid(var/mob/user)
	if(!stored_user)
		stored_user = user
		return 1
	if(user != stored_user)
		return 0
	return 1

/obj/item/support_pad/proc/can_use(var/mob/m,var/datum/support_option/o)
	if(world.time < next_use)
		to_chat(m,"[cooldown_msg] [(next_use - world.time)/60] minutes left.")
		return 0
	if(!have_required_rank(m,o))
		return 0
	return 1

/obj/item/support_pad/proc/activate_option(var/datum/support_option/o,var/mob/m)
	if(!can_use(m,o))
		return
	if(o.activate_option(src.loc,m))
		next_use = world.time + o.cooldown_inflict

//ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nano_ui/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
/obj/item/support_pad/ui_interact(mob/user, ui_key = "cmduplnk", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]
	data["locked_seconds"] = 0
	if(world.time < next_use)
		data["locked_message"] = cooldown_msg
		data["locked_seconds"] = (next_use - world.time)/10
	for(var/entry in options)
		var/datum/support_option/o = GLOB.support_options_global[entry]
		data["options"] += list(list(\
		"name" = entry,
		"desc" = "[o.desc]",
		"cooldown" = "Estimated Cooldown:[o.cooldown_inflict/600] minutes",
		"uservalid" = is_user_valid(user),
		"have_rank" = have_required_rank(user,o)
		))
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		//(nuser, nsrc_object, nui_key, ntemplate_filename, ntitle = 0, nwidth = 0, nheight = 0, var/atom/nref = null, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
		ui = new(user, src, ui_key, "leader_support_item.tmpl", "Command Uplink", 800, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/support_pad/Topic(href,href_list)
	var/selected = href_list["selected"]
	if(selected && selected in options)
		var/datum/support_option/o = GLOB.support_options_global[selected]
		if(o && istype(usr,/mob/living))
			activate_option(o,usr)
		src.add_fingerprint(usr)
		GLOB.nanomanager.update_uis(src)

/obj/item/support_pad/covenant
	options_init = list(\
	/datum/support_option/supply_drop/mass_ammo/cov,
	/datum/support_option/supply_drop/medical_drop/cov,
	/datum/support_option/supply_drop/vehicle_drop/cov,
	/datum/support_option/supply_drop/construction_drop/cov,
	)