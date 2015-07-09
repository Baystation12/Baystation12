/obj/item
	var/list/properties = null
	var/main_prop = null

/obj/item/proc/can_use_tool(var/action, var/mob/user)
	return 1

/obj/item/proc/use_tool(var/action, var/mob/user, var/parameters)
	return

/obj/item/proc/play_tool_sound(var/action)
	switch(action)
		if(TOOL_WRENCH)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(TOOL_SCREWDRIVER)
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(TOOL_WIRECUTTERS)
			playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
		if(TOOL_WELDER)
			playsound(loc, 'sound/items/Welder.ogg', 50, 1)
		if(TOOL_CROWBAR)
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
	return

/obj/item/weapon/wrench
	properties = list(TOOL_WRENCH = 1)
	main_prop = TOOL_WRENCH

/obj/item/weapon/screwdriver
	properties = list(TOOL_SCREWDRIVER = 1, TOOL_CROWBAR = 0.1)
	main_prop = TOOL_SCREWDRIVER

/obj/item/weapon/wirecutters
	properties = list(TOOL_WIRECUTTERS = 1)
	main_prop = TOOL_WIRECUTTERS

/obj/item/weapon/weldingtool
	properties = list(TOOL_WELDER = 1)
	main_prop = TOOL_WELDER

/obj/item/weapon/weldingtool/can_use_tool(var/action, var/mob/user)
	if(action == TOOL_WELDER && welding)
		return 1
	else
		return 0
	return 1

/obj/item/weapon/weldingtool/use_tool(var/action, var/mob/user, var/parameters)
	remove_fuel(parameters, user)

/obj/item/weapon/crowbar
	properties = list(TOOL_CROWBAR = 1)
	main_prop = TOOL_CROWBAR

/obj/item/weapon/combitool
	name = "supertool"
	desc = "A magical tool that can be used in place of any common tool."
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 10
	w_class = 1
	attack_verb = list("constructed")

	properties = list(TOOL_WRENCH = 2, TOOL_SCREWDRIVER = 2, TOOL_WIRECUTTERS = 2, TOOL_WELDER = 2, TOOL_CROWBAR = 2)

/obj/proc/handle_tool(var/obj/item/I, var/mob/user, var/expand = 0)
	var/list/actions = gather_actions()
	actions &= I.properties
	if(!actions || !actions.len)
		return
	if(!expand && (!I.main_prop || !(I.main_prop in actions)))
		return
	var/action
	if(!expand)
		action = I.main_prop
	else if(actions.len == 1)
		action = actions[1]
	else
		action = input(user, "Choose an action", "Action") as null|anything in actions
	if(!action || action == "Cancel")
		return
	if(!I.can_use_tool(action, user))
		return

	I.play_tool_sound(action)
	return tool_act(action, I.properties[action], I, user)

/obj/proc/gather_actions()
	return null

/obj/proc/tool_act(var/action, var/efficiency, var/obj/item/I, var/mob/user)
	return 0
