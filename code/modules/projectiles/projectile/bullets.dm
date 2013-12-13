/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = 0
	flag = "bullet"
	embed = 1

	on_hit(var/atom/target, var/blocked = 0)
		if (..(target, blocked))
			var/mob/living/L = target
			shake_camera(L, 3, 2)
			return 1
		return 0

/obj/item/projectile/bullet/slug
	name = "slug"


/obj/item/projectile/bullet/rubberbullet
	damage = 10
	stun = 5
	weaken = 5
	embed = 0

/obj/item/projectile/bullet/weakbullet/booze
	embed = 0
	on_hit(var/atom/target, var/blocked = 0)
		if(..(target, blocked))
			var/mob/living/M = target
			M.dizziness += 20
			M:slurring += 20
			M.confused += 20
			M.eye_blurry += 20
			M.drowsyness += 20
			for(var/datum/reagent/ethanol/A in M.reagents.reagent_list)
				M.paralysis += 2
				M.dizziness += 10
				M:slurring += 10
				M.confused += 10
				M.eye_blurry += 10
				M.drowsyness += 10
				A.volume += 5 //Because we can


/obj/item/projectile/bullet/midbullet12
	damage = 20
	stun = 5
	weaken = 5
	embed = 0

/obj/item/projectile/bullet/midbullet9
	damage = 25

/obj/item/projectile/bullet/midbullet45
	damage = 25
	stun = 1
	weaken = 1

/obj/item/projectile/bullet/midbullet10 //Only used with the Stechkin Pistol - RobRichards
	damage = 30

/obj/item/projectile/bullet/buck
	name = "pellet"
	damage = 15

/obj/item/projectile/bullet/blank
	name = "blankshot"
	nodamage = 1

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage = 20
	damage_type = OXY


/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 40
	damage_type = TOX


/obj/item/projectile/bullet/burstbullet//I think this one needs something for the on hit
	name = "exploding bullet"
	damage = 20


/obj/item/projectile/bullet/stunshot
	name = "stunshot"
	damage = 5
	stun = 10
	weaken = 10
	stutter = 10

/obj/item/projectile/bullet/a762
	damage = 25