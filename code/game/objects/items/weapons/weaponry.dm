/obj/item/nullrod
	name = "null sceptre"
	desc = "A sceptre of pure black obsidian capped at both ends with silver ferrules. Some religious groups claim it disrupts and dampens the powers of paranormal phenomenae."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 10
	throw_speed = 1
	throw_range = 4
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL

/obj/item/nullrod/disrupts_psionics()
	return src

/obj/item/nullrod/use_before(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.
	. = FALSE
	if (!istype(M) || user.a_intent == I_HELP)
		return FALSE

	admin_attack_log(user, M, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)
	//if(user != M)
	if (!user.IsAdvancedToolUser())
		to_chat(user, SPAN_DANGER("You don't have the dexterity to do this!"))
		return TRUE

	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_DANGER("The rod slips out of your hand and hits your head."))
		user.take_organ_damage(10, 0)
		user.Paralyse(20)
		return TRUE

	if (M.mind && LAZYLEN(M.mind.learned_spells))
		M.silence_spells(300) //30 seconds
		M.visible_message(SPAN_NOTICE("\The [user] waves \the [src] over \the [M]'s head."))
		to_chat(M, SPAN_DANGER("You've been silenced!"))
		return TRUE

	if(GLOB.cult && iscultist(M))
		M.visible_message(SPAN_NOTICE("\The [user] waves \the [src] over \the [M]'s head."))
		GLOB.cult.offer_uncult(M)
		return TRUE

/obj/item/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/energy_net

/obj/item/energy_net/safari
	name = "animal net"
	desc = "An energized net meant to subdue animals."
	net_type = /obj/energy_net/safari

/obj/item/energy_net/dropped()
	..()
	spawn(10)
		if(src) qdel(src)

/obj/item/energy_net/throw_impact(atom/hit_atom)
	..()
	try_capture_mob(hit_atom)

// This will validate the hit_atom, then spawn an energy_net effect and qdel itself
/obj/item/energy_net/proc/try_capture_mob(mob/living/M)

	if(!istype(M) || locate(/obj/energy_net) in M.loc)
		qdel(src)
		return FALSE

	var/turf/T = get_turf(M)
	if(T)
		var/obj/energy_net/net_effect = new net_type(T)
		net_effect.capture_mob(M)
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = TRUE
	opacity = 0
	mouse_opacity = 1
	anchored = TRUE
	health_max = 25

	var/countdown = 15
	var/temporary = 1
	var/mob/living/carbon/captured = null
	var/min_free_time = 50
	var/max_free_time = 85

/obj/energy_net/safari
	name = "animal net"
	desc = "An energized net meant to subdue animals."

	anchored = FALSE
	health_max = 5
	temporary = 0
	min_free_time = 5
	max_free_time = 10

/obj/energy_net/teleport
	countdown = 60

/obj/energy_net/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/energy_net/Destroy()
	if(istype(captured, /mob/living/carbon))
		if(captured.handcuffed == src)
			captured.handcuffed = null
	if(captured)
		unbuckle_mob()
	STOP_PROCESSING(SSobj, src)
	captured = null
	return ..()

/obj/energy_net/Process()
	if(temporary)
		countdown--
	if(!captured || captured.buckled != src)
		kill_health()
	if(get_turf(src) != get_turf(captured))  //just in case they somehow teleport around or
		countdown = 0
	if(countdown <= 0)
		visible_message(SPAN_WARNING("\The [src] fades away!"))
		qdel(src)

/obj/energy_net/Move()
	..()

	if(buckled_mob)
		buckled_mob.forceMove(src.loc)
	else
		countdown = 0


/obj/energy_net/proc/capture_mob(mob/living/M)
	captured = M
	if(M.buckled)
		M.buckled.unbuckle_mob()
	buckle_mob(M)
	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		if(!C.handcuffed)
			C.handcuffed = src
	return 1

/obj/energy_net/post_buckle_mob(mob/living/M)
	if(buckled_mob)
		layer = ABOVE_HUMAN_LAYER
		visible_message("\The [M] was caught in [src]!")
	else
		to_chat(M,SPAN_WARNING("You are free of the net!"))
		reset_plane_and_layer()

/obj/energy_net/on_death()
	visible_message(SPAN_DANGER("\The [src] is torn apart!"))
	qdel(src)

/obj/energy_net/attack_hand(mob/user)
	if (user.a_intent != I_HURT)
		return

	user.visible_message(
		SPAN_WARNING("\The [user] claws at \the [src]!"),
		SPAN_WARNING("You claw at \the [src]!")
	)
	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.species.can_shred(H))
			playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			damage_health(rand(10, 20))
		else
			damage_health(rand(1, 3))

	else if (MUTATION_HULK in user.mutations)
		kill_health()
	else
		damage_health(rand(5, 8))

/obj/energy_net/user_unbuckle_mob(mob/user)
	return escape_net(user)


/obj/energy_net/proc/escape_net(mob/user as mob)
	visible_message(
		SPAN_WARNING("\The [user] attempts to free themselves from \the [src]!"),
		SPAN_WARNING("You attempt to free yourself from \the [src]!")
	)
	if (do_after(user, rand(min_free_time, max_free_time), src, DO_PUBLIC_UNIQUE, INCAPACITATION_DISABLED))
		kill_health()
		return TRUE
	else
		return FALSE
