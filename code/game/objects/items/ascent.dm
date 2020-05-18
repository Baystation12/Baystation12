/obj/item/clustertool
	name = "alien clustertool"
	desc = "A bewilderingly complex knot of tool heads."
	icon = 'icons/obj/ascent.dmi'
	icon_state = "clustertool"
	w_class = ITEM_SIZE_SMALL

	var/tool_mode
	var/list/tool_modes = list("wrench", "wirecutters", "crowbar", "screwdriver")

/obj/item/clustertool/attack_self(var/mob/user)
	var/new_index = tool_modes.Find(tool_mode) + 1
	if(new_index > tool_modes.len)
		new_index = 1
	tool_mode = tool_modes[new_index]
	name = "[initial(name)] ([tool_mode])"
	playsound(user, 'sound/machines/bolts_down.ogg', 10)
	to_chat(user, SPAN_NOTICE("You select the [tool_mode] attachment."))
	update_icon()

/obj/item/clustertool/on_update_icon()
	icon_state = "[initial(icon_state)]-[tool_mode]"

/obj/item/clustertool/Initialize()
	. = ..()
	tool_mode = tool_modes[1]
	name = "[initial(name)] ([tool_mode])"
	update_icon()

/obj/item/clustertool/iswrench()
	return tool_mode == "wrench"

/obj/item/clustertool/iswirecutter()
	return tool_mode == "wirecutters"

/obj/item/clustertool/isscrewdriver()
	return tool_mode == "screwdriver"

/obj/item/clustertool/iscrowbar()
	return tool_mode == "crowbar"
