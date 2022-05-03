/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 0
	damage_type = DAMAGE_BURN
	damage_flags = 0
	nodamage = TRUE
	var/heavy_effect_range = 1
	var/light_effect_range = 1

/obj/item/projectile/ion/on_impact(var/atom/A)
	empulse(A, heavy_effect_range, light_effect_range)
	return 1

/obj/item/projectile/ion/small
	name = "ion pulse"
	heavy_effect_range = 0
	light_effect_range = 1

/obj/item/projectile/ion/tiny
	heavy_effect_range = 0
	light_effect_range = 0

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	damage_flags = DAMAGE_FLAG_BULLET | DAMAGE_FLAG_SHARP | DAMAGE_FLAG_EDGE

/obj/item/projectile/bullet/gyro/on_hit(var/atom/target, var/blocked = 0)
	explosion(target, -1, 0, 2)
	return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = DAMAGE_BRUTE
	nodamage = TRUE

/obj/item/projectile/meteor/Bump(atom/A as mob|obj|turf|area, forced=0)
	if(A == firer)
		forceMove(A.loc)
		return

	sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

	if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
		if(A)

			A.ex_act(2)
			playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

			for(var/mob/M in range(10, src))
				if(!M.stat && !istype(M, /mob/living/silicon/ai))\
					shake_camera(M, 3, 1)
			qdel(src)
			return 1
	else
		return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = DAMAGE_TOXIN
	nodamage = TRUE

/obj/item/projectile/energy/floramut/on_hit(var/atom/target, var/blocked = 0)
	var/mob/living/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.species_flags & SPECIES_FLAG_IS_PLANT) && (H.nutrition < 500))
			if(prob(15))
				H.apply_damage((rand(30,80)), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
				H.Weaken(5)
				for (var/mob/V in viewers(src))
					V.show_message("<span class='warning'>[M] writhes in pain as \his vacuoles boil.</span>", 3, "<span class='warning'>You hear the crunching of leaves.</span>", 2)
			if(prob(35))
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message("<span class='danger'>The radiation beam singes you!</span>")
	else if(istype(target, /mob/living/carbon))
		M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
	else
		return 1

/obj/item/projectile/energy/floramut/gene
	name = "gamma somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = DAMAGE_TOXIN
	nodamage = TRUE
	var/decl/plantgene/gene = null

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = DAMAGE_TOXIN
	nodamage = TRUE

/obj/item/projectile/energy/florayield/on_hit(var/atom/target, var/blocked = 0)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.species_flags & SPECIES_FLAG_IS_PLANT) && (H.nutrition < 500))
			H.adjust_nutrition(30)
	else if (istype(target, /mob/living/carbon))
		M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
	else
		return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

/obj/item/projectile/beam/mindflayer/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.confused += rand(5,8)

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = FALSE // nope
	nodamage = TRUE
	damage_type = DAMAGE_PAIN
	damage_flags = 0
	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/bola
	name = "bola"
	icon_state = "bola"
	damage = 5
	embed = FALSE
	damage_type = DAMAGE_STUN
	muzzle_type = null

/obj/item/projectile/bola/on_hit(atom/target, blocked = 0)
	if (isliving(target))
		var/mob/living/M = target
		M.Weaken(3)
		M.visible_message(
			SPAN_WARNING("\The [M] is hit with a glob of webbing!"),
			SPAN_DANGER("You are hit with a glob of webbing, causing you to trip!"),
			SPAN_DANGER("Some sort of sticky substance hits you and causes you to fall over!")
		)
	..()

/obj/item/projectile/webball
	name = "ball of web"
	icon_state = "bola"
	damage = 1
	embed = FALSE
	damage_type = DAMAGE_BRUTE
	muzzle_type = null

/obj/item/projectile/webball/on_hit(atom/target, blocked = 0)
	if (isturf(target.loc))
		var/obj/effect/spider/stickyweb/W = locate() in get_turf(target)
		if (!W && prob(75))
			visible_message(SPAN_DANGER("\The [src] splatters a layer of web on \the [target]!"))
			new /obj/effect/spider/stickyweb(target.loc)

			if (isliving(target))
				var/mob/living/M = target
				var/has_webs = FALSE
				for (var/obj/aura/A in M.auras)
					if (istype(A, /obj/aura/web))
						has_webs = TRUE
						break
				if (!has_webs)
					M.add_aura(new /obj/aura/web(M))
	..()

/obj/item/projectile/venom
	name = "venom bolt"
	icon_state = "venom"
	damage = 5 //most damage is in the reagent
	damage_type = DAMAGE_TOXIN
	damage_flags = 0

/obj/item/projectile/venom/on_hit(atom/target, blocked, def_zone)
	. = ..()
	var/mob/living/L = target
	if(L.reagents)
		L.reagents.add_reagent(/datum/reagent/toxin/venom, 5)

/obj/item/missile
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	var/primed = null
	throwforce = 15

/obj/item/missile/throw_impact(atom/hit_atom)
	if(primed)
		explosion(hit_atom, 0, 1, 2, 4)
		qdel(src)
	else
		..()
	return

/obj/item/projectile/hotgas
	name = "gas vent"
	icon_state = null
	damage_type = DAMAGE_BURN
	damage_flags = 0
	life_span = 3
	silenced = TRUE

/obj/item/projectile/hotgas/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		to_chat(target, SPAN_WARNING("You feel a wave of heat wash over you!"))
		L.adjust_fire_stacks(rand(5,8))
		L.IgniteMob()
