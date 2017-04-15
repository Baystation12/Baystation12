/obj/structure/blob
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

	var/max_health = 50
	var/health
	var/regen_rate = 4

/obj/structure/blob/ex_act(var/severity)
	switch(severity)
		if(1)
			take_damage(rand(100, 120))
		if(2)
			take_damage(rand(60, 100))
		if(3)
			take_damage(rand(20, 60))

/obj/structure/blob/update_icon()
	if(health > max_health / 2)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/structure/blob/proc/take_damage(var/damage)
	health -= damage
	if(health < 0)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
	else
		update_icon()

/obj/structure/blob/proc/regen()
	health = min(health + regen_rate, max_health)
	update_icon()

/obj/structure/blob/proc/try_expand(var/turf/T)
	if(istype(T, /turf/unsimulated/) || istype(T, /turf/space) || (istype(T, /turf/simulated/mineral) && T.density))
		return 0
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/SW = T
		SW.take_damage(80)
		return 0
	var/obj/structure/girder/G = locate() in T
	if(G)
		if(prob(40))
			G.dismantle()
		return 0
	var/obj/structure/window/W = locate() in T
	if(W)
		W.shatter()
		return 0
	var/obj/structure/grille/GR = locate() in T
	if(GR)
		qdel(GR)
		return 0
	for(var/obj/machinery/door/D in T) // There can be several - and some of them can be open, locate() is not suitable
		if(D.density)
			D.ex_act(2)
			return 0
	var/obj/structure/foamedmetal/F = locate() in T
	if(F)
		qdel(F)
		return 0
	var/obj/structure/inflatable/I = locate() in T
	if(I)
		I.deflate(1)
		return 0

	var/obj/vehicle/V = locate() in T
	if(V)
		V.ex_act(2)
		return 0
	var/obj/mecha/M = locate() in T
	if(M)
		M.visible_message("<span class='danger'>The blob attacks \the [M]!</span>")
		M.take_damage(40)
		return 0

	// Above things, we destroy completely and thus can use locate. Mobs are different.
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		attack_mob(L)
		return 0
	return 1

/obj/structure/blob/proc/attack_mob(var/mob/living/L)
	L.visible_message("<span class='danger'>The blob attacks \the [L]!</span>", "<span class='danger'>The blob attacks you!</span>")
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	var/armor = L.run_armor_check(BP_CHEST, "melee") // TODO: proper mob rewrite
	L.apply_damage(30, BRUTE, BP_CHEST, armor, 0, src)

/obj/structure/blob/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	switch(Proj.damage_type)
		if(BRUTE)
			take_damage(Proj.damage)
		if(BURN)
			take_damage(Proj.damage / BLOB_LASER_RESIST)
	return 0

/obj/structure/blob/attackby(var/obj/item/weapon/W, var/mob/user)
	if(!W.force)
		return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	take_damage(W.force)
	return

/obj/structure/blob/proc/get_strength()
	return 0

/obj/structure/blob/proc/factorable()
	if(health < max_health)
		return 0
	if(locate(/obj/structure/blob/core) in range(BLOB_FACTORY_CORE_DIST, src))
		return 0
	if(locate(/obj/structure/blob/factory) in range(BLOB_FACTORY_FACTORY_DIST, src))
		return 0
	for(var/i in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		if(!(locate(/obj/structure/blob) in get_step(src, i)))
			return 0
	return 1

/obj/structure/blob/proc/shieldable()
	if(health < max_health)
		return 0
	
	return (!!(locate(/obj/structure/blob/core) in range(1, src)) || !!(locate(/obj/structure/blob/factory) in range(1, src)))
