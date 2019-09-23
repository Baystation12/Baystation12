/obj/structure/mech_wreckage
	name = "wreckage"
	desc = "It might have some salvagable parts."
	density = 1
	opacity = 1
	anchored = 1
	icon_state = "wreck"
	icon = 'icons/mecha/mech_part_items.dmi'
	var/prepared

/obj/structure/mech_wreckage/New(var/newloc, var/mob/living/exosuit/exosuit, var/gibbed)
	if(exosuit)
		name = "wreckage of \the [exosuit.name]"
		if(!gibbed)
			for(var/obj/item/thing in list(exosuit.arms, exosuit.legs, exosuit.head, exosuit.body))
				if(thing && prob(40))
					thing.forceMove(src)
			for(var/hardpoint in exosuit.hardpoints)
				if(exosuit.hardpoints[hardpoint] && prob(40))
					var/obj/item/thing = exosuit.hardpoints[hardpoint]
					if(exosuit.remove_system(hardpoint))
						thing.forceMove(src)

	..()

/obj/structure/mech_wreckage/powerloader/New(var/newloc)
	..(newloc, new /mob/living/exosuit/premade/powerloader(newloc), FALSE)

/obj/structure/mech_wreckage/attack_hand(var/mob/user)
	if(contents.len)
		var/obj/item/thing = pick(contents)
		if(istype(thing))
			thing.forceMove(get_turf(user))
			user.put_in_hands(thing)
			to_chat(user, "You retrieve \the [thing] from \the [src].")
			return
	return ..()

/obj/structure/mech_wreckage/attackby(var/obj/item/W, var/mob/user)

	var/cutting
	if(isWelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())
			cutting = TRUE
		else
			to_chat(user, SPAN_WARNING("Turn the torch on, first."))
	else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
		cutting = TRUE

	if(cutting)
		if(!prepared)
			prepared = 1
			to_chat(user, SPAN_NOTICE("You partially dismantle \the [src]."))
		else
			to_chat(user, SPAN_WARNING("\The [src] has already been weakened."))
		return 1

	else if(isWrench(W))
		if(prepared)
			to_chat(user, SPAN_NOTICE("You finish dismantling \the [src]."))
			new /obj/item/stack/material/steel(get_turf(src),rand(5,10))
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("It's too solid to dismantle. Try cutting through some of the bigger bits."))
		return 1
	else if(istype(W) && W.force > 20)
		visible_message(SPAN_DANGER("\The [src] has been smashed with \the [W] by \the [user]!"))
		if(prob(20))
			new /obj/item/stack/material/steel(get_turf(src),rand(1,3))
			qdel(src)
		return 1
	return ..()

/obj/structure/mech_wreckage/Destroy()
	for(var/obj/thing in contents)
		if(prob(65))
			thing.forceMove(get_turf(src))
		else
			qdel(thing)
	..()
