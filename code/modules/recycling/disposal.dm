// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things, no other draggables
// Toilets are a type of disposal bin for small objects only and work on magic. By magic, I mean torque rotation
#define SEND_PRESSURE (700 + ONE_ATMOSPHERE) //kPa - assume the inside of a dispoal pipe is 1 atm, so that needs to be added.
#define PRESSURE_TANK_VOLUME 150	//L
#define PUMP_MAX_FLOW_RATE 90		//L/s - 4 m/s using a 15 cm by 15 cm inlet

GLOBAL_LIST_EMPTY(diversion_junctions)

/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	anchored = TRUE
	density = TRUE
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = 1	// item mode 0=off 1=charging 2=charged
	var/flush = 0	// true if flush handle is pulled
	var/obj/structure/disposalpipe/trunk/trunk = null // the attached pipe trunk
	var/flushing = 0	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	var/last_sound = 0
	var/list/allowed_objects = list(/obj/structure/closet)
	active_power_usage = 2200	//the pneumatic pump power. 3 HP ~ 2200W
	idle_power_usage = 100
	atom_flags = ATOM_FLAG_CLIMBABLE
	var/turn = DISPOSAL_FLIP_NONE
	throwpass = TRUE

// create a new disposal
// find the attached trunk (if present) and init gas resvr.
// initializes the reagents datum for storing vomit reagents
/obj/machinery/disposal/Initialize()
	. = ..()
	spawn(5)
		trunk = locate() in src.loc
		if(!trunk)
			mode = 0
			flush = 0
		else
			trunk.linked = src	// link the pipe trunk to self

		air_contents = new/datum/gas_mixture(PRESSURE_TANK_VOLUME)
		update_icon()
	src.create_reagents(500)

/obj/machinery/disposal/Destroy()
	eject()
	if(trunk)
		trunk.linked = null
	return ..()

// attack by item places it in to disposal
/obj/machinery/disposal/attackby(var/obj/item/I, var/mob/user)
	if(stat & BROKEN || !I || !user)
		return

	add_fingerprint(user, 0, I)
	if(mode<=0) // It's off
		if(isScrewdriver(I))
			if(contents.len > LAZYLEN(component_parts))
				to_chat(user, "Eject the items first!")
				return
			if(mode==0) // It's off but still not unscrewed
				mode=-1 // Set it to doubleoff l0l
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "You remove the screws around the power connection.")
				return
			else if(mode==-1)
				mode=0
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "You attach the screws around the power connection.")
				return
		else if(isWelder(I) && mode==-1)
			if(contents.len > LAZYLEN(component_parts))
				to_chat(user, "Eject the items first!")
				return
			var/obj/item/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "You start slicing the floorweld off the disposal unit.")

				if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
					if(!src || !W.isOn()) return
					to_chat(user, "You sliced the floorweld off the disposal unit.")
					var/obj/structure/disposalconstruct/machine/C = new (loc, src)
					src.transfer_fingerprints_to(C)
					C.update()
					qdel(src)
				return
			else
				to_chat(user, "You need more welding fuel to complete this task.")
				return

	if(istype(I, /obj/item/melee/energy/blade))
		to_chat(user, "You can't place that item inside the disposal unit.")
		return

	if(istype(I, /obj/item/storage/bag/trash))
		var/obj/item/storage/bag/trash/T = I
		to_chat(user, "<span class='notice'>You empty the bag.</span>")
		for(var/obj/item/O in T.contents)
			T.remove_from_storage(O,src, 1)
		T.finish_bulk_removal()
		update_icon()
		return

	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			usr.visible_message(SPAN_DANGER("\The [usr] starts putting [GM.name] into the disposal."))
			if(do_after(usr, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
				if (GM.client)
					GM.client.perspective = EYE_PERSPECTIVE
					GM.client.eye = src
				GM.forceMove(src)
				usr.visible_message(SPAN_DANGER("\The [GM] has been placed in the [src] by \the [user]."))
				qdel(G)
				admin_attack_log(usr, GM, "Placed the victim into \the [src].", "Was placed into \the [src] by the attacker.", "stuffed \the [src] with")
		return

	if(isrobot(user))
		return
	if(!I)
		return

	if(!user.unEquip(I, src))
		return

	user.visible_message("\The [user] places \the [I] into \the [src].", "You place \the [I] into \the [src].")

	update_icon()

/obj/machinery/disposal/MouseDrop_T(atom/movable/AM, mob/user)
	if(!istype(AM)) // Could be dragging in a turf.
		return
	var/incapacitation_flags = INCAPACITATION_DEFAULT
	if(AM == user)
		incapacitation_flags &= ~INCAPACITATION_RESTRAINED

	if(stat & BROKEN || !CanMouseDrop(AM, user, incapacitation_flags) || AM.anchored || !isturf(user.loc))
		return

	// Animals can only put themself in
	if(isanimal(user) && AM != user)
		return

	// Determine object type and run necessary checks
	var/mob/M = AM
	var/is_dangerous // To determine css style in messages
	if(istype(M))
		is_dangerous = TRUE
		if(M.buckled)
			return
	else if(istype(AM, /obj/item))
		attackby(AM, user)
		return
	else if(!is_type_in_list(AM, allowed_objects))
		return

	// Checks completed, start inserting
	src.add_fingerprint(user)
	var/old_loc = AM.loc
	if(AM == user)
		user.visible_message("<span class='warning'>[user] starts climbing into [src].</span>", \
							 "<span class='notice'>You start climbing into [src].</span>")
	else
		user.visible_message("<span class='[is_dangerous ? "warning" : "notice"]'>[user] starts stuffing [AM] into [src].</span>", \
							 "<span class='notice'>You start stuffing [AM] into [src].</span>")

	if(!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
		return

	// Repeat checks
	if(stat & BROKEN || user.incapacitated(incapacitation_flags))
		return
	if(!AM || old_loc != AM.loc || AM.anchored)
		return
	if(istype(M) && M.buckled)
		return

	// Messages and logging
	if(AM == user)
		user.visible_message("<span class='danger'>[user] climbs into [src].</span>", \
							 "<span class='notice'>You climb into [src].</span>")
		admin_attack_log(user, null, "Stuffed themselves into \the [src].", null, "stuffed themselves into \the [src].")
	else
		user.visible_message("<span class='[is_dangerous ? "danger" : "notice"]'>[user] stuffs [AM] into [src][is_dangerous ? "!" : "."]</span>", \
							 "<span class='notice'>You stuff [AM] into [src].</span>")
		if(ismob(M))
			admin_attack_log(user, M, "Placed the victim into \the [src].", "Was placed into \the [src] by the attacker.", "stuffed \the [src] with")
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src

	AM.forceMove(src)
	update_icon()
	return

// attempt to move while inside
/obj/machinery/disposal/relaymove(mob/user as mob)
	if (user.incapacitated() || src.flushing)
		return
	if (user.loc == src)
		src.go_out(user)
	return

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)

	if (user.client)
		user.client.eye = user.client.mob
		user.client.perspective = MOB_PERSPECTIVE
	user.forceMove(src.loc)
	update_icon()
	return

/obj/machinery/disposal/DefaultTopicState()
	return GLOB.outside_state

// human interact with machine
/obj/machinery/disposal/physical_attack_hand(mob/user)
	// Clumsy folks can only flush it.
	if(!user.IsAdvancedToolUser(1))
		flush = !flush
		update_icon()
		return TRUE

/obj/machinery/disposal/interface_interact(mob/user)
	interact(user)
	return TRUE

// user interaction
/obj/machinery/disposal/interact(mob/user)

	src.add_fingerprint(user)
	if(stat & BROKEN)
		user.unset_machine()
		return

	var/ai = isAI(user)
	var/dat = "<head><title>Waste Disposal Unit</title></head><body><TT><B>Waste Disposal Unit</B><HR>"

	if(!ai)  // AI can't pull flush handle
		if(flush)
			dat += "Disposal handle: <A href='?src=\ref[src];handle=0'>Disengage</A> <B>Engaged</B>"
		else
			dat += "Disposal handle: <B>Disengaged</B> <A href='?src=\ref[src];handle=1'>Engage</A>"

		dat += "<BR><HR><A href='?src=\ref[src];eject=1'>Eject contents</A><HR>"

	if(mode <= 0)
		dat += "Pump: <B>Off</B> <A href='?src=\ref[src];pump=1'>On</A><BR>"
	else if(mode == 1)
		dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (pressurizing)<BR>"
	else
		dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (idle)<BR>"

	var/per = 100* air_contents.return_pressure() / (SEND_PRESSURE)

	dat += "Pressure: [round(per, 1)]%<BR></body>"


	user.set_machine(src)
	show_browser(user, dat, "window=disposal;size=360x170")
	onclose(user, "disposal")

// handle machine interaction

/obj/machinery/disposal/CanUseTopic(mob/user, state, href_list)
	if(user.loc == src)
		to_chat(user, "<span class='warning'>You cannot reach the controls from inside.</span>")
		return STATUS_CLOSE
	if(isAI(user) && href_list && (href_list["handle"] || href_list["eject"]))
		return min(STATUS_UPDATE, ..())
	if(mode==-1 && href_list && !href_list["eject"]) // only allow ejecting if mode is -1
		to_chat(user, "<span class='warning'>The disposal units power is disabled.</span>")
		return min(STATUS_UPDATE, ..())
	if(flushing)
		return min(STATUS_UPDATE, ..())
	return ..()

/obj/machinery/disposal/OnTopic(user, href_list)
	if(href_list["close"])
		close_browser(user, "window=disposal")
		return TOPIC_HANDLED

	if(href_list["pump"])
		if(text2num(href_list["pump"]))
			mode = 1
		else
			mode = 0
		update_icon()
		. = TOPIC_REFRESH

	else if(href_list["handle"])
		flush = text2num(href_list["handle"])
		update_icon()
		. = TOPIC_REFRESH

	else if(href_list["eject"])
		eject()
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/machinery/disposal/verb/manual_eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Items From Bin"

	if (!isliving(usr) || usr.incapacitated())
		return
	usr.visible_message(
		SPAN_NOTICE("\The [usr] ejects \the [src]'s contents'."),
		SPAN_NOTICE("You eject \the [initial(name)]'s contents."),
	)
	eject()
	add_fingerprint(usr)

// eject the contents of the disposal unit
/obj/machinery/disposal/proc/eject()
	for(var/atom/movable/AM in (contents - component_parts))
		AM.forceMove(src.loc)
		AM.pipe_eject(0)
	if(reagents.total_volume)
		visible_message(SPAN_DANGER("Vomit spews out of the disposal unit!"))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		if(istype(src.loc, /turf/simulated))
			var/obj/effect/decal/cleanable/vomit/splat = new /obj/effect/decal/cleanable/vomit(src.loc)
			reagents.trans_to_obj(splat, reagents.total_volume)
			splat.update_icon()
	reagents.clear_reagents()
	update_icon()

// update the icon & overlays to reflect mode & status
/obj/machinery/disposal/on_update_icon()
	overlays.Cut()
	if(stat & BROKEN)
		mode = 0
		flush = 0
		return

	// flush handle
	if(flush)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-handle")

	// only handle is shown if no power
	if(stat & NOPOWER || mode == -1)
		return

	// 	check for items/vomit in disposal - occupied light
	if(contents.len > LAZYLEN(component_parts) || reagents.total_volume)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-full")

	// charging and ready light
	if(mode == 1)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-charge")
	else if(mode == 2)
		overlays += image('icons/obj/pipes/disposal.dmi', "dispover-ready")

// timed process
// charge the gas reservoir and perform flush if ready
/obj/machinery/disposal/Process()
	if(!air_contents || (stat & BROKEN))			// nothing can happen if broken
		update_use_power(POWER_USE_OFF)
		return

	flush_count++
	if( flush_count >= flush_every_ticks )
		if( contents.len > LAZYLEN(component_parts) || reagents.total_volume)
			if(mode == 2)
				spawn(0)
					flush()
		flush_count = 0

	src.updateDialog()

	if(flush && air_contents.return_pressure() >= SEND_PRESSURE )	// flush can happen even without power
		flush()

	if(mode != 1) //if off or ready, no need to charge
		update_use_power(POWER_USE_IDLE)
	else if(air_contents.return_pressure() >= SEND_PRESSURE)
		mode = 2 //if full enough, switch to ready mode
		update_icon()
	else
		src.pressurize() //otherwise charge

/obj/machinery/disposal/proc/pressurize()
	if(stat & NOPOWER)			// won't charge if no power
		update_use_power(POWER_USE_OFF)
		return

	var/atom/L = loc						// recharging from loc turf
	var/datum/gas_mixture/env = L.return_air()

	var/power_draw = -1
	if(env && env.temperature > 0)
		var/transfer_moles = (PUMP_MAX_FLOW_RATE/env.volume)*env.total_moles	//group_multiplier is divided out here
		power_draw = pump_gas(src, env, air_contents, transfer_moles, active_power_usage)

	if (power_draw > 0)
		use_power_oneoff(power_draw)

// perform a flush
/obj/machinery/disposal/proc/flush()

	flushing = 1
	flick("[icon_state]-flush", src)

	var/wrapcheck = 0
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.

	// handle vomit transportation
	// flush the vomit out and put vomit into the disposalholder
	reagents.trans_to_holder(H.create_reagents(500), reagents.total_volume)

	var/list/stuff = contents - component_parts
	//Hacky test to get drones to mail themselves through disposals.
	for(var/mob/living/silicon/robot/drone/D in stuff)
		wrapcheck = 1

	for(var/obj/item/smallDelivery/O in stuff)
		wrapcheck = 1

	if(wrapcheck == 1)
		H.tomail = 1

	sleep(10)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		last_sound = world.time
	sleep(5) // wait for animation to finish


	H.init(src, air_contents)	// copy the contents of disposer to holder
	air_contents = new(PRESSURE_TANK_VOLUME)	// new empty gas resv.

	for (var/mob/M in H.check_mob(stuff))
		if (M.ckey)
			admin_attack_log(null, M, null, "Was flushed down [src].", "has been flushed down [src].")
	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update_icon()
	return

// called when holder is expelled from a disposal
// should usually only occur if the pipe network is modified
/obj/machinery/disposal/proc/expel(var/obj/structure/disposalholder/H)

	var/turf/target
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	if(H) // Somehow, someone managed to flush a window which broke mid-transit and caused the disposal to go in an infinite loop trying to expel null, hopefully this fixes it
		for(var/atom/movable/AM in H)
			target = get_offset_target_turf(src.loc, rand(5)-rand(5), rand(5)-rand(5))

			AM.forceMove(src.loc)
			AM.pipe_eject(0)
			// Poor drones kept smashing windows and taking system damage being fired out of disposals.
			if(!istype(AM,/mob/living/silicon/robot/drone))
				spawn(1)
					if(AM)
						AM.throw_at(target, 5, 1)

		H.vent_gas(loc)
		qdel(H)

/obj/machinery/disposal/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(75))
			I.forceMove(src)
			visible_message("\The [I] lands in \the [src].")
		else
			visible_message("\The [I] bounces off of \the [src]'s rim!")
		return 0
	else
		return ..(mover, target, height, air_group)

/obj/machinery/disposal/slam_into(mob/living/L)
	L.forceMove(src)
	L.Weaken(5)
	L.visible_message(SPAN_WARNING("\The [L] falls into \the [src]!"))
	playsound(L, "punch", 25, 1, FALSE)

/obj/machinery/disposal_switch
	name = "disposal switch"
	desc = "A disposal control switch."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	layer = ABOVE_OBJ_LAYER
	var/on = 0
	var/list/junctions = list()

/obj/machinery/disposal_switch/Initialize(mapload, var/newid)
	. = ..(mapload)
	if(!id_tag)
		id_tag = newid
	for(var/obj/structure/disposalpipe/diversion_junction/D in GLOB.diversion_junctions)
		if(D.id_tag && !D.linked && D.id_tag == src.id_tag)
			junctions += D
			D.linked = src

/obj/machinery/disposal_switch/Destroy()
	junctions.Cut()
	return ..()

/obj/machinery/disposal_switch/attackby(obj/item/I, mob/user, params)
	if(isCrowbar(I))
		var/obj/item/disposal_switch_construct/C = new/obj/item/disposal_switch_construct(src.loc, id_tag)
		transfer_fingerprints_to(C)
		user.visible_message("<span class='notice'>\The [user] deattaches \the [src]</span>")
		qdel(src)
	else
		. = ..()

/obj/machinery/disposal_switch/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	. = TRUE
	on = !on
	for(var/obj/structure/disposalpipe/diversion_junction/D in junctions)
		if(D.id_tag == src.id_tag)
			D.active = on
	if(on)
		icon_state = "switch-fwd"
	else
		icon_state = "switch-off"


/obj/item/disposal_switch_construct
	name = "disposal switch assembly"
	desc = "A disposal control switch assembly."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	w_class = ITEM_SIZE_LARGE
	var/id_tag

/obj/item/disposal_switch_construct/Initialize(var/id)
	. = ..()
	if(id) id_tag = id
	else
		id_tag = "ds[sequential_id(/obj/item/disposal_switch_construct)]"

/obj/item/disposal_switch_construct/afterattack(atom/A, mob/user, proximity)
	if(!proximity || !istype(A, /turf/simulated/floor) || istype(A, /area/shuttle) || user.incapacitated() || !id_tag)
		return
	var/found = 0
	for(var/obj/structure/disposalpipe/diversion_junction/D in world)
		if(D.id_tag == src.id_tag)
			found = 1
			break
	if(!found)
		to_chat(user, "[icon2html(src, user)]<span class=notice>\The [src] is not linked to any junctions!</span>")
		return
	var/obj/machinery/disposal_switch/NC = new/obj/machinery/disposal_switch(A, id_tag)
	transfer_fingerprints_to(NC)
	qdel(src)

// the disposal outlet machine

/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE
	var/active = 0
	var/turf/target	// this will be where the output objects are 'thrown' to.
	var/mode = 0
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE

/obj/structure/disposaloutlet/Initialize()
	. = ..()
	spawn(1)
	target = get_ranged_target_turf(src, dir, 10)
	var/obj/structure/disposalpipe/trunk/trunk = locate() in src.loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

// expel the contents of the holder object, then delete it
// called when the holder exits the outlet
/obj/structure/disposaloutlet/proc/expel(var/obj/structure/disposalholder/H)
	animate_expel()
	if(H)
		if(H.reagents?.total_volume)
			visible_message(SPAN_DANGER("Vomit seeps out of the disposal outlet!"))
			playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			if(istype(src.loc, /turf/simulated))
				var/obj/effect/decal/cleanable/vomit/splat = new /obj/effect/decal/cleanable/vomit(src.loc)
				H.reagents.trans_to_obj(splat, H.reagents.total_volume)
				splat.update_icon()

		for(var/atom/movable/AM in H)
			AM.forceMove(src.loc)
			AM.pipe_eject(dir)
			// Drones keep smashing windows from being fired out of chutes.
			if(!istype(AM,/mob/living/silicon/robot/drone))
				spawn(5)
					AM.throw_at(target, 3, 1)
		H.vent_gas(src.loc)
		qdel(H)

/obj/structure/disposaloutlet/proc/animate_expel()
	set waitfor = FALSE
	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	sleep(20)	//wait until correct animation frame
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

/obj/structure/disposaloutlet/attackby(var/obj/item/I, var/mob/user)
	if(!I || !user)
		return
	src.add_fingerprint(user, 0, I)
	if(isScrewdriver(I))
		if(mode==0)
			mode=1
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(mode==1)
			mode=0
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(istype(I,/obj/item/weldingtool) && mode==1)
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			to_chat(user, "You start slicing the floorweld off the disposal outlet.")
			if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
				if(!src || !W.isOn()) return
				to_chat(user, "You sliced the floorweld off the disposal outlet.")
				var/obj/structure/disposalconstruct/machine/outlet/C = new (loc, src)
				src.transfer_fingerprints_to(C)
				C.anchored = TRUE
				C.set_density(1)
				C.update()
				qdel(src)
				return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return

/obj/structure/disposaloutlet/forceMove()//updates this when shuttle moves. So you can YEET things out the airlock
	. = ..()
	if(.)
		target = get_ranged_target_turf(src, dir, 10)

// called when movable is expelled from a disposal pipe or outlet
// by default does nothing, override for special behaviour

/atom/movable/proc/pipe_eject(var/direction)
	return

// check if mob has client, if so restore client view on eject
/mob/pipe_eject(var/direction)
	if (src.client)
		src.client.perspective = MOB_PERSPECTIVE
		src.client.eye = src

	return

/obj/effect/decal/cleanable/blood/gibs/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()
	addtimer(CALLBACK(src, .proc/streak, dirs), 0)

/obj/effect/decal/cleanable/blood/gibs/robot/pipe_eject(var/direction)
	var/list/dirs
	if(direction)
		dirs = list( direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()
	addtimer(CALLBACK(src, .proc/streak, dirs), 0)
