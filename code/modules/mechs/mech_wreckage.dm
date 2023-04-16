/obj/structure/mech_wreckage
	name = "wreckage"
	desc = "It might have some salvagable parts."
	density = TRUE
	opacity = 1
	anchored = TRUE
	icon_state = "wreck"
	icon = 'icons/mecha/mech_part_items.dmi'
	health_max = 100
	health_min_damage = 20
	var/prepared

/obj/structure/mech_wreckage/New(newloc, mob/living/exosuit/exosuit, gibbed)
	if(exosuit)
		name = "wreckage of \the [exosuit.name]"
		if(!gibbed)
			for(var/obj/item/thing in list(exosuit.arms, exosuit.legs, exosuit.head, exosuit.body))
				if(thing && prob(40))
					thing.forceMove(src)
			for(var/hardpoint in exosuit.hardpoints)
				if(exosuit.hardpoints[hardpoint])
					if(prob(40))
						var/obj/item/thing = exosuit.hardpoints[hardpoint]
						if(exosuit.remove_system(hardpoint))
							thing.forceMove(src)
					else
						//This has been destroyed, some modules may need to perform bespoke logic
						var/obj/item/mech_equipment/E = exosuit.hardpoints[hardpoint]
						if(istype(E))
							E.wreck()

	..()

/obj/structure/mech_wreckage/powerloader/New(newloc)
	..(newloc, new /mob/living/exosuit/premade/powerloader(newloc), FALSE)

/obj/structure/mech_wreckage/attack_hand(mob/user)
	if(length(contents))
		var/obj/item/thing = pick(contents)
		if(istype(thing))
			thing.forceMove(get_turf(user))
			user.put_in_hands(thing)
			to_chat(user, "You retrieve \the [thing] from \the [src].")
			return
	return ..()


/obj/structure/mech_wreckage/on_death()
	. = ..()
	visible_message(SPAN_WARNING("\The [src] breaks apart!"))
	new /obj/item/stack/material/steel(loc, rand(1, 3))
	qdel_self()


/obj/structure/mech_wreckage/use_tool(obj/item/tool, mob/user, list/click_params)
	// Welding Tool, Plasma Cutter - Cut through wreckage
	if (istype(tool, /obj/item/gun/energy/plasmacutter) || isWelder(tool))
		if (prepared)
			USE_FEEDBACK_FAILURE("\The [src] has already been weakened.")
			return TRUE
		if (isWelder(tool))
			var/obj/item/weldingtool/welder = tool
			if (!welder.remove_fuel(1, user))
				return TRUE
		else if (istype(tool, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/plasmacutter = tool
			if (!plasmacutter.slice(user))
				return TRUE
		prepared = TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] partially cuts through \the [src] with \a [tool]."),
			SPAN_NOTICE("You partially cut through \the [src] with \a [tool].")
		)
		return TRUE

	// Wrench - Finish dismantling
	if (isWrench(tool))
		if (!prepared)
			USE_FEEDBACK_FAILURE("\The [src] is too solid to dismantle. Try cutting through it first.")
			return TRUE
		new /obj/item/stack/material/steel(loc, rand(5, 10))
		user.visible_message(
			SPAN_NOTICE("\The [user] finishes dismantling \the [src] with \a [tool]."),
			SPAN_NOTICE("You finish dismantling \the [src] with \a [tool].")
		)
		qdel_self()
		return TRUE

	return ..()


/obj/structure/mech_wreckage/Destroy()
	for(var/obj/thing in contents)
		if(prob(65))
			thing.forceMove(get_turf(src))
		else
			qdel(thing)
	..()
