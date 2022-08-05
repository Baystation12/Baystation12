//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting stuff manually
//as they handle all relevant stuff like adding it to the player's screen and such

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)
/mob/living/silicon/robot/get_active_hand()
	return module_active

/*-------TODOOOOOOOOOO--------*/

//Verbs used by hotkeys.
/mob/living/silicon/robot/verb/cmd_unequip_module()
	set name = "unequip-module"
	set hidden = 1
	uneq_active()

/mob/living/silicon/robot/verb/cmd_toggle_module(module as num)
	set name = "toggle-module"
	set hidden = 1
	toggle_module(module)

/mob/living/silicon/robot/hotkey_drop()
	if (!module)
		to_chat(src, SPAN_WARNING("You haven't selected a module yet."))
		return
	uneq_active()
	hud_used.update_robot_modules_display()

/mob/living/silicon/robot/proc/uneq_active()
	if(isnull(module_active))
		return
	GLOB.module_deactivated_event.raise_event(src, module_active)
	if(module_state_1 == module_active)
		if(istype(module_state_1,/obj/item/borg/sight))
			sight_mode &= ~module_state_1:sight_mode
		if (client)
			client.screen -= module_state_1
		module_state_1.forceMove(module)
		module_active = null
		module_state_1 = null
		inv1.icon_state = "inv1"
	else if(module_state_2 == module_active)
		if(istype(module_state_2,/obj/item/borg/sight))
			sight_mode &= ~module_state_2:sight_mode
		if (client)
			client.screen -= module_state_2
		module_state_2.forceMove(module)
		module_active = null
		module_state_2 = null
		inv2.icon_state = "inv2"
	else if(module_state_3 == module_active)
		if(istype(module_state_3,/obj/item/borg/sight))
			sight_mode &= ~module_state_3:sight_mode
		if (client)
			client.screen -= module_state_3
		module_state_3.forceMove(module)
		module_active = null
		module_state_3 = null
		inv3.icon_state = "inv3"
	update_icon()
	hud_used.update_robot_modules_display()

/mob/living/silicon/robot/proc/uneq_all()
	module_active = null

	if(module_state_1)
		GLOB.module_deactivated_event.raise_event(src, module_state_1)
		if(istype(module_state_1,/obj/item/borg/sight))
			sight_mode &= ~module_state_1:sight_mode
		if (client)
			client.screen -= module_state_1
		module_state_1.forceMove(module)
		module_state_1 = null
		inv1.icon_state = "inv1"
	if(module_state_2)
		GLOB.module_deactivated_event.raise_event(src, module_state_2)
		if(istype(module_state_2,/obj/item/borg/sight))
			sight_mode &= ~module_state_2:sight_mode
		if (client)
			client.screen -= module_state_2
		module_state_2.forceMove(module)
		module_state_2 = null
		inv2.icon_state = "inv2"
	if(module_state_3)
		GLOB.module_deactivated_event.raise_event(src, module_state_3)
		if(istype(module_state_3,/obj/item/borg/sight))
			sight_mode &= ~module_state_3:sight_mode
		if (client)
			client.screen -= module_state_3
		module_state_3.forceMove(module)
		module_state_3 = null
		inv3.icon_state = "inv3"
	update_icon()
	hud_used.update_robot_modules_display()

/mob/living/silicon/robot/proc/activated(obj/item/O)
	if(module_state_1 == O)
		return 1
	else if(module_state_2 == O)
		return 1
	else if(module_state_3 == O)
		return 1
	else
		return 0

//Helper procs for cyborg modules on the UI.
//These are hackish but they help clean up code elsewhere.

//module_selected(module) - Checks whether the module slot specified by "module" is currently selected.
/mob/living/silicon/robot/proc/module_selected(var/module) //Module is 1-3
	return module == get_selected_module()

//module_active(module) - Checks whether there is a module active in the slot specified by "module".
/mob/living/silicon/robot/proc/module_active(var/module) //Module is 1-3
	if(module < 1 || module > 3) return 0

	switch(module)
		if(1)
			if(module_state_1)
				return 1
		if(2)
			if(module_state_2)
				return 1
		if(3)
			if(module_state_3)
				return 1
	return 0

//get_selected_module() - Returns the slot number of the currently selected module.  Returns 0 if no modules are selected.
/mob/living/silicon/robot/proc/get_selected_module()
	if(module_state_1 && module_active == module_state_1)
		return 1
	else if(module_state_2 && module_active == module_state_2)
		return 2
	else if(module_state_3 && module_active == module_state_3)
		return 3

	return 0

//select_module(module) - Selects the module slot specified by "module"
/mob/living/silicon/robot/proc/select_module(module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(!module_active(module)) return

	switch(module)
		if(1)
			if(module_active != module_state_1)
				inv1.icon_state = "inv1 +a"
				inv2.icon_state = "inv2"
				inv3.icon_state = "inv3"
				module_active = module_state_1
		if(2)
			if(module_active != module_state_2)
				inv1.icon_state = "inv1"
				inv2.icon_state = "inv2 +a"
				inv3.icon_state = "inv3"
				module_active = module_state_2
		if(3)
			if(module_active != module_state_3)
				inv1.icon_state = "inv1"
				inv2.icon_state = "inv2"
				inv3.icon_state = "inv3 +a"
				module_active = module_state_3
	module_active.on_active_hand(src)
	GLOB.module_selected_event.raise_event(src, module_active)

//deselect_module(module) - Deselects the module slot specified by "module"
/mob/living/silicon/robot/proc/deselect_module(module) //Module is 1-3
	if(module < 1 || module > 3) return

	GLOB.module_deselected_event.raise_event(src, module_active)
	switch(module)
		if(1)
			if(module_active == module_state_1)
				inv1.icon_state = "inv1"
				module_active = null
		if(2)
			if(module_active == module_state_2)
				inv2.icon_state = "inv2"
				module_active = null
		if(3)
			if(module_active == module_state_3)
				inv3.icon_state = "inv3"
				module_active = null

//toggle_module(module) - Toggles the selection of the module slot specified by "module".
/mob/living/silicon/robot/proc/toggle_module(module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(module_selected(module))
		deselect_module(module)
	else
		if(module_active(module))
			select_module(module)
		else
			deselect_module(get_selected_module()) //If we can't do select anything, at least deselect the current module.
	return

//cycle_modules() - Cycles through the list of selected modules.
/mob/living/silicon/robot/proc/cycle_modules()
	var/slot_start = get_selected_module()
	if(slot_start) deselect_module(slot_start) //Only deselect if we have a selected slot.

	var/slot_num
	if(slot_start == 0)
		slot_num = 1
		slot_start = 2
	else
		slot_num = slot_start + 1

	while(slot_start != slot_num) //If we wrap around without finding any free slots, just give up.
		if(module_active(slot_num))
			select_module(slot_num)
			return
		slot_num++
		if(slot_num > 3) slot_num = 1 //Wrap around.

	return

/mob/living/silicon/robot/proc/activate_module(obj/item/O)
	if(!(locate(O) in module.equipment) && O != src.module.emag)
		return
	if(activated(O))
		to_chat(src, "<span class='notice'>Already activated</span>")
		return
	if(!module_state_1)
		module_state_1 = O
		O.hud_layerise()
		O.screen_loc = inv1.screen_loc
		O.forceMove(src)
		if(istype(module_state_1,/obj/item/borg/sight))
			sight_mode |= module_state_1:sight_mode
	else if(!module_state_2)
		module_state_2 = O
		O.hud_layerise()
		O.screen_loc = inv2.screen_loc
		O.forceMove(src)
		if(istype(module_state_2,/obj/item/borg/sight))
			sight_mode |= module_state_2:sight_mode
	else if(!module_state_3)
		module_state_3 = O
		O.hud_layerise()
		O.screen_loc = inv3.screen_loc
		O.forceMove(src)
		if(istype(module_state_3,/obj/item/borg/sight))
			sight_mode |= module_state_3:sight_mode
	else
		to_chat(src, "<span class='notice'>You need to disable a module first!</span>")
		return
	GLOB.module_activated_event.raise_event(src, O)

/mob/living/silicon/put_in_hands(var/obj/item/W) // No hands.
	if(W.loc)
		W.dropInto(W.loc)
	else if(loc)
		W.dropInto(loc)
	return FALSE

/// Check if the thing being dropped is in a gripper and clear the gripper's reference to it if so
/mob/living/silicon/robot/remove_from_mob(obj/thing, atom/target)
	. = ..()
	if (.)
		for (var/obj/item/gripper/gripper in module?.equipment)
			if (gripper.wrapped == thing)
				gripper.wrapped = null

//Robots don't use inventory slots, so we need to override this.
/mob/living/silicon/robot/canUnEquip(obj/item/I)
	if(!I)
		return 1
	if((I in module) || (I in src)) //Includes all modules and installed components.
		return I.canremove          //Will be 0 for modules, but items held by grippers will also be checked here.
	return 1
