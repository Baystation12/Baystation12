/obj/effect/vine/HasProximity(var/atom/movable/AM)

	if(!is_mature() || seed.get_trait(TRAIT_SPREAD) != 2)
		return

	var/mob/living/M = AM
	if(!istype(M))
		return

	if(!buckled_mob && !M.buckled && !M.anchored && (issmall(M) || prob(round(seed.get_trait(TRAIT_POTENCY)/6))))
		//wait a tick for the Entered() proc that called HasProximity() to finish (and thus the moving animation),
		//so we don't appear to teleport from two tiles away when moving into a turf adjacent to vines.
		spawn(1)
			if(prob(seed.get_trait(((TRAIT_POTENCY)/2)*3)))
				entangle(M)

/obj/effect/vine/attack_hand(var/mob/user)
	manual_unbuckle(user)

/obj/effect/vine/attack_generic(var/mob/user)
	if(istype(user))
		manual_unbuckle(user)

/obj/effect/vine/Crossed(atom/movable/O)
	if(isliving(O))
		trodden_on(O)

/obj/effect/vine/proc/trodden_on(var/mob/living/victim)
	wake_neighbors()
	if(!is_mature())
		return
	if(prob(seed.get_trait(((TRAIT_POTENCY)/2)*3)))
		entangle(victim)
	Process(0)
	var/mob/living/carbon/human/H = victim
	if(istype(H) && H.shoes)
		return
	seed.do_thorns(victim,src)
	seed.do_sting(victim,src,pick(BP_R_FOOT,BP_L_FOOT,BP_R_LEG,BP_L_LEG))

/obj/effect/vine/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.UpdateLyingBuckledAndVerbStatus()
		buckled_mob = null
	START_PROCESSING(SSvines, src)
	return

/obj/effect/vine/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		var/chance = 20
		if(seed)
			chance = round(100/(20*seed.get_trait(TRAIT_POTENCY)/100))
		if(prob(chance) && (buckled_mob != user))
			buckled_mob.visible_message(\
				"<span class='notice'>\The [user] frees \the [buckled_mob] from \the [src].</span>",\
				"<span class='notice'>\The [user] frees you from \the [src].</span>",\
				"<span class='warning'>You hear shredding and ripping.</span>")
			unbuckle()
		else
			user.setClickCooldown(100)
			var/breakouttime = rand(600, 1200) //1 to 2 minutes.

			user.visible_message(
				"<span class='danger'>\The [user] attempts to get free from [src]!</span>",
				"<span class='warning'>You attempt to get free from [src].</span>")

			if(do_after(user, breakouttime, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
				if(!buckled_mob)
					return
				unbuckle_mob(user)
				user.visible_message(
					"<span class='danger'>\The [user] manages to escape [src]!</span>",
					"<span class='warning'>You successfully escape [src]!</span>")

	START_PROCESSING(SSvines, src)
	return

/obj/effect/vine/proc/entangle(var/mob/living/victim)
	var/mob/living/carbon/human/H = victim
	if(istype(H) && (isalien(victim) || (H.species.species_flags & SPECIES_FLAG_NO_TANGLE)))
		return

	if(buckled_mob)
		return

	if(victim.buckled || victim.anchored)
		return

	//grabbing people
	if(!victim.anchored && (Adjacent(victim) || victim.loc == src.loc))
		var/can_grab = 1
		if(istype(victim, /mob/living/carbon/human))
			if(((istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & ITEM_FLAG_NOSLIP)) || (H.species.species_flags & SPECIES_FLAG_NO_SLIP)) && victim.loc != src.loc)
				if(prob(90))
					src.visible_message("<span class='danger'>Tendrils lash to drag \the [victim] but \the [src] can't pull them across the ground!</span>")
					can_grab = 0
		if(can_grab)
			victim.visible_message("<span class='danger'>Tendrils lash out from \the [src] and drag \the [victim] in!</span>", "<span class='danger'>Tendrils lash out from \the [src] and drag you in!</span>")
			victim.forceMove(src.loc)
			sleep(1)
			//entangling people
			if(victim.loc == src.loc)
				buckle_mob(victim)
				victim.set_dir(pick(GLOB.cardinal))
				to_chat(victim, "<span class='danger'>The tendrils [pick("wind", "tangle", "tighten", "coil", "knot", "snag", "twist", "constrict", "squeeze", "clench", "tense")] around you!</span>")
			Process(0)

/obj/effect/vine/buckle_mob()
	. = ..()
	if(.) START_PROCESSING(SSvines, src)