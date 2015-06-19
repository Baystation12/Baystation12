// Controller.
/datum/controller/process/fluid/setup()
	name = "fluids"
	schedule_interval = FLUID_SCHEDULE_INTERVAL
	fluid_controller_exists = 1

/datum/controller/process/fluid/started()
	..()
	for(var/obj/item/fluid_spawn/P in world) // Is there a list for objects somewhere?
		P.spawn_fluid()

/datum/controller/process/fluid/doWork()

	// Handle spread of existing fluids.
	var/i = 0
	while(processing_fluids.len && i <= FLUID_PROCESSING_CUTOFF)
		i++
		var/obj/effect/fluid/F = pick(processing_fluids)
		processing_fluids -= F
		F.equalize(1)
		scheck()
	// Equalize fluid tiles spawned this cycle.
	i = 0
	while(new_fluids.len && i <= FLUID_PROCESSING_CUTOFF)
		i++
		var/obj/effect/fluid/F = pick(new_fluids)
		new_fluids -= F
		F.equalize()
		scheck()
	// Update all appropriate icons.
	i = 0
	while(updating_fluids.len && i <= FLUID_PROCESSING_CUTOFF)
		i++
		var/obj/effect/fluid/F = pick(updating_fluids)
		updating_fluids -= F
		F.update_icon()
		scheck()

/datum/controller/process/fluid/getStatName()
	return ..()+"(P[processing_fluids.len] N[new_fluids.len] U[updating_fluids.len])"
