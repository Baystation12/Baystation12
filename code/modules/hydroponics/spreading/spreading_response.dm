/obj/effect/plant/HasProximity(var/atom/movable/AM)

	if(!is_mature() || seed.get_trait(TRAIT_SPREAD) != 2)
		return

	var/mob/living/M = AM
	if(!istype(M))
		return

	if(!buckled_mob && !M.buckled && !M.anchored && (issmall(M) || prob(round(seed.get_trait(TRAIT_POTENCY)/6))))
		//wait a tick for the Entered() proc that called HasProximity() to finish (and thus the moving animation),
		//so we don't appear to teleport from two tiles away when moving into a turf adjacent to vines.
		spawn(1)
			entangle(M)

/obj/effect/plant/attack_hand(var/mob/user)
	manual_unbuckle(user)

/obj/effect/plant/attack_generic(var/mob/user)
	if(istype(user))
		manual_unbuckle(user)

/obj/effect/plant/Crossed(atom/movable/O)
	if(isliving(O))
		trodden_on(O)

/obj/effect/plant/proc/trodden_on(var/mob/living/victim)
	if(!is_mature())
		return
	var/mob/living/carbon/human/H = victim
	if(prob(round(seed.get_trait(TRAIT_POTENCY)/4)))
		entangle(victim)
	if(istype(H) && H.shoes)
		return
	seed.do_thorns(victim,src)
	seed.do_sting(victim,src,pick(BP_R_FOOT,BP_L_FOOT,BP_R_LEG,BP_L_LEG))

/obj/effect/plant/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
		buckled_mob = null
	return

/obj/effect/plant/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		var/chance = 20
		if(seed)
			chance = round(100/(20*seed.get_trait(TRAIT_POTENCY)/100))
		if(prob(chance))
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"<span class='notice'>\The [user] frees \the [buckled_mob] from \the [src].</span>",\
					"<span class='notice'>\The [user] frees you from \the [src].</span>",\
					"<span class='warning'>You hear shredding and ripping.</span>")
			else
				buckled_mob.visible_message(\
					"<span class='notice'>\The [buckled_mob] struggles free of \the [src].</span>",\
					"<span class='notice'>You untangle \the [src] from around yourself.</span>",\
					"<span class='warning'>You hear shredding and ripping.</span>")
			unbuckle()
		else
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			health -= rand(1,5)
			var/text = pick("rip","tear","pull", "bite", "tug")
			user.visible_message(\
				"<span class='warning'>\The [user] [text]s at \the [src].</span>",\
				"<span class='warning'>You [text] at \the [src].</span>",\
				"<span class='warning'>You hear shredding and ripping.</span>")
			check_health()
	return

/obj/effect/plant/proc/entangle(var/mob/living/victim)

	if(buckled_mob)
		return

	if(victim.buckled || victim.anchored)
		return

	//grabbing people
	if(!victim.anchored && Adjacent(victim) && victim.loc != src.loc)
		var/can_grab = 1
		if(istype(victim, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = victim
			if((istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & NOSLIP)) || (H.species.flags & NO_SLIP))
				can_grab = 0
		if(can_grab)
			src.visible_message("<span class='danger'>Tendrils lash out from \the [src] and drag \the [victim] in!</span>")
			victim.forceMove(src.loc)
			sleep(1)
			//entangling people
			if(victim.loc == src.loc)
				buckle_mob(victim)
				victim.set_dir(pick(GLOB.cardinal))
				to_chat(victim, "<span class='danger'>Tendrils [pick("wind", "tangle", "tighten")] around you!</span>")

/obj/effect/plant/buckle_mob()
	. = ..()
	if(.) plant_controller.add_plant(src)