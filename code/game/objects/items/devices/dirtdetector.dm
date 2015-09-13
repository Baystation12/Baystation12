/obj/item/device/dirtdetector

	name = "dirt detector"
	desc = "Detects all dirt on the station."

	icon = 'icons/obj/janitor.dmi'
	icon_state = "dirtdetector"
	item_state = "electronic"

	var/list/stored_dirt_areas = list()
	var/list/stored_trash_areas = list()
	var/lastuse = 0

/obj/item/device/dirtdetector/attack_self(mob/user as mob)
	if(world.time - lastuse < 5)
		return
	if (user.stat)
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return

	scan_dirt()
	display_scan_info(user)


/obj/item/device/dirtdetector/proc/scan_dirt()
	lastuse = world.time

	for(var/obj/effect/decal/cleanable/D in world)
		if(D.z == 1 && !(D.loc.loc in stored_dirt_areas))
			stored_dirt_areas += D.loc.loc

	for(var/obj/item/trash/T in world)
		if(T.z == 1 && !(T.loc.loc in stored_trash_areas))
			stored_trash_areas += T.loc.loc


/obj/item/device/dirtdetector/proc/display_scan_info(mob/user)

	user.show_message("\blue ==== DIRT DETECTOR DATA ====",1)

	for(var/A in stored_dirt_areas)
		user.show_message("\blue Dirt detected in [A]",1)
		stored_dirt_areas -= A

	for(var/A in stored_trash_areas)
		user.show_message("\blue Trash detected in [A]",1)
		stored_trash_areas -= A

	user.show_message("\blue =========================",1)