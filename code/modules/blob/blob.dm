// Types that blobs should not be allowed to attack. Primarily for gameplay reasons - No explosions or hellgas leaks for example.
#define BLOB_BANNED_TARGET_TYPES list(\
	/obj/machinery/portable_atmospherics,\
	/obj/structure/reagent_dispensers/fueltank\
)


/obj/effect/blob
	name = "pulsating mass"
	desc = "A pulsating mass of interwoven tendrils."
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob"
	light_outer_range = 2
	light_color = BLOB_COLOR_PULS
	density = TRUE
	opacity = 1
	anchored = TRUE
	mouse_opacity = 2

	layer = BLOB_SHIELD_LAYER

	health_max = 30
	health_resistances = list(
		DAMAGE_BRUTE     = 0.23,
		DAMAGE_BURN      = 1.24,
		DAMAGE_FIRE      = 1.24,
		DAMAGE_EXPLODE   = 0.23,
		DAMAGE_STUN      = 0,
		DAMAGE_EMP       = 0,
		DAMAGE_RADIATION = 0,
		DAMAGE_BIO       = 0,
		DAMAGE_PAIN      = 0,
		DAMAGE_TOXIN     = 0,
		DAMAGE_GENETIC   = 0,
		DAMAGE_OXY       = 0,
		DAMAGE_BRAIN     = 0
	)
	damage_hitsound = 'sound/effects/attackblob.ogg'

	var/regen_rate = 5
	var/laser_resist = 2	// Special resist for laser based weapons - Emitters or handheld energy weaponry. Damage is divided by this and THEN by fire_resist.
	var/expandType = /obj/effect/blob
	var/secondary_core_growth_chance = 5 //% chance to grow a secondary blob core instead of whatever was suposed to grown. Secondary cores are considerably weaker, but still nasty.
	var/damage_min = 15
	var/damage_max = 30
	var/pruned = FALSE
	var/product = /obj/item/blob_tendril
	var/attack_freq = 5 //see proc/attempt_attack; lower is more often, min 1

/obj/effect/blob/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/blob/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/blob/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	if(air_group || height == 0)
		return 1
	return 0

/obj/effect/blob/on_update_icon()
	switch (get_damage_percentage())
		if (0 to 49)
			icon_state = "blob"
		else
			icon_state = "blob_damaged"

/obj/effect/blob/Process(wait, times_fired)
	regen()
	if(times_fired % attack_freq)
		return
	attempt_attack(GLOB.alldirs)

/obj/effect/blob/handle_death_change(new_death_state)
	. = ..()
	if (new_death_state)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)

/obj/effect/blob/post_health_change(health_mod, damage_type)
	update_icon()

/obj/effect/blob/proc/regen()
	restore_health(regen_rate)


/obj/effect/blob/proc/expand(turf/T)
	if (!istype(T) || T.turf_flags & TURF_DISALLOW_BLOB)
		return

	var/damage = rand(damage_min, damage_max)
	var/damage_type = pick(DAMAGE_BRUTE, DAMAGE_BURN)

	if (T.density && T.is_alive())
		visible_message(SPAN_DANGER("A tendril flies out from \the [src] and smashes into \the [T]!"))
		playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		T.damage_health(damage)
		return

	for (var/obj/machinery/door/D in T)
		if (D.density)
			if (D.is_broken())
				D.open(TRUE)
				return
			playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
			D.take_damage(damage)
			return

	var/obj/structure/foamedmetal/F = locate() in T
	if (F)
		qdel(F)
		return

	var/obj/machinery/camera/CA = locate() in T
	if (CA && !CA.is_broken())
		playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		CA.take_damage(30)
		return

	var/sound_played

	for(var/mob/living/L in T)
		if (L.stat == DEAD)
			continue
		if (!sound_played)
			playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
			sound_played = TRUE
		attack_living(L)

	// If any atoms on the turf are dense, we should stop after the loop. This allows the blob to hit everything while stopping it from expanding onto the tile.
	var/density_check = FALSE
	for (var/atom/A in T)
		if (A.can_damage_health(damage, damage_type) && !(A.type in BLOB_BANNED_TARGET_TYPES))
			visible_message(SPAN_DANGER("A tendril flies out from \the [src] and smashes into \the [A]!"))
			if (!sound_played)
				playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
			A.damage_health(damage, damage_type)
		if (A.density)
			density_check = TRUE

	if (density_check)
		return

	if (!(locate(/obj/effect/blob/core) in range(T, 2)) && prob(secondary_core_growth_chance))
		new /obj/effect/blob/core/secondary (T)
	else
		new expandType(T, min(get_current_health(), 30))


/obj/effect/blob/proc/pulse(var/forceLeft, var/list/dirs)
	sleep(4)
	var/pushDir = pick(dirs)
	var/turf/T = get_step(src, pushDir)
	var/obj/effect/blob/B = (locate() in T)
	if(!B)
		if(prob(get_current_health()))
			expand(T)
		return
	if(forceLeft)
		B.pulse(forceLeft - 1, dirs)

/obj/effect/blob/proc/attack_living(var/mob/living/L)
	if(!L)
		return
	var/blob_damage = pick(DAMAGE_BRUTE, DAMAGE_BURN)
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

/obj/effect/blob/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return
	var/damage = Proj.damage
	if (Proj.damage_type == DAMAGE_BURN)
		damage = round(damage / laser_resist)
	playsound(damage_hitsound, src, 75)
	damage_health(damage, Proj.damage_type)
	return 0

/obj/effect/blob/attackby(obj/item/W, mob/user)
	if (user.a_intent == I_HURT)
		if(isWelder(W))
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)
		..()
		return

	if (isWirecutter(W))
		if(prob(user.skill_fail_chance(SKILL_SCIENCE, 90, SKILL_EXPERT)))
			to_chat(user, SPAN_WARNING("You fail to collect a sample from \the [src]."))
		else
			if(!pruned)
				to_chat(user, SPAN_NOTICE("You collect a sample from \the [src]."))
				new product(user.loc)
				pruned = TRUE
			else
				to_chat(user, SPAN_WARNING("\The [src] has already been pruned."))
		return

	..()

/obj/effect/blob/core
	name = "master nucleus"
	desc = "A massive, fragile nucleus guarded by a shield of thick tendrils."
	icon_state = "blob_core"
	damage_min = 30
	damage_max = 40
	expandType = /obj/effect/blob/shield
	product = /obj/item/blob_tendril/core
	health_max = 450

	light_color = BLOB_COLOR_CORE
	layer = BLOB_CORE_LAYER

	var/growth_range = 8 // Maximal distance for new blob pieces from this core.
	var/blob_may_process = 1
	var/reported_low_damage = FALSE
	var/times_to_pulse = 0

	/// Health state tracker to prevent redundant var updates in `process_core_health()
	var/core_health_state = null

/*
the master core becomes more vulnereable to damage as it weakens,
but it also becomes more aggressive, and channels more of its energy into regenerating rather than spreading
regen() will cover update_icon() for this proc
*/
/obj/effect/blob/core/proc/process_core_health()
	switch (get_damage_percentage())
		if (0 to 24)
			if (core_health_state == 4)
				return
			core_health_state = 4
			set_damage_resistance(DAMAGE_BRUTE, 0.29)
			set_damage_resistance(DAMAGE_EXPLODE, 0.29)
			set_damage_resistance(DAMAGE_BURN, 0.5)
			set_damage_resistance(DAMAGE_FIRE, 0.5)
			attack_freq = 5
			regen_rate = 2
			times_to_pulse = 4
			if(reported_low_damage)
				report_shield_status("high")
		if (25 to 49)
			if (core_health_state == 3)
				return
			core_health_state = 3
			set_damage_resistance(DAMAGE_BRUTE, 0.4)
			set_damage_resistance(DAMAGE_EXPLODE, 0.4)
			set_damage_resistance(DAMAGE_BURN, 0.67)
			set_damage_resistance(DAMAGE_FIRE, 0.67)
			attack_freq = 4
			regen_rate = 3
			times_to_pulse = 3
		if (35 to 74)
			if (core_health_state == 2)
				return
			core_health_state = 2
			remove_damage_resistance(DAMAGE_BRUTE)
			remove_damage_resistance(DAMAGE_EXPLODE)
			set_damage_resistance(DAMAGE_BURN, 1.25)
			set_damage_resistance(DAMAGE_FIRE, 1.25)
			attack_freq = 3
			regen_rate = 4
			times_to_pulse = 2
		else
			if (core_health_state == 1)
				return
			core_health_state = 1
			set_damage_resistance(DAMAGE_BRUTE, 2)
			set_damage_resistance(DAMAGE_EXPLODE, 2)
			set_damage_resistance(DAMAGE_BURN, 6.67)
			set_damage_resistance(DAMAGE_FIRE, 6.67)
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
	switch (get_damage_percentage())
		if(0 to 32)
			icon_state = "blob_core"
		if(33 to 65)
			icon_state = "blob_node"
		else
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
	regen_rate = 1
	growth_range = 4
	damage_min = 15
	damage_max = 20
	layer = BLOB_NODE_LAYER
	product = /obj/item/blob_tendril/core/aux
	times_to_pulse = 4
	health_max = 125

/obj/effect/blob/core/secondary/process_core_health()
	return

/obj/effect/blob/core/secondary/on_update_icon()
	switch (get_damage_percentage())
		if (0 to 49)
			icon_state = "blob_node"
		else
			icon_state = "blob_factory"

/obj/effect/blob/shield
	name = "shielding mass"
	desc = "A pulsating mass of interwoven tendrils. These seem particularly robust, but not quite as active."
	icon_state = "blob_idle"
	damage_min = 13
	damage_max = 25
	attack_freq = 7
	regen_rate = 4
	expandType = /obj/effect/blob/ravaging
	light_color = BLOB_COLOR_SHIELD
	health_max = 120

/obj/effect/blob/shield/New()
	..()
	update_nearby_tiles()

/obj/effect/blob/shield/Destroy()
	set_density(0)
	update_nearby_tiles()
	..()

/obj/effect/blob/shield/on_update_icon()
	switch (get_damage_percentage())
		if (0 to 32)
			icon_state = "blob_idle"
		if (33 to 65)
			icon_state = "blob"
		else
			icon_state = "blob_damaged"

/obj/effect/blob/shield/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	return !density

/obj/effect/blob/ravaging
	name = "ravaging mass"
	desc = "A mass of interwoven tendrils. They thrash around haphazardly at anything in reach."
	damage_min = 27
	damage_max = 36
	attack_freq = 3
	light_color = BLOB_COLOR_RAV
	color = "#ffd400" //Temporary, for until they get a new sprite.
	health_max = 20

//produce
/obj/item/blob_tendril
	name = "asteroclast tendril"
	desc = "A tendril removed from an asteroclast. It's entirely lifeless."
	icon = 'icons/mob/blob.dmi'
	icon_state = "tendril"
	item_state = "blob_tendril"
	w_class = ITEM_SIZE_LARGE
	attack_verb = list("smacked", "smashed", "whipped")
	var/is_tendril = TRUE
	var/types_of_tendril = list("solid", "fire")

/obj/item/blob_tendril/Initialize()
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
				damtype = DAMAGE_BURN
				force = 15
				color = COLOR_AMBER
				origin_tech = list(TECH_POWER = 2)

/obj/item/blob_tendril/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return
	if(is_tendril && prob(50))
		force--
		if(force <= 0)
			visible_message(SPAN_NOTICE("\The [src] crumbles apart!"))
			user.drop_from_inventory(src)
			new /obj/effect/decal/cleanable/ash(src.loc)
			qdel(src)

/obj/item/blob_tendril/core
	name = "asteroclast nucleus sample"
	desc = "A sample taken from an asteroclast's nucleus. It pulses with energy."
	icon_state = "core_sample"
	item_state = "blob_core"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 5, TECH_BIO = 7)
	is_tendril = FALSE

/obj/item/blob_tendril/core/aux
	name = "asteroclast auxiliary nucleus sample"
	desc = "A sample taken from an asteroclast's auxiliary nucleus."
	icon_state = "core_sample_2"
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 3, TECH_BIO = 4)


#undef BLOB_BANNED_TARGET_TYPES
