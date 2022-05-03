/mob/living/New()
	..()
	if(stat == DEAD)
		add_to_dead_mob_list()
	else
		add_to_living_mob_list()

	selected_image = image(icon('icons/misc/buildmode.dmi'), loc = src, icon_state = "ai_sel")

/mob/living/examine(mob/user, distance, infix, suffix)
	. = ..()
	if (admin_paralyzed)
		to_chat(user, SPAN_DEBUG("OOC: They have been paralyzed by staff. Please avoid interacting with them unless cleared to do so by staff."))

//mob verbs are faster than object verbs. See mob/verb/examine.
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set category = "Object"

	if(AM.Adjacent(src))
		src.start_pulling(AM)

	return

//mob verbs are faster than object verbs. See above.
/mob/living/pointed(atom/A as mob|obj|turf in view())
	if(incapacitated())
		return 0
	if(src.status_flags & FAKEDEATH)
		return 0
	if(!..())
		return 0

	usr.visible_message("<b>[src]</b> points to [A]")
	return 1

/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(var/mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		else
			return ((a_intent == I_HELP && swapped.a_intent == I_HELP) && swapped.can_move_mob(src, swapping, 1))

/mob/living/canface()
	if(stat)
		return 0
	return ..()

/mob/living/Bump(atom/movable/AM, yes)

	// This is boilerplate from /atom/movable/Bump() but in all honest
	// I have no clue what is going on in the logic below this and I'm
	// afraid to touch it in case it explodes and kills me.
	if(!QDELETED(throwing))
		throwing.hit_atom(AM)
		return
	// End boilerplate.

	spawn(0)
		if ((!( yes ) || now_pushing) || !loc)
			return

		now_pushing = 1
		if (istype(AM, /mob/living))
			var/mob/living/tmob = AM

			for(var/mob/living/M in range(tmob, 1))
				if(tmob.pinned.len ||  ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/grab, tmob.grabbed_by.len)) )
					if ( !(world.time % 5) )
						to_chat(src, "<span class='warning'>[tmob] is restrained, you cannot push past</span>")
					now_pushing = 0
					return
				if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
					if ( !(world.time % 5) )
						to_chat(src, "<span class='warning'>[tmob] is restraining [M], you cannot push past</span>")
					now_pushing = 0
					return

			if(can_swap_with(tmob)) // mutual brohugs all around!
				var/turf/oldloc = loc
				forceMove(tmob.loc)
				tmob.forceMove(oldloc)
				now_pushing = 0
				for(var/mob/living/carbon/slime/slime in view(1,tmob))
					if(slime.Victim == tmob)
						slime.UpdateFeed()
				return

			if(!can_move_mob(tmob, 0, 0))
				now_pushing = 0
				return
			if(src.restrained())
				now_pushing = 0
				return
			if(tmob.a_intent != I_HELP)
				if(istype(tmob, /mob/living/carbon/human) && (MUTATION_FAT in tmob.mutations))
					if(prob(40) && !(MUTATION_FAT in src.mutations))
						to_chat(src, "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>")
						now_pushing = 0
						return
				if(tmob.r_hand && istype(tmob.r_hand, /obj/item/shield/riot))
					if(prob(99))
						now_pushing = 0
						return
				if(tmob.l_hand && istype(tmob.l_hand, /obj/item/shield/riot))
					if(prob(99))
						now_pushing = 0
						return
			if(!(tmob.status_flags & CANPUSH))
				now_pushing = 0
				return
			tmob.LAssailant = src
		if(isobj(AM) && !AM.anchored)
			var/obj/I = AM
			if(!can_pull_size || can_pull_size < I.w_class)
				to_chat(src, "<span class='warning'>It won't budge!</span>")
				now_pushing = 0
				return

		now_pushing = 0
		spawn(0)
			..()
			var/saved_dir = AM.dir
			if ((confused || (MUTATION_CLUMSY in mutations)) && !MOVING_DELIBERATELY(src))
				AM.slam_into(src)
			if (!istype(AM, /atom/movable) || AM.anchored)
				return
			if (!now_pushing)
				now_pushing = 1

				var/t = get_dir(src, AM)
				if (istype(AM, /obj/structure/window))
					for(var/obj/structure/window/win in get_step(AM,t))
						now_pushing = 0
						return
				step(AM, t)
				if (istype(AM, /mob/living))
					var/mob/living/tmob = AM
					if(istype(tmob.buckled, /obj/structure/bed))
						if(!tmob.buckled.anchored)
							step(tmob.buckled, t)
				if(ishuman(AM))
					var/mob/living/carbon/human/M = AM
					for(var/obj/item/grab/G in M.grabbed_by)
						step(G.assailant, get_dir(G.assailant, AM))
						G.adjust_position()
				if(saved_dir)
					AM.set_dir(saved_dir)
				now_pushing = 0

/proc/swap_density_check(var/mob/swapper, var/mob/swapee)
	var/turf/T = get_turf(swapper)
	if(T?.density)
		return 1
	for(var/atom/movable/A in T)
		if(A == swapper)
			continue
		if(!A.CanPass(swapee, T, 1))
			return 1

/mob/living/proc/can_swap_with(var/mob/living/tmob)
	if(!tmob) return
	if(tmob.buckled || buckled || tmob.anchored)
		return 0
	//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
	if(!(tmob.mob_always_swap || (tmob.a_intent == I_HELP || tmob.restrained()) && (a_intent == I_HELP || src.restrained())))
		return 0
	if(!tmob.MayMove(src) || incapacitated())
		return 0

	if(swap_density_check(src, tmob))
		return 0

	if(swap_density_check(tmob, src))
		return 0

	return can_move_mob(tmob, 1, 0)


/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - getHalLoss()


//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return


//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	take_overall_damage(0, burn_amount)

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/btemperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		btemperature += change
		if(actual > desired)
			btemperature = desired
	// Too hot
	if(actual > desired)
		btemperature -= change
		if(actual < desired)
			btemperature = desired
//	if(istype(src, /mob/living/carbon/human))
//		log_debug("[src] ~ [src.bodytemperature] ~ [temperature]")

	return btemperature

/mob/living/proc/getBruteLoss()
	return maxHealth - health

/mob/living/proc/adjustBruteLoss(var/amount)
	if (status_flags & GODMODE)
		return
	health = clamp(health - amount, 0, maxHealth)

/mob/living/proc/getOxyLoss()
	return 0

/mob/living/proc/adjustOxyLoss(var/amount)
	return

/mob/living/proc/setOxyLoss(var/amount)
	return

/mob/living/proc/getToxLoss()
	return 0

/mob/living/proc/adjustToxLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setToxLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getFireLoss()
	return

/mob/living/proc/adjustFireLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setFireLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getHalLoss()
	return 0

/mob/living/proc/adjustHalLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setHalLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getBrainLoss()
	return 0

/mob/living/proc/adjustBrainLoss(var/amount)
	return

/mob/living/proc/setBrainLoss(var/amount)
	return

/mob/living/proc/getCloneLoss()
	return 0

/mob/living/proc/setCloneLoss(var/amount)
	return

/mob/living/proc/adjustCloneLoss(var/amount)
	return

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	maxHealth = newMaxHealth

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/proc/get_contents()
	return

//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)

		for(var/obj/item/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)

		for(var/obj/item/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0

/mob/living/proc/can_inject(var/mob/user, var/target_zone)
	return 1

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter.zone_sel?.selecting
	if ((t in list( BP_EYES, BP_MOUTH )))
		t = BP_HEAD
	var/obj/item/organ/external/def_zone = ran_zone(t)
	return def_zone


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn, var/affect_robo = 0)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(brute = 0, burn = 0, flags = 0)
	if(status_flags & GODMODE || !brute && !burn)
		return
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return

/mob/living/proc/revive()
	rejuvenate()
	if(buckled)
		buckled.unbuckle_mob()
	if(iscarbon(src))
		var/mob/living/carbon/C = src

		if (C.handcuffed && !initial(C.handcuffed))
			C.drop_from_inventory(C.handcuffed)
		C.handcuffed = initial(C.handcuffed)
	SET_BIT(hud_updateflag, HEALTH_HUD)
	SET_BIT(hud_updateflag, STATUS_HUD)
	SET_BIT(hud_updateflag, LIFE_HUD)
	ExtinguishMob()
	fire_stacks = 0

/mob/living/proc/rejuvenate()
	if(reagents)
		reagents.clear_reagents()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)

	// shut down ongoing problems
	radiation = 0
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	drowsyness = 0
	druggy = 0
	jitteriness = 0
	confused = 0

	heal_overall_damage(getBruteLoss(), getFireLoss())

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		switch_from_dead_to_living_mob_list()
		timeofdeath = 0

	// restore us to conciousness
	set_stat(CONSCIOUS)

	// make the icons look correct
	regenerate_icons()

	SET_BIT(hud_updateflag, HEALTH_HUD)
	SET_BIT(hud_updateflag, STATUS_HUD)
	SET_BIT(hud_updateflag, LIFE_HUD)

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	reload_fullscreen()
	return

/mob/living/proc/basic_revival(var/repair_brain = TRUE)

	if(repair_brain && getBrainLoss() > 50)
		repair_brain = FALSE
		setBrainLoss(50)

	if(stat == DEAD)
		switch_from_dead_to_living_mob_list()
		timeofdeath = 0

	stat = CONSCIOUS
	regenerate_icons()

	SET_BIT(hud_updateflag, HEALTH_HUD)
	SET_BIT(hud_updateflag, STATUS_HUD)
	SET_BIT(hud_updateflag, LIFE_HUD)

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	reload_fullscreen()

/mob/living/carbon/basic_revival(var/repair_brain = TRUE)
	if(repair_brain && should_have_organ(BP_BRAIN))
		repair_brain = FALSE
		var/obj/item/organ/internal/brain/brain = internal_organs_by_name[BP_BRAIN]
		if(brain.damage > (brain.max_damage/2))
			brain.damage = (brain.max_damage/2)
		if(brain.status & ORGAN_DEAD)
			brain.status &= ~ORGAN_DEAD
			START_PROCESSING(SSobj, brain)
		brain.update_icon()
	..(repair_brain)

/mob/living/proc/UpdateDamageIcon()
	return

/mob/living/Move(a, b, flag)
	if (buckled)
		return

	if(get_dist(src, pulling) > 1)
		stop_pulling()

	var/turf/old_loc = get_turf(src)

	. = ..()

	if(. && pulling)
		handle_pulling_after_move(old_loc)

	if (s_active && !( s_active in contents ) && get_turf(s_active) != get_turf(src))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)

	if(update_slimes)
		for(var/mob/living/carbon/slime/M in view(1,src))
			M.UpdateFeed()

/mob/living/proc/can_pull()
	if(!moving)
		return FALSE
	if(pulling.anchored)
		return FALSE
	if(!isturf(pulling.loc))
		return FALSE
	if(restrained())
		return FALSE

	if(get_dist(src, pulling) > 2)
		return FALSE

	if(pulling.z != z)
		if(pulling.z < z)
			return FALSE
		var/turf/T = GetAbove(src)
		if(!isopenspace(T))
			return FALSE
	return TRUE

/mob/living/proc/handle_pulling_after_move(turf/old_loc)
	if(!pulling)
		return

	if(!can_pull())
		stop_pulling()
		return

	if(pulling.loc == loc || pulling.loc == old_loc)
		return

	if (!isliving(pulling))
		step(pulling, get_dir(pulling.loc, old_loc))
	else
		var/mob/living/M = pulling
		if(M.grabbed_by.len)
			if (prob(75))
				var/obj/item/grab/G = pick(M.grabbed_by)
				if(istype(G))
					M.visible_message(SPAN_WARNING("[G.affecting] has been pulled from [G.assailant]'s grip by [src]!"), SPAN_WARNING("[G.affecting] has been pulled from your grip by [src]!"))
					qdel(G)
		if (!M.grabbed_by.len)
			M.handle_pull_damage(src)

			var/atom/movable/t = M.pulling
			M.stop_pulling()
			step(M, get_dir(pulling.loc, old_loc))
			if(t)
				M.start_pulling(t)

	handle_dir_after_pull()

/mob/living/proc/handle_dir_after_pull()
	if(pulling)
		if(isobj(pulling))
			var/obj/O = pulling
			if(O.w_class >= ITEM_SIZE_HUGE || O.density)
				return set_dir(get_dir(src, pulling))
		if(isliving(pulling))
			var/mob/living/L = pulling
			// If pulled mob was bigger than us, we morelike will turn
			// I made additional check in case if someone want a hand walk
			if(L.mob_size > mob_size || L.lying || a_intent != I_HELP)
				return set_dir(get_dir(src, pulling))

/mob/living/proc/handle_pull_damage(mob/living/puller)
	var/area/A = get_area(src)
	if(!A.has_gravity)
		return
	var/turf/location = get_turf(src)
	if(lying && prob(getBruteLoss() / 6))
		location.add_blood(src)
		if(prob(25))
			src.adjustBruteLoss(1)
			visible_message("<span class='danger'>\The [src]'s [src.isSynthetic() ? "state worsens": "wounds open more"] from being dragged!</span>")
			. = TRUE
	if(src.pull_damage())
		if(prob(25))
			src.adjustBruteLoss(2)
			visible_message("<span class='danger'>\The [src]'s [src.isSynthetic() ? "state" : "wounds"] worsen terribly from being dragged!</span>")
			location.add_blood(src)
			. = TRUE

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && last_resist + 2 SECONDS <= world.time)
		last_resist = world.time
		resist_grab()
		if(resting)
			lay_down()
		if(!weakened)
			process_resist()

/mob/living/proc/process_resist()
	//Getting out of someone's inventory.
	if(istype(src.loc, /obj/item/holder))
		escape_inventory(src.loc)
		return

	//unbuckling yourself
	if(buckled)
		spawn() escape_buckle()
		return TRUE

	//Breaking out of a structure?
	if(istype(loc, /obj/structure))
		var/obj/structure/C = loc
		if(C.mob_breakout(src))
			return TRUE

/mob/living/proc/escape_inventory(obj/item/holder/H)
	if(H != src.loc) return

	var/mob/M = H.loc //Get our mob holder (if any).

	if(istype(M))
		M.drop_from_inventory(H)
		to_chat(M, "<span class='warning'>\The [H] wriggles out of your grip!</span>")
		to_chat(src, "<span class='warning'>You wriggle out of \the [M]'s grip!</span>")

		// Update whether or not this mob needs to pass emotes to contents.
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_animal/borer) || istype(A,/obj/item/holder))
				return
		M.status_flags &= ~PASSEMOTES
	else if(istype(H.loc,/obj/item/clothing/accessory/storage/holster) || istype(H.loc,/obj/item/storage/belt/holster))
		var/datum/extension/holster/holster = get_extension(H.loc, /datum/extension/holster)
		if(holster.holstered == H)
			holster.clear_holster()
		to_chat(src, "<span class='warning'>You extricate yourself from \the [holster].</span>")
		H.forceMove(get_turf(H))
	else if(istype(H.loc,/obj))
		to_chat(src, "<span class='warning'>You struggle free of \the [H.loc].</span>")
		H.forceMove(get_turf(H))

	if(loc != H)
		qdel(H)

/mob/living/proc/escape_buckle()
	if(buckled)
		if(buckled.can_buckle)
			buckled.user_unbuckle_mob(src)
		else if (istype(buckled, /obj/effect/vine))
			var/obj/effect/vine/V = buckled
			spawn() V.manual_unbuckle(src)
		else
			to_chat(usr, "<span class='warning'>You can't seem to escape from \the [buckled]!</span>")
			return

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/grab/G in grabbed_by)
		resisting++
		G.handle_resist()
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")

//called when the mob receives a bright flash
/mob/living/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(override_blindness_check || !(disabilities & BLINDED))
		..()
		overlay_fullscreen("flash", type)
		spawn(25)
			if(src)
				clear_fullscreen("flash", 25)
		return 1

/mob/living/proc/cannot_use_vents()
	if(mob_size > MOB_SMALL)
		return "You can't fit into that vent."
	return null

/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/slip(var/slipped_on,stun_duration=8)
	return 0

/mob/living/carbon/human/canUnEquip(obj/item/I)
	if(!..())
		return
	if(I in internal_organs)
		return
	if(I in organs)
		return
	return 1

//Organs should not be removed via inventory procs.
/mob/living/carbon/drop_from_inventory(var/obj/item/W, var/atom/Target = null)
	if(W in internal_organs)
		return
	if(W in organs)
		return
	. = ..()

//damage/heal the mob ears and adjust the deaf amount
/mob/living/adjustEarDamage(var/damage, var/deaf)
	ear_damage = max(0, ear_damage + damage)
	ear_deaf = max(0, ear_deaf + deaf)

//pass a negative argument to skip one of the variable
/mob/living/setEarDamage(var/damage = null, var/deaf = null)
	if(!isnull(damage))
		ear_damage = damage
	if(!isnull(deaf))
		ear_deaf = deaf

/mob/proc/can_be_possessed_by(var/mob/observer/ghost/possessor)
	return istype(possessor) && possessor.client

/mob/living/can_be_possessed_by(var/mob/observer/ghost/possessor)
	if(!..())
		return 0
	if(!possession_candidate)
		to_chat(possessor, "<span class='warning'>That animal cannot be possessed.</span>")
		return 0
	if(jobban_isbanned(possessor, "Animal"))
		to_chat(possessor, "<span class='warning'>You are banned from animal roles.</span>")
		return 0
	if(!possessor.MayRespawn(1,ANIMAL_SPAWN_DELAY))
		return 0
	return 1

/mob/living/proc/do_possession(var/mob/observer/ghost/possessor)

	if(!(istype(possessor) && possessor.ckey))
		return 0

	if(src.ckey || src.client)
		to_chat(possessor, "<span class='warning'>\The [src] already has a player.</span>")
		return 0

	message_admins("<span class='adminnotice'>[key_name_admin(possessor)] has taken control of \the [src].</span>")
	log_admin("[key_name(possessor)] took control of \the [src].")
	src.ckey = possessor.ckey
	qdel(possessor)

	if(round_is_spooky(6)) // Six or more active cultists.
		to_chat(src, "<span class='notice'>You reach out with tendrils of ectoplasm and invade the mind of \the [src]...</span>")
		to_chat(src, "<b>You have assumed direct control of \the [src].</b>")
		to_chat(src, "<span class='notice'>Due to the spookiness of the round, you have taken control of the poor animal as an invading, possessing spirit - roleplay accordingly.</span>")
		src.universal_speak = TRUE
		src.universal_understand = TRUE
		//src.cultify() // Maybe another time.
		return

	to_chat(src, "<b>You are now \the [src]!</b>")
	to_chat(src, "<span class='notice'>Remember to stay in character for a mob of this type!</span>")
	return 1

/mob/living/reset_layer()
	if (jumping)
		layer = VEHICLE_LOAD_LAYER
	else if (hiding)
		layer = HIDING_MOB_LAYER
	else
		..()

/mob/living/update_icons()
	if(auras)
		overlays |= auras

/mob/living/proc/add_aura(var/obj/aura/aura)
	LAZYDISTINCTADD(auras,aura)
	update_icons()
	return 1

/mob/living/proc/remove_aura(var/obj/aura/aura)
	LAZYREMOVE(auras,aura)
	update_icons()
	return 1

/mob/living/Destroy()
	if(auras)
		for(var/a in auras)
			remove_aura(a)

	qdel(selected_image)
	return ..()

/mob/living/proc/melee_accuracy_mods()
	. = 0
	if(incapacitated(INCAPACITATION_UNRESISTING))
		. += 100
	if(confused)
		. += 10
	if(weakened)
		. += 15
	if(eye_blurry)
		. += 5
	if(eye_blind)
		. += 60
	if(MUTATION_CLUMSY in mutations)
		. += 40

/mob/living/proc/ranged_accuracy_mods()
	. = 0
	if(jitteriness)
		. -= 2
	if(confused)
		. -= 2
	if(eye_blind)
		. -= 5
	if(eye_blurry)
		. -= 1
	if(MUTATION_CLUMSY in mutations)
		. -= 3

/mob/living/can_drown()
	return TRUE

/mob/living/handle_drowning()
	var/turf/T = get_turf(src)
	if(!can_drown() || !loc.is_flooded(lying))
		return FALSE
	if(!lying && T.above && !T.above.is_flooded() && T.above.CanZPass(src, UP) && can_overcome_gravity())
		return FALSE
	if(prob(5))
		to_chat(src, SPAN_DANGER("You choke and splutter as you inhale water!"))
	T.show_bubbles()
	return TRUE // Presumably chemical smoke can't be breathed while you're underwater.

/mob/living/water_act(var/depth)
	..()
	wash_mob(src)
	for(var/thing in get_equipped_items(TRUE))
		if(isnull(thing)) continue
		var/atom/movable/A = thing
		if(A.simulated && !A.waterproof)
			A.water_act(depth)

/mob/living/proc/nervous_system_failure()
	return FALSE

/mob/living/proc/needs_wheelchair()
	return FALSE

/mob/living/proc/seizure()
	set waitfor = 0
	sleep(rand(5,10))
	if(!paralysis && stat == CONSCIOUS)
		visible_message(SPAN_DANGER("\The [src] starts having a seizure!"))
		Paralyse(rand(8,16))
		make_jittery(rand(150,200))
		adjustHalLoss(rand(50,60))

/mob/living/proc/get_digestion_product()
	return null

/mob/living/proc/eyecheck()
	return FLASH_PROTECTION_NONE

/mob/living/proc/InStasis()
	return FALSE

/mob/living/proc/jump_layer_shift()
	jumping = TRUE
	reset_layer()

/mob/living/proc/jump_layer_shift_end()
	jumping = FALSE
	reset_layer()
