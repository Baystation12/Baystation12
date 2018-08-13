/obj/structure/mech_wreckage
	name = "wreckage"
	desc = "It might have some salvagable parts."
	density = 1
	opacity = 1
	anchored = 1
	icon_state = "wreck"
	icon = 'icons/mecha/mech_part_items.dmi'
	var/prepared

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
	if(isWelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())
			if(!prepared)
				prepared = 1
				to_chat(user, "<span class='notice'>You partially dismantle \the [src].</span>")
			else
				to_chat(user, "<span class='warning'>\The [src] has already been weakened.</span>")
		else
			to_chat(user, "<span class='warning'>Turn the torch on, first.</span>")
		return 1
	else if(isWrench(W))
		if(prepared)
			to_chat(user, "<span class='notice'>You finish dismantling \the [src].</span>")
			new /obj/item/stack/material/steel(get_turf(src),rand(5,10))
			qdel(src)
		else
			to_chat(user, "<span class='warning'>It's too solid to dismantle. Try cutting through some of the bigger bits.</span>")
		return 1
	else if(istype(W) && W.force > 20)
		visible_message("<span class='danger'>\The [src] has been smashed with \the [W] by \the [user]!</span>")
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
