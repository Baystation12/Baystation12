
/mob/living/simple_animal/hostile
	var/primed_grenade = 0 //If set to 1, we will throw a grenade next time we attack.
	var/next_grenade_at = 0 //WE cannot prime a nade again until this time.
	var/grenade_delay = 20 SECONDS //Delays between nade priming
	var/list/possible_grenades = list()

/mob/living/simple_animal/hostile/proc/throw_nade(var/atom/attacked)
	var/turf/atk_trf = get_turf(attacked)
	var/turf/spawn_turf = get_step(loc,get_dir(loc,atk_trf))
	primed_grenade = 0
	var/nadetype = pick(possible_grenades)
	var/obj/item/weapon/grenade/nade = new nadetype (spawn_turf)
	visible_message("<span class = 'danger'>[src] throws [nade]!</span>")
	nade.activate(src)
	nade.det_time = max(10,nade.det_time-10)
	nade.throw_at(atk_trf, nade.throw_range, nade.throw_speed, src)

/mob/living/simple_animal/hostile/RangedAttack(var/atom/attacked)
	. = ..()
	if(primed_grenade)
		throw_nade(attacked)
	if(possible_grenades.len > 0 && world.time >= next_grenade_at)
		primed_grenade = 1
		next_grenade_at = world.time + grenade_delay
		visible_message("<span class = 'warning'>[src] gets ready to throw a grenade!</span>")