/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 0
	damage_type = BURN
	damage_flags = 0
	nodamage = 1
	var/heavy_effect_range = 1
	var/light_effect_range = 2

	on_impact(var/atom/A)
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
	damage_flags = DAM_BULLET | DAM_SHARP | DAM_EDGE

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	fire_sound = 'sound/weapons/pulse3.ogg'
	damage = 0
	damage_type = BURN
	damage_flags = 0
	nodamage = 1
	var/firing_temperature = 300

	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = firing_temperature
		return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1

	Bump(atom/A as mob|obj|turf|area)
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
	damage_type = TOX
	nodamage = 1

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/living/M = target
		if(ishuman(target))
			var/mob/living/carbon/human/H = M
			if((H.species.species_flags & SPECIES_FLAG_IS_PLANT) && (H.nutrition < 500))
				if(prob(15))
					H.apply_damage((rand(30,80)),IRRADIATE, damage_flags = DAM_DISPERSED)
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
		else if(istype(target, /mob/living/carbon/))
			M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		else
			return 1

/obj/item/projectile/energy/floramut/gene
	name = "gamma somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1
	var/decl/plantgene/gene = null

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
		if(ishuman(target)) //These rays make plantmen fat.
			var/mob/living/carbon/human/H = M
			if((H.species.species_flags & SPECIES_FLAG_IS_PLANT) && (H.nutrition < 500))
				H.adjust_nutrition(30)
		else if (istype(target, /mob/living/carbon/))
			M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		else
			return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.confused += rand(5,8)

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope
	nodamage = 1
	damage_type = PAIN
	damage_flags = 0
	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/venom
	name = "venom bolt"
	icon_state = "venom"
	damage = 5 //most damage is in the reagent
	damage_type = TOX
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


/obj/item/projectile/sonic
	name = "sonic pulse"
	icon_state = "sound"
	fire_sound = 'sound/effects/basscannon.ogg'
	damage = 5
	armor_penetration = 40
	damage_type = BRUTE
	vacuum_traversal = 0
	penetration_modifier = 0.2
	penetrating = 1

/obj/item/projectile/sonic/weak
	agony = 70

/obj/item/projectile/sonic/strong
	damage = 20
	penetrating = 1

obj/item/projectile/sonic/strong/proc/bang(var/mob/living/carbon/M)
	to_chat(M, "<span class='danger'>You hear a loud roar.</span>")
	var/ear_safety = 0
	var/mob/living/carbon/human/H = M
	if(iscarbon(M))
		if(ishuman(M))
			if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(MUTATION_HULK in M.mutations)
				ear_safety += 1
			if(istype(H.head, /obj/item/clothing/head/helmet))
				ear_safety += 1
		if(ear_safety == 1)
			M.make_dizzy(60)
		else if (ear_safety > 1)
			M.make_dizzy(10)
		else if (!ear_safety)
			M.make_dizzy(120)
			M.ear_damage += rand(1, 10)
			M.ear_deaf = max(M.ear_deaf,15)
		if (M.ear_damage >= 15)
			to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
			if (prob(M.ear_damage - 5))
				to_chat(M, "<span class='danger'>You can't hear anything!</span>")
				M.set_sdisability(DEAF)
		else
			if (M.ear_damage >= 5)
				to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
		M.update_icons()

/obj/item/projectile/sonic/strong/on_hit(var/atom/movable/target, var/blocked = 0)
	if(ismob(target))
		var/throwdir = get_dir(firer,target)
		target.throw_at(get_edge_target_turf(target, throwdir), rand(1,5), 6)
		bang(target)
		return 1
