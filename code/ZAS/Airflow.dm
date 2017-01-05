/*
Contains helper procs for airflow, handled in /connection_group.
*/

mob/var/tmp/last_airflow_stun = 0
mob/proc/airflow_stun()
	if(stat == 2)
		return 0
	if(last_airflow_stun > world.time - vsc.airflow_stun_cooldown)	return 0

	if(!(status_flags & CANSTUN) && !(status_flags & CANWEAKEN))
		to_chat(src, "<span class='notice'>You stay upright as the air rushes past you.</span>")
		return 0
	if(buckled)
		to_chat(src, "<span class='notice'>Air suddenly rushes past you!</span>")
		return 0
	if(!lying)
		to_chat(src, "<span class='warning'>The sudden rush of air knocks you over!</span>")
	Weaken(5)
	last_airflow_stun = world.time

mob/living/silicon/airflow_stun()
	return

mob/living/carbon/slime/airflow_stun()
	return

mob/living/carbon/human/airflow_stun()
	if(shoes && (shoes.item_flags & NOSLIP))
		to_chat(src, "<span class='notice'>Air suddenly rushes past you!</span>")
		return 0
	..()

atom/movable/proc/check_airflow_movable(n)

	if(anchored && !ismob(src)) return 0

	if(!isobj(src) && n < vsc.airflow_dense_pressure) return 0

	return 1

mob/check_airflow_movable(n)
	if(n < vsc.airflow_heavy_pressure)
		return 0
	return 1

mob/living/silicon/check_airflow_movable()
	return 0


obj/check_airflow_movable(n)
	if(isnull(w_class))
		if(n < vsc.airflow_dense_pressure) return 0 //most non-item objs don't have a w_class yet
	else
		switch(w_class)
			if(1,2)
				if(n < vsc.airflow_lightest_pressure) return 0
			if(3)
				if(n < vsc.airflow_light_pressure) return 0
			if(4,5)
				if(n < vsc.airflow_medium_pressure) return 0
			if(6)
				if(n < vsc.airflow_heavy_pressure) return 0
			if(7 to INFINITY)
				if(n < vsc.airflow_dense_pressure) return 0
	return ..()


/atom/movable/var/tmp/turf/airflow_dest
/atom/movable/var/tmp/airflow_speed = 0
/atom/movable/var/tmp/airflow_time = 0
/atom/movable/var/tmp/last_airflow = 0

/atom/movable/proc/AirflowCanMove(n)
	return 1

/mob/AirflowCanMove(n)
	if(status_flags & GODMODE)
		return 0
	if(buckled)
		return 0
	var/obj/item/shoes = get_equipped_item(slot_shoes)
	if(istype(shoes) && (shoes.item_flags & NOSLIP))
		return 0
	return 1

/atom/movable/proc/GotoAirflowDest(n)
	if(!airflow_dest) return
	if(airflow_speed < 0) return
	if(last_airflow > world.time - vsc.airflow_delay) return
	if(airflow_speed)
		airflow_speed = n/max(get_dist(src,airflow_dest),1)
		return
	if(airflow_dest == loc)
		step_away(src,loc)
	if(!src.AirflowCanMove(n))
		return
	if(ismob(src))
		to_chat(src, "<span class='danger'>You are sucked away by airflow!</span>")
	last_airflow = world.time
	var/airflow_falloff = 9 - sqrt((x - airflow_dest.x) ** 2 + (y - airflow_dest.y) ** 2)
	if(airflow_falloff < 1)
		airflow_dest = null
		return
	airflow_speed = min(max(n * (9/airflow_falloff),1),9)
	var
		xo = airflow_dest.x - src.x
		yo = airflow_dest.y - src.y
		od = 0
	airflow_dest = null
	if(!density)
		set_density(1)
		od = 1
	while(airflow_speed > 0)
		if(airflow_speed <= 0) break
		airflow_speed = min(airflow_speed,15)
		airflow_speed -= vsc.airflow_speed_decay
		if(airflow_speed > 7)
			if(airflow_time++ >= airflow_speed - 7)
				if(od)
					set_density(0)
				sleep(1 * tick_multiplier)
		else
			if(od)
				set_density(0)
			sleep(max(1,10-(airflow_speed+3)) * tick_multiplier)
		if(od)
			set_density(1)
		if ((!( src.airflow_dest ) || src.loc == src.airflow_dest))
			src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx), min(max(src.y + yo, 1), world.maxy), src.z)
		if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
			break
		if(!istype(loc, /turf))
			break
		step_towards(src, src.airflow_dest)
		var/mob/M = src
		if(istype(M) && M.client)
			M.setMoveCooldown(vsc.airflow_mob_slowdown)
	airflow_dest = null
	airflow_speed = 0
	airflow_time = 0
	if(od)
		set_density(0)


/atom/movable/proc/RepelAirflowDest(n)
	if(!airflow_dest) return
	if(airflow_speed < 0) return
	if(last_airflow > world.time - vsc.airflow_delay) return
	if(airflow_speed)
		airflow_speed = n/max(get_dist(src,airflow_dest),1)
		return
	if(airflow_dest == loc)
		step_away(src,loc)
	if(!src.AirflowCanMove(n))
		return
	if(ismob(src))
		to_chat(src, "<span clas='danger'>You are pushed away by airflow!</span>")
	last_airflow = world.time
	var/airflow_falloff = 9 - sqrt((x - airflow_dest.x) ** 2 + (y - airflow_dest.y) ** 2)
	if(airflow_falloff < 1)
		airflow_dest = null
		return
	airflow_speed = min(max(n * (9/airflow_falloff),1),9)
	var
		xo = -(airflow_dest.x - src.x)
		yo = -(airflow_dest.y - src.y)
		od = 0
	airflow_dest = null
	if(!density)
		set_density(1)
		od = 1
	while(airflow_speed > 0)
		if(airflow_speed <= 0) return
		airflow_speed = min(airflow_speed,15)
		airflow_speed -= vsc.airflow_speed_decay
		if(airflow_speed > 7)
			if(airflow_time++ >= airflow_speed - 7)
				sleep(1 * tick_multiplier)
		else
			sleep(max(1,10-(airflow_speed+3)) * tick_multiplier)
		if ((!( src.airflow_dest ) || src.loc == src.airflow_dest))
			src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx), min(max(src.y + yo, 1), world.maxy), src.z)
		if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
			return
		if(!istype(loc, /turf))
			return
		step_towards(src, src.airflow_dest)
		if(ismob(src) && src:client)
			src:client:move_delay = world.time + vsc.airflow_mob_slowdown
	airflow_dest = null
	airflow_speed = 0
	airflow_time = 0
	if(od)
		set_density(0)

/atom/movable/Bump(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		airflow_hit(A)
	else
		airflow_speed = 0
		airflow_time = 0
		. = ..()

atom/movable/proc/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

mob/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_message("<span class='danger'>\The [src] slams into \a [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src.loc, "smash.ogg", 25, 1, -1)
	var/weak_amt = istype(A,/obj/item) ? A:w_class : rand(1,5) //Heheheh
	Weaken(weak_amt)
	. = ..()

obj/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_message("<span class='danger'>\The [src] slams into \a [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src.loc, "smash.ogg", 25, 1, -1)
	. = ..()

obj/item/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

mob/living/carbon/human/airflow_hit(atom/A)
//	for(var/mob/M in hearers(src))
//		M.show_message("<span class='danger'>[src] slams into [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src.loc, "punch", 25, 1, -1)
	if (prob(33))
		loc:add_blood(src)
		bloody_body(src)
	var/b_loss = airflow_speed * vsc.airflow_damage

	var/blocked = run_armor_check(BP_HEAD,"melee")
	apply_damage(b_loss/3, BRUTE, BP_HEAD, blocked, 0, "Airflow")

	blocked = run_armor_check(BP_CHEST,"melee")
	apply_damage(b_loss/3, BRUTE, BP_CHEST, blocked, 0, "Airflow")

	blocked = run_armor_check(BP_GROIN,"melee")
	apply_damage(b_loss/3, BRUTE, BP_GROIN, blocked, 0, "Airflow")

	if(airflow_speed > 10)
		Paralyse(round(airflow_speed * vsc.airflow_stun))
		Stun(paralysis + 3)
	else
		Stun(round(airflow_speed * vsc.airflow_stun/2))
	. = ..()

zone/proc/movables()
	. = list()
	for(var/turf/T in contents)
		for(var/atom/movable/A in T)
			if(!A.simulated || A.anchored || istype(A, /obj/effect) || isobserver(A))
				continue
			. += A
