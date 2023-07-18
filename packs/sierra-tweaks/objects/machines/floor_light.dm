/obj/machinery/floor_light
	icon = 'packs/sierra-tweaks/icons/machinery/floor_light.dmi'

/obj/machinery/floor_light/use_tool(obj/item/tool, mob/user)
	if(isMultitool(tool))
		var/new_colour = input(usr, "Choose a colour.", "light color", default_light_colour) as color|null
		if(new_colour && new_colour != default_light_colour)
			default_light_colour = new_colour
			update_icon()
		to_chat(usr, SPAN_NOTICE("You set \the [src] to shine with <font color='[default_light_colour]'>a new colour</font>."))

	return ..()
