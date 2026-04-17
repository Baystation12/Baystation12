//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting stuff manually
//as they handle all relevant stuff like adding it to the player's screen and such

/mob/living/silicon/robot/proc/get_active_module()
	if (isnull(module_active_index))
		return null

	return module_states[module_active_index]

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)
/mob/living/silicon/robot/get_active_hand()
	return get_active_module()


/mob/living/silicon/robot/IsHolding(obj/item/item)
	if (istype(item))
		if (QDELING(item))
			crash_with("Invalid instance supplied: The passed item has been QDEL'd.")
			return
		for (var/obj/item/module_state in module_states)
			if (module_state == item)
				return item
		return

	if (ispath(item, /obj/item))
		for (var/obj/item/module_state in module_states)
			if (istype(module_state, item))
				return item
		return

	crash_with("Invalid instance or path supplied: Not a valid subtype of `/obj/item` or was `null`.")


/mob/living/silicon/robot/HandsEmpty()
	for (var/module_state in module_states)
		if (!isnull(module_state))
			return FALSE

	return TRUE

/mob/living/silicon/robot/HasFreeHand()
	for (var/module_state in module_states)
		if (isnull(module_state))
			return TRUE

	return FALSE

/mob/living/silicon/robot/GetAllHeld(item_path)
	. = list()

	if (HandsEmpty())
		return

	if (!item_path)
		for (var/obj/item/module_state in module_states)
			if (!isnull(module_state))
				. += module_state
		return

	if (ispath(item_path, /obj/item))
		for (var/obj/item/module_state in module_states)
			if (istype(module_state, item_path))
				. += module_state
		return

	crash_with("Invalid path supplied: Not a valid subtype of `/obj/item`.")


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

/mob/living/silicon/robot/proc/eq_module(index, obj/O)
	if (isnull(index))
		return

	module_states[index] = O
	O.hud_layerise()
	O.screen_loc = inv[index].screen_loc
	O.forceMove(src)
	if (istype(module_states[index], /obj/item/borg/sight))
		sight_mode |= module_states[index]:sight_mode

	GLOB.module_activated_event.raise_event(src, O)

/mob/living/silicon/robot/proc/uneq_module(index)
	if (isnull(index))
		return

	var/obj/item/active_module = module_states[index]
	if (isnull(active_module))
		return

	GLOB.module_deactivated_event.raise_event(src, active_module)

	if(istype(active_module, /obj/item/borg/sight))
		sight_mode &= ~active_module:sight_mode
	if (client)
		client.screen -= active_module
	active_module.forceMove(module)
	module_states[index] = null

/mob/living/silicon/robot/proc/uneq_module_by_obj(obj/item/item)
	var/index = 0
	for (var/module_state in module_states)
		index += 1
		if (module_state == item)
			uneq_module(index)

/mob/living/silicon/robot/proc/uneq_active()
	uneq_module(module_active_index)
	update_icon()
	hud_used.update_robot_modules_display()

/mob/living/silicon/robot/proc/uneq_all()
	for (var/index = 1; index <= length(module_states); index++)
		uneq_module(index)

	update_icon()
	hud_used.update_robot_modules_display()

//Helper procs for cyborg modules on the UI.
//These are hackish but they help clean up code elsewhere.

//module_selected(module) - Checks whether the module slot specified by "module" is currently selected.
/mob/living/silicon/robot/proc/module_selected(module) //Module is 1-3
	return module == module_active_index

//module_active(module) - Checks whether there is a module active in the slot specified by "module".
/mob/living/silicon/robot/proc/module_active(module) //Module is 1-3
	return !isnull(module_states[module])

//select_module(module) - Selects the module slot specified by "module"
/mob/living/silicon/robot/proc/select_module(module) //Module is 1-3
	for (var/index = 1; index <= length(inv); index++)
		if (index == module)
			inv[index].icon_state = "inv[index] +a"
		else
			inv[index].icon_state = "inv[index]"

	module_active_index = module
	var/obj/item/active_module = module_states[module_active_index]

	if (isnull(active_module))
		return

	active_module.on_active_hand(src)
	GLOB.module_selected_event.raise_event(src, active_module)

//deselect_module(module) - Deselects the module slot specified by "module"
/mob/living/silicon/robot/proc/deselect_module(module) //Module is 1-3
	var/obj/item/active_module = module_states[module]
	if (!isnull(active_module))
		GLOB.module_deselected_event.raise_event(src, active_module)

	module_active_index = null
	inv[module].icon_state = "inv[module]"

//toggle_module(module) - Toggles the selection of the module slot specified by "module".
/mob/living/silicon/robot/proc/toggle_module(module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(module_selected(module))
		deselect_module(module)
	else
		select_module(module)
	return

//cycle_modules() - Cycles through the list of selected modules.
/mob/living/silicon/robot/proc/cycle_modules()
	var/slot_start = module_active_index
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
	if(!(locate(O) in module.equipment))
		return

	if (!isnull(module_active_index))
		uneq_module(module_active_index)
		eq_module(module_active_index, O)
		return

	if (!HasFreeHand())
		to_chat(src, SPAN_NOTICE("You need to disable a module first!"))
		return

	for (var/index = 1; index <= length(module_states); index++)
		if (isnull(module_states[index]))
			eq_module(index, O)
			return

/mob/living/silicon/put_in_hands(obj/item/W) // No hands.
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
				gripper.update_icon()

//Robots don't use inventory slots, so we need to override this.
/mob/living/silicon/robot/canUnEquip(obj/item/I)
	if(!I)
		return 1
	if((I in module) || (I in src)) //Includes all modules and installed components.
		return I.canremove          //Will be 0 for modules, but items held by grippers will also be checked here.
	return 1
