//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/*Composed of 7 parts
3 Particle emitters
proc
emit_particle()

1 power box
the only part of this thing that uses power, can hack to mess with the pa/make it better.
Lies, only the control computer draws power.

1 fuel chamber
contains procs for mixing gas and whatever other fuel it uses
mix_gas()

1 gas holder WIP
acts like a tank valve on the ground that you wrench gas tanks onto
proc
extract_gas()
return_gas()
attach_tank()
remove_tank()
get_available_mix()

1 End Cap

1 Control computer
interface for the pa, acts like a computer with an html menu for diff parts and a status report
all other parts contain only a ref to this
a /machine/, tells the others to do work
contains ref for all parts
proc
process()
check_build()

Setup map
  |EC|
CC|FC|
  |PB|
PE|PE|PE


Icon Addemdum
Icon system is much more robust, and the icons are all variable based.
Each part has a reference string, powered, strength, and contruction values.
Using this the update_icon() proc is simplified a bit (using for absolutely was problematic with naming),
so the icon_state comes out be:
"[reference][strength]", with a switch controlling construction_states and ensuring that it doesn't
power on while being contructed, and all these variables are set by the computer through it's scan list
Essential order of the icons:
Standard - [reference]
Wrenched - [reference]
Wired    - [reference]w
Closed   - [reference]c
Powered  - [reference]p[strength]
Strength being set by the computer and a null strength (Computer is powered off or inactive) returns a 'null', counting as empty
So, hopefully this is helpful if any more icons are to be added/changed/wondering what the hell is going on here

*/

/obj/structure/particle_accelerator
	name = "Particle Accelerator"
	desc = "Part of a Particle Accelerator."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "none"
	anchored = 0
	density = 1
	var/obj/machinery/particle_accelerator/control_box/master = null
	var/construction_state = 0
	var/reference = null
	var/powered = 0
	var/strength = null
	var/desc_holder = null

/obj/structure/particle_accelerator/Destroy()
	construction_state = 0
	if(master)
		master.part_scan()
	. = ..()

/obj/structure/particle_accelerator/end_cap
	name = "Alpha Particle Generation Array"
	desc_holder = "This is where Alpha particles are generated from \[REDACTED\]"
	icon_state = "end_cap"
	reference = "end_cap"

/obj/structure/particle_accelerator/update_icon()
	..()
	return


/obj/structure/particle_accelerator/verb/rotate()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

/obj/structure/particle_accelerator/verb/rotateccw()
	set name = "Rotate Counter Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1

/obj/structure/particle_accelerator/examine(mob/user)
	switch(src.construction_state)
		if(0)
			src.desc = text("A [name], looks like it's not attached to the flooring")
		if(1)
			src.desc = text("A [name], it is missing some cables")
		if(2)
			src.desc = text("A [name], the panel is open")
		if(3)
			src.desc = text("The [name] is assembled")
			if(powered)
				src.desc = src.desc_holder
	..()
	return


/obj/structure/particle_accelerator/attackby(obj/item/W, mob/user)
	if(istool(W))
		if(src.process_tool_hit(W,user))
			return
	..()
	return


/obj/structure/particle_accelerator/Move()
	..()
	if(master && master.active)
		master.toggle_power()
		investigate_log("was moved whilst active; it <font color='red'>powered down</font>.","singulo")

/obj/structure/particle_accelerator/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				qdel(src)
				return
		else
	return

/obj/structure/particle_accelerator/update_icon()
	switch(construction_state)
		if(0,1)
			icon_state="[reference]"
		if(2)
			icon_state="[reference]w"
		if(3)
			if(powered)
				icon_state="[reference]p[strength]"
			else
				icon_state="[reference]c"
	return

/obj/structure/particle_accelerator/proc/update_state()
	if(master)
		master.update_state()
		return 0


/obj/structure/particle_accelerator/proc/report_ready(var/obj/O)
	if(O && (O == master))
		if(construction_state >= 3)
			return 1
	return 0


/obj/structure/particle_accelerator/proc/report_master()
	if(master)
		return master
	return 0


/obj/structure/particle_accelerator/proc/connect_master(var/obj/O)
	if(O && istype(O,/obj/machinery/particle_accelerator/control_box))
		if(O.dir == src.dir)
			master = O
			return 1
	return 0


/obj/structure/particle_accelerator/proc/process_tool_hit(var/obj/O, var/mob/user)
	if(!(O) || !(user))
		return 0
	if(!ismob(user) || !isobj(O))
		return 0
	var/temp_state = src.construction_state

	switch(src.construction_state)//TODO:Might be more interesting to have it need several parts rather than a single list of steps
		if(0)
			if(iswrench(O))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				src.anchored = 1
				user.visible_message("[user.name] secures the [src.name] to the floor.", \
					"You secure the external bolts.")
				temp_state++
		if(1)
			if(iswrench(O))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				src.anchored = 0
				user.visible_message("[user.name] detaches the [src.name] from the floor.", \
					"You remove the external bolts.")
				temp_state--
			else if(iscoil(O))
				if(O:use(1,user))
					user.visible_message("[user.name] adds wires to the [src.name].", \
						"You add some wires.")
					temp_state++
		if(2)
			if(iswirecutter(O))//TODO:Shock user if its on?
				user.visible_message("[user.name] removes some wires from the [src.name].", \
					"You remove some wires.")
				temp_state--
			else if(isscrewdriver(O))
				user.visible_message("[user.name] closes the [src.name]'s access panel.", \
					"You close the access panel.")
				temp_state++
		if(3)
			if(isscrewdriver(O))
				user.visible_message("[user.name] opens the [src.name]'s access panel.", \
					"You open the access panel.")
				temp_state--
	if(temp_state == src.construction_state)//Nothing changed
		return 0
	else
		src.construction_state = temp_state
		if(src.construction_state < 3)//Was taken apart, update state
			update_state()
		update_icon()
		return 1
	return 0



/obj/machinery/particle_accelerator
	name = "Particle Accelerator"
	desc = "Part of a Particle Accelerator."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "none"
	anchored = 0
	density = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/construction_state = 0
	var/active = 0
	var/reference = null
	var/powered = null
	var/strength = 0
	var/desc_holder = null


/obj/machinery/particle_accelerator/verb/rotate()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

/obj/machinery/particle_accelerator/verb/rotateccw()
	set name = "Rotate Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1

/obj/machinery/particle_accelerator/update_icon()
	return

/obj/machinery/particle_accelerator/examine(mob/user)
	switch(src.construction_state)
		if(0)
			src.desc = text("A [name], looks like it's not attached to the flooring")
		if(1)
			src.desc = text("A [name], it is missing some cables")
		if(2)
			src.desc = text("A [name], the panel is open")
		if(3)
			src.desc = text("The [name] is assembled")
			if(powered)
				src.desc = src.desc_holder
	..()
	return


/obj/machinery/particle_accelerator/attackby(obj/item/W, mob/user)
	if(istool(W))
		if(src.process_tool_hit(W,user))
			return
	..()
	return

/obj/machinery/particle_accelerator/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				qdel(src)
				return
		else
	return


/obj/machinery/particle_accelerator/proc/update_state()
	return 0


/obj/machinery/particle_accelerator/proc/process_tool_hit(var/obj/O, var/mob/user)
	if(!(O) || !(user))
		return 0
	if(!ismob(user) || !isobj(O))
		return 0
	var/temp_state = src.construction_state
	switch(src.construction_state)//TODO:Might be more interesting to have it need several parts rather than a single list of steps
		if(0)
			if(iswrench(O))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				src.anchored = 1
				user.visible_message("[user.name] secures the [src.name] to the floor.", \
					"You secure the external bolts.")
				temp_state++
		if(1)
			if(iswrench(O))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				src.anchored = 0
				user.visible_message("[user.name] detaches the [src.name] from the floor.", \
					"You remove the external bolts.")
				temp_state--
			else if(iscoil(O))
				if(O:use(1))
					user.visible_message("[user.name] adds wires to the [src.name].", \
						"You add some wires.")
					temp_state++
		if(2)
			if(iswirecutter(O))//TODO:Shock user if its on?
				user.visible_message("[user.name] removes some wires from the [src.name].", \
					"You remove some wires.")
				temp_state--
			else if(isscrewdriver(O))
				user.visible_message("[user.name] closes the [src.name]'s access panel.", \
					"You close the access panel.")
				temp_state++
		if(3)
			if(isscrewdriver(O))
				user.visible_message("[user.name] opens the [src.name]'s access panel.", \
					"You open the access panel.")
				temp_state--
				active = 0
	if(temp_state == src.construction_state)//Nothing changed
		return 0
	else
		if(src.construction_state < 3)//Was taken apart, update state
			update_state()
			if(use_power)
				use_power = 0
		src.construction_state = temp_state
		if(src.construction_state >= 3)
			use_power = 1
		update_icon()
		return 1
	return 0
