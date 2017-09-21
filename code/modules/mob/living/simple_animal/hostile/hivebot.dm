/obj/item/projectile/hivebotbullet
	damage = 10
	damage_type = BRUTE

/mob/living/simple_animal/hostile/hivebot
	name = "Hivebot"
	desc = "A small robot"
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"
	health = 15
	maxHealth = 15
	melee_damage_lower = 2
	melee_damage_upper = 3
	attacktext = "clawed"
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	projectiletype = /obj/item/projectile/hivebotbullet
	faction = "hivebot"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4

/mob/living/simple_animal/hostile/hivebot/range
	name = "Hivebot"
	desc = "A smallish robot, this one is armed!"
	ranged = 1

/mob/living/simple_animal/hostile/hivebot/rapid
	ranged = 1
	rapid = 1

/mob/living/simple_animal/hostile/hivebot/strong
	name = "Strong Hivebot"
	desc = "A robot, this one is armed and looks tough!"
	health = 80
	ranged = 1


/mob/living/simple_animal/hostile/hivebot/death()
	..(null, "blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebot/tele
	name = "Beacon"
	desc = "Some odd beacon thing"
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "def_radar-off"
	icon_living = "def_radar-off"
	health = 200
	maxHealth = 200
	status_flags = 0
	anchored = 1
	stop_automated_movement = 1
	var/bot_type = /mob/living/simple_animal/hostile/hivebot
	var/bot_amt = 10
	var/spawn_delay = 100
	var/spawn_time = 0

/mob/living/simple_animal/hostile/hivebot/tele/New()
	..()
	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(5, 0, src.loc)
	smoke.start()
	visible_message("<span class='danger'>\The [src] warps in!</span>")
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple_animal/hostile/hivebot/tele/proc/warpbots()
	while(bot_amt > 0 && bot_type)
		bot_amt--
		var/mob/M = new bot_type(get_turf(src))
		M.faction = faction
	playsound(src.loc, 'sound/effects/teleport.ogg', 50, 1)
	qdel(src)
	return

/mob/living/simple_animal/hostile/hivebot/tele/FindTarget()
	if(..() && !spawn_time)
		spawn_time = world.time + spawn_delay
		visible_message("<span class='danger'>\The [src] turns on!</span>")
		icon_state = "def_radar"
	return null

/mob/living/simple_animal/hostile/hivebot/tele/Life()
	. = ..()
	if(. && spawn_time && spawn_time <= world.time)
		warpbots()

/mob/living/simple_animal/hostile/hivebot/tele/strong
	bot_type = /mob/living/simple_animal/hostile/hivebot/strong

/mob/living/simple_animal/hostile/hivebot/tele/range
	bot_type = /mob/living/simple_animal/hostile/hivebot/range

/mob/living/simple_animal/hostile/hivebot/tele/rapid
	bot_type = /mob/living/simple_animal/hostile/hivebot/rapid