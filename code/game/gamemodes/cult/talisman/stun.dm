/obj/item/paper/talisman/stun
	talisman_name = "stun"
	talisman_desc = "temporarily stuns a targeted mob"
	valid_target_type = list(
		/mob/living/carbon,
		/mob/living/silicon
	)


/obj/item/paper/talisman/stun/invoke(mob/living/target, mob/user)
	if(issilicon(target))
		target.Weaken(15)
		target.silent += 15
	else if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.silent += 15
		C.Weaken(20)
		C.Stun(20)
