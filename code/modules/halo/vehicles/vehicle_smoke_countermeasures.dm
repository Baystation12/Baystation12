
/datum/effect/effect/system/smoke_spread/vehicle_smokescreen
	spread_steps_on_spawn = 2

/obj/vehicles/proc/deploy_smoke()
	set name = "Deploy Smoke"
	set category = "Vehicle"
	set src in view(1)

	var/mob/living/user = usr
	if(!can_smoke)
		to_chat(user,"<span class = 'notice'>This vehicle doesn't have smoke countermeasures installed!</span>")
		verbs -= /obj/vehicles/proc/deploy_smoke
		return
	if(!istype(user) || !(user in get_occupants_in_position("driver")))
		to_chat(user,"<span class = 'notice'>You must be the driver of [src] to deploy smoke countermeasures.</span>")
		return
	if(smoke_ammo <= 0)
		to_chat(user,"<span class = 'notice'>[src]'s smoke dispenser has no charges left!</span>")
		return
	if(world.time < next_smoke_min)
		to_chat(user,"<span class = 'notice'>[src]'s smoke dispenser was recently used and is on cooldown!</span>")
		return
	deploy_smoke_proc()

/obj/vehicles/proc/deploy_smoke_proc()
	var/origin = pick(locs)
	var/origin_forwardsearch_cap = 6
	while(origin in locs) //Step our chosen origin point forwards until we get to the front facing direction of the vehicle that ISN'T in our locslist.
		origin = get_step(origin,dir)
		if(origin_forwardsearch_cap <= 0)
			break
	if(smoke_step_dist)
		for(var/i = 0 to smoke_step_dist)
			origin = get_step(origin,dir)
	playsound(loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	playsound(origin, 'sound/effects/smoke.ogg', 50, 1, -3)
	var/datum/effect/effect/system/smoke_spread/smoke = new smoke_type()
	smoke.attach(origin)
	next_smoke_min = world.time + smoke_delay
	smoke_ammo--
	spawn(0)
		for(var/i = 0 to smoke_start_amt)
			smoke.start()
			sleep(10)
