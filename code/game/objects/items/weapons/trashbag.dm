/obj/item/weapon/trashbag
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag0"
	item_state = "trashbag"
	name = "Trash bag"
	desc = "A heavy-duty, no fun allowed trash bag."
	var/mode = 1;  //0 = pick one at a time, 1 = pick all on tile
	var/capacity = 25; //the number of trash it can carry.
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	w_class = 2.0

/obj/item/weapon/trashbag/update_icon()
	if(contents.len == 0)
		icon_state = "trashbag0"
	else if(contents.len < 12)
		icon_state = "trashbag1"
	else if(contents.len < 25)
		icon_state = "trashbag2"
	else icon_state = "trashbag3"

/obj/item/weapon/trashbag/attackby(obj/item/W as obj, mob/living/user as mob)
	..()
	if (contents.len < capacity)
		if (istype(W, /obj/item))
			if (W.w_class <= 2)
				var/obj/item/O = W
				src.contents += O
	else
		user << "\blue The bag is full!"

/obj/item/weapon/trashbag/attack_self(mob/living/user as mob)

	if(contents.len > 0)
		for(var/obj/item/I in src.contents)
			I.loc = user.loc
		update_icon()
		user << "\blue You drop all the trash onto the floor."

/obj/item/weapon/trashbag/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	if(istype(target, /obj/item))
		var/obj/item/W = target
		if(W.w_class <= 2)
			if(mode == 1)
				if(contents.len < capacity)	//slightly redundant, but it makes it prettier in the chatbox. -Pete
					user << "\blue You pick up all the trash."
					for(var/obj/item/O in get_turf(W))
						if(istype(O, /obj/item/weapon/disk/nuclear)) continue //No nuke disks - Nodrak
						if(contents.len < capacity)
							if(O.w_class <= 2)
								contents += O;
						else
							user << "\blue The bag is full!"
							break
				else
					user << "\blue The bag is full!"
			else
				if(istype(W, /obj/item/weapon/disk/nuclear)) return //No nuke disks - Nodrak
				if(contents.len < capacity)
					contents += W;
				else
					user << "\blue The bag is full!"
			update_icon()
		return

/obj/item/weapon/trashbag/verb/toggle_mode()
	set name = "Switch Bag Method"
	set category = "Object"

	mode = !mode
	switch (mode)
		if(1)
			usr << "The bag now picks up all trash in a tile at once."
		else
			usr << "The bag now picks up one piece of trash at a time."