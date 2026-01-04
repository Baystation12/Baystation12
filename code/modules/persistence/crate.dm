/obj/structure/ore_box/persistent
	name = "sturdy ore box"
	var/tracked
	var/deferred_init
	var/decay_rate = 25

/obj/structure/ore_box/persistent/Initialize()
	. = ..()
	TrackPersistencePersistently(/datum/persistent/crate, 4, 10 SECONDS)

/obj/structure/ore_box/persistent/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/crate)
	. = ..()

/obj/structure/ore_box/persistent/proc/TrackPersistencePersistently(datum/persistent/as_type, tries, delay)
	if(tracked)
		return

	if (SSpersistence.initialized && SSmaterials.initialized)
		tracked = SSpersistence.track_value(src, as_type)
		if(tracked)
			DeferredInit()
			return

	if(tries > 1)
		addtimer(new Callback(src, PROC_REF(TrackPersistencePersistently), as_type, tries-1, delay*2), delay, TIMER_UNIQUE)

	return


/obj/structure/ore_box/persistent/proc/DeferredInit()
	if(!deferred_init)
		return

	for (var/mat_name in deferred_init)
		var/material/M = SSmaterials.get_material_by_name(mat_name)
		if(istype(M) && (M.name == mat_name))
			var/loss = max(2, deferred_init[mat_name] * rand(0, decay_rate) / 100.0)
			var/n = clamp(deferred_init[mat_name] - loss, 0, 500)
			for(var/i=0; i < n; i++)
				new /obj/item/ore(src, mat_name)

	deferred_init = null

	update_ore_count()


/obj/structure/ore_box/persistent/heavy
	name = "reserve ore box"
	decay_rate = 15
	icon_state = "orebox3"
	anchored = TRUE

/obj/structure/ore_box/persistent/heavy/can_anchor(obj/item/tool, mob/user, silent = FALSE)
	return FALSE