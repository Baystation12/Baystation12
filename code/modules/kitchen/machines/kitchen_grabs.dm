/obj/machinery/kitchen/proc/handle_grab(var/mob/living/victim, var/mob/user)
	if(!istype(victim))
		return
	playsound(src.loc, 'sound/items/trayhit1.ogg', 50, 1)
	visible_message("<span class='danger'>\The [user] slams \the [victim] into \the [src]!</span>")
	victim.apply_damage(rand(5,8))

/obj/machinery/kitchen/oven/handle_grab(var/mob/living/victim, var/mob/user)
	if(!istype(victim))
		return
	playsound(src.loc, 'sound/items/trayhit1.ogg', 50, 1)
	if(istype(victim, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = victim
		var/obj/item/organ/external/E = H.get_organ("head")
		if(E)
			visible_message("<span class='danger'>\The [user] slams \the [victim]'s head in \the [src]'s door!</span>")
			E.take_damage(rand(5,8))
			return
	visible_message("<span class='danger'>\The [user] slams \the [victim] into \the [src]!</span>")
	victim.apply_damage(rand(5,8))

/obj/machinery/kitchen/stove/handle_grab(var/mob/living/victim, var/mob/user)
	if(!istype(victim))
		return
	var/hottest_burner = 0
	for(var/burner in burners_temperature)
		if(burners_temperature[burner] > hottest_burner)
			hottest_burner = burners_temperature[burner]
	if(hottest_burner < 60) //Cooking temp.
		return ..(victim, user)
	playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
	if(istype(victim, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = victim
		var/obj/item/organ/external/E = H.get_organ("head")
		if(E)
			visible_message("<span class='danger'>\The [user] mashes \the [victim]'s face into \the [src]'s lit burners!</span>")
			E.take_damage(0,round(hottest_burner/4))
			return
	visible_message("<span class='danger'>\The [user] mashes \the [victim] into \the [src]'s lit burners!</span>")
	victim.apply_damage(round(hottest_burner/4), BURN)