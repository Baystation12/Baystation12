/obj/structure/closet/statue //what
	name = "statue"
	desc = "An incredibly lifelike marble carving."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_male"
	density = TRUE
	anchored = TRUE
	setup = 0
	health_max = 0
	var/intialTox = 0 	//these are here to keep the mob from taking damage from things that logically wouldn't affect a rock
	var/intialFire = 0	//it's a little sloppy I know but it was this or the GODMODE flag. Lesser of two evils.
	var/intialBrute = 0
	var/intialOxy = 0
	var/timer = 240 //eventually the person will be freed

/obj/structure/closet/statue/New(loc, var/mob/living/L)
	if(L && (ishuman(L) || L.is_species(SPECIES_MONKEY) || iscorgi(L)))
		if(L.buckled)
			L.buckled = 0
			L.anchored = FALSE
		if(L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
		L.forceMove(src)
		L.set_sdisability(MUTED)
		set_max_health(L.health + 100)
		intialTox = L.getToxLoss()
		intialFire = L.getFireLoss()
		intialBrute = L.getBruteLoss()
		intialOxy = L.getOxyLoss()
		if(ishuman(L))
			name = "statue of [L.name]"
			if(L.gender == "female")
				icon_state = "human_female"
		else if(L.is_species(SPECIES_MONKEY))
			name = "statue of a monkey"
			icon_state = "monkey"
		else if(iscorgi(L))
			name = "statue of a corgi"
			icon_state = "corgi"
			desc = "If it takes forever, I will wait for you..."

	if(health_max == 0) //meaning if the statue didn't find a valid target
		qdel(src)
		return

	START_PROCESSING(SSobj, src)
	..()

/obj/structure/closet/statue/Process()
	timer--
	for(var/mob/living/M in src) //Go-go gadget stasis field
		M.setToxLoss(intialTox)
		M.adjustFireLoss(intialFire - M.getFireLoss())
		M.adjustBruteLoss(intialBrute - M.getBruteLoss())
		M.setOxyLoss(intialOxy)
	if (timer <= 0)
		dump_contents()
		STOP_PROCESSING(SSobj, src)
		qdel(src)

/obj/structure/closet/statue/dump_contents()
	for(var/obj/O in src)
		O.dropInto(loc)

	for(var/mob/living/M in src)
		M.dropInto(loc)
		M.unset_sdisability(MUTED)
		M.take_overall_damage(M.health - get_damage_value(), 0) //any new damage the statue incurred is transfered to the mob
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/statue/open()
	return

/obj/structure/closet/statue/close()
	return

/obj/structure/closet/statue/toggle()
	return

/obj/structure/closet/statue/handle_death_change(new_death_state)
	if (new_death_state)
		for (var/mob/M in src)
			shatter(M)

/obj/structure/closet/statue/attack_generic(var/mob/user, damage, attacktext, environment_smash)
	if(damage && environment_smash)
		kill_health()

/obj/structure/closet/statue/MouseDrop_T()
	return

/obj/structure/closet/statue/relaymove()
	return

/obj/structure/closet/statue/attack_hand()
	return

/obj/structure/closet/statue/verb_toggleopen()
	return

/obj/structure/closet/statue/on_update_icon()
	return

/obj/structure/closet/statue/proc/shatter(mob/user as mob)
	if (user)
		user.dust()
	dump_contents()
	visible_message("<span class='warning'>[src] shatters!.</span>")
	qdel(src)
