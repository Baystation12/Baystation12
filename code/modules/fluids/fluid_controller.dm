// Controller.
/datum/controller/process/fluid/setup()
	name = "fluids"
	schedule_interval = FLUID_SCHEDULE_INTERVAL
	fluid_controller_exists = 1
	fluid_image = image('icons/effects/liquid.dmi',"water")

/datum/controller/process/fluid/started()
	..()
	for(var/obj/item/fluid_spawn/P in world) // Is there a list for objects somewhere?
		P.spawn_fluid()

/datum/controller/process/fluid/doWork()

	// Handle spread of existing fluids.
	// TODO randomize like new_fluids when update handling is fixed
	if(processing_fluids.len)
		for(var/obj/effect/fluid/F in processing_fluids)
			F.equalize(1)
		//processing_fluids.Cut()

	// Equalize fluid tiles spawned this cycle.
	while(new_fluids.len)
		var/obj/effect/fluid/F = pick(new_fluids)
		new_fluids -= F
		F.equalize()

	// Update all appropriate icons.
	if(updating_fluids.len)
		for(var/obj/effect/fluid/F in updating_fluids)
			F.update_icon()
		updating_fluids.Cut()

/datum/controller/process/fluid/getStatName()
	return ..()+"(P[processing_fluids.len] N[new_fluids.len] U[updating_fluids.len])"
