/obj/item/device/flash
	name = "flash"
	desc = "Used for blinding and being an asshole."
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

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			last_used = world.time
			if(prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
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
				var/flash_strength = 10
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					flash_strength *= H.species.flash_mod
				if(flash_strength > 0)
					M.Weaken(flash_strength)
					M.flash_eyes(FLASH_PROTECTION_MODERATE - safety)
			else
				flashfail = 1

	else if(issilicon(M))
		M.Weaken(rand(5,10))
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
		flick("flash2", src)
		if(!issilicon(M))

			user.visible_message("<span class='disarm'>[user] blinds [M] with the flash!</span>")
		else

			user.visible_message("<span class='notice'>[user] overloads [M]'s sensors with the flash!</span>")
	else

		user.visible_message("<span class='notice'>[user] fails to blind [M] with the flash!</span>")

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
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			user.show_message("<span class='warning'>*click* *click*</span>", 2)
			return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("flash2", src)
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

	return

/obj/item/device/flash/emp_act(severity)
	if(broken)	return
	flash_recharge()
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))
				broken = 1
				icon_state = "flashburnt"
				return
			times_used++
			if(istype(loc, /mob/living/carbon))
				var/mob/living/carbon/M = loc
				var/safety = M.eyecheck()
				if(safety < FLASH_PROTECTION_MODERATE)
					M.Weaken(10)
					M.flash_eyes()
					for(var/mob/O in viewers(M, null))
						O.show_message("<span class='disarm'>[M] is blinded by the flash!</span>")
	..()

/obj/item/device/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution."
	icon_state = "sflash"
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)

//attack_as_weapon
/obj/item/device/flash/synthetic/attack(mob/living/M, mob/living/user, var/target_zone)
	..()
	if(!broken)
		broken = 1
		to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
		icon_state = "flashburnt"

/obj/item/device/flash/synthetic/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	..()
	if(!broken)
		broken = 1
		to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
		icon_state = "flashburnt"
