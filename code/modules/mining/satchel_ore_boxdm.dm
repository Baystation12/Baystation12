
/**********************Ore box**************************/

/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = 1
	var/last_update = 0
	var/list/stored_ore = list()

/obj/structure/ore_box/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/ore))
		user.u_equip(W)
		src.contents += W
	if (istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		S.hide_from(usr)
		for(var/obj/item/weapon/ore/O in S.contents)
			S.remove_from_storage(O, src) //This will move the item to this item's contents
		user << "\blue You empty the satchel into the box."

	update_ore_count()

	return

/obj/structure/ore_box/proc/update_ore_count()

	stored_ore = list()

	for(var/obj/item/weapon/ore/O in contents)

		if(stored_ore[O.name])
			stored_ore[O.name]++
		else
			stored_ore[O.name] = 1

/obj/structure/ore_box/examine()
	set name = "Examine"
	set category = "IC"
	set src in view(usr.client) //If it can be seen, it can be examined.

	if (!( usr ))
		return
	usr << "That's an [src]."
	usr << desc

	if(!istype(usr, /mob/living/carbon/human)) //Only living, intelligent creatures with hands can check the contents of ore boxes.
		return

	if(!Adjacent(usr)) //Can only check the contents of ore boxes if you can physically reach them.
		return

	add_fingerprint(usr)

	if(!contents.len)
		usr << "It is empty."
		return

	if(world.time > last_update + 10)
		update_ore_count()
		last_update = world.time

	usr << "It holds:"
	for(var/ore in stored_ore)
		usr << "- [stored_ore[ore]] [ore]"
	return


/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = "Object"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human)) //Only living, intelligent creatures with hands can empty ore boxes.
		usr << "\red You are physically incapable of emptying the ore box."
		return

	if( usr.stat || usr.restrained() )
		return

	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
		usr << "You cannot reach the ore box."
		return

	add_fingerprint(usr)

	if(contents.len < 1)
		usr << "\red The ore box is empty"
		return

	for (var/obj/item/weapon/ore/O in contents)
		contents -= O
		O.loc = src.loc
	usr << "\blue You empty the ore box"

	return