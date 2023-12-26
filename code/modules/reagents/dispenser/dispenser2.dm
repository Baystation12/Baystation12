/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	icon = 'icons/obj/machines/dispensers.dmi'
	icon_state = "dispenser"
	layer = BELOW_OBJ_LAYER
	clicksound = "button"
	clickvol = 20

	var/list/spawn_cartridges = null // Set to a list of types to spawn one of each on New()

	var/list/cartridges = list() // Associative, label -> cartridge
	var/obj/item/reagent_containers/container = null

	var/ui_title = "Chemical Dispenser"

	var/accept_drinking = 0
	var/amount = 30

	idle_power_usage = 100
	density = TRUE
	anchored = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE | OBJ_FLAG_CAN_TABLE
	core_skill = SKILL_CHEMISTRY
	var/can_contaminate = TRUE

/obj/machinery/chemical_dispenser/New()
	..()

	if(spawn_cartridges)
		for(var/type in spawn_cartridges)
			add_cartridge(new type(src))

/obj/machinery/chemical_dispenser/examine(mob/user)
	. = ..()
	to_chat(user, "It has [length(cartridges)] cartridges installed, and has space for [DISPENSER_MAX_CARTRIDGES - length(cartridges)] more.")

/obj/machinery/chemical_dispenser/proc/add_cartridge(obj/item/reagent_containers/chem_disp_cartridge/C, mob/user)
	if(!istype(C))
		if(user)
			to_chat(user, SPAN_WARNING("\The [C] will not fit in \the [src]!"))
		return

	if(length(cartridges) >= DISPENSER_MAX_CARTRIDGES)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] does not have any slots open for \the [C] to fit into!"))
		return

	if(!C.label)
		if(user)
			to_chat(user, SPAN_WARNING("\The [C] does not have a label!"))
		return

	if(cartridges[C.label])
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] already contains a cartridge with that label!"))
		return

	if(user)
		if(user.unEquip(C))
			to_chat(user, SPAN_NOTICE("You add \the [C] to \the [src]."))
		else
			return

	C.forceMove(src)
	cartridges[C.label] = C
	cartridges = sortAssoc(cartridges)
	SSnano.update_uis(src)

/obj/machinery/chemical_dispenser/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label
	SSnano.update_uis(src)

/obj/machinery/chemical_dispenser/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (istype(W, /obj/item/reagent_containers/chem_disp_cartridge))
		add_cartridge(W, user)
		return TRUE

	if (isScrewdriver(W))
		var/label = input(user, "Which cartridge would you like to remove?", "Chemical Dispenser") as null|anything in cartridges
		if(!label) return TRUE
		var/obj/item/reagent_containers/chem_disp_cartridge/C = remove_cartridge(label)
		if(C)
			to_chat(user, SPAN_NOTICE("You remove \the [C] from \the [src]."))
			C.dropInto(loc)
		return TRUE

	if (istype(W, /obj/item/reagent_containers/glass) || istype(W, /obj/item/reagent_containers/food) || istype(W, /obj/item/reagent_containers/ivbag))
		if(container)
			to_chat(user, SPAN_WARNING("There is already \a [container] on \the [src]!"))
			return TRUE

		var/obj/item/reagent_containers/RC = W

		if(!accept_drinking && istype(RC,/obj/item/reagent_containers/food))
			to_chat(user, SPAN_WARNING("This machine only accepts beakers and IV bags!"))
			return TRUE

		if(!RC.is_open_container())
			to_chat(user, SPAN_WARNING("You don't see how \the [src] could dispense reagents into \the [RC]."))
			return TRUE
		if(!user.unEquip(RC, src))
			return TRUE
		container =  RC
		update_icon()
		to_chat(user, SPAN_NOTICE("You set \the [RC] on \the [src]."))
		SSnano.update_uis(src) // update all UIs attached to src
		return TRUE

	return ..()

/obj/machinery/chemical_dispenser/proc/eject_beaker(mob/user)
	if(!container)
		return
	var/obj/item/reagent_containers/B = container
	user.put_in_hands(B)
	container = null
	update_icon()

/obj/machinery/chemical_dispenser/ui_interact(mob/user, ui_key = "main",datum/nanoui/ui = null, force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["amount"] = amount
	data["isBeakerLoaded"] = container ? 1 : 0
	data["glass"] = accept_drinking
	var beakerD[0]
	if(container && container.reagents && length(container.reagents.reagent_list))
		for(var/datum/reagent/R in container.reagents.reagent_list)
			beakerD[LIST_PRE_INC(beakerD)] = list("name" = R.name, "volume" = R.volume)
	data["beakerContents"] = beakerD

	if(container)
		data["beakerCurrentVolume"] = container.reagents.total_volume
		data["beakerMaxVolume"] = container.reagents.maximum_volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var chemicals[0]
	for(var/label in cartridges)
		var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
		chemicals[LIST_PRE_INC(chemicals)] = list("label" = label, "amount" = C.reagents.total_volume)
	data["chemicals"] = chemicals

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_disp.tmpl", ui_title, 390, 680)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/chemical_dispenser/OnTopic(mob/user, href_list)
	if(href_list["amount"])
		amount = round(text2num(href_list["amount"]), 1) // round to nearest 1
		amount = max(0, min(120, amount)) // Since the user can actually type the commands himself, some sanity checking
		return TOPIC_REFRESH

	if(href_list["dispense"])
		var/label = href_list["dispense"]
		if(cartridges[label] && container && container.is_open_container())
			var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
			var/mult = 1 + (-0.5 + round(rand(), 0.1))*(user.skill_fail_chance(core_skill, 0.3, SKILL_TRAINED))
			C.reagents.trans_to(container, amount*mult)
			var/contaminants_left = rand(0, max(SKILL_TRAINED - user.get_skill_value(core_skill), 0)) * can_contaminate
			var/choices = cartridges.Copy()
			while(length(choices) && contaminants_left)
				var/chosen_label = pick_n_take(choices)
				var/obj/item/reagent_containers/chem_disp_cartridge/choice = cartridges[chosen_label]
				if(choice == C)
					continue
				choice.reagents.trans_to(container, round(rand()*amount/5, 0.1))
				contaminants_left--
			return TOPIC_REFRESH
		return TOPIC_HANDLED

	else if(href_list["ejectBeaker"])
		eject_beaker(user)
		return TOPIC_REFRESH



/obj/machinery/chemical_dispenser/AltClick(mob/user)
	if(CanDefaultInteract(user))
		eject_beaker(user)
		return TRUE
	return ..()

/obj/machinery/chemical_dispenser/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/chemical_dispenser/on_update_icon()
	ClearOverlays()
	if(is_powered())
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(container)
		var/mutable_appearance/beaker_overlay
		beaker_overlay = image('icons/obj/machines/dispensers.dmi', src, "lil_beaker")
		beaker_overlay.pixel_x = rand(-10, 5)
		AddOverlays(beaker_overlay)
