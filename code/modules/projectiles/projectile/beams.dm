/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	temperature = T0C + 300
	fire_sound='sound/weapons/Laser.ogg'
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_LASER_MEAT, BULLET_IMPACT_METAL = SOUNDS_LASER_METAL)
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 40
	damage_type = DAMAGE_BURN
	sharp = TRUE
	damage_flags = DAMAGE_FLAG_LASER
	eyeblur = 4
	hitscan = TRUE
	invisibility = 101	//beam projectiles are invisible as they are rendered by the effect engine
	penetration_modifier = 0.3
	distance_falloff = 1.5
	damage_falloff = TRUE
	damage_falloff_list = list(
		list(3, 0.95),
		list(5, 0.90),
		list(7, 0.80),
	)

	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
	impact_type = /obj/effect/projectile/laser/impact

/obj/item/projectile/beam/practice
	fire_sound = 'sound/weapons/Taser.ogg'
	damage = 0
	eyeblur = 2

/obj/item/projectile/beam/smalllaser
	damage = 35
	distance_falloff = 2
	damage_falloff_list = list(
		list(3, 0.90),
		list(5, 0.80),
		list(7, 0.60),
	)

/obj/item/projectile/beam/midlaser
	damage = 40
	armor_penetration = 10
	distance_falloff = 1
	damage_falloff_list = list(
		list(4, 0.96),
		list(6, 0.92),
		list(8, 0.86),
	)

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 60
	armor_penetration = 30
	distance_falloff = 0.5
	damage_falloff_list = list(
		list(6, 0.97),
		list(9, 0.94),
		list(11, 0.88),
	)

	muzzle_type = /obj/effect/projectile/laser/heavy/muzzle
	tracer_type = /obj/effect/projectile/laser/heavy/tracer
	impact_type = /obj/effect/projectile/laser/heavy/impact

/obj/item/projectile/beam/xray
	name = "x-ray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	damage = 30
	armor_penetration = 30
	penetration_modifier = 0.8
	distance_falloff = 1.5
	damage_falloff_list = list(
		list(3, 0.95),
		list(5, 0.90),
		list(7, 0.80),
	)

	muzzle_type = /obj/effect/projectile/laser/xray/muzzle
	tracer_type = /obj/effect/projectile/laser/xray/tracer
	impact_type = /obj/effect/projectile/laser/xray/impact

/obj/item/projectile/beam/xray/midlaser
	damage = 30
	armor_penetration = 50
	distance_falloff = 1
	damage_falloff_list = list(
		list(4, 0.96),
		list(6, 0.92),
		list(8, 0.84),
	)

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	fire_sound='sound/weapons/pulse.ogg'
	damage = 15 //lower damage, but fires in bursts
	armor_penetration = 25
	distance_falloff = 1.5
	damage_falloff_list = list(
		list(3, 0.95),
		list(5, 0.90),
		list(7, 0.80),
	)

	muzzle_type = /obj/effect/projectile/laser/pulse/muzzle
	tracer_type = /obj/effect/projectile/laser/pulse/tracer
	impact_type = /obj/effect/projectile/laser/pulse/impact

/obj/item/projectile/beam/pulse/mid
	damage = 20
	armor_penetration = 30
	distance_falloff = 1
	damage_falloff_list = list(
		list(4, 0.96),
		list(6, 0.92),
		list(8, 0.84),
	)

/obj/item/projectile/beam/pulse/heavy
	damage = 25
	armor_penetration = 35
	distance_falloff = 0.5
	damage_falloff_list = list(
		list(6, 0.97),
		list(9, 0.94),
		list(11, 0.88),
	)

/obj/item/projectile/beam/pulse/destroy
	name = "destroyer pulse"
	damage = 100 //badmins be badmins I don't give a fuck
	armor_penetration = 100
	damage_falloff_list = list(
		list(6, 0.99),
		list(9, 0.98),
		list(11, 0.97),
	)

/obj/item/projectile/beam/pulse/destroy/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		target.ex_act(EX_ACT_HEAVY)
	..()

/obj/item/projectile/beam/pulse/skrell
	icon_state = "pu_laser"
	damage = 20
	muzzle_type = /obj/effect/projectile/laser/pulse/skrell/muzzle
	tracer_type = /obj/effect/projectile/laser/pulse/skrell/tracer
	impact_type = /obj/effect/projectile/laser/pulse/skrell/impact

/obj/item/projectile/beam/pulse/skrell/heavy
	damage = 30

/obj/item/projectile/beam/pulse/skrell/single
	damage = 50

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	damage = 0 // The actual damage is computed in /code/modules/power/singularity/emitter.dm

	muzzle_type = /obj/effect/projectile/laser/emitter/muzzle
	tracer_type = /obj/effect/projectile/laser/emitter/tracer
	impact_type = /obj/effect/projectile/laser/emitter/impact

/obj/item/projectile/beam/lastertag/blue
	name = "lasertag beam"
	icon_state = "bluelaser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	no_attack_log = TRUE
	damage_type = DAMAGE_BURN

	muzzle_type = /obj/effect/projectile/laser/blue/muzzle
	tracer_type = /obj/effect/projectile/laser/blue/tracer
	impact_type = /obj/effect/projectile/laser/blue/impact

/obj/item/projectile/beam/lastertag/blue/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/red
	name = "lasertag beam"
	icon_state = "laser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	no_attack_log = TRUE
	damage_type = DAMAGE_BURN

/obj/item/projectile/beam/lastertag/red/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/omni//A laser tag bolt that stuns EVERYONE
	name = "lasertag beam"
	icon_state = "omnilaser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	damage_type = DAMAGE_BURN

	muzzle_type = /obj/effect/projectile/laser/omni/muzzle
	tracer_type = /obj/effect/projectile/laser/omni/tracer
	impact_type = /obj/effect/projectile/laser/omni/impact

/obj/item/projectile/beam/lastertag/omni/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/marauder.ogg'
	damage = 50
	armor_penetration = 10
	damage_falloff_list = list(
		list(8, 0.97),
		list(12, 0.94),
		list(16, 0.88),
	)

	muzzle_type = /obj/effect/projectile/laser/xray/muzzle
	tracer_type = /obj/effect/projectile/laser/xray/tracer
	impact_type = /obj/effect/projectile/laser/xray/impact

/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	damage_flags = 0
	sharp = FALSE
	damage = 1//flavor burn! still not a laser, dmg will be reduce by energy resistance not laser resistances
	damage_type = DAMAGE_BURN
	eyeblur = 1//Some feedback that you've been hit
	agony = 40
	distance_falloff = 1.5
	damage_falloff_list = list(
		list(3, 0.95),
		list(5, 0.90),
		list(7, 0.80),
	)

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/beam/stun/smalllaser
	distance_falloff = 2
	damage_falloff_list = list(
		list(3, 0.90),
		list(5, 0.80),
		list(7, 0.60),
	)

/obj/item/projectile/beam/stun/heavy
	name = "heavy stun beam"
	damage = 2
	agony = 60
	distance_falloff = 1
	damage_falloff_list = list(
		list(5, 0.97),
		list(7, 0.94),
		list(9, 0.88),
	)

/obj/item/projectile/beam/stun/shock
	name = "shock beam"
	agony = 0
	damage = 15
	damage_type = DAMAGE_SHOCK
	fire_sound='sound/weapons/pulse.ogg'
	distance_falloff = 1.5
	damage_falloff_list = list(
		list(3, 0.95),
		list(5, 0.90),
		list(7, 0.80),
	)

/obj/item/projectile/beam/stun/shock/smalllaser
	distance_falloff = 2
	damage_falloff_list = list(
		list(3, 0.90),
		list(5, 0.80),
		list(7, 0.60),
	)

/obj/item/projectile/beam/stun/shock/heavy
	name = "heavy shock beam"
	damage = 30
	distance_falloff = 1
	damage_falloff_list = list(
		list(5, 0.97),
		list(7, 0.94),
		list(9, 0.88),
	)

/obj/item/projectile/beam/plasmacutter
	name = "plasma arc"
	icon_state = "omnilaser"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	damage = 20
	armor_penetration = 30
	edge = TRUE
	damage_type = DAMAGE_BURN
	life_span = 5
	pass_flags = PASS_FLAG_TABLE
	distance_falloff = 2
	damage_falloff_list = list(
		list(2, 0.80),
		list(3, 0.60),
		list(4, 0.40),
	)

	muzzle_type = /obj/effect/projectile/trilaser/muzzle
	tracer_type = /obj/effect/projectile/trilaser/tracer
	impact_type = /obj/effect/projectile/trilaser/impact

/obj/item/projectile/beam/plasmacutter/on_impact(var/atom/A)
	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		M.GetDrilled(1)
	. = ..()

/obj/item/projectile/beam/confuseray
	name = "disorientator ray"
	icon_state = "beam_grass"
	fire_sound='sound/weapons/confuseray.ogg'
	damage = 2
	agony = 7
	sharp = FALSE
	distance_falloff = 5
	damage_flags = 0
	damage_type = DAMAGE_STUN
	life_span = 3
	penetration_modifier = 0
	var/potency_min = 4
	var/potency_max = 6

	muzzle_type = /obj/effect/projectile/confuseray/muzzle
	tracer_type = /obj/effect/projectile/confuseray/tracer
	impact_type = /obj/effect/projectile/confuseray/impact

/obj/item/projectile/beam/confuseray/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/L = target
		var/potency = rand(potency_min, potency_max)
		L.confused += potency
		L.eye_blurry += potency
		if(L.confused >= 10)
			L.Stun(1)
			L.drop_l_hand()
			L.drop_r_hand()

	return 1

/obj/item/projectile/beam/particle
	name = "particle lance"
	icon_state = "particle"
	damage = 35
	armor_penetration = 50
	muzzle_type = /obj/effect/projectile/laser_particle/muzzle
	tracer_type = /obj/effect/projectile/laser_particle/tracer
	impact_type = /obj/effect/projectile/laser_particle/impact
	penetration_modifier = 0.5

/obj/item/projectile/beam/particle/small
	name = "particle beam"
	damage = 20
	armor_penetration = 20
	penetration_modifier = 0.3

/obj/item/projectile/beam/darkmatter
	name = "dark matter bolt"
	icon_state = "darkb"
	damage = 40
	armor_penetration = 35
	damage_type = DAMAGE_BRUTE
	muzzle_type = /obj/effect/projectile/darkmatter/muzzle
	tracer_type = /obj/effect/projectile/darkmatter/tracer
	impact_type = /obj/effect/projectile/darkmatter/impact

/obj/item/projectile/beam/stun/darkmatter
	name = "dark matter wave"
	icon_state = "darkt"
	damage_flags = 0
	sharp = FALSE
	agony = 40
	damage_type = DAMAGE_STUN
	muzzle_type = /obj/effect/projectile/stun/darkmatter/muzzle
	tracer_type = /obj/effect/projectile/stun/darkmatter/tracer
	impact_type = /obj/effect/projectile/stun/darkmatter/impact

/obj/item/projectile/beam/pointdefense
	name = "point defense salvo"
	icon_state = "laser"
	damage = 15
	damage_type = DAMAGE_SHOCK //You should be safe inside a voidsuit
	sharp = FALSE //"Wide" spectrum beam
	muzzle_type = /obj/effect/projectile/pointdefense/muzzle
	tracer_type = /obj/effect/projectile/pointdefense/tracer
	impact_type = /obj/effect/projectile/pointdefense/impact

/obj/item/projectile/beam/incendiary_laser
	name = "scattered laser blast"
	icon_state = "beam_incen"
	fire_sound='sound/weapons/scan.ogg'
	damage = 12
	agony = 8
	eyeblur = 8
	sharp = FALSE
	damage_flags = 0
	life_span = 8
	armor_penetration = 10
	damage_falloff_list = list(
		list(3, 0.95),
		list(5, 0.90),
		list(7, 0.80),
	)

	muzzle_type = /obj/effect/projectile/incen/muzzle
	tracer_type = /obj/effect/projectile/incen/tracer
	impact_type = /obj/effect/projectile/incen/impact

/obj/item/projectile/beam/incendiary_laser/on_hit(var/atom/target, var/blocked = 0)
	..()
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(rand(2,4))
		if(L.fire_stacks >= 3)
			L.IgniteMob()

/obj/item/projectile/beam/blue
	damage = 30

	muzzle_type = /obj/effect/projectile/laser/blue/muzzle
	tracer_type = /obj/effect/projectile/laser/blue/tracer
	impact_type = /obj/effect/projectile/laser/blue/impact
