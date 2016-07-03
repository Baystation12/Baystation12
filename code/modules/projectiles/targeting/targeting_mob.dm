/mob/living/var/obj/aiming_overlay/aiming
/mob/living/var/list/aimed = list()

/mob/verb/toggle_gun_mode()
	set name = "Toggle Gun Mode"
	set desc = "Begin or stop aiming."
	set category = "IC"

	if(isliving(src)) //Needs to be a mob verb to prevent error messages when using hotkeys
		var/mob/living/M = src
		if(!M.aiming)
			M.aiming = new(src)
		M.aiming.toggle_active()
	else
		src << "<span class='warning'>This verb may only be used by living mobs, sorry.</span>"
	return

/mob/living/proc/stop_aiming(var/obj/item/thing, var/no_message = 0)
	if(!aiming)
		aiming = new(src)
	if(thing && aiming.aiming_with != thing)
		return
	aiming.cancel_aiming(no_message)

/mob/living/death(gibbed,deathmessage="seizes up and falls limp...")
	if(..())
		stop_aiming(no_message=1)

/mob/living/proc/vomit(var/skip_wait, var/blood_vomit)
	return

/mob/living/carbon/vomit(var/skip_wait, var/blood_vomit)

	if(isSynthetic())
		src << "<span class='danger'>A sudden, dizzying wave of internal feedback rushes over you!</span>"
		src.Weaken(5)
		return

	if(!check_has_mouth())
		return

	if(!lastpuke)

		if (nutrition <= 100)
			src << "<span class='danger'>You gag as you want to throw up, but there's nothing in your stomach!</span>"
			src.Weaken(10)
			src.adjustToxLoss(3)
			return

		lastpuke = 1
		src << "<span class='warning'>You feel nauseous...</span>"

		if(!skip_wait)
			sleep(150)	//15 seconds until second warning
			src << "<span class='warning'>You feel like you are about to throw up!</span>"
			sleep(100)	//and you have 10 more for mad dash to the bucket

		Stun(5)
		src.visible_message("<span class='warning'>[src] throws up!</span>","<span class='warning'>You throw up!</span>")
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		var/turf/simulated/T = get_turf(src)
		if(istype(T))
			if(blood_vomit)
				T.add_blood_floor(src)
			else
				T.add_vomit_floor(src, 1)

		if(blood_vomit)
			if(getBruteLoss() < 50)
				adjustBruteLoss(3)
		else
			nutrition -= 40
			adjustToxLoss(-3)

		sleep(350)
		lastpuke = 0

/mob/living/update_canmove()
	..()
	if(lying)
		stop_aiming(no_message=1)

/mob/living/Weaken(amount)
	stop_aiming(no_message=1)
	..()

/mob/living/Destroy()
	if(aiming)
		qdel(aiming)
		aiming = null
	aimed.Cut()
	return ..()

