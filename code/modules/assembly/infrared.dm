//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32
/obj/item/device/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	origin_tech = list(TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "waste" = 100)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_ACTIVATE
	wire_num = 6

	var/on = 0
	var/visible = 0
	var/triggered = 0
	var/obj/effect/beam/i_beam/first = null
	var/range = 7

/obj/item/device/assembly/infra/anchored(var/anchored = 0)
	if(!anchored)
		trigger_beam()
		if(on)
			activate()
	sleep(0)
	return 1

/obj/item/device/assembly/infra/activate()
	if(anchored || (holder && holder.anchored))
		on = !on
		if(on)
			processing_objects.Add(src)
		else
			if(first) qdel(first)
			processing_objects.Remove(src)
	return 1

/obj/item/device/assembly/infra/process()//Old code
	if(holder) dir = holder.dir
	if(!first && !triggered && (istype(loc, /turf) || holder && istype(holder.loc, /turf)))
		var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(get_turf(src))
		I.master = src
		I.density = 1
		I.set_dir(dir)
		step(I, I.dir)
		if(I)
			I.density = 0
			first = I
			I.vis_spread(visible)
			spawn(0)
				if(I)
					//world << "infra: setting limit"
					I.limit = range
					//world << "infra: processing beam \ref[I]"
					I.process()
				return
	return

/obj/item/device/assembly/infra/Move()
	var/t = dir
	..()
	set_dir(t)
	qdel(first)
	return


/obj/item/device/assembly/infra/holder_movement()
	if(!holder)	return 0
	set_dir(holder.dir)
//	qdel(first)
	return 1

/obj/item/device/assembly/infra/misc_activate()
	if(active_wires & WIRE_MISC_ACTIVATE)
		send_pulse_to_connected()
		return 1
	return 0


/obj/item/device/assembly/infra/proc/trigger_beam()
	if(first)
		qdel(first)
	triggered = 1
	spawn(50)
		triggered = 0
	if(!on)	return 0
	misc_activate()
	if(!holder)
		visible_message("\icon[src] *beep* *beep*")
	return

/*
	interact(mob/user as mob)//TODO: change this this to the wire control panel
		if(!secured)	return
		user.set_machine(src)
		var/dat = text("<TT><B>Infrared Laser</B>\n<B>Status</B>: []<BR>\n<B>Visibility</B>: []<BR>\n</TT>", (on ? text("<A href='?src=\ref[];state=0'>On</A>", src) : text("<A href='?src=\ref[];state=1'>Off</A>", src)), (src.visible ? text("<A href='?src=\ref[];visible=0'>Visible</A>", src) : text("<A href='?src=\ref[];visible=1'>Invisible</A>", src)))
		dat += "<BR><BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
		dat += "<BR><BR><A href='?src=\ref[src];close=1'>Close</A>"
		user << browse(dat, "window=infra")
		onclose(user, "infra")
		return
*/
/obj/item/device/assembly/infra/get_data()
	return list("On", on, "Visible", visible, "Range", range)


/obj/item/device/assembly/infra/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["option"])
		switch(href_list["option"])
			if("On")
				if(anchored || (holder && holder.anchored))
					process_activation()
				else
					usr << "<span class='notice'>You need to anchor \the [src] first!</span>"
			if("Visible")
				visible = !visible
			if("Range")
				var/inp = max(1, min(text2num(input(usr,"What would you like the range to be?", "Infrared")), 10))
				if(inp)
					range = inp
				else range = 4
	return 1

/*
	verb/rotate()//This could likely be better
		set name = "Rotate Infrared Laser"
		set category = "Object"
		set src in usr

		set_dir(turn(dir, 90))
		return
*/


/***************************IBeam*********************************/

/obj/effect/beam/i_beam
	name = "i beam"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ibeam"
	var/obj/effect/beam/i_beam/next = null
	var/obj/item/device/assembly/infra/master = null
	var/limit = null
	var/visible = 0.0
	var/left = null
	anchored = 1.0


/obj/effect/beam/i_beam/proc/hit()
	if(master)
		master.trigger_beam()
	qdel(src)
	return

/obj/effect/beam/i_beam/proc/vis_spread(v)
	//world << "i_beam \ref[src] : vis_spread"
	visible = v
	spawn(0)
		if(next)
			//world << "i_beam \ref[src] : is next [next.type] \ref[next], calling spread"
			next.vis_spread(v)
		return
	return

/obj/effect/beam/i_beam/process()

	if((loc && loc.density) || !master)
		qdel(src)
		return

	if(left > 0)
		left--
	if(left < 1)
		if(!(visible))
			invisibility = 101
		else
			invisibility = 0
	else
		invisibility = 0

	if(!next && get_dist(src, master) < master.range)
		//world << "now [src.left] left"
		var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(loc)
		I.master = master
		I.density = 1
		I.set_dir(dir)
		//world << "created new beam \ref[I] at [I.x] [I.y] [I.z]"
		step(I, I.dir)

		if(I)
			//world << "step worked, now at [I.x] [I.y] [I.z]"
			//world << "no next"
			I.density = 0
			//world << "spreading"
			I.vis_spread(visible)
			next = I
			spawn(0)
				//world << "limit = [limit] "
				if((I && limit > 0))
					I.limit = limit-1
					//world << "calling next process"
					I.process()
				return
	spawn(10)
		process()
		return
	return

/obj/effect/beam/i_beam/Bump(var/atom/A)
	if(!istype(A, /mob/))
		qdel(src)
	else hit()
	return

/obj/effect/beam/i_beam/Bumped()
	hit()
	return

/obj/effect/beam/i_beam/Crossed(atom/movable/AM as mob|obj)
	if(istype(AM, /obj/effect/beam))
		return
	spawn(0)
		hit()
		return
	return

/obj/effect/beam/i_beam/Destroy()
	if(master.first == src)
		master.first = null
	if(next)
		qdel(next)
		next = null
	..()