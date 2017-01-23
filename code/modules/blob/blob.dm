//I will need to recode parts of this but I am way too tired atm
/obj/effect/blob
	name = "blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob"
	light_range = 2
	light_color = "#b5ff5b"
	desc = "Some blob creature thingy."
	density = 1
	opacity = 0
	anchored = 1
	mouse_opacity = 2

	plane = BLOB_PLANE
	layer = BLOB_SHIELD_LAYER

	var/maxHealth = 30
	var/health
	var/regen_rate = 5
	var/brute_resist = 4
	var/fire_resist = 1
	var/laser_resist = 5	// Special resist for laser based weapons - Emitters or handheld energy weaponry. Damage is divided by this and THEN by fire_resist.
	var/expandType = /obj/effect/blob
	var/secondary_core_growth_chance = 5 //% chance to grow a secondary blob core instead of whatever was suposed to grown. Secondary cores are considerably weaker, but still nasty.

/obj/effect/blob/New(loc)
	health = maxHealth
	update_icon()
	return ..(loc)

/obj/effect/blob/CanPass(var/atom/movable/mover, vra/turf/target, var/height = 0, var/air_group = 0)
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

/obj/effect/blob/update_icon()
	if(health > maxHealth / 2)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

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
	var/obj/mecha/M = locate() in T
	if(M)
		M.visible_message("<span class='danger'>The blob attacks \the [M]!</span>")
		M.take_damage(40)
		return

	// Above things, we destroy completely and thus can use locate. Mobs are different.
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		L.visible_message("<span class='danger'>The blob attacks \the [L]!</span>", "<span class='danger'>The blob attacks you!</span>")
		playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		L.take_organ_damage(rand(30, 40))
		return
	if(!(locate(/obj/effect/blob/core) in range(T, 2)) && prob(secondary_core_growth_chance))
		new/obj/effect/blob/core/secondary(T)
	else
		new expandType(T, min(health, 30))

/obj/effect/blob/proc/pulse(var/forceLeft, var/list/dirs)
	regen()
	sleep(5)
	var/pushDir = pick(dirs)
	var/turf/T = get_step(src, pushDir)
	var/obj/effect/blob/B = (locate() in T)
	if(!B)
		if(prob(health))
			expand(T)
		return
	if(forceLeft)
		B.pulse(forceLeft - 1, dirs)

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
	var/damage = 0
	switch(W.damtype)
		if("fire")
			damage = (W.force / fire_resist)
			if(istype(W, /obj/item/weapon/weldingtool))
				playsound(loc, 'sound/items/Welder.ogg', 100, 1)
		if("brute")
			damage = (W.force / brute_resist)

	take_damage(damage)
	return

/obj/effect/blob/core
	name = "blob core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_core"
	maxHealth = 200
	brute_resist = 2
	fire_resist = 2
	laser_resist = 10
	regen_rate = 2

	layer = BLOB_CORE_LAYER

	expandType = /obj/effect/blob/shield
	var/blob_may_process = 1
	var/growth_range = 10 // Maximal distance for new blob pieces from this core.

// Rough icon state changes that reflect the core's health
/obj/effect/blob/core/update_icon()
	var/health_percent = (health / maxHealth) * 100
	switch(health_percent)
		if(66 to INFINITY)
			icon_state = "blob_core"
		if(33 to 66)
			icon_state = "blob_node"
		if(-INFINITY to 33)
			icon_state = "blob_factory"

/obj/effect/blob/core/New(loc)
	processing_objects.Add(src)
	return ..(loc)

/obj/effect/blob/core/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/effect/blob/core/process()
	set waitfor = 0
	if(!blob_may_process)
		return
	blob_may_process = 0
	sleep(0)
	pulse(20, list(NORTH, EAST))
	pulse(20, list(NORTH, WEST))
	pulse(20, list(SOUTH, EAST))
	pulse(20, list(SOUTH, WEST))
	blob_may_process = 1

// Half the stats of a normal core. Blob has a very small probability of growing these when spreading. These will spread the blob further.
/obj/effect/blob/core/secondary
	name = "small blob core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_node"
	maxHealth = 100
	brute_resist = 1
	fire_resist = 1
	laser_resist = 5
	regen_rate = 1
	growth_range = 3

	layer = BLOB_NODE_LAYER

/obj/effect/blob/core/secondary/update_icon()
	icon_state = (health / maxHealth >= 0.5) ? "blob_node" : "blob_factory"

/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	desc = "Some blob creature thingy."
	maxHealth = 60
	brute_resist = 1
	fire_resist = 2
	laser_resist = 7

/obj/effect/blob/shield/New()
	..()
	update_nearby_tiles()

/obj/effect/blob/shield/Destroy()
	set_density(0)
	update_nearby_tiles()
	..()

/obj/effect/blob/shield/update_icon()
	if(health > maxHealth * 2 / 3)
		icon_state = "blob_idle"
	else if(health > maxHealth / 3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/shield/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	return !density
