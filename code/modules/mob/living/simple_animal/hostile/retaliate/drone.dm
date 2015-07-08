#define DRONE_ABILITY_CLOAK "cloak"
#define DRONE_ABILITY_REPAIR "repair"

//malfunctioning combat drones
/mob/living/simple_animal/hostile/retaliate/malf_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone3"
	icon_living = "drone3"
	icon_dead = "drone_dead"
	ranged = 1
	rapid = 1
	speak_chance = 5
	turns_per_move = 3
	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speak = list("ALERT.","Hostile-ile-ile entities dee-twhoooo-wected.","Threat parameterszzzz- szzet.","Bring sub-sub-sub-systems uuuup to combat alert alpha-a-a.")
	emote_see = list("beeps menacingly","whirrs threateningly","scans its immediate vicinity")
	a_intent = I_HURT
	health = 300
	maxHealth = 300
	move_delay = 8
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	var/datum/effect/effect/system/ion_trail_follow/ion_trail

	//the drone randomly switches between these states because it's malfunctioning
	var/hostile_drone = 0
	//0 - retaliate, only attack enemies that attack it
	//1 - hostile, attack everything that comes near

	var/turf/patrol_target
	var/explode_chance = 1
	var/disabled = 0
	var/exploding = 0

	//Drones aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	var/has_loot = 1
	faction = "malf_drone"
	default_mob_ai = /mob/living/simple_animal/hostile/retaliate/malf_drone

	var/list/ability_delays

/mob/living/simple_animal/hostile/retaliate/malf_drone/New()
	..()
	if(prob(5))
		projectiletype = /obj/item/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	ability_delays = list()
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

	mob_ai.destroy_probability = 0

/mob/living/simple_animal/hostile/retaliate/malf_drone/Destroy()
	qdel(ion_trail)
	ion_trail = null

	//some random debris left behind
	if(has_loot)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		var/obj/O

		//shards
		O = new /obj/item/weapon/material/shard(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/weapon/material/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/weapon/material/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/weapon/material/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//rods
		O = PoolOrNew(/obj/item/stack/rods, src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = PoolOrNew(/obj/item/stack/rods, src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = PoolOrNew(/obj/item/stack/rods, src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = PoolOrNew(/obj/item/stack/rods, src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//plasteel
		O = new /obj/item/stack/material/plasteel(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/material/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/material/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/material/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//also drop dummy circuit boards deconstructable for research (loot)
		var/obj/item/weapon/circuitboard/C

		//spawn 1-4 boards of a random type
		var/spawnees = 0
		var/num_boards = rand(1,4)
		var/list/options = list(1,2,4,8,16,32,64,128,256,512)
		for(var/i=0, i<num_boards, i++)
			var/chosen = pick(options)
			options.Remove(options.Find(chosen))
			spawnees |= chosen

		if(spawnees & 1)
			C = new(src.loc)
			C.name = "Drone CPU motherboard"
			C.origin_tech = list(TECH_DATA = rand(3, 6))

		if(spawnees & 2)
			C = new(src.loc)
			C.name = "Drone neural interface"
			C.origin_tech = list(TECH_BIO = rand(3,6))

		if(spawnees & 4)
			C = new(src.loc)
			C.name = "Drone suspension processor"
			C.origin_tech = list(TECH_MAGNET = rand(3,6))

		if(spawnees & 8)
			C = new(src.loc)
			C.name = "Drone shielding controller"
			C.origin_tech = list(TECH_BLUESPACE = rand(3,6))

		if(spawnees & 16)
			C = new(src.loc)
			C.name = "Drone power capacitor"
			C.origin_tech = list(TECH_POWER = rand(3,6))

		if(spawnees & 32)
			C = new(src.loc)
			C.name = "Drone hull reinforcer"
			C.origin_tech = list(TECH_MATERIAL = rand(3,6))

		if(spawnees & 64)
			C = new(src.loc)
			C.name = "Drone auto-repair system"
			C.origin_tech = list(TECH_ENGINERING = rand(3,6))

		if(spawnees & 128)
			C = new(src.loc)
			C.name = "Drone phoron overcharge counter"
			C.origin_tech = list(TECH_PHORON = rand(3,6))

		if(spawnees & 256)
			C = new(src.loc)
			C.name = "Drone targetting circuitboard"
			C.origin_tech = list(TECH_COMBAT = rand(3,6))

		if(spawnees & 512)
			C = new(src.loc)
			C.name = "Corrupted drone morality core"
			C.origin_tech = list(TECH_ILLEGAL = rand(3,6))

	..()

/mob/living/simple_animal/hostile/retaliate/malf_drone/Process_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/retaliate/malf_drone/proc/CanUseAbility(var/ability, var/mob/user = usr)
	if(stat != CONSCIOUS)
		user << "<span class='warning'>You are currently disabled!</span>"
		return 0

	if(world.time < ability_delays[ability])
		user << "<span class='notice'>This ability is not yet ready.</span>"
		return 0

	return 1

/mob/living/simple_animal/hostile/retaliate/malf_drone/verb/RepairDamage()
	set name = "Repair Damage"
	set desc = "Heals a random amount of damage, up until max HP."
	set category = "Abilities"

	if(!CanUseAbility(DRONE_ABILITY_REPAIR))
		return
	ability_delays[DRONE_ABILITY_REPAIR] = world.time + 1 MINUTES

	src.visible_message("<span class='danger'>\The [src] shudders and shakes as some of it's damaged systems come back online.</span>")
	var/datum/effect/effect/system/spark_spread/s = PoolOrNew(/datum/effect/effect/system/spark_spread)
	s.set_up(3, 1, src)
	s.start()
	health = max(maxHealth, health + rand(25,100))
	update_icons()

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/retaliate/malf_drone/Life()
	handle_disabled()

	//repair a bit of damage
	if(prob(1))
		RepairDamage()

	if(health < maxHealth && prob(5))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	//sometimes our targetting sensors malfunction, and we attack anyone nearby
	if(prob(disabled ? 0 : 1))
		if(hostile_drone)
			src.visible_message("<span class='notice'>\The [src] retracts several targetting vanes, and dulls it's running lights.</span>")
			hostile_drone = 0
		else
			src.visible_message("<span class='danger'>\The [src] suddenly lights up, and additional targetting vanes slide into place.</span>")
			hostile_drone = 1

	if(health / maxHealth > 0.9)
		explode_chance = 0
	else if(health / maxHealth > 0.7)
		explode_chance = 0
	else if(health / maxHealth > 0.5)
		explode_chance = 0.5
	else if(health / maxHealth > 0.3)
		explode_chance = 5
	else if(health > 0)
		//if health gets too low, shut down
		exploding = 0
		if(!disabled)
			if(prob(50))
				src.visible_message("<span class='danger'>\The [src] suddenly shuts down!</span>")
			else
				src.visible_message("<span class='danger'>\The [src] suddenly lies still and quiet.</span>")
			disabled = rand(150, 600)
			walk(src,0)

	if(exploding && prob(20))
		if(prob(50))
			src.visible_message("<span class='danger'>\The [src] begins to spark and shake violenty!</span>")
		else
			src.visible_message("<span class='danger'>\The [src] sparks and shakes like it's about to explode!</span>")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	if(!exploding && !disabled && prob(explode_chance))
		exploding = 1
		stat = UNCONSCIOUS
		walk(src,0)
		spawn(rand(50,150))
			if(!disabled && exploding)
				explosion(get_turf(src), 0, 1, 4, 7)
				//proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1)
		update_icons()
	..()

/mob/living/simple_animal/hostile/retaliate/malf_drone/update_icons()
	if(disabled)
		icon_state = "drone_dead"
		return
	if(health / maxHealth > 0.9)
		icon_state = "drone3"
	else if(health / maxHealth > 0.7)
		icon_state = "drone2"
	else if(health / maxHealth > 0.5)
		icon_state = "drone1"
	else if(health / maxHealth > 0.3)
		icon_state = "drone0"
	else if(health > 0)
		icon_state = "drone_dead"

/mob/living/simple_animal/hostile/retaliate/malf_drone/proc/handle_disabled()
//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		if(stat != UNCONSCIOUS)
			stat = UNCONSCIOUS
			update_icons()
		disabled--
		if(disabled <= 0)
			stat = CONSCIOUS
			update_icons()

//ion rifle!
/mob/living/simple_animal/hostile/retaliate/malf_drone/emp_act(severity)
	health -= rand(3,15) * (severity + 1)
	disabled = rand(150, 600)
	hostile_drone = 0
	walk(src,0)
	update_icons()

/mob/living/simple_animal/hostile/retaliate/malf_drone/death()
	..(null,"suddenly breaks apart.")
	qdel(src)

/obj/item/projectile/beam/drone
	damage = 15

/obj/item/projectile/beam/pulse/drone
	damage = 10

#undef DRONE_ABILITY_CLOAK
#undef DRONE_ABILITY_REPAIR
