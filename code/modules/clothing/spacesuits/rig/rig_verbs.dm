// Interface for humans.
/obj/item/rig/verb/hardsuit_interface()

	set name = "Open Hardsuit Interface"
	set desc = "Open the hardsuit system interface."
	set category = "Hardsuit"
	set src = usr.contents

	if(wearer && wearer.back == src)
		ui_interact(usr)

/obj/item/rig/verb/toggle_vision()

	set name = "Toggle Visor"
	set desc = "Turns your rig visor off or on."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_power_cost(usr))
		return

	if(canremove)
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(!check_suit_access(usr))
		return

	if(!visor)
		to_chat(usr, "<span class='warning'>The hardsuit does not have a configurable visor.</span>")
		return

	if(!visor.active)
		visor.activate()
	else
		visor.deactivate()

/obj/item/rig/proc/toggle_helmet()

	set name = "Toggle Helmet"
	set desc = "Deploys or retracts your helmet."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("helmet",wearer)

/obj/item/rig/proc/toggle_chest()

	set name = "Toggle Chestpiece"
	set desc = "Deploys or retracts your chestpiece."
	set category = "Hardsuit"
	set src = usr.contents

	if(!check_suit_access(usr))
		return

	toggle_piece("chest",wearer)

/obj/item/rig/proc/toggle_gauntlets()

	set name = "Toggle Gauntlets"
	set desc = "Deploys or retracts your gauntlets."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("gauntlets",wearer)

/obj/item/rig/proc/toggle_boots()

	set name = "Toggle Boots"
	set desc = "Deploys or retracts your boots."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	toggle_piece("boots",wearer)

/obj/item/rig/verb/deploy_suit()

	set name = "Deploy Hardsuit"
	set desc = "Deploys helmet, gloves and boots."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	if(!check_power_cost(usr))
		return

	deploy(wearer)

/obj/item/rig/verb/toggle_seals_verb()

	set name = "Toggle Hardsuit"
	set desc = "Activates or deactivates your rig."
	set category = "Hardsuit"
	set src = usr.contents

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_suit_access(usr))
		return

	toggle_seals(wearer)

/obj/item/rig/verb/switch_vision_mode()

	set name = "Switch Vision Mode"
	set desc = "Switches between available vision modes."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(canremove)
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(!visor)
		to_chat(usr, "<span class='warning'>The hardsuit does not have a configurable visor.</span>")
		return

	if(!visor.active)
		visor.activate()

	if(!visor.active)
		to_chat(usr, "<span class='warning'>The visor is suffering a hardware fault and cannot be configured.</span>")
		return

	visor.engage()

/obj/item/rig/proc/alter_voice()

	set name = "Configure Voice Synthesiser"
	set desc = "Toggles or configures your voice synthesizer."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(canremove)
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!speech)
		to_chat(usr, "<span class='warning'>The hardsuit does not have a speech synthesiser.</span>")
		return

	speech.engage()

/obj/item/rig/verb/select_module()

	set name = "Select Module"
	set desc = "Selects a module as your primary system."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(canremove)
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	var/list/selectable = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.selectable)
			selectable |= module

	var/obj/item/rig_module/module = input("Which module do you wish to select?") as null|anything in selectable

	if(!istype(module))
		deselect_module()
		to_chat(usr, "<span class='info'><b>Primary system is now: deselected.</b></span>")
		return

	module.select()
	to_chat(usr, "<span class='info'><b>Primary system is now: [selected_module.interface_name].</b></span>")

/obj/item/rig/verb/toggle_module()

	set name = "Toggle Module"
	set desc = "Toggle a system module."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	if(canremove)
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	var/list/selectable = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.toggleable)
			selectable |= module

	var/obj/item/rig_module/module = input("Which module do you wish to toggle?") as null|anything in selectable

	if(!istype(module))
		return

	if(module.active)
		to_chat(usr, "<span class='info'><b>You attempt to deactivate \the [module.interface_name].</b></span>")
		module.deactivate()
	else
		to_chat(usr, "<span class='info'><b>You attempt to activate \the [module.interface_name].</b></span>")
		module.activate()

/obj/item/rig/verb/engage_module()

	set name = "Engage Module"
	set desc = "Engages a system module."
	set category = "Hardsuit"
	set src = usr.contents

	if(malfunction_check(usr))
		return

	if(canremove)
		to_chat(usr, "<span class='warning'>The suit is not active.</span>")
		return

	if(!istype(wearer) || !wearer.back == src)
		to_chat(usr, "<span class='warning'>The hardsuit is not being worn.</span>")
		return

	if(!check_power_cost(usr, 0, 0, 0, 0))
		return

	var/list/selectable = list()
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.usable)
			selectable |= module

	var/obj/item/rig_module/module = input("Which module do you wish to engage?") as null|anything in selectable

	if(!istype(module))
		return

	to_chat(usr, "<span class='info'><b>You attempt to engage the [module.interface_name].</b></span>")
	module.engage()