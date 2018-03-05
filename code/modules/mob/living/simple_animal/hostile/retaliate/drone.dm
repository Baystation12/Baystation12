
//malfunctioning combat drones
/mob/living/simple_animal/hostile/retaliate/malf_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone"
	icon_living = "drone"
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
	stop_automated_movement_when_pulled = 0
	health = 300
	maxHealth = 300
	speed = 8
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	destroy_surroundings = 0
	var/datum/effect/effect/system/trail/ion_trail

	//the drone randomly switches between these states if it's malfunctioning
	var/malfunctioning = 1
	var/hostile_drone = 0
	//0 - retaliate, only attack enemies that attack it
	//1 - hostile, attack everything that comes near

	var/turf/patrol_target
	var/explode_chance = 1
	var/disabled = 0
	var/exploding = 0

	//Drones aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	var/has_loot = 1
	faction = "malf_drone"

/mob/living/simple_animal/hostile/retaliate/malf_drone/Initialize()
	. = ..()
	if(prob(5))
		projectiletype = /obj/item/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	ion_trail = new /datum/effect/effect/system/trail/ion()
	ion_trail.set_up(src)
	ion_trail.start()

/mob/living/simple_animal/hostile/retaliate/malf_drone/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/retaliate/malf_drone/proc/Haywire()
	if(prob(disabled ? 0 : 1) && malfunctioning)
		if(hostile_drone)
			src.visible_message("<span class='notice'>\icon[src] [src] retracts several targetting vanes, and dulls it's running lights.</span>")
			hostile_drone = 0
		else
			src.visible_message("<span class='warning'>\icon[src] [src] suddenly lights up, and additional targetting vanes slide into place.</span>")
			hostile_drone = 1

/mob/living/simple_animal/hostile/retaliate/malf_drone/ListTargets()
	if(hostile_drone)
		return view(src, 10)
	else
		return ..()

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/retaliate/malf_drone/Life()

	//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		set_stat(UNCONSCIOUS)
		icon_state = "[initial(icon_state)]_dead"
		disabled--
		wander = 0
		speak_chance = 0
		if(disabled <= 0)
			set_stat(CONSCIOUS)
			icon_state = "[initial(icon_state)]0"
			wander = 1
			speak_chance = 5

	//repair a bit of damage
	if(prob(1))
		src.visible_message("<span class='warning'>\icon[src] [src] shudders and shakes as some of it's damaged systems come back online.</span>")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		health += rand(25,100)

	//spark for no reason
	if(prob(5))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	//sometimes our targetting sensors malfunction, and we attack anyone nearby
	Haywire()

	if(health / maxHealth > 0.9)
		icon_state = "[initial(icon_state)]"
		explode_chance = 0
	else if(health / maxHealth > 0.7)
		icon_state = "[initial(icon_state)]2"
		explode_chance = 0
	else if(health / maxHealth > 0.5)
		icon_state = "[initial(icon_state)]1"
		explode_chance = 0.5
	else if(health / maxHealth > 0.3)
		icon_state = "[initial(icon_state)]0"
		explode_chance = 5
	else if(health > 0)
		//if health gets too low, shut down
		icon_state = "[initial(icon_state)]_dead"
		exploding = 0
		if(!disabled)
			if(prob(50))
				src.visible_message("<span class='notice'>\icon[src] [src] suddenly shuts down!</span>")
			else
				src.visible_message("<span class='notice'>\icon[src] [src] suddenly lies still and quiet.</span>")
			disabled = rand(150, 600)
			walk(src,0)

	if(exploding && prob(20))
		if(prob(50))
			src.visible_message("<span class='warning'>\icon[src] [src] begins to spark and shake violenty!</span>")
		else
			src.visible_message("<span class='warning'>\icon[src] [src] sparks and shakes like it's about to explode!</span>")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	if(!exploding && !disabled && prob(explode_chance))
		exploding = 1
		set_stat(UNCONSCIOUS)
		wander = 1
		walk(src,0)
		spawn(rand(50,150))
			if(!disabled && exploding)
				explosion(get_turf(src), 0, 1, 4, 7)
				//proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1)
	..()

//ion rifle!
/mob/living/simple_animal/hostile/retaliate/malf_drone/emp_act(severity)
	health -= rand(3,15) * (severity + 1)
	disabled = rand(150, 600)
	hostile_drone = 0
	walk(src,0)

/mob/living/simple_animal/hostile/retaliate/malf_drone/death()
	..(null,"suddenly breaks apart.", "You have been destroyed.")
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/malf_drone/Destroy()
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
		O = new /obj/item/stack/rods(loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/rods(loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/rods(loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/rods(loc)
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
			C.SetName("Drone CPU motherboard")
			C.origin_tech = list(TECH_DATA = rand(3, 6))

		if(spawnees & 2)
			C = new(src.loc)
			C.SetName("Drone neural interface")
			C.origin_tech = list(TECH_BIO = rand(3,6))

		if(spawnees & 4)
			C = new(src.loc)
			C.SetName("Drone suspension processor")
			C.origin_tech = list(TECH_MAGNET = rand(3,6))

		if(spawnees & 8)
			C = new(src.loc)
			C.SetName("Drone shielding controller")
			C.origin_tech = list(TECH_BLUESPACE = rand(3,6))

		if(spawnees & 16)
			C = new(src.loc)
			C.SetName("Drone power capacitor")
			C.origin_tech = list(TECH_POWER = rand(3,6))

		if(spawnees & 32)
			C = new(src.loc)
			C.SetName("Drone hull reinforcer")
			C.origin_tech = list(TECH_MATERIAL = rand(3,6))

		if(spawnees & 64)
			C = new(src.loc)
			C.SetName("Drone auto-repair system")
			C.origin_tech = list(TECH_ENGINEERING = rand(3,6))

		if(spawnees & 128)
			C = new(src.loc)
			C.SetName("Drone phoron overcharge counter")
			C.origin_tech = list(TECH_PHORON = rand(3,6))

		if(spawnees & 256)
			C = new(src.loc)
			C.SetName("Drone targetting circuitboard")
			C.origin_tech = list(TECH_COMBAT = rand(3,6))

		if(spawnees & 512)
			C = new(src.loc)
			C.SetName("Corrupted drone morality core")
			C.origin_tech = list(TECH_ILLEGAL = rand(3,6))

	..()

/obj/item/projectile/beam/drone
	damage = 15

/obj/item/projectile/beam/pulse/drone
	damage = 10
