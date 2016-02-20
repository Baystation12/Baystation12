/obj/item/device/assembly/flash
	name = "flash"
	desc = "Used for blinding and being an asshole."
	icon_state = "flash"
	item_state = "flashtool"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_POWER_RECEIVE
	wire_num = 4

	var/times_used = 0 //Number of times it's been used.

	var/last_used = 0 //last world.time it was used.
	var/power_cost = 10 // Gradually becomes more expensive to use.

/obj/item/device/assembly/flash/proc/clown_check(var/mob/user)
	if(user && (CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>\The [src] slips out of your hand.</span>"
		user.drop_item()
		return 0
	return 1

/obj/item/device/assembly/flash/signal_failure(var/sent = 0)
	if(prob(5))
		activate()

/obj/item/device/assembly/flash/misc_special(mob/living/M as mob, mob/user as mob)
	if(user && !clown_check(user))	return
	if(broken)
		user << "<span class='warning'>\The [src] is broken.</span>"
		return

	if(!draw_power(power_cost))
		add_debug_log("Activation failure! Low power! \[[src]\]")
		if(user)
			user << "<span class='warning'>*click* *click*</span>"
		else
			var/turf/T = get_turf(src)
			if(T) T.audible_message("<span class='warning'><small>*click* *click*</small></span>")
		return

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.

	// Leaving this as is despite self-recharge removal -- rose
	switch(times_used)
		if(0 to 5)
			last_used = world.time
			if(prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				if(user)
					user << "<span class='warning'>The bulb has burnt out!</span>"
				else
					var/turf/T = get_turf(src)
					if(T) T.visible_message("<span class='warning'>[src]'s bulb fizzes out!</span>")
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			if(user)
				user << "<span class='warning'>*click* *click*</span>"
			else
				var/turf/T = get_turf(src)
				if(T) T.audible_message("<span class='warning'><small>*click* *click*</small></span>")
			return
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	var/flashfail = 0

	if(iscarbon(M))
		var/safety = M:eyecheck()
		if(safety <= 0)
			M.Weaken(10)
			flick("e_flash", M.flash)

			if(ishuman(M) && ishuman(user) && M.stat!=DEAD)
				if(user.mind && user.mind in revs.current_antagonists)
					var/revsafe = 0
					for(var/obj/item/weapon/implant/loyalty/L in M)
						if(L && L.implanted)
							revsafe = 1
							break
					M.mind_initialize()		//give them a mind datum if they don't have one.
					if(M.mind.has_been_rev)
						revsafe = 2
					if(!revsafe)
						M.mind.has_been_rev = 1
						revs.add_antagonist(M.mind)
					else if(revsafe == 1)
						if(user)
							user << "<span class='warning'>Something seems to be blocking the flash!</span>"
					else if(user)
						user << "<span class='warning'>This mind seems resistant to the flash!</span>"
		else
			flashfail = 1

	else if(issilicon(M))
		M.Weaken(rand(5,10))
	else
		flashfail = 1

	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	if(!flashfail)
		power_cost += 0.01
		if(!user) return
		if(!issilicon(M))

			user.visible_message("<span class='disarm'>[user] blinds [M] with the flash!</span>")
		else

			user.visible_message("<span class='notice'>[user] overloads [M]'s sensors with the flash!</span>")
	else if(user)

		user.visible_message("<span class='notice'>[user] fails to blind [M] with the flash!</span>")

	return


/obj/item/device/assembly/flash/activate()
	if(broken || !draw_power(power_cost))
		var/turf/T = get_turf(src)
		if(T)
			T.audible_message("<span class='warning'>*click* *click*</span>")
		return
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	for(var/mob/living/carbon/M in view(5))
		var/safety = M.eyecheck()
		if(safety <= 0)
			flick("e_flash", M.flash)

/*

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				var/turf/T = get_turf(src)
				if(T)
					T.audible_message("<span class='warning'><small>Bzzzt</small></span>")
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			var/turf/T = get_turf(src)
			if(T)
				T.audible_message("<span class='warning'>*click* *click*</span>")
			return
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("flash2", src)
	for(var/mob/living/carbon/M in oviewers(3, null))
		if(prob(50))
			if (locate(/obj/item/weapon/cloaking_device, M))
				for(var/obj/item/weapon/cloaking_device/S in M)
					S.active = 0
					S.icon_state = "shield0"
		var/safety = M:eyecheck()
		if(!safety)
			if(!M.blinded)
				flick("flash", M.flash)

	return

/obj/item/device/assembly/flash/emp_act(severity)
	if(broken)	return
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
				if(safety <= 0)
					M.Weaken(10)
					flick("e_flash", M.flash)
					for(var/mob/O in viewers(M, null))
						O.show_message("<span class='disarm'>[M] is blinded by the flash!</span>")
*/	..()

/obj/item/device/assembly/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution."
	icon_state = "sflash"
	origin_tech = "magnets=2;combat=1"
	var/construction_cost = list(DEFAULT_WALL_MATERIAL=750,"glass"=750)
	var/construction_time=100

/obj/item/device/assembly/flash/synthetic/activate()
	..()
	if(!broken)
		broken = 1
		var/turf/T = get_turf(src)
		if(T) T.audible_message("<span class='warning'>[src]'s bulb fizzles loudly!</span>")
		icon_state = "flashburnt"

