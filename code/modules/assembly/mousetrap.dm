/obj/item/device/assembly/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	icon_state = "mousetrap"
	origin_tech = list(TECH_COMBAT = 1)
	matter = list(MATERIAL_STEEL = 100, MATERIAL_WASTE = 10)
	var/armed = 0

/obj/item/device/assembly/mousetrap/examine(mob/user)
	. = ..()
	if(armed)
		to_chat(user, "It looks like it's armed.")

/obj/item/device/assembly/mousetrap/on_update_icon()
	if(armed)
		icon_state = "mousetraparmed"
	else
		icon_state = "mousetrap"
	if(holder)
		holder.update_icon()

/obj/item/device/assembly/mousetrap/proc/triggered(mob/target, var/type = "feet")
	if(!armed)
		return
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		switch(type)
			if("feet")
				if(!H.shoes)
					affecting = H.get_organ(pick(BP_L_LEG, BP_R_LEG))
					H.Weaken(3)
			if(BP_L_HAND, BP_R_HAND)
				if(!H.gloves)
					affecting = H.get_organ(type)
					H.Stun(3)
		if(affecting)
			affecting.take_external_damage(1, 0)
			H.updatehealth()
	else if(ismouse(target))
		var/mob/living/simple_animal/passive/mouse/M = target
		visible_message("<span class='danger'>SPLAT!</span>")
		M.splat()
	playsound(target.loc, 'sound/effects/snap.ogg', 50, 1)
	reset_plane_and_layer()
	armed = 0
	update_icon()
	pulse(0)


/obj/item/device/assembly/mousetrap/attack_self(mob/living/user)
	if(!armed)
		to_chat(user, "<span class='notice'>You arm [src].</span>")
	else
		if((MUTATION_CLUMSY in user.mutations) && prob(50))
			var/which_hand = BP_L_HAND
			if(!user.hand)
				which_hand = BP_R_HAND
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return
		to_chat(user, "<span class='notice'>You disarm [src].</span>")
	armed = !armed
	update_icon()
	playsound(user.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -3)


/obj/item/device/assembly/mousetrap/attack_hand(mob/living/user)
	if(armed)
		if((MUTATION_CLUMSY in user.mutations) && prob(50))
			var/which_hand = BP_L_HAND
			if(!user.hand)
				which_hand = BP_R_HAND
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return
	..()


/obj/item/device/assembly/mousetrap/Crossed(atom/movable/AM)
	if(armed)
		if(ishuman(AM))
			var/mob/living/carbon/H = AM
			if(!MOVING_DELIBERATELY(H))
				triggered(H)
				H.visible_message("<span class='warning'>[H] accidentally steps on [src].</span>", \
								  "<span class='warning'>You accidentally step on [src]</span>")
		if(ismouse(AM))
			triggered(AM)
	..()


/obj/item/device/assembly/mousetrap/on_found(mob/finder)
	if(armed)
		finder.visible_message("<span class='warning'>[finder] accidentally sets off [src], breaking their fingers.</span>", \
							   "<span class='warning'>You accidentally trigger [src]!</span>")
		triggered(finder, finder.hand ? BP_L_HAND : BP_R_HAND)
		return 1	//end the search!
	return 0


/obj/item/device/assembly/mousetrap/hitby(atom/A)
	if(!armed)
		return ..()
	visible_message("<span class='warning'>[src] is triggered by [A].</span>")
	triggered(A)


/obj/item/device/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = 1


/obj/item/device/assembly/mousetrap/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(usr.incapacitated())
		return

	layer = MOUSETRAP_LAYER
	to_chat(usr, "<span class='notice'>You hide [src].</span>")
