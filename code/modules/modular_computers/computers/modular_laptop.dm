// Laptop in it's item state, can be carried around.

/obj/item/laptop
	name		= "laptop computer"
	desc		= "A portable computer. It is closed."
	icon		= 'icons/obj/modular_laptop.dmi'
	icon_state	= "laptop-closed"
	item_state	= "laptop-inhand"
	w_class		= 3
	var/obj/machinery/modular_computer/laptop/stored_computer = null

/obj/item/laptop/verb/open_computer()
	set name = "Open Laptop"
	set category = "Object"
	set src in view(1)

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		usr << "<span class='warning'>You can't do that.</span>"
		return

	if(!Adjacent(usr))
		usr << "You can't reach it."
		return

	if(!istype(loc,/turf))
		usr << "[src] is too bulky!  You'll have to set it down."
		return

	if(!stored_computer)
		if(contents.len)
			for(var/obj/O in contents)
				O.loc = loc
		usr << "\The [src] crumbles to pieces."
		spawn(5)
			qdel(src)
		return

	stored_computer.loc = loc
	stored_computer.stat &= ~MAINT
	stored_computer.update_icon()
	stored_computer.open = 1
	loc = stored_computer
	usr << "You open \the [src]."


/obj/item/laptop/AltClick()
	if(Adjacent(usr))
		open_computer()

// The actual laptop
/obj/machinery/modular_computer/laptop
	name = "laptop computer"
	desc = "A portable computer"
	var/obj/item/laptop/portable = null						// Portable version of this computer, dropped on alt-click to allow transport. Used by laptops.
	battery_powered = 1										// Laptops have integrated battery
	icon_state_unpowered = "laptop-open"					// Icon state when the computer is turned off
	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "laptop-open"

/obj/machinery/modular_computer/laptop/update_icon()
	icon_state = icon_state_unpowered

	overlays.Cut()
	if(!enabled)
		return
	if(active_program)
		overlays.Add(active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu)
	else
		overlays.Add(icon_state_menu)

// Close the computer. collapsing it into movable item that can't be used.
/obj/machinery/modular_computer/laptop/verb/close_computer()
	set name = "Close Laptop"
	set category = "Object"
	set src in view(1)

	if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
		usr << "<span class='warning'>You can't do that.</span>"
		return

	if(!Adjacent(usr))
		usr << "<span class='warning'>You can't reach it.</span>"
		return

	close_laptop(usr)

/obj/machinery/modular_computer/laptop/proc/close_laptop(mob/user = null)
	if(istype(loc,/obj/item/laptop))
		return
	if(!istype(loc,/turf))
		return

	if(!portable)
		portable=new
		portable.stored_computer = src

	portable.loc = loc
	loc = portable
	stat |= MAINT
	if(user)
		user << "You close \the [src]."
	open = 0

/obj/machinery/modular_computer/laptop/AltClick()
	if(Adjacent(usr))
		close_laptop()