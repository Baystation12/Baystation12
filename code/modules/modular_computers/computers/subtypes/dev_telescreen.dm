/obj/item/modular_computer/telescreen
	name = "telescreen"
	desc = "A wall-mounted touchscreen computer."
	icon = 'icons/obj/machines/modular_telescreen.dmi'
	icon_state = "telescreen"
	icon_state_unpowered = "telescreen"
	hardware_flag = PROGRAM_TELESCREEN
	anchored = TRUE
	density = FALSE
	base_idle_power_usage = 75
	base_active_power_usage = 300
	max_hardware_size = 2
	steel_sheet_cost = 10
	light_strength = 4
	health_max = 300
	broken_damage = 150
	w_class = ITEM_SIZE_HUGE

/obj/item/modular_computer/telescreen/New()
	..()
	// Allows us to create "north bump" "south bump" etc. named objects, for more comfortable mapping.
	name = "telescreen"

/obj/item/modular_computer/telescreen/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isCrowbar(W))
		if(anchored)
			shutdown_computer()
			anchored = FALSE
			screen_on = FALSE
			pixel_x = 0
			pixel_y = 0
			to_chat(user, "You unsecure \the [src].")
			return TRUE
		else
			var/choice = input(user, "Where do you want to place \the [src]?", "Offset selection") in list("North", "South", "West", "East", "This tile", "Cancel")
			var/valid = FALSE
			switch(choice)
				if("North")
					valid = TRUE
					pixel_y = 32
				if("South")
					valid = TRUE
					pixel_y = -32
				if("West")
					valid = TRUE
					pixel_x = -32
				if("East")
					valid = TRUE
					pixel_x = 32
				if("This tile")
					valid = TRUE

			if(valid)
				anchored = TRUE
				screen_on = TRUE
				to_chat(user, "You secure \the [src].")
			return TRUE
	return ..()
