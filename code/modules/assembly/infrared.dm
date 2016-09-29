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
	var/last_triggered = 0
	var/list/beams = list()
	var/range = 7
	var/resets = 0

/obj/item/device/assembly/infra/activate()
	if(anchored || (holder && holder.anchored))
		on = !on
		if(on)
			create_beam()
		else
			destroy_beam()
		return 1
	return 0

/obj/item/device/assembly/infra/Destroy()
	for(var/I in beams)
		var/obj/effect/beam/infrared/beam = I
		qdel(beam)
	beams.Cut()
	return ..()

/obj/item/device/assembly/infra/proc/create_beam()
	if(beams.len)
		destroy_beam()
		sleep(0)
	for(var/dist = 0, dist < range, dist += 1)
		var/turf/T = get_step((holder ? holder : src), dir)
		if(!T || T.contains_dense_objects())
			range = dist
			add_debug_log("\[[src]\] - Beam unable to reach desired range. Range modified to: [range]")
			break
		var/obj/effect/beam/infrared/beam = new(T, src)
		beams += beam

/obj/item/device/assembly/infra/proc/destroy_beam()
	for(var/obj/effect/beam/infrared/beam in beams)
		qdel(beam)

/obj/item/device/assembly/infra/Move()
	var/t = dir
	..()
	set_dir(t)
	destroy_beam()
	on = 0

/obj/item/device/assembly/infra/holder_movement()
	if(!holder)	return 0
	set_dir(holder.dir)
	destroy_beam()
	on = 0
	return 1

/obj/item/device/assembly/infra/misc_activate()
	if(active_wires & WIRE_MISC_ACTIVATE)
		send_pulse_to_connected()
		return 1
	return 0


/obj/item/device/assembly/infra/proc/trigger_beam()
	if(world.timeofday >= last_triggered+10)
		misc_activate()
		last_triggered = world.timeofday
		if(!resets)
			destroy_beam()
			on = 0
		return

/obj/item/device/assembly/infra/get_data()
	return list("On", on, "Visible", visible, "Range", range, "Resets", resets)

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
				return 1
			if("Visible")
				visible = !visible
				for(var/I in beams)
					var/obj/effect/beam/infrared/beam = I
					beam.toggle_visibility()
				return 1
			if("Range")
				var/inp = max(1, min(text2num(input(usr,"What would you like the range to be?", "Infrared")), 10))
				if(inp)
					range = inp
				else range = 4
				destroy_beam()
				spawn(0) // Refresh the beam
					create_beam()
				return 1
			if("Resets")
				resets = !resets
				return 1

/***************************IBeam*********************************/

/obj/effect/beam/infrared
	name = "infrared laser"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ibeam"
	var/obj/item/device/assembly/infra/linked
	var/visible = 0.0
	var/left = null
	anchored = 1.0

/obj/effect/beam/infrared/proc/toggle_visibility()
	if(!linked) qdel(src)
	visible = linked.visible
	if(!visible)
		alpha = 10 // Still slightly visible.
		set_light(0)
	else
		set_light(1, null, "#FF000")
		alpha = initial(alpha)

/obj/effect/beam/infrared/New(var/obj/item/device/assembly/infra/creator)
	..()
	linked = creator
	toggle_visibility()

/obj/effect/beam/infrared/Bump(var/atom/A)
	if(!linked) qdel(src)
	if(istype(A, /mob/living))
		linked.trigger_beam()
	..()

/obj/effect/beam/infrared/Bumped()
	if(!linked) qdel(src)
	linked.trigger_beam()
	..()

/obj/effect/beam/infrared/Crossed(atom/movable/AM as mob|obj)
	if(!linked) qdel(src)
	if(istype(AM, /obj/effect/beam))
		return
	else if(istype(AM, /mob/living) || istype(AM, /obj/))
		linked.trigger_beam()
	..()

/obj/effect/beam/infrared/Destroy()
	linked = null
	return ..()