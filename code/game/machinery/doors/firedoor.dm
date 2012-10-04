/var/const/OPEN = 1
/var/const/CLOSED = 2

/obj/machinery/door/firedoor
	name = "Firelock"
	desc = "Apply crowbar"
	icon = 'icons/obj/doors/Doorfire.dmi'
	icon_state = "door_open"
	opacity = 0
	density = 0
	var/blocked = 0
	var/nextstate = null


	Bumped(atom/AM)
		if(p_open || operating)	return
		if(!density)	return ..()
		return 0


	power_change()
		if(powered(ENVIRON))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER
		return


	attackby(obj/item/weapon/C as obj, mob/user as mob)
		add_fingerprint(user)
		if(operating)	return//Already doing something.
		if(istype(C, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/W = C
			if(W.remove_fuel(0, user))
				blocked = !blocked
				user << text("\red You [blocked?"welded":"unwelded"] the [src]")
				update_icon()
				return

		if(istype(C, /obj/item/weapon/crowbar) || (istype(C,/obj/item/weapon/twohanded/fireaxe) && C:wielded == 1))
			if(blocked || operating)	return
			if(density)
				open()
				return
			else	//close it up again	//fucking 10/10 commenting here einstein
				close()
				return
		return


	process()
		if(operating || stat & NOPOWER || !nextstate)
			return
		switch(nextstate)
			if(OPEN)
				open()
			if(CLOSED)
				close()
		nextstate = null
		return


	animate(animation)
		switch(animation)
			if("opening")
				flick("door_opening", src)
			if("closing")
				flick("door_closing", src)
		return


	update_icon()
		overlays = null
		if(density)
			icon_state = "door_closed"
			if(blocked)
				overlays += "welded"
		else
			icon_state = "door_open"
			if(blocked)
				overlays += "welded_open"
		return



//border_only fire doors are special when it comes to air groups
/obj/machinery/door/firedoor/border_only

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group)
			var/direction = get_dir(src,target)
			return (dir != direction)
		else if(density)
			if(!height)
				var/direction = get_dir(src,target)
				return (dir != direction)
			else
				return 0
		return 1


	//skytodo
	update_nearby_tiles(need_rebuild)
		/*if(!air_master) return 0

		var/turf/simulated/source = loc
		var/turf/simulated/destination = get_step(source,dir)

		if(need_rebuild)
			if(istype(source)) //Rebuild/update nearby group geometry
				if(source.parent)
					air_master.groups_to_rebuild += source.parent
				else
					air_master.tiles_to_update += source
			if(istype(destination))
				if(destination.parent)
					air_master.groups_to_rebuild += destination.parent
				else
					air_master.tiles_to_update += destination
		else
			if(istype(source)) air_master.tiles_to_update += source
			if(istype(destination)) air_master.tiles_to_update += destination*/
		return 1