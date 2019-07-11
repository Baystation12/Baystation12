//A workbench for upgrading things
/obj/structure/table/workbench
	name = "Nanocircuit Repair Bench"
	tool_qualities = list(QUALITY_WORKBENCH = 1)
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "deadspace_workbench"
	standalone = TRUE //No connecting, uses its own icon
	can_plate = FALSE


//Quick ways to open crafting menu at this workbench
/obj/structure/table/workbench/AltClick(var/mob/user)
	if (isliving(user))
		var/mob/living/L = user
		L.open_craft_menu()
