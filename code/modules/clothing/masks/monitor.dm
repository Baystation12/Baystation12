//IPC-face object for FPB.
/obj/item/clothing/mask/monitor

	name = "display monitor"
	desc = "A rather clunky old CRT-style display screen, fit for mounting on an optical output."
	flags_inv = HIDEFACE|HIDEEYES
	body_parts_covered = FACE
	dir = SOUTH

	icon = 'icons/mob/monitor_icons.dmi'
	icon_override = 'icons/mob/monitor_icons.dmi'
	icon_state = "ipc_blank"
	item_state = null

	var/monitor_state_index = "blank"
	var/global/list/monitor_states = list(
		"blank" =    "ipc_blank_s",
		"pink" =     "ipc_pink_s",
		"red" =      "ipc_red_s",
		"green" =    "ipc_green_s",
		"blue" =     "ipc_blue_s",
		"breakout" = "ipc_breakout_s",
		"eight" =    "ipc_eight_s",
		"goggles" =  "ipc_goggles_s",
		"heart" =    "ipc_heart_s",
		"monoeye" =  "ipc_monoeye_s",
		"nature" =   "ipc_nature_s",
		"orange" =   "ipc_orange_s",
		"purple" =   "ipc_purple_s",
		"shower" =   "ipc_shower_s",
		"static" =   "ipc_static_s",
		"yellow" =   "ipc_yellow_s"
		)

/obj/item/clothing/mask/monitor/set_dir()
	dir = SOUTH
	return

/obj/item/clothing/mask/monitor/equipped()
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_mask == src)
		canremove = 0
		H << "<span class='notice'>\The [src] connects to your display output.</span>"

/obj/item/clothing/mask/monitor/dropped()
	canremove = 1
	return ..()

/obj/item/clothing/mask/monitor/mob_can_equip(var/mob/living/carbon/human/user, var/slot)
	if (!..())
		return 0
	if(istype(user))
		var/obj/item/organ/external/E = user.organs_by_name[BP_HEAD]
		if(istype(E) && (E.robotic >= ORGAN_ROBOT))
			return 1
		user << "<span class='warning'>You must have a robotic head to install this upgrade.</span>"
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
		usr << "<span class='warning'>You have not installed \the [src] yet.</span>"
		return
	var/choice = input("Select a screen icon.") as null|anything in monitor_states
	if(choice)
		monitor_state_index = choice
		update_icon()

/obj/item/clothing/mask/monitor/update_icon()
	if(!(monitor_state_index in monitor_states))
		monitor_state_index = initial(monitor_state_index)
	icon_state = monitor_states[monitor_state_index]
	var/mob/living/carbon/human/H = loc
	if(istype(H)) H.update_inv_wear_mask()