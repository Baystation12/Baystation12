////Lasertag ED////////

/mob/living/bot/secbot/ed209/tag
	var/lasercolor

/mob/living/bot/secbot/ed209/tag/New(var/new_loc,var/name,var/color)
	lasercolor = color
	if(color == "r")
		projectile_type = /obj/item/projectile/beam/lastertag/red
		name = "ED-209 Redtag Robot"
		desc = "A red lasertag robot. He looks quite thrilled."
		icon_state = "red2090"
	if(color == "b")
		projectile_type = /obj/item/projectile/beam/lastertag/blue
		name = "ED-209 Blutag Robot"
		desc = "A blue lasertag robot. He looks quite thrilled."
		icon_state = "bed2090"
	..(new_loc,name)

/mob/living/bot/secbot/ed209/tag/update_icons()
	if(on && is_attacking)
		icon_state = "[lasercolor]ed209-c"
	else
		icon_state = "[lasercolor]ed209[on]"

/mob/living/bot/secbot/ed209/tag/explode()
	visible_message("<span class='warning'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/weapon/secbot_assembly/ed209_assembly(Tsec)
	var/obj/item/weapon/gun/energy/lasertag/G
	if(lasercolor == "r")
		G = new /obj/item/weapon/gun/energy/lasertag/red(Tsec)
	else if(lasercolor == "b")
		G = new /obj/item/weapon/gun/energy/lasertag/blue(Tsec)
	else G = new /obj/item/weapon/gun/energy/lasertag(Tsec)
	G.power_supply.charge = 0
	if(prob(50))
		new /obj/item/robot_parts/l_leg(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/r_leg(Tsec)
	new /obj/item/clothing/head/soft/grey(Tsec)
	if(lasercolor == "b")
		new /obj/item/clothing/suit/bluetag(Tsec)
	if(lasercolor == "r")
		new /obj/item/clothing/suit/redtag(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(Tsec)
	qdel(src)

/mob/living/bot/secbot/ed209/tag/RangedAttack(var/atom/A)
	var/projectile = /obj/item/projectile/beam/lastertag/omni
	if(last_shot + shot_delay > world.time)
		src << "You are not ready to fire yet!"
		return

	if(lasercolor == "r" )
		projectile = /obj/item/projectile/beam/lastertag/red
	if(lasercolor == "b" )
		projectile = /obj/item/projectile/beam/lastertag/blue
	last_shot = world.time
	var/turf/T = get_turf(src)
	var/turf/U = get_turf(A)
	if(emagged)
		projectile = /obj/item/projectile/beam

	playsound(loc, emagged ? 'sound/weapons/Laser.ogg' : 'sound/weapons/Taser.ogg', 50, 1)
	var/obj/item/projectile/P = new projectile(loc)

	P.original = A
	P.starting = T
	P.current = T
	P.yo = U.y - T.y
	P.xo = U.x - T.x
	spawn()
		P.process()
	return

/mob/living/bot/secbot/ed209/tag/UnarmedAttack(var/mob/M, var/proximity)
	if(!istype(M))
		return

	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		var/cuff = 1
		if(istype(C, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			if(istype(H.back, /obj/item/weapon/rig) && istype(H.gloves,/obj/item/clothing/gloves/rig))
				cuff = 0
		if(!C.lying || C.handcuffed || arrest_type)
			cuff = 0
		if(!cuff)
			C.stun_effect_act(0, 60, null)
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			do_attack_animation(C)
			is_attacking = 1
			update_icons()
			spawn(2)
				is_attacking = 0
				update_icons()
			visible_message("<span class='warning'>[C] was tagged by [src] with a tag baton!</span>")
		else
			playsound(loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
			visible_message("<span class='warning'>[src] is trying to put zipties on [C]!</span>")
			if(do_mob(src, C, 60))
				if(!C.handcuffed)
					if(lasercolor == "r")
						C.handcuffed = new /obj/item/weapon/handcuffs/cable/red(C)
					if(lasercolor == "b")
						C.handcuffed = new /obj/item/weapon/handcuffs/cable/blue(C)
					else
						C.handcuffed = new /obj/item/weapon/handcuffs/cable/pink(C)
					C.update_inv_handcuffed()
				if(preparing_arrest_sounds.len)
					playsound(loc, pick(preparing_arrest_sounds), 50, 0)
	else if(istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/S = M
		S.AdjustStunned(10)
		S.adjustBruteLoss(15)
		do_attack_animation(M)
		playsound(loc, "swing_hit", 50, 1, -1)
		is_attacking = 1
		update_icons()
		spawn(2)
			is_attacking = 0
			update_icons()
		visible_message("<span class='warning'>[M] was beaten by [src] with a tag baton!</span>")

#define SECBOT_HUNT 		1

/mob/living/bot/secbot/ed209/tag/scan_view()
	for(var/mob/living/M in view(7, src))
		if(M.invisibility >= INVISIBILITY_LEVEL_ONE)
			continue
		if(M.stat)
			continue

		var/threat = check_threat(M)

		if(threat >= 4)
			target = M
			say("Level [threat] hostile soldier detected!")
			custom_emote(1, "turns to face [M.name]!")
			mode = SECBOT_HUNT
			break
	return

/mob/living/bot/secbot/ed209/tag/check_threat(var/mob/living/M)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	if(lasercolor == "b")
		if(istype(H.wear_suit, /obj/item/clothing/suit/redtag))
			if(H.handcuffed)
				return 1
			else
				return 10
	if(lasercolor == "r")
		if(istype(H.wear_suit, /obj/item/clothing/suit/bluetag))
			if(H.handcuffed)
				return 1
			else
				return 10
	if(lasercolor == "o")
		if(istype(H.wear_suit, /obj/item/clothing/suit/redtag) || istype(H.wear_suit, /obj/item/clothing/suit/bluetag))
			if(H.handcuffed)
				return 1
			else
				return 10
	else
		return 0

////Lasertag End////////////