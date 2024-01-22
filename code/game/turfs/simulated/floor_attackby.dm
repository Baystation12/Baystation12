/turf/simulated/floor/use_tool(obj/item/C, mob/living/user, list/click_params)
	var/area/A = get_area(src)
	if (!A.can_modify_area())
		visible_message("\The [src] cannot be dismantled or modified in any way!")
		return TRUE

	if(isCoil(C) || (flooring && istype(C, /obj/item/stack/material/rods)))
		return ..(C, user)

	if(!(isScrewdriver(C) && flooring && (flooring.flags & TURF_REMOVE_SCREWDRIVER)) && try_graffiti(user, C))
		return TRUE

	if(flooring)
		if(isCrowbar(C))
			if(broken || burnt)
				to_chat(user, SPAN_NOTICE("You remove the broken [flooring.descriptor]."))
				make_plating()
			else if(flooring.flags & TURF_IS_FRAGILE)
				to_chat(user, SPAN_DANGER("You forcefully pry off \the [flooring.descriptor], destroying them in the process."))
				make_plating()
			else if(flooring.flags & TURF_REMOVE_CROWBAR)
				if (flooring.remove_timer)
					user.visible_message(
						SPAN_NOTICE("\The [user] begins prying up \the [flooring.descriptor] with \the [C]!"),
						SPAN_NOTICE("You begin prying up \the [flooring.descriptor] with \the [C].")
					)
					playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
					if (do_after(user, flooring.remove_timer, src, DO_REPAIR_CONSTRUCT))
						user.visible_message(
							SPAN_NOTICE("\The [user] pries up \the [flooring.descriptor] with \the [C]!"),
							SPAN_NOTICE("You pry up \the [flooring.descriptor] with \the [C].")
						)
						make_plating(TRUE)
						playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
					return TRUE
				else
					to_chat(user, SPAN_NOTICE("You lever off \the [flooring.descriptor]."))
					make_plating(TRUE)
			else
				return ..()

			playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
			return TRUE

		else if(isScrewdriver(C) && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return ..()
			if (flooring.remove_timer)
				user.visible_message(
					SPAN_NOTICE("\The [user] begins unscrewing \the [flooring.descriptor] with \the [C]!"),
					SPAN_NOTICE("You begin unscrewing \the [flooring.descriptor] with \the [C].")
				)
				playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
				if (do_after(user, flooring.remove_timer, src, DO_REPAIR_CONSTRUCT))
					user.visible_message(
						SPAN_NOTICE("\The [user] unscrews \the [flooring.descriptor] with \the [C]!"),
						SPAN_NOTICE("You unscrew \the [flooring.descriptor] with \the [C].")
					)
					make_plating(TRUE)
					playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
				return TRUE
			else
				to_chat(user, SPAN_NOTICE("You unscrew and remove \the [flooring.descriptor]."))
				make_plating(TRUE)
				playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
				return TRUE

		else if(isWrench(C) && (flooring.flags & TURF_REMOVE_WRENCH))
			if (flooring.remove_timer)
				user.visible_message(
					SPAN_NOTICE("\The [user] begins unwrenching \the [flooring.descriptor] with \the [C]!"),
					SPAN_NOTICE("You begin unwrenching \the [flooring.descriptor] with \the [C].")
				)
				playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
				if (do_after(user, flooring.remove_timer, src, DO_REPAIR_CONSTRUCT))
					user.visible_message(
						SPAN_NOTICE("\The [user] unwrench \the [flooring.descriptor] with \the [C]!"),
						SPAN_NOTICE("You unwrench \the [flooring.descriptor] with \the [C].")
					)
					make_plating(TRUE)
					playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
				return TRUE
			else
				to_chat(user, SPAN_NOTICE("You unwrench and remove \the [flooring.descriptor]."))
				make_plating(TRUE)
				playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
				return TRUE

		else if(istype(C, /obj/item/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			to_chat(user, SPAN_NOTICE("You shovel off \the [flooring.descriptor]."))
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return TRUE

		else if(isCoil(C))
			to_chat(user, SPAN_WARNING("You must remove \the [flooring.descriptor] first."))
			return TRUE

	else
		if(istype(C, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
				return TRUE
			//first check, catwalk? Else let flooring do its thing
			if(locate(/obj/structure/catwalk, src))
				return ..()

			if (istype(C, /obj/item/stack/material/rods))
				var/obj/item/stack/material/rods/R = C
				if (!R.can_use(2))
					USE_FEEDBACK_STACK_NOT_ENOUGH(R, 2, "to build the catwalk.")
					return TRUE

				R.use(2)
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				new /obj/structure/catwalk(src)
				return TRUE

			var/obj/item/stack/S = C
			var/singleton/flooring/use_flooring
			var/list/singletons = GET_SINGLETON_SUBTYPE_MAP(/singleton/flooring)
			for(var/flooring_type in singletons)
				var/singleton/flooring/F = singletons[flooring_type]
				if(!F.build_type)
					continue
				if(S.type == F.build_type || S.build_type == F.build_type)
					use_flooring = F
					break
			if(!use_flooring)
				return TRUE

			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				to_chat(user, SPAN_WARNING("You require at least [use_flooring.build_cost] [S.name] to complete \the [use_flooring.descriptor]."))
				return TRUE

			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src, DO_REPAIR_CONSTRUCT))
				return TRUE
			if(flooring || !S || !user || !use_flooring)
				return TRUE
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return TRUE

		// Repairs and Deconstruction.
		else if (isCrowbar(C) && (broken || burnt))
			playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
			visible_message(SPAN_NOTICE("\The [user] has begun prying off the damaged plating."))
			var/turf/T = GetBelow(src)
			if(T)
				T.visible_message(SPAN_WARNING("The ceiling above looks as if it's being pried off."))
			if (!do_after(user, (C.toolspeed * 10) SECONDS, src, DO_REPAIR_CONSTRUCT))
				return TRUE
			if (!istype(src, /turf/simulated/floor))
				return TRUE
			if (!broken && !burnt || !(is_plating()))
				return TRUE
			visible_message(SPAN_WARNING("\The [user] has pried off the damaged plating."))
			new /obj/item/stack/tile/floor(src)
			ReplaceWithLattice()
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			if(T)
				T.visible_message(SPAN_DANGER("The ceiling above has been pried off!"))
			return TRUE

		else if(isWelder(C))
			var/obj/item/weldingtool/welder = C
			if(welder.can_use(2, user) && (is_plating()))
				if(broken || burnt)
					welder.remove_fuel(2, user)
					to_chat(user, SPAN_NOTICE("You fix some dents on the broken plating."))
					playsound(src, 'sound/items/Welder.ogg', 80, 1)
					icon_state = "plating"
					burnt = null
					broken = null
					return TRUE
				else
					welder.remove_fuel(2, user)
					playsound(src, 'sound/items/Welder.ogg', 80, 1)
					visible_message(SPAN_NOTICE("\The [user] has started melting the plating's reinforcements!"))
					if(do_after(user, (C.toolspeed * 5) SECONDS, src, DO_REPAIR_CONSTRUCT) && welder.isOn() && welder_melt())
						visible_message(SPAN_WARNING("\The [user] has melted the plating's reinforcements! It should be possible to pry it off."))
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
					return TRUE

		else if(istype(C, /obj/item/gun/energy/plasmacutter) && (is_plating()) && !broken && !burnt)
			var/obj/item/gun/energy/plasmacutter/cutter = C
			if(!cutter.slice(user))
				return ..()
			playsound(src, 'sound/items/Welder.ogg', 80, 1)
			visible_message(SPAN_NOTICE("\The [user] has started slicing through the plating's reinforcements!"))
			if(do_after(user, (C.toolspeed * 3) SECONDS, src, DO_PUBLIC_UNIQUE) && welder_melt())
				visible_message(SPAN_WARNING("[user] has sliced through the plating's reinforcements! It should be possible to pry it off."))
				playsound(src, 'sound/items/Welder.ogg', 80, 1)
			return TRUE

	return ..()

/turf/simulated/floor/proc/welder_melt()
	if(!(is_plating()) || broken || burnt)
		return 0
	burnt = 1
	remove_decals()
	update_icon()
	return 1

/turf/simulated/floor/can_build_cable(mob/user)
	if(!is_plating() || flooring)
		to_chat(user, SPAN_WARNING("Remove the tiling first."))
		return 0
	if(broken || burnt)
		to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
		return 0
	return 1
