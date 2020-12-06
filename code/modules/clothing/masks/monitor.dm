//IPC-face object for FPB.
/obj/item/clothing/mask/monitor

	name = "display monitor"
	desc = "A rather clunky old CRT-style display screen, fit for mounting on an optical output."
	flags_inv = HIDEEYES
	body_parts_covered = EYES
	dir = SOUTH

	icon = 'icons/obj/clothing/obj_head_ipc.dmi'
	icon_override = 'icons/mob/monitor_icons.dmi'
	icon_state = "ipc_blank"
	item_state = null

	var/monitor_state_index = "blank"
	var/global/list/monitor_states = list(
		"blank" =    "ipc_blank",
		"pink" =     "ipc_pink",
		"red" =      "ipc_red",
		"green" =    "ipc_green",
		"blue" =     "ipc_blue",
		"breakout" = "ipc_breakout",
		"eight" =    "ipc_eight",
		"goggles" =  "ipc_goggles",
		"heart" =    "ipc_heart",
		"monoeye" =  "ipc_monoeye",
		"nature" =   "ipc_nature",
		"orange" =   "ipc_orange",
		"purple" =   "ipc_purple",
		"shower" =   "ipc_shower",
		"static" =   "ipc_static",
		"yellow" =   "ipc_yellow",
		"smiley" =   "ipc_smiley",
		"list" =     "ipc_database",
		"yes" =      "ipc_yes",
		"no" =       "ipc_no",
		"frown" =    "ipc_frowny",
		"stars" =    "ipc_stars",
		"crt" =      "ipc_crt",
		"scroll" =   "ipc_scroll",
		"console" =  "ipc_console",
		"rgb" =      "ipc_rgb",
		"tetris" =   "ipc_tetris",
		"doom" =     "ipc_doom"
		)

/obj/item/clothing/mask/monitor/set_dir()
	dir = SOUTH
	return

/obj/item/clothing/mask/monitor/equipped()
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_mask == src)
		canremove = 0
		to_chat(H, "<span class='notice'>\The [src] connects to your display output.</span>")

/obj/item/clothing/mask/monitor/dropped()
	canremove = 1
	return ..()

/obj/item/clothing/mask/monitor/mob_can_equip(var/mob/living/carbon/human/user, var/slot)
	if (!..())
		return 0
	if(istype(user))
		var/obj/item/organ/external/E = user.organs_by_name[BP_HEAD]
		if(istype(E) && BP_IS_ROBOTIC(E))
			return 1
		to_chat(user, "<span class='warning'>You must have a robotic head to install this upgrade.</span>")
	return 0

/obj/item/clothing/mask/monitor/verb/set_monitor_state()
	set name = "Set Monitor State"
	set desc = "Choose an icon for your monitor."
	set category = "IC"

	set src in usr
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H != usr)
		return
	if(H.wear_mask != src)
		to_chat(usr, "<span class='warning'>You have not installed \the [src] yet.</span>")
		return
	var/choice = input("Select a screen icon.") as null|anything in monitor_states
	if(choice)
		monitor_state_index = choice
		update_icon()

/obj/item/clothing/mask/monitor/on_update_icon()
	if(!(monitor_state_index in monitor_states))
		monitor_state_index = initial(monitor_state_index)
	icon_state = monitor_states[monitor_state_index]
	var/mob/living/carbon/human/H = loc
	if(istype(H)) H.update_inv_wear_mask()

/obj/item/clothing/mask/monitor/AltClick(var/mob/user)
	set_monitor_state(user)