#define ONLY_DEPLOY 1
#define ONLY_RETRACT 2
#define SEAL_DELAY 30

/*
 * Defines the behavior of hardsuits/rigs/power armour.
 */

/obj/item/weapon/rig

	name = "hardsuit control module"
	icon = 'icons/obj/rig_modules.dmi'
	desc = "A back-mounted hardsuit deployment and control mechanism."
	slot_flags = SLOT_BACK
	req_one_access = list()
	req_access = list()
	w_class = 4

	// These values are passed on to all component pieces.
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.2
	permeability_coefficient = 0.1
	unacidable = 1

	var/interface_path = "hardsuit.tmpl"
	var/ai_interface_path = "hardsuit.tmpl"
	var/interface_title = "Hardsuit Controller"

	// Keeps track of what this rig should spawn with.
	var/suit_type = "hardsuit"
	var/list/initial_modules
	var/chest_type = /obj/item/clothing/suit/space/rig
	var/helm_type =  /obj/item/clothing/head/helmet/space/rig
	var/boot_type =  /obj/item/clothing/shoes/magboots/rig
	var/glove_type = /obj/item/clothing/gloves/rig
	var/cell_type =  /obj/item/weapon/cell/high
	var/air_type =   /obj/item/weapon/tank/oxygen

	//Component/device holders.
	var/obj/item/weapon/tank/air_supply                       // Air tank, if any.
	var/obj/item/clothing/shoes/boots = null                  // Deployable boots, if any.
	var/obj/item/clothing/suit/space/rig/chest                // Deployable chestpiece, if any.
	var/obj/item/clothing/head/helmet/space/rig/helmet = null // Deployable helmet, if any.
	var/obj/item/clothing/gloves/rig/gloves = null            // Deployable gauntlets, if any.
	var/obj/item/weapon/cell/cell                             // Power supply, if any.
	var/obj/item/rig_module/selected_module = null            // Primary system (used with middle-click)
	var/obj/item/rig_module/vision/visor                      // Kinda shitty to have a var for a module, but saves time.
	var/obj/item/rig_module/voice/speech                      // As above.
	var/mob/living/carbon/human/wearer                        // The person currently wearing the rig.
	var/image/mob_icon                                        // Holder for on-mob icon.
	var/list/installed_modules = list()                       // Power consumption/use bookkeeping.

	// Rig status vars.
	var/open = 0                                              // Access panel status.
	var/locked = 1                                            // Lock status.
	var/subverted = 0
	var/interface_locked = 0
	var/control_overridden = 0
	var/ai_override_enabled = 0
	var/security_check_enabled = 1
	var/malfunctioning = 0
	var/malfunction_delay = 0
	var/electrified = 0
	var/locked_down = 0

	var/seal_delay = SEAL_DELAY
	var/sealing                                               // Keeps track of seal status independantly of canremove.
	var/offline = 1                                           // Should we be applying suit maluses?
	var/offline_slowdown = 3                                  // If the suit is deployed and unpowered, it sets slowdown to this.
	var/vision_restriction
	var/offline_vision_restriction = 1                        // 0 - none, 1 - welder vision, 2 - blind. Maybe move this to helmets.
	var/airtight = 1 //If set, will adjust AIRTIGHT and STOPPRESSUREDAMAGE flags on components. Otherwise it should leave them untouched.

	var/emp_protection = 0

	// Wiring! How exciting.
	var/datum/wires/rig/wires
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/item/weapon/rig/examine()
	usr << "This is \icon[src][src.name]."
	usr << "[src.desc]"
	if(wearer)
		for(var/obj/item/piece in list(helmet,gloves,chest,boots))
			if(!piece || piece.loc != wearer)
				continue
			usr << "\icon[piece] \The [piece] [piece.gender == PLURAL ? "are" : "is"] deployed."

	if(src.loc == usr)
		usr << "The maintenance panel is [open ? "open" : "closed"]."
		usr << "Hardsuit systems are [offline ? "<font color='red'>offline</font>" : "<font color='green'>online</green>"]."

/obj/item/weapon/rig/New()
	..()

	item_state = icon_state
	wires = new(src)

	if((!req_access || !req_access.len) && (!req_one_access || !req_one_access.len))
		locked = 0

	spark_system = new()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	processing_objects |= src

	if(initial_modules && initial_modules.len)
		for(var/path in initial_modules)
			var/obj/item/rig_module/module = new path(src)
			installed_modules += module
			module.installed(src)

	// Create and initialize our various segments.
	if(cell_type)
		cell = new cell_type(src)
	if(air_type)
		air_supply = new air_type(src)
	if(glove_type)
		gloves = new glove_type(src)
		verbs |= /obj/item/weapon/rig/proc/toggle_gauntlets
	if(helm_type)
		helmet = new helm_type(src)
		verbs |= /obj/item/weapon/rig/proc/toggle_helmet
	if(boot_type)
		boots = new boot_type(src)
		verbs |= /obj/item/weapon/rig/proc/toggle_boots
	if(chest_type)
		chest = new chest_type(src)
		if(allowed)
			chest.allowed = allowed
		chest.slowdown = offline_slowdown
		verbs |= /obj/item/weapon/rig/proc/toggle_chest

	for(var/obj/item/piece in list(gloves,helmet,boots,chest))
		if(!istype(piece))
			continue
		piece.canremove = 0
		piece.name = "[suit_type] [initial(piece.name)]"
		piece.desc = "It seems to be part of a [src.name]."
		piece.icon_state = "[initial(icon_state)]"
		piece.min_cold_protection_temperature = min_cold_protection_temperature
		piece.max_heat_protection_temperature = max_heat_protection_temperature
		if(piece.siemens_coefficient > siemens_coefficient) //So that insulated gloves keep their insulation.
			piece.siemens_coefficient = siemens_coefficient
		piece.permeability_coefficient = permeability_coefficient
		piece.unacidable = unacidable
		if(islist(armor)) piece.armor = armor.Copy()

	update_icon(1)

/obj/item/weapon/rig/Destroy()
	for(var/obj/item/piece in list(gloves,boots,helmet,chest))
		var/mob/living/M = piece.loc
		if(istype(M))
			M.drop_from_inventory(piece)
		qdel(piece)
	processing_objects -= src
	..()

/obj/item/weapon/rig/proc/suit_is_deployed()
	if(!istype(wearer) || src.loc != wearer || wearer.back != src)
		return 0
	if(helm_type && !(helmet && wearer.head == helmet))
		return 0
	if(glove_type && !(gloves && wearer.gloves == gloves))
		return 0
	if(boot_type && !(boots && wearer.shoes == boots))
		return 0
	if(chest_type && !(chest && wearer.wear_suit == chest))
		return 0
	return 1

/obj/item/weapon/rig/proc/reset()
	offline = 2
	canremove = 1
	for(var/obj/item/piece in list(helmet,boots,gloves,chest))
		if(!piece) continue
		piece.icon_state = "[initial(icon_state)]"
		if(airtight)
			piece.item_flags &= ~(STOPPRESSUREDAMAGE|AIRTIGHT)
	update_icon(1)

/obj/item/weapon/rig/proc/toggle_seals(var/mob/living/carbon/human/M,var/instant)

	if(sealing) return

	if(!check_power_cost(M))
		return 0

	deploy(M,instant)

	var/seal_target = !canremove
	var/failed_to_seal

	canremove = 0 // No removing the suit while unsealing.
	sealing = 1

	if(!seal_target && !suit_is_deployed())
		M.visible_message("<span class='danger'>[M]'s suit flashes an error light.</span>","<span class='danger'>Your suit flashes an error light. It can't function properly without being fully deployed.</span>")
		failed_to_seal = 1

	if(!failed_to_seal)

		if(!instant)
			M.visible_message("<font color='blue'>[M]'s suit emits a quiet hum as it begins to adjust its seals.</font>","<font color='blue'>With a quiet hum, the suit begins running checks and adjusting components.</font>")
			if(seal_delay && !do_after(M,seal_delay))
				if(M) M << "<span class='warning'>You must remain still while the suit is adjusting the components.</span>"
				failed_to_seal = 1

		if(!M)
			failed_to_seal = 1
		else
			for(var/list/piece_data in list(list(M.shoes,boots,"boots",boot_type),list(M.gloves,gloves,"gloves",glove_type),list(M.head,helmet,"helmet",helm_type),list(M.wear_suit,chest,"chest",chest_type)))

				var/obj/item/piece = piece_data[1]
				var/obj/item/compare_piece = piece_data[2]
				var/msg_type = piece_data[3]
				var/piece_type = piece_data[4]

				if(!piece || !piece_type)
					continue

				if(!istype(M) || !istype(piece) || !istype(compare_piece) || !msg_type)
					if(M) M << "<span class='warning'>You must remain still while the suit is adjusting the components.</span>"
					failed_to_seal = 1
					break

				if(!failed_to_seal && M.back == src && piece == compare_piece)

					if(seal_delay && !instant && !do_after(M,seal_delay,needhand=0))
						failed_to_seal = 1

					piece.icon_state = "[initial(icon_state)][!seal_target ? "_sealed" : ""]"
					switch(msg_type)
						if("boots")
							M << "<font color='blue'>\The [piece] [!seal_target ? "seal around your feet" : "relax their grip on your legs"].</font>"
							M.update_inv_shoes()
						if("gloves")
							M << "<font color='blue'>\The [piece] [!seal_target ? "tighten around your fingers and wrists" : "become loose around your fingers"].</font>"
							M.update_inv_gloves()
						if("chest")
							M << "<font color='blue'>\The [piece] [!seal_target ? "cinches tight again your chest" : "releases your chest"].</font>"
							M.update_inv_wear_suit()
						if("helmet")
							M << "<font color='blue'>\The [piece] hisses [!seal_target ? "closed" : "open"].</font>"
							M.update_inv_head()
							if(helmet)
								helmet.update_light(wearer)

					//sealed pieces become airtight, protecting against diseases
					if (!seal_target)
						piece.armor["bio"] = 100
					else
						piece.armor["bio"] = src.armor["bio"]

				else
					failed_to_seal = 1

		if((M && !(istype(M) && M.back == src) && !istype(M,/mob/living/silicon)) || (!seal_target && !suit_is_deployed()))
			failed_to_seal = 1

	sealing = null

	if(failed_to_seal)
		for(var/obj/item/piece in list(helmet,boots,gloves,chest))
			if(!piece) continue
			piece.icon_state = "[initial(icon_state)][!seal_target ? "" : "_sealed"]"
		canremove = !seal_target
		if(airtight)
			update_component_sealed()
		update_icon(1)
		return 0

	// Success!
	canremove = seal_target
	M << "<font color='blue'><b>Your entire suit [canremove ? "loosens as the components relax" : "tightens around you as the components lock into place"].</b></font>"

	if(canremove)
		for(var/obj/item/rig_module/module in installed_modules)
			module.deactivate()
	if(airtight)
		update_component_sealed()
	update_icon(1)

/obj/item/weapon/rig/proc/update_component_sealed()
	for(var/obj/item/piece in list(helmet,boots,gloves,chest))
		if(canremove)
			piece.item_flags &= ~(STOPPRESSUREDAMAGE|AIRTIGHT)
		else
			piece.item_flags |=  (STOPPRESSUREDAMAGE|AIRTIGHT)
	update_icon(1)

/obj/item/weapon/rig/process()

	// If we've lost any parts, grab them back.
	var/mob/living/M
	for(var/obj/item/piece in list(gloves,boots,helmet,chest))
		if(piece.loc != src && !(wearer && piece.loc == wearer))
			if(istype(piece.loc, /mob/living))
				M = piece.loc
				M.drop_from_inventory(piece)
			piece.loc = src

	if(!istype(wearer) || loc != wearer || wearer.back != src || canremove || !cell || cell.charge <= 0)
		if(!cell || cell.charge <= 0)
			if(electrified > 0)
				electrified = 0
			if(!offline)
				if(istype(wearer))
					if(!canremove)
						if (offline_slowdown < 3)
							wearer << "<span class='danger'>Your suit beeps stridently, and suddenly goes dead.</span>"
						else
							wearer << "<span class='danger'>Your suit beeps stridently, and suddenly you're wearing a leaden mass of metal and plastic composites instead of a powered suit.</span>"
					if(offline_vision_restriction == 1)
						wearer << "<span class='danger'>The suit optics flicker and die, leaving you with restricted vision.</span>"
					else if(offline_vision_restriction == 2)
						wearer << "<span class='danger'>The suit optics drop out completely, drowning you in darkness.</span>"
		if(!offline)
			offline = 1
	else
		if(offline)
			offline = 0
			chest.slowdown = initial(slowdown)

	if(offline)
		if(offline == 1)
			for(var/obj/item/rig_module/module in installed_modules)
				module.deactivate()
			offline = 2
			chest.slowdown = offline_slowdown
		return

	if(cell && cell.charge > 0 && electrified > 0)
		electrified--

	if(malfunction_delay > 0)
		malfunction_delay--
	else if(malfunctioning)
		malfunctioning--
		malfunction()

	for(var/obj/item/rig_module/module in installed_modules)
		cell.use(module.process()*10)

/obj/item/weapon/rig/proc/check_power_cost(var/mob/living/user, var/cost, var/use_unconcious, var/obj/item/rig_module/mod, var/user_is_ai)

	if(!istype(user))
		return 0

	var/fail_msg

	if(!user_is_ai)
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.back != src)
			fail_msg = "<span class='warning'>You must be wearing \the [src] to do this.</span>"
		else if(user.incorporeal_move)
			fail_msg = "<span class='warning'>You must be solid to do this.</span>"
	if(sealing)
		fail_msg = "<span class='warning'>The hardsuit is in the process of adjusting seals and cannot be activated.</span>"
	else if(!fail_msg && ((use_unconcious && user.stat > 1) || (!use_unconcious && user.stat)))
		fail_msg = "<span class='warning'>You are in no fit state to do that.</span>"
	else if(!cell)
		fail_msg = "<span class='warning'>There is no cell installed in the suit.</span>"
	else if(cost && cell.charge < cost * 10) //TODO: Cellrate?
		fail_msg = "<span class='warning'>Not enough stored power.</span>"

	if(fail_msg)
		user << "[fail_msg]"
		return 0

	// This is largely for cancelling stealth and whatever.
	if(mod && mod.disruptive)
		for(var/obj/item/rig_module/module in (installed_modules - mod))
			if(module.active && module.disruptable)
				module.deactivate()

	cell.use(cost*10)
	return 1

/obj/item/weapon/rig/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(!user)
		return

	var/list/data = list()

	if(selected_module)
		data["primarysystem"] = "[selected_module.interface_name]"

	if(src.loc != user)
		data["ai"] = 1

	data["seals"] =     "[src.canremove]"
	data["sealing"] =   "[src.sealing]"
	data["helmet"] =    (helmet ? "[helmet.name]" : "None.")
	data["gauntlets"] = (gloves ? "[gloves.name]" : "None.")
	data["boots"] =     (boots ?  "[boots.name]" :  "None.")
	data["chest"] =     (chest ?  "[chest.name]" :  "None.")

	data["charge"] =       cell ? round(cell.charge,1) : 0
	data["maxcharge"] =    cell ? cell.maxcharge : 0
	data["chargestatus"] = cell ? Floor((cell.charge/cell.maxcharge)*50) : 0

	data["emagged"] =       subverted
	data["coverlock"] =     locked
	data["interfacelock"] = interface_locked
	data["aicontrol"] =     control_overridden
	data["aioverride"] =    ai_override_enabled
	data["securitycheck"] = security_check_enabled
	data["malf"] =          malfunction_delay


	var/list/module_list = list()
	var/i = 1
	for(var/obj/item/rig_module/module in installed_modules)
		var/list/module_data = list(
			"index" =             i,
			"name" =              "[module.interface_name]",
			"desc" =              "[module.interface_desc]",
			"can_use" =           "[module.usable]",
			"can_select" =        "[module.selectable]",
			"can_toggle" =        "[module.toggleable]",
			"is_active" =         "[module.active]",
			"engagecost" =        module.use_power_cost*10,
			"activecost" =        module.active_power_cost*10,
			"passivecost" =       module.passive_power_cost*10,
			"engagestring" =      module.engage_string,
			"activatestring" =    module.activate_string,
			"deactivatestring" =  module.deactivate_string,
			"damage" =            module.damage
			)

		if(module.charges && module.charges.len)

			module_data["charges"] = list()
			var/datum/rig_charge/selected = module.charges[module.charge_selected]
			module_data["chargetype"] = selected ? "[selected.display_name]" : "none"

			for(var/chargetype in module.charges)
				var/datum/rig_charge/charge = module.charges[chargetype]
				module_data["charges"] += list(list("caption" = "[chargetype] ([charge.charges])", "index" = "[chargetype]"))

		module_list += list(module_data)
		i++

	if(module_list.len)
		data["modules"] = module_list

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, ((src.loc != user) ? ai_interface_path : interface_path), interface_title, 480, 550, data["ai"] ? contained_state : inventory_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/weapon/rig/update_icon(var/update_mob_icon)

	//TODO: Maybe consider a cache for this (use mob_icon as blank canvas, use suit icon overlay).
	overlays.Cut()
	if(!mob_icon || update_mob_icon)
		var/species_icon = 'icons/mob/rig_back.dmi'
		// Since setting mob_icon will override the species checks in
		// update_inv_wear_suit(), handle species checks here.
		if(wearer && sprite_sheets && sprite_sheets[wearer.species.name])
			species_icon =  sprite_sheets[wearer.species.name]
		mob_icon = image("icon" = species_icon, "icon_state" = "[icon_state]")

	if(installed_modules.len)
		for(var/obj/item/rig_module/module in installed_modules)
			if(module.suit_overlay)
				chest.overlays += image("icon" = 'icons/mob/rig_modules.dmi', "icon_state" = "[module.suit_overlay]", "dir" = SOUTH)

	if(wearer)
		wearer.update_inv_shoes()
		wearer.update_inv_gloves()
		wearer.update_inv_head()
		wearer.update_inv_wear_suit()
		wearer.update_inv_back()
	return

/obj/item/weapon/rig/proc/check_suit_access(var/mob/living/carbon/human/user)

	if(!security_check_enabled)
		return 1

	if(istype(user))
		if(malfunction_check(user))
			return 0
		if(user.back != src)
			return 0
		else if(!src.allowed(user))
			user << "<span class='danger'>Unauthorized user. Access denied.</span>"
			return 0

	else if(!ai_override_enabled)
		user << "<span class='danger'>Synthetic access disabled. Please consult hardware provider.</span>"
		return 0

	return 1

//TODO: Fix Topic vulnerabilities for malfunction and AI override.
/obj/item/weapon/rig/Topic(href,href_list)
	if(!check_suit_access(usr))
		return 0

	if(href_list["toggle_piece"])
		if(ishuman(usr) && (usr.stat || usr.stunned || usr.lying))
			return 0
		toggle_piece(href_list["toggle_piece"], usr)
	else if(href_list["toggle_seals"])
		toggle_seals(usr)
	else if(href_list["interact_module"])

		var/module_index = text2num(href_list["interact_module"])

		if(module_index > 0 && module_index <= installed_modules.len)
			var/obj/item/rig_module/module = installed_modules[module_index]
			switch(href_list["module_mode"])
				if("activate")
					module.activate()
				if("deactivate")
					module.deactivate()
				if("engage")
					module.engage()
				if("select")
					selected_module = module
				if("select_charge_type")
					module.charge_selected = href_list["charge_type"]
	else if(href_list["toggle_ai_control"])
		ai_override_enabled = !ai_override_enabled
		notify_ai("Synthetic suit control has been [ai_override_enabled ? "enabled" : "disabled"].")
	else if(href_list["toggle_suit_lock"])
		locked = !locked

	usr.set_machine(src)
	src.add_fingerprint(usr)
	return 0

/obj/item/weapon/rig/proc/notify_ai(var/message)
	if(!message || !installed_modules || !installed_modules.len)
		return
	for(var/obj/item/rig_module/module in installed_modules)
		for(var/mob/living/silicon/ai/ai in module.contents)
			if(ai && ai.client && !ai.stat)
				ai << "[message]"

/obj/item/weapon/rig/equipped(mob/living/carbon/human/M)
	..()

	if(seal_delay > 0 && istype(M) && M.back == src)
		M.visible_message("<font color='blue'>[M] starts putting on \the [src]...</font>", "<font color='blue'>You start putting on \the [src]...</font>")
		if(!do_after(M,seal_delay))
			if(M && M.back == src)
				M.back = null
				M.drop_from_inventory(src)
			src.loc = get_turf(src)
			return

	if(istype(M) && M.back == src)
		M.visible_message("<font color='blue'><b>[M] struggles into \the [src].</b></font>", "<font color='blue'><b>You struggle into \the [src].</b></font>")
		wearer = M
		update_icon()

/obj/item/weapon/rig/proc/toggle_piece(var/piece, var/mob/living/carbon/human/H, var/deploy_mode)

	if(sealing || !cell || !cell.charge)
		return

	if(!istype(wearer) || !wearer.back == src)
		return

	if(usr == wearer && (usr.stat||usr.paralysis||usr.stunned)) // If the usr isn't wearing the suit it's probably an AI.
		return

	var/obj/item/check_slot
	var/equip_to
	var/obj/item/use_obj

	if(!H)
		return

	switch(piece)
		if("helmet")
			equip_to = slot_head
			use_obj = helmet
			check_slot = H.head
		if("gauntlets")
			equip_to = slot_gloves
			use_obj = gloves
			check_slot = H.gloves
		if("boots")
			equip_to = slot_shoes
			use_obj = boots
			check_slot = H.shoes
		if("chest")
			equip_to = slot_wear_suit
			use_obj = chest
			check_slot = H.wear_suit

	if(use_obj)
		if(check_slot == use_obj && deploy_mode != ONLY_DEPLOY)

			var/mob/living/carbon/human/holder

			if(use_obj)
				holder = use_obj.loc
				if(istype(holder))
					if(use_obj && check_slot == use_obj)
						H << "<font color='blue'><b>Your [use_obj.name] [use_obj.gender == PLURAL ? "retract" : "retracts"] swiftly.</b></font>"
						use_obj.canremove = 1
						holder.drop_from_inventory(use_obj)
						use_obj.loc = get_turf(src)
						use_obj.dropped()
						use_obj.canremove = 0
						use_obj.loc = src

		else if (deploy_mode != ONLY_RETRACT)
			if(check_slot)
				if(check_slot != use_obj)
					H << "<span class='danger'>You are unable to deploy \the [piece] as \the [check_slot] [check_slot.gender == PLURAL ? "are" : "is"] in the way.</span>"
				return
			else
				use_obj.loc = H
				if(!H.equip_to_slot_if_possible(use_obj, equip_to, 0))
					use_obj.loc = src
				else
					H << "<font color='blue'><b>Your [use_obj.name] [use_obj.gender == PLURAL ? "deploy" : "deploys"] swiftly.</b></span>"

	if(piece == "helmet" && helmet)
		helmet.update_light(H)

/obj/item/weapon/rig/proc/deploy(mob/M,var/sealed)

	var/mob/living/carbon/human/H = M

	if(!H || !istype(H)) return

	if(H.back != src)
		return

	if(sealed)
		if(H.head)
			var/obj/item/garbage = H.head
			H.drop_from_inventory(garbage)
			H.head = null
			qdel(garbage)

		if(H.gloves)
			var/obj/item/garbage = H.gloves
			H.drop_from_inventory(garbage)
			H.gloves = null
			qdel(garbage)

		if(H.shoes)
			var/obj/item/garbage = H.shoes
			H.drop_from_inventory(garbage)
			H.shoes = null
			qdel(garbage)

		if(H.wear_suit)
			var/obj/item/garbage = H.wear_suit
			H.drop_from_inventory(garbage)
			H.wear_suit = null
			qdel(garbage)

	for(var/piece in list("helmet","gauntlets","chest","boots"))
		toggle_piece(piece, H, ONLY_DEPLOY)

/obj/item/weapon/rig/dropped(var/mob/user)
	..()
	for(var/piece in list("helmet","gauntlets","chest","boots"))
		toggle_piece(piece, user, ONLY_RETRACT)
	wearer = null

//Todo
/obj/item/weapon/rig/proc/malfunction()
	return 0

/obj/item/weapon/rig/emp_act(severity_class)
	//set malfunctioning
	if(emp_protection < 30) //for ninjas, really.
		malfunctioning += 10
		if(malfunction_delay <= 0)
			malfunction_delay = max(malfunction_delay, round(30/severity_class))

	//drain some charge
	if(cell) cell.emp_act(severity_class + 15)

	//possibly damage some modules
	take_hit((100/severity_class), "electrical pulse", 1)

/obj/item/weapon/rig/proc/shock(mob/user)
	if (electrocute_mob(user, cell, src)) //electrocute_mob() handles removing charge from the cell, no need to do that here.
		spark_system.start()
		if(user.stunned)
			return 1
	return 0

/obj/item/weapon/rig/proc/take_hit(damage, source, is_emp=0)

	if(!installed_modules.len)
		return

	var/chance
	if(!is_emp)
		chance = 2*max(0, damage - (chest? chest.breach_threshold : 0))
	else
		//Want this to be roughly independant of the number of modules, meaning that X emp hits will disable Y% of the suit's modules on average.
		//that way people designing hardsuits don't have to worry (as much) about how adding that extra module will affect emp resiliance by 'soaking' hits for other modules
		chance = 2*max(0, damage - emp_protection)*min(installed_modules.len/15, 1)

	if(!prob(chance))
		return

	//deal addition damage to already damaged module first.
	//This way the chances of a module being disabled aren't so remote.
	var/list/valid_modules = list()
	var/list/damaged_modules = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.damage < 2)
			valid_modules |= module
			if(module.damage > 0)
				damaged_modules |= module

	var/obj/item/rig_module/dam_module = null
	if(damaged_modules.len)
		dam_module = pick(damaged_modules)
	else if(valid_modules.len)
		dam_module = pick(valid_modules)

	if(!dam_module) return

	dam_module.damage++

	if(!source)
		source = "hit"

	if(wearer)
		if(dam_module.damage >= 2)
			wearer << "<span class='danger'>The [source] has disabled your [dam_module.interface_name]!</span>"
		else
			wearer << "<span class='warning'>The [source] has damaged your [dam_module.interface_name]!"
	dam_module.deactivate()

/obj/item/weapon/rig/proc/malfunction_check(var/mob/living/carbon/human/user)
	if(malfunction_delay)
		if(offline)
			user << "<span class='danger'>The suit is completely unresponsive.</span>"
		else
			user << "<span class='danger'>ERROR: Hardware fault. Rebooting interface...</span>"
		return 1
	return 0

/*/obj/item/weapon/rig/proc/forced_move(dir)
	if(locked_down)
		return 0
	if(!control_overridden)
		return
	if(!wearer || wearer.back != src)
		return 0
	wearer.Move(null,dir)*/

/atom/proc/get_rig()
	if(loc)
		return loc.get_rig()
	return null

/obj/item/weapon/rig/get_rig()
	return src

#undef ONLY_DEPLOY
#undef ONLY_RETRACT
#undef SEAL_DELAY
