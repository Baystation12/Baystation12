
/obj/item/weapon/gun/energy/laser/sentinel_beam
	name = "Sentinel Beam"
	self_recharge = 1
	recharge_time = 0

/mob/living/simple_animal/hostile/sentinel
	name = "Sentinel"
	desc = "An automated defence drone made of advanced alien technology."
	icon = 'code/modules/halo/Forerunner/Sentinel.dmi'
	icon_state = "sentinel"
	icon_living = "sentinel"
	icon_dead = "sentinel_dead"
	response_harm = "batters"
	health = 200
	maxHealth = 200
	ranged = 1
	move_to_delay = 5
	resistance = 10
	var/obj/item/weapon/gun/energy/laser/sentinel_beam

/mob/living/simple_animal/hostile/sentinel/New()
	. = ..()
	sentinel_beam = new(src)

/mob/living/simple_animal/hostile/sentinel/RangedAttack(var/atom/attacked)
	sentinel_beam.Fire(attacked, src)

/mob/living/simple_animal/hostile/sentinel/death(gibbed, deathmessage = "crashes into the ground!", show_dead_message = 1)
	new /obj/effect/gibspawner/robot(src.loc)
	. = ..(gibbed, deathmessage, show_dead_message)

//how do i shoot gun
/mob/living/simple_animal/hostile/sentinel/IsAdvancedToolUser()
	return 1
