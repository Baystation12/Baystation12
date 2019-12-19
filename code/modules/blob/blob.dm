/obj/effect/blob
	name = "pulsating mass"
	desc = "A pulsating mass of interwoven tendrils."
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob"
	light_outer_range = 2
	light_color = BLOB_COLOR_PULS
	density = 1
	opacity = 1
	anchored = 1
	mouse_opacity = 2

	layer = BLOB_SHIELD_LAYER

	var/maxHealth = 30
	var/health
	var/regen_rate = 5
	var/brute_resist = 4.3
	var/fire_resist = 0.8
	var/laser_resist = 2	// Special resist for laser based weapons - Emitters or handheld energy weaponry. Damage is divided by this and THEN by fire_resist.
	var/expandType = /obj/effect/blob
	var/secondary_core_growth_chance = 5 //% chance to grow a secondary blob core instead of whatever was suposed to grown. Secondary cores are considerably weaker, but still nasty.
	var/damage_min = 15
	var/damage_max = 30
	var/pruned = FALSE
	var/product = /obj/item/weapon/blob_tendril
	var/attack_freq = 5 //see proc/attempt_attack; lower is more often, min 1

/obj/effect/blob/New(loc)
	health = maxHealth
	update_icon()
	return ..(loc)

/obj/effect/blob/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/blob/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	if(air_group || height == 0)
		return 1
	return 0

/obj/effect/blob/ex_act(var/severity)
	switch(severity)
		if(1)
			take_damage(rand(100, 120) / brute_resist)
		if(2)
			take_damage(rand(60, 100) / brute_resist)
		if(3)
			take_damage(rand(20, 60) / brute_resist)

/obj/effect/blob/on_update_icon()
	if(health > maxHealth / 2)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/Process(wait, times_fired)
	regen()
	if(times_fired % attack_freq)
		return
	attempt_attack(GLOB.alldirs)

/obj/effect/blob/proc/take_damage(var/damage)
	health -= damage
	if(health < 0)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
	else
		update_icon()

/obj/effect/blob/proc/regen()
	health = min(health + regen_rate, maxHealth)
	update_icon()

/obj/effect/blob/proc/expand(var/turf/T)
	if(istype(T, /turf/unsimulated/) || istype(T, /turf/space) || (istype(T, /turf/simulated/mineral) && T.density))
		return
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/SW = T
		SW.take_damage(80)
		return
	var/obj/structure/girder/G = locate() in T
	if(G)
		if(prob(40))
			G.dismantle()
		return
	var/obj/structure/window/W = locate() in T
	if(W)
		W.shatter()
		return
	var/obj/structure/grille/GR = locate() in T
	if(GR)
		qdel(GR)
		return
	for(var/obj/machinery/door/D in T) // There can be several - and some of them can be open, locate() is not suitable
		if(D.density)
			D.ex_act(2)
			return
	var/obj/structure/foamedmetal/F = locate() in T
	if(F)
		qdel(F)
		return
	var/obj/structure/inflatable/I = locate() in T
	if(I)
		I.deflate(1)
		return

	var/obj/vehicle/V = locate() in T
	if(V)
		V.ex_act(2)
		return
	var/obj/machinery/camera/CA = locate() in T
	if(CA)
		CA.take_damage(30)
		return

	// Above things, we destroy completely and thus can use locate. Mobs are different.
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		attack_living(L)

	if(!(locate(/obj/effect/blob/core) in range(T, 2)) && prob(secondary_core_growth_chance))
		new/obj/effect/blob/core/secondary(T)
	else
		new expandType(T, min(health, 30))

/obj/effect/blob/proc/pulse(var/forceLeft, var/list/dirs)
	sleep(4)
	var/pushDir = pick(dirs)
	var/turf/T = get_step(src, pushDir)
	var/obj/effect/blob/B = (locate() in T)
	if(!B)
		if(prob(health))
			expand(T)
		return
	if(forceLeft)
		B.pulse(forceLeft - 1, dirs)

/obj/effect/blob/proc/attack_living(var/mob/living/L)
	if(!L)
		return
	var/blob_damage = pick(BRUTE, BURN)
	L.visible_message(SPAN_DANGER("A tendril flies out from \the [src] and smashes into \the [L]!"), SPAN_DANGER("A tendril flies out from \the [src] and smashes into you!"))
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	L.apply_damage(rand(damage_min, damage_max), blob_damage, used_weapon = "blob tendril")

/obj/effect/blob/proc/attempt_attack(var/list/dirs)
	var/attackDir = pick(dirs)
	var/turf/T = get_step(src, attackDir)
	for(var/mob/living/victim in T)
		if(victim.stat == DEAD)
			continue
		attack_living(victim)

/obj/effect/blob/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	switch(Proj.damage_type)
		if(BRUTE)
			take_damage(Proj.damage / brute_resist)
		if(BURN)
			take_damage((Proj.damage / laser_resist) / fire_resist)
	return 0

/obj/effect/blob/attackby(var/obj/item/weapon/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	if(isWirecutter(W))
		if(prob(user.skill_fail_chance(SKILL_SCIENCE, 90, SKILL_EXPERT)))
			to_chat(user, SPAN_WARNING("You fail to collect a sample from \the [src]."))
			return
		else
			if(!pruned)
				to_chat(user, SPAN_NOTICE("You collect a sample from \the [src]."))
				new product(user.loc)
				pruned = TRUE
				return
			else
				to_chat(user, SPAN_WARNING("\The [src] has already been pruned."))
				return

	var/damage = 0
	switch(W.damtype)
		if("fire")
			damage = (W.force / fire_resist)
			if(isWelder(W))
				playsound(loc, 'sound/items/Welder.ogg', 100, 1)
		if("brute")
			damage = (W.force / brute_resist)

	take_damage(damage)
	return

/obj/effect/blob/core
	name = "master nucleus"
	desc = "A massive, fragile nucleus guarded by a shield of thick tendrils."
	icon_state = "blob_core"
	maxHealth = 450
	damage_min = 30
	damage_max = 40
	expandType = /obj/effect/blob/shield
	product = /obj/item/weapon/blob_tendril/core

	light_color = BLOB_COLOR_CORE
	layer = BLOB_CORE_LAYER

	var/growth_range = 8 // Maximal distance for new blob pieces from this core.
	var/blob_may_process = 1
	var/reported_low_damage = FALSE
	var/times_to_pulse = 0

/obj/effect/blob/core/proc/get_health_percent()
	return ((health / maxHealth) * 100)

/*
the master core becomes more vulnereable to damage as it weakens,
but it also becomes more aggressive, and channels more of its energy into regenerating rather than spreading
regen() will cover update_icon() for this proc
*/
/obj/effect/blob/core/proc/process_core_health() 
	switch(get_health_percent())
		if(75 to INFINITY)
			brute_resist = 3.5
			fire_resist = 2
			attack_freq = 5
			regen_rate = 2
			times_to_pulse = 4
			if(reported_low_damage)
				report_shield_status("high")
		if(50 to 74)
			brute_resist = 2.5
			fire_resist = 1.5
			attack_freq = 4
			regen_rate = 3
			times_to_pulse = 3
		if(34 to 49)
			brute_resist = 1
			fire_resist = 0.8
			attack_freq = 3
			regen_rate = 4
			times_to_pulse = 2
		if(-INFINITY to 33)
			brute_resist = 0.5
			fire_resist = 0.3
			regen_rate = 5
			times_to_pulse = 1
			if(!reported_low_damage)
				report_shield_status("low")

/obj/effect/blob/core/proc/report_shield_status(var/status)
	if(status == "low")
		visible_message(SPAN_DANGER("The [src]'s tendril shield fails, leaving the nucleus vulnerable!"), 3)
		reported_low_damage = TRUE
	if(status == "high")
		visible_message(SPAN_NOTICE("The [src]'s tendril shield seems to have fully reformed."), 3)
		reported_low_damage = FALSE

// Rough icon state changes that reflect the core's health
/obj/effect/blob/core/on_update_icon()
	switch(get_health_percent())
		if(66 to INFINITY)
			icon_state = "blob_core"
		if(33 to 66)
			icon_state = "blob_node"
		if(-INFINITY to 33)
			icon_state = "blob_factory"

/obj/effect/blob/core/Process()
	set waitfor = 0
	if(!blob_may_process)
		return
	blob_may_process = 0
	sleep(0)
	process_core_health()
	regen()
	for(var/I in 1 to times_to_pulse)
		pulse(20, GLOB.alldirs)
	attempt_attack(GLOB.alldirs)
	attempt_attack(GLOB.alldirs)
	blob_may_process = 1

// Blob has a very small probability of growing these when spreading. These will spread the blob further.
/obj/effect/blob/core/secondary
	name = "auxiliary nucleus"
	desc = "An interwoven mass of tendrils. A glowing nucleus pulses at its center."
	icon_state = "blob_node"
	maxHealth = 125
	regen_rate = 1
	growth_range = 4
	damage_min = 15
	damage_max = 20
	layer = BLOB_NODE_LAYER
	product = /obj/item/weapon/blob_tendril/core/aux
	times_to_pulse = 4

/obj/effect/blob/core/secondary/process_core_health()
	return

/obj/effect/blob/core/secondary/on_update_icon()
	icon_state = (health / maxHealth >= 0.5) ? "blob_node" : "blob_factory"

/obj/effect/blob/shield
	name = "shielding mass"
	desc = "A pulsating mass of interwoven tendrils. These seem particularly robust, but not quite as active."
	icon_state = "blob_idle"
	maxHealth = 120
	damage_min = 13
	damage_max = 25
	attack_freq = 7
	regen_rate = 4
	expandType = /obj/effect/blob/ravaging
	light_color = BLOB_COLOR_SHIELD

/obj/effect/blob/shield/New()
	..()
	update_nearby_tiles()

/obj/effect/blob/shield/Destroy()
	set_density(0)
	update_nearby_tiles()
	..()

/obj/effect/blob/shield/on_update_icon()
	if(health > maxHealth * 2 / 3)
		icon_state = "blob_idle"
	else if(health > maxHealth / 3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/shield/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	return !density

/obj/effect/blob/ravaging
	name = "ravaging mass"
	desc = "A mass of interwoven tendrils. They thrash around haphazardly at anything in reach."
	maxHealth = 20
	damage_min = 27
	damage_max = 36
	attack_freq = 3
	light_color = BLOB_COLOR_RAV
	color = "#ffd400" //Temporary, for until they get a new sprite.

//produce
/obj/item/weapon/blob_tendril
	name = "asteroclast tendril"
	desc = "A tendril removed from an asteroclast. It's entirely lifeless."
	icon = 'icons/mob/blob.dmi'
	icon_state = "tendril"
	item_state = "blob_tendril"
	w_class = ITEM_SIZE_LARGE
	attack_verb = list("smacked", "smashed", "whipped")
	var/is_tendril = TRUE
	var/types_of_tendril = list("solid", "fire")

/obj/item/weapon/blob_tendril/Initialize()
	. = ..()
	if(is_tendril)
		var/tendril_type
		tendril_type = pick(types_of_tendril)
		switch(tendril_type)
			if("solid")
				desc = "An incredibly dense, yet flexible, tendril, removed from an asteroclast."
				force = 10
				color = COLOR_BRONZE
				origin_tech = list(TECH_MATERIAL = 2)
			if("fire")
				desc = "A tendril removed from an asteroclast. It's hot to the touch."
				damtype = BURN
				force = 15
				color = COLOR_AMBER
				origin_tech = list(TECH_POWER = 2)

/obj/item/weapon/blob_tendril/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return
	if(is_tendril && prob(50))
		force--
		if(force <= 0)
			visible_message(SPAN_NOTICE("\The [src] crumbles apart!"))
			user.drop_from_inventory(src)
			new /obj/effect/decal/cleanable/ash(src.loc)
			qdel(src)

/obj/item/weapon/blob_tendril/core
	name = "asteroclast nucleus sample"
	desc = "A sample taken from an asteroclast's nucleus. It pulses with energy."
	icon_state = "core_sample"
	item_state = "blob_core"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 5, TECH_BIO = 7)
	is_tendril = FALSE

/obj/item/weapon/blob_tendril/core/aux
	name = "asteroclast auxiliary nucleus sample"
	desc = "A sample taken from an asteroclast's auxiliary nucleus."
	icon_state = "core_sample_2"
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 3, TECH_BIO = 4)
