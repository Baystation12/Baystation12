/obj/item/device/assembly/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	icon_state = "mousetrap"
	matter = list(DEFAULT_WALL_MATERIAL = 100, "waste" = 10)
	var/armed = 0

	wires = null
	wire_num = 0



/obj/item/device/assembly/mousetrap/examine(mob/user)
	..(user)
	if(armed)
		user << "It looks like it's armed."

/obj/item/device/assembly/mousetrap/update_icon()
	if(armed)
		icon_state = "mousetraparmed"
	else
		icon_state = "mousetrap"
	if(holder)
		holder.update_icon()

/obj/item/device/assembly/mousetrap/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/cable_coil))
		if(istype(src, /obj/item/device/assembly/mousetrap/pressure_plate))
			user << "<span class='notice'>\The [src] is already modified!</span>"
			return
		var/obj/item/stack/cable_coil/cable = W
		if(!cable.amount >= 10)
			user << "<span class='notice'>You need atleast ten units of cable to do this!</span>"
			return

		user << "<span class='notice'>You start wiring up \the [src]!</span>"
		spawn(50)
			if(user in view(2))
				cable.use(10)
				user.visible_message("<span class='warning'>\The [user] modifies \the [src]!</span>", "<span class='notice'>You add some wiring to \the [src], allowing it to trigger devices when tripped!</span>")
				var/obj/item/device/assembly/mousetrap/pressure_plate/trap = new()
				trap.forceMove(get_turf(src))
				qdel(src)
				return
	..()

/obj/item/device/assembly/mousetrap/proc/triggered(mob/target as mob, var/type = "feet")
	if(!armed)
		return
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		switch(type)
			if("feet")
				if(!H.shoes)
					affecting = H.get_organ(pick("l_leg", "r_leg"))
					H.Weaken(3)
			if("l_hand", "r_hand")
				if(!H.gloves)
					affecting = H.get_organ(type)
					H.Stun(3)
		if(affecting)
			if(affecting.take_damage(1, 0))
				H.UpdateDamageIcon()
			H.updatehealth()
	else if(ismouse(target))
		var/mob/living/simple_animal/mouse/M = target
		visible_message("<span class='warning'><b>SPLAT!</b></span>")
		M.splat()
	playsound(target.loc, 'sound/effects/snap.ogg', 50, 1)
	layer = MOB_LAYER - 0.2
	armed = 0
	update_icon()

/obj/item/device/assembly/mousetrap/attack_self(mob/living/user as mob)
	if(!armed)
		user << "<span class='notice'>You arm [src].</span>"
	else
		if(((user.getBrainLoss() >= 60 || (CLUMSY in user.mutations)) && prob(50)))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return
		user << "<span class='notice'>You disarm [src].</span>"
	armed = !armed
	update_icon()
	playsound(user.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -3)


/obj/item/device/assembly/mousetrap/attack_hand(mob/living/user as mob)
	if(armed)
		if(((user.getBrainLoss() >= 60 || CLUMSY in user.mutations)) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return
	..()


/obj/item/device/assembly/mousetrap/Crossed(AM as mob|obj)
	if(armed)
		if(ishuman(AM))
			var/mob/living/carbon/H = AM
			if(H.m_intent == "run")
				triggered(H)
				H.visible_message("<span class='warning'>[H] accidentally steps on \the [holder ? "[holder]" : "[src]"].</span>", \
								  "<span class='warning'>You accidentally step on \the [holder ? "[holder]" : "[src]"].</span>")
		if(ismouse(AM))
			triggered(AM)
	..()

/obj/item/device/assembly/mousetrap/on_found(mob/finder as mob)
	if(armed)
		finder.visible_message("<span class='warning'>[finder] accidentally sets off [src], breaking their fingers.</span>", \
							   "<span class='warning'>You accidentally trigger [src]!</span>")
		triggered(finder, finder.hand ? "l_hand" : "r_hand")
		return 1	//end the search!
	return 0


/obj/item/device/assembly/mousetrap/hitby(A as mob|obj)
	if(!armed)
		return ..()
	visible_message("<span class='warning'>[src] is triggered by [A].</span>")
	triggered(null)


/obj/item/device/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = 1