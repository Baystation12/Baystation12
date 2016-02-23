/obj/item/device/assembly/chute
	name = "disposal chute"
	desc = "A chute that connects to disposal pipes."
	icon_state = "chute"
	item_state = "assembly"
	throwforce = 6
	w_class = 4
	throw_speed = 2
	throw_range = 1
	density = 1
	weight = 8
	var/obj/machinery/disposal/D
	var/obj/structure/disposalpipe/trunk/trunk
	dangerous = 1

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE
	wire_num = 3

/obj/item/device/assembly/chute/New()
	..()
	spawn(5)
		D = new()
		trunk = locate() in src.loc

/obj/item/device/assembly/chute/activate()
	if(trunk || !istype(trunk)) return 0
	var/turf/T = get_turf(src.loc)
	var/datum/gas_mixture/environment
	if(T)
		environment = T.return_air()
	for(var/atom/A in T) // Suck everything ontop of it inwards.
		if(ismob(A))
			var/mob/M = A
			if(holder)
				if(M.layer >= holder.layer)
					M.forceMove(D)
			else if(M.layer >= src.layer)
				M.forceMove(D)
			M << "<span class='danger'>You feel something suck you downwards into darkness!</span>"
		if(istype(A, /obj/item))
			var/obj/item/O = A
			if(istype(O, /obj/item/device/assembly))
				if(O:holder == holder) continue
			if(istype(O, /obj/item/device/assembly_holder))
				if(O == holder) continue
			if(O == src) continue
			O.forceMove(D)

	add_debug_log("Beginning pneumatic flush...\[[src]\]")

	if(holder)
		flick("chute_a", holder)
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
													// travels through the pipes.
	spawn(25)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		sleep(25) // wait for animation to finish

		H.init(D, environment)	// copy the contents of disposer to holder

		H.start(D) // start the holder processing movement
		return 1

/obj/item/device/assembly/chute/Destroy()
	if(D)
		qdel(D)
	..()

/obj/item/device/assembly/chute/anchored(var/on = 0)
	if(on)
		var/turf/T = get_turf(src)
		if(isturf(T))
			trunk = locate() in T
	else
		trunk = null
	return 1
