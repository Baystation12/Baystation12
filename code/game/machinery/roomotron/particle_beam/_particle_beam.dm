/// Technically, a beam. A real obj beam is only made if it exits the roomotron.
/datum/particle_beam
	/// The current location of the beam. Practically the same as the loc of an atom.
	var/atom/loc
	/// Particle amount.
	var/particle_amount
	/// The beam when exiting the roomotron.
	var/obj/item/projectile/particles/beam = /obj/item/projectile/particles
	/// The last time the particle moved
	var/particle_move
	/// The speed of the particle in ticks.
	var/speed = 10

/datum/particle_beam/New(atom/source)
	loc = source

/// Called during the machine's Process()
/datum/particle_beam/proc/process()
	if(istype(loc, /obj/machinery/roomotron))
		var/obj/machinery/roomotron/segment = loc
		speed = speed * segment.speed
		if(world.time -= particle_move >= speed)
			update_position()

/// Moves the beam from one segment to another segment.
/datum/particle_beam/proc/update_position(obj/machinery/roomotron/target, obj/machinery/roomotron/source)
	if(!target)
		exit_containment()

	if(source && source.beam == src)
		source.beam = null
	target.beam = src
	loc = target

/datum/particle_beam/proc/exit_containment()
	if(istype(loc, /obj/machinery/roomotron))
		var/obj/machinery/roomotron/segment = loc
		segment.beam = null

	beam.launch(get_step(loc, loc.dir))
	loc.visible_message(SPAN_DANGER("\The [beam] fires out from \the [loc]!"))
	loc = beam