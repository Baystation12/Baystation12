/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "gravitational singularity generator"
	desc = "An Odd Device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/machines/power/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = FALSE
	density = TRUE
	use_power = POWER_USE_OFF
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/energy = 0

/obj/machinery/the_singularitygen/Process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		new /obj/singularity/(T, 50)
		if(src) qdel(src)
