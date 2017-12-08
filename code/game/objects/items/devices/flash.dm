/obj/item/device/flash
	name = "flash"
	desc = "A device that produces a bright flash of light, designed to stun and disorient an attacker."
	icon_state = "flash"
	item_state = "flashtool"
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)

	var/times_used = 0 //Number of times it's been used.
	var/broken = 0     //Is the flash burnt out?
	var/last_used = 0 //last world.time it was used.
	var/str_min = 2 //how weak the effect CAN be
	var/str_max = 7 //how powerful the effect COULD be

/obj/item/device/flash/proc/clown_check(var/mob/user)
	if(user && (CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>\The [src] slips out of your hand.</span>")
		user.drop_item()
		return 0
	return 1

/obj/item/device/flash/proc/flash_recharge()
	//capacitor recharges over time
	for(var/i=0, i<3, i++)
		if(last_used+600 > world.time)
			break
		last_used += 600
		times_used -= 2
	last_used = world.time
	times_used = max(0,round(times_used)) //sanity

//attack_as_weapon
/obj/item/device/flash/attack(mob/living/M, mob/living/user, var/target_zone)
	if(!user || !M)	return	//sanity
	admin_attack_log(user, M, "flashed their victim using \a [src].", "Was flashed by \a [src].", "used \a [src] to flash")

	if(!clown_check(user))	return
	if(broken)
		to_chat(user, "<span class='warning'>\The [src] is broken.</span>")
		return

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			last_used = world.time
			if(prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
				icon_state = "[initial(icon_state)]_burnt"
				return
			times_used++
		else	//can only use it 5 times a minute
			to_chat(user, "<span class='warning'>*click* *click*</span>")
			return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	var/flashfail = 0

	if(iscarbon(M))
		if(M.stat!=DEAD)
			var/mob/living/carbon/C = M
			var/safety = C.eyecheck()
			if(safety < FLASH_PROTECTION_MODERATE)
				var/flash_strength = (rand(str_min,str_max))
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					flash_strength = round(H.species.flash_mod * flash_strength)
				if(flash_strength > 0)
					M.flash_eyes(FLASH_PROTECTION_MODERATE - safety)
					M.Stun(flash_strength / 2)
					M.eye_blurry += flash_strength
					M.confused += (flash_strength + 2)
					if(flash_strength > 3)
						M.drop_l_hand()
						M.drop_r_hand()
					if(flash_strength > 5)
						M.Weaken(2)
			else
				flashfail = 1

	else if(issilicon(M))
		M.Weaken(rand(str_min,6))
	else
		flashfail = 1

	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.plane = user.plane
			animation.layer = user.layer + 0.01
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	if(!flashfail)
		flick("[initial(icon_state)]_on", src)
		if(!issilicon(M))
			user.visible_message("<span class='disarm'>[user] blinds [M] with \the [src]!</span>")
		else
			user.visible_message("<span class='notice'>[user] overloads [M]'s sensors with \the [src]!</span>")
	else
		user.visible_message("<span class='notice'>[user] fails to blind [M] with \the [src]!</span>")
	return




/obj/item/device/flash/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user || !clown_check(user)) 	return

	if(broken)
		user.show_message("<span class='warning'>The [src.name] is broken</span>", 2)
		return

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
				icon_state = "[initial(icon_state)]_burnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			user.show_message("<span class='warning'>*click* *click*</span>", 2)
			return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("[initial(icon_state)]_on", src)
	if(user && isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.plane = user.plane
			animation.layer = user.layer + 0.01
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	for(var/mob/living/carbon/M in oviewers(3, null))
		var/safety = M.eyecheck()
		if(safety < FLASH_PROTECTION_MODERATE)
			if(!M.blinded)
				M.flash_eyes()
				M.eye_blurry += 2

	return

/obj/item/device/flash/emp_act(severity)
	if(broken)	return
	flash_recharge()
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))
				broken = 1
				icon_state = "[initial(icon_state)]_burnt"
				return
			times_used++
			if(istype(loc, /mob/living/carbon))
				var/mob/living/carbon/M = loc
				var/safety = M.eyecheck()
				if(safety < FLASH_PROTECTION_MODERATE)
					M.Weaken(10)
					M.flash_eyes()
					for(var/mob/O in viewers(M, null))
						O.show_message("<span class='disarm'>[M] is blinded by the [name]!</span>")
	..()

/obj/item/device/flash/synthetic //not for regular use, weaker effects
	name = "modified flash"
	desc = "A device that produces a bright flash of light. This is a specialized version designed specifically for use in camera systems."
	icon_state = "sflash"
	str_min = 1
	str_max = 4

/obj/item/device/flash/advanced
	name = "advanced flash"
	desc = "A device that produces a very bright flash of light. This is an advanced and expensive version often issued to VIPs."
	icon_state = "advflash"
	str_min = 3
	str_max = 8