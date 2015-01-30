// SPACE VINES (Note that this code is very similar to Biomass code)
/obj/effect/plantsegment
	name = "space vines"
	desc = "An extremely expansionistic species of vine."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Light1"
	anchored = 1
	density = 0
	layer = 5
	pass_flags = PASSTABLE | PASSGRILLE

	// Vars used by vines with seed data.
	var/age = 0
	var/lastproduce = 0
	var/harvest = 0
	var/list/chems
	var/plant_damage_noun = "Thorns"
	var/limited_growth = 0

	// Life vars/
	var/energy = 0
	var/obj/effect/plant_controller/master = null
	var/mob/living/buckled_mob
	var/datum/seed/seed

/obj/effect/plantsegment/New()
	return

/obj/effect/plantsegment/Del()
	if(master)
		master.vines -= src
		master.growth_queue -= src
	..()

/obj/effect/plantsegment/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!W || !user || !W.type) return
	switch(W.type)
		if(/obj/item/weapon/circular_saw) del src
		if(/obj/item/weapon/kitchen/utensil/knife) del src
		if(/obj/item/weapon/scalpel) del src
		if(/obj/item/weapon/twohanded/fireaxe) del src
		if(/obj/item/weapon/hatchet) del src
		if(/obj/item/weapon/melee/energy) del src
		if(/obj/item/weapon/pickaxe/plasmacutter) del src

		// Less effective weapons
		if(/obj/item/weapon/wirecutters)
			if(prob(25)) del src
		if(/obj/item/weapon/shard)
			if(prob(25)) del src

		// Weapons with subtypes
		else
			if(istype(W, /obj/item/weapon/melee/energy/sword)) del src
			else if(istype(W, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = W
				if(WT.remove_fuel(0, user)) del src
			else
				manual_unbuckle(user)
				return
		// Plant-b-gone damage is handled in its entry in chemistry-reagents.dm
	..()


/obj/effect/plantsegment/attack_hand(mob/user as mob)

	if(user.a_intent == "help" && seed && harvest)
		seed.harvest(user,1)
		harvest = 0
		lastproduce = age
		update()
		return

	manual_unbuckle(user)

/obj/effect/plantsegment/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
		buckled_mob = null
	return

/obj/effect/plantsegment/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(prob(seed ? min(max(0,100 - seed.get_trait(TRAIT_POTENCY)),100) : 50))
			if(buckled_mob.buckled == src)
				if(buckled_mob != user)
					buckled_mob.visible_message(\
						"<span class='notice'>[user.name] frees [buckled_mob.name] from [src].</span>",\
						"<span class='notice'>[user.name] frees you from [src].</span>",\
						"<span class='warning'>You hear shredding and ripping.</span>")
				else
					buckled_mob.visible_message(\
						"<span class='notice'>[buckled_mob.name] struggles free of [src].</span>",\
						"<span class='notice'>You untangle [src] from around yourself.</span>",\
						"<span class='warning'>You hear shredding and ripping.</span>")
			unbuckle()
		else
			var/text = pick("rips","tears","pulls")
			user.visible_message(\
				"<span class='notice'>[user.name] [text] at [src].</span>",\
				"<span class='notice'>You [text] at [src].</span>",\
				"<span class='warning'>You hear shredding and ripping.</span>")
	return

/obj/effect/plantsegment/proc/grow()

	if(!energy)
		src.icon_state = pick("Med1", "Med2", "Med3")
		energy = 1

		//Low-lying creepers do not block vision or grow thickly.
		if(limited_growth)
			energy = 2
			return

		src.opacity = 1
		layer = 5
	else if(!limited_growth)
		src.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		energy = 2

/obj/effect/plantsegment/proc/entangle_mob()

	if(limited_growth)
		return

	if(prob(seed ? seed.get_trait(TRAIT_POTENCY) : 25))

		if(!buckled_mob)
			var/mob/living/carbon/V = locate() in src.loc
			if(V && (V.stat != DEAD) && (V.buckled != src)) // If mob exists and is not dead or captured.
				V.buckled = src
				V.loc = src.loc
				V.update_canmove()
				src.buckled_mob = V
				V << "<span class='danger'>The vines [pick("wind", "tangle", "tighten")] around you!</span>"

		// FEED ME, SEYMOUR.
		if(buckled_mob && seed && (buckled_mob.stat != DEAD)) //Don't bother with a dead mob.
			seed.do_thorns(buckled_mob,src)
			seed.do_sting(buckled_mob,src)

/obj/effect/plantsegment/proc/update()
	if(!seed) return

	// Update bioluminescence.
	if(seed.get_trait(TRAIT_BIOLUM))
		SetLuminosity(1+round(seed.get_trait(TRAIT_POTENCY)/10))
		if(seed.get_trait(TRAIT_BIOLUM_COLOUR))
			l_color = seed.get_trait(TRAIT_BIOLUM_COLOUR)
		else
			l_color = null
		return
	else
		SetLuminosity(0)

	// Update flower/product overlay.
	overlays.Cut()
	if(age >= seed.get_trait(TRAIT_MATURATION))
		if(prob(20) && seed.products && seed.products.len && !harvest && ((age-lastproduce) > seed.get_trait(TRAIT_PRODUCTION)))
			harvest = 1
			lastproduce = age

		if(harvest)
			var/image/fruit_overlay = image('icons/obj/hydroponics_vines.dmi',"")
			if(seed.get_trait(TRAIT_PRODUCT_COLOUR))
				fruit_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
			overlays += fruit_overlay

		if(seed.get_trait(TRAIT_FLOWERS))
			var/image/flower_overlay = image('icons/obj/hydroponics_vines.dmi',"[seed.get_trait(TRAIT_FLOWER_ICON)]")
			if(seed.get_trait(TRAIT_FLOWER_COLOUR))
				flower_overlay.color = seed.get_trait(TRAIT_FLOWER_COLOUR)
			overlays += flower_overlay

/obj/effect/plantsegment/proc/spread()
	var/direction = pick(cardinal)
	var/step = get_step(src,direction)
	if(istype(step,/turf/simulated/floor))
		var/turf/simulated/floor/F = step
		if(!locate(/obj/effect/plantsegment,F))
			if(F.Enter(src))
				if(master)
					master.spawn_piece( F )

// Explosion damage.
/obj/effect/plantsegment/ex_act(severity)
	switch(severity)
		if(1.0)
			die()
			return
		if(2.0)
			if (prob(90))
				die()
				return
		if(3.0)
			if (prob(50))
				die()
				return
	return

// Hotspots kill vines.
/obj/effect/plantsegment/fire_act(null, temp, volume)
	del src

/obj/effect/plantsegment/proc/die()
	if(seed && harvest && rand(5))
		seed.harvest(src,1)
		del(src)

/obj/effect/plantsegment/proc/life()

	if(!seed)
		return

	if(prob(30))
		age++

	var/turf/T = loc
	var/datum/gas_mixture/environment
	if(T) environment = T.return_air()

	if(!environment)
		return

	var/pressure = environment.return_pressure()
	if(pressure < seed.get_trait(TRAIT_LOWKPA_TOLERANCE) || pressure > seed.get_trait(TRAIT_HIGHKPA_TOLERANCE))
		die()
		return

	if(abs(environment.temperature - seed.get_trait(TRAIT_IDEAL_HEAT)) > seed.get_trait(TRAIT_HEAT_TOLERANCE))
		die()
		return

	var/area/A = T.loc
	if(A)
		var/light_available
		if(A.lighting_use_dynamic)
			light_available = max(0,min(10,T.lighting_lumcount)-5)
		else
			light_available =  5
		if(abs(light_available - seed.get_trait(TRAIT_IDEAL_LIGHT)) > seed.get_trait(TRAIT_LIGHT_TOLERANCE))
			die()
			return

/obj/effect/plant_controller

	//What this does is that instead of having the grow minimum of 1, required to start growing, the minimum will be 0,
	//meaning if you get the spacevines' size to something less than 20 plots, it won't grow anymore.

	var/list/obj/effect/plantsegment/vines = list()
	var/list/growth_queue = list()
	var/reached_collapse_size
	var/reached_slowdown_size
	var/datum/seed/seed

	var/collapse_limit = 250
	var/slowdown_limit = 30
	var/limited_growth = 0

/obj/effect/plant_controller/creeper
	collapse_limit = 6
	slowdown_limit = 3
	limited_growth = 1

/obj/effect/plant_controller/New()
	if(!istype(src.loc,/turf/simulated/floor))
		del(src)

	spawn(0)
		spawn_piece(src.loc)

	processing_objects.Add(src)

/obj/effect/plant_controller/Del()
	processing_objects.Remove(src)
	..()

/obj/effect/plant_controller/proc/spawn_piece(var/turf/location)
	var/obj/effect/plantsegment/SV = new(location)
	SV.limited_growth = src.limited_growth
	growth_queue += SV
	vines += SV
	SV.master = src
	if(seed)
		SV.seed = seed
		SV.name = "[seed.seed_name] vines"
		SV.update()

/obj/effect/plant_controller/process()

	// Space vines exterminated. Remove the controller
	if(!vines)
		del(src)
		return

	// Sanity check.
	if(!growth_queue)
		del(src)
		return

	// Check if we're too big for our own good.
	if(vines.len >= (seed?seed.get_trait(TRAIT_POTENCY)*collapse_limit : 250)&&!reached_collapse_size)
		reached_collapse_size = 1
	if(vines.len >= (seed?seed.get_trait(TRAIT_POTENCY)*slowdown_limit : 30)&&!reached_slowdown_size)
		reached_slowdown_size = 1

	var/length = 0
	if(reached_collapse_size)
		length = 0
	else if(reached_slowdown_size)
		if(prob(seed ? seed.get_trait(TRAIT_POTENCY) : 25))
			length = 1
		else
			length = 0
	else
		length = 1

	length = min(30, max(length, vines.len/5))

	// Update as many pieces of vine as we're allowed to.
	// Append updated vines to the end of the growth queue.
	var/i = 0
	var/list/obj/effect/plantsegment/queue_end = list()
	for(var/obj/effect/plantsegment/SV in growth_queue)
		i++
		queue_end += SV
		growth_queue -= SV

		SV.life()

		if(!SV) continue

		if(SV.energy < 2) //If tile isn't fully grown
			var/chance
			if(seed)
				chance = limited_growth ? round(seed.get_trait(TRAIT_POTENCY)/2,1) : seed.get_trait(TRAIT_POTENCY)
			else
				chance = 20

			if(prob(chance))
				SV.grow()

		else if(!seed || !limited_growth) //If tile is fully grown and not just a creeper.
			SV.entangle_mob()

		SV.update()
		SV.spread()
		if(i >= length)
			break

	growth_queue = growth_queue + queue_end