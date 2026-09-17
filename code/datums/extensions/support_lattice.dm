/datum/extension/support_lattice
	base_type = /datum/extension/support_lattice
	expected_type = /atom

/datum/extension/support_lattice/proc/try_construct(obj/item/C, mob/living/user, list/click_params)
	var/turf/T = get_turf(holder)
	if (istype(C, /obj/item/stack/material/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, T)
		if(L)
			return L.use_tool(C, user)
		var/obj/item/stack/material/rods/R = C
		if (!R.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(R, 1, "to lay down support lattice.")
			return TRUE

		to_chat(user, SPAN_NOTICE("You lay down the support lattice."))
		playsound(T, 'sound/weapons/Genhit.ogg', 50, 1)
		T.ReplaceWithLattice(R.material.name)
		R.use(1)
		return TRUE

	if (istype(C, /obj/item/stack/tile))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, T)
		if(!L)
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))
			return TRUE
		var/obj/item/stack/tile/floor/S = C
		if (!S.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(S, 1, "to place the plating.")
			return TRUE

		qdel(L)
		playsound(T, 'sound/weapons/Genhit.ogg', 50, 1)
		T.ChangeTurf(/turf/simulated/floor/plating, keep_air = TRUE)
		S.use(1)
		return TRUE

	if(isCoil(C))
		var/obj/item/stack/cable_coil/coil = C
		coil.PlaceCableOnTurf(T, user, click_params)
		return TRUE

	return FALSE
