/mob/living/simple_animal/hostile
	faction = "hostile"
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/ranged = 0
	var/burst_size = 1
	var/burst_delay = 0.5 SECONDS
	var/projectiletype
	var/projectilesound
	var/list/attack_sfx = list()
	var/obj/item/ammo_casing/casingtype
	var/move_to_delay = 4 //delay for the automated movement.
	var/attack_delay = DEFAULT_ATTACK_COOLDOWN
	var/list/friends = list()
	var/break_stuff_probability = 10
	stop_automated_movement_when_pulled = 0
	var/destroy_surroundings = 1
	a_intent = I_HURT

	var/shuttletarget = null
	var/enroute = 0

	var/damtype = BRUTE
	var/defense = "melee" //what armor protects against its attacks

	var/feral = 0

	var/obj/item/weapon/gun/vehicle_turret/using_vehicle_gun

	var/datum/npc_overmind/our_overmind

/mob/living/simple_animal/hostile/New()
	. = ..()
	if(our_overmind)
		if(our_overmind.overmind_active)
			assault_target_type = null //Sorted troops are now soley under overmind command, if the overmind is currently active.
		var/sorted = 0
		if(our_overmind.is_type_list(src,our_overmind.constructor_types))
			our_overmind.constructor_troops += src
			sorted = 1
		if(our_overmind.is_type_list(src,our_overmind.combat_types))
			our_overmind.combat_troops += src
			sorted = 1
		if(our_overmind.is_type_list(src,our_overmind.support_types))
			our_overmind.support_troops += src
			sorted = 1
		if(!sorted)
			our_overmind.other_troops += src


/mob/living/simple_animal/hostile/Move(var/turfnew,var/dir)
	if(istype(loc,/obj/vehicles))
		var/obj/vehicles/v = loc
		. = v.relaymove(src,dir)
	else
		if(using_vehicle_gun)
			qdel(using_vehicle_gun)
		. = ..()

/mob/living/simple_animal/hostile/proc/FindTarget()
	if(!faction) //No faction, no reason to attack anybody.
		return null
	var/atom/T = null
	//stop_automated_movement = 0
	for(var/atom/A in ListTargets(7))

		if(A == src || A == src.loc)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else
				if(!L.stat)
					stance = HOSTILE_STANCE_ATTACK
					T = L
					break

		else if(istype(A, /obj/mecha)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if (M.occupant)
				stance = HOSTILE_STANCE_ATTACK
				T = M
				break
		else if(istype(A,/obj/vehicles))
			var/obj/vehicles/v = A
			var/attack_vehicle = 0
			for(var/mob/m in v.occupants)
				if(m.stat == CONSCIOUS && m.faction != src.faction)
					attack_vehicle = 1
					break
			if(attack_vehicle)
				stance = HOSTILE_STANCE_ATTACK
				T = v
				break

	if(our_overmind && !isnull(T))
		var/list/targlist = ListTargets(7)
		our_overmind.create_report(1,src,null,targlist.len,assault_target,loc)
	return T


/mob/living/simple_animal/hostile/proc/Found(var/atom/A)
	return

/mob/living/simple_animal/hostile/proc/MoveToTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(7))
		if(ranged || istype(loc,/obj/vehicles))
			if(get_dist(loc, target_mob) <= 6)
				walk(src, 0)
				OpenFire(target_mob)
			else
				walk_to(src, target_mob, 1, move_to_delay)
		else
			stance = HOSTILE_STANCE_ATTACKING
			walk_to(src, target_mob, 1, move_to_delay)
			spawn(get_dist(src,target_mob)*move_to_delay) //If the target is within range after our original move, we attack them.
				AttackTarget()

/mob/living/simple_animal/hostile/proc/AttackTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(7)))
		LostTarget()
		return 0
	if(next_move >= world.time)
		return 0
	if(Adjacent(target_mob))	//Attacking
		AttackingTarget()
		return 1

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	setClickCooldown(attack_delay)
	if(!Adjacent(target_mob))
		return
	UnarmedAttack(target_mob)

/mob/living/simple_animal/hostile/UnarmedAttack(var/atom/attacked,var/prox_flag)
	setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	if(istype(attacked,/mob/living))
		var/mob/living/L = attacked
		var/damage_to_apply = rand(melee_damage_lower,melee_damage_upper)
		if(istype(L,/mob/living/carbon/human))
			var/mob/living/carbon/human/h = L
			if(h.check_shields(damage_to_apply, src, src, attacktext))
				return
		L.apply_damage(damage_to_apply,damtype,null,L.run_armor_check(null,defense))
		L.visible_message("<span class='danger'>[src] has attacked [L]!</span>")
		src.do_attack_animation(L)
		spawn(1) L.updatehealth()
		return L
	if(istype(attacked,/obj/mecha) || istype(attacked,/obj/structure) || istype(attacked,/obj/vehicles))
		var/obj/o = attacked
		o.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		src.do_attack_animation(o)
		if(istype(attacked,/obj/vehicles))
			var/obj/vehicles/v = attacked
			if(v.movement_destroyed || v.guns_disabled)
				target_mob = null
				stance = HOSTILE_STANCE_IDLE
		return o

/mob/living/simple_animal/hostile/RangedAttack(var/atom/attacked)
	var/obj/vehicles/v = loc
	if(istype(v))
		if(!using_vehicle_gun && src in v.get_occupants_in_position("gunner"))
			var/using_vehicle_gun_type = pick(v.comp_prof.gunner_weapons)
			using_vehicle_gun = new using_vehicle_gun_type
	else if(using_vehicle_gun)
		using_vehicle_gun = null

	if(!ranged && !using_vehicle_gun)
		return
	var/target = attacked
	visible_message("<span class='danger'>\The [src] fires at \the [target]!</span>")
	var/casingtype_use = casingtype
	var/burstsize_use = burst_size
	var/burstdelay_use = burst_delay
	if(using_vehicle_gun)
		casingtype_use = null
		burstsize_use = using_vehicle_gun.burst
		burstdelay_use = using_vehicle_gun.burst_delay

	if(burstsize_use > 0)
		for(var/i = 0, i < burstsize_use,i++)
			Shoot(target, src.loc, src)
			if(casingtype_use)
				var/obj/item/ammo_casing/casing = new casingtype(get_turf(src))
				if(!isnull(casing.BB))
					casing.expend()
			sleep(burstdelay_use)
	var/fire_delay_use = 6 //Same as base gun fire delay.
	if(using_vehicle_gun)
		fire_delay_use = using_vehicle_gun.fire_delay
	setClickCooldown(fire_delay_use)

/mob/living/simple_animal/hostile/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)

/mob/living/simple_animal/hostile/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)

/mob/living/simple_animal/hostile/proc/ListTargets(var/dist = 8)
	var/list/L = list()

	for(var/A in view(dist,src.loc))
		if(istype(A,/mob/living))
			L += A
			continue
		if(istype(A,/obj/mecha))
			L += A
			continue
		if(istype(A,/obj/vehicles))
			L += A
			continue

	return L

/mob/living/simple_animal/hostile/death(gibbed, deathmessage, show_dead_message)
	if(our_overmind)
		var/list/targlist = ListTargets(7)
		our_overmind.create_report(5,src,null,targlist.len,assault_target,loc)
	..(gibbed, deathmessage, show_dead_message)
	stop_automated_movement = 0
	walk(src, 0)

/mob/living/simple_animal/hostile/Life()

	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client || ckey)
		return 0
	if(isturf(src.loc) || istype(src.loc,/obj/vehicles))
		if(!stat)
			switch(stance)
				if(HOSTILE_STANCE_IDLE)
					target_mob = FindTarget()

					if(!target_mob)
						handle_assault_pathing()

				if(HOSTILE_STANCE_ATTACK)
					if(destroy_surroundings)
						DestroySurroundings()
					MoveToTarget()

				if(HOSTILE_STANCE_ATTACKING)
					if(destroy_surroundings)
						DestroySurroundings()
					AttackTarget()
				if(HOSTILE_STANCE_INSIDE) //we aren't inside something so just switch
					stance = HOSTILE_STANCE_IDLE
	else
		if(stance != HOSTILE_STANCE_INSIDE)
			stance = HOSTILE_STANCE_INSIDE
			walk(src,0)
			target_mob = null


/mob/living/simple_animal/hostile/attackby(var/obj/item/O, var/mob/user)
	var/oldhealth = health
	. = ..()
	if(health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = user
		//MoveToTarget()
		stance = HOSTILE_STANCE_ATTACK
		Life()

/mob/living/simple_animal/hostile/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(M.a_intent == I_HURT && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = M
		//MoveToTarget()
		stance = HOSTILE_STANCE_ATTACK
		Life()

/mob/living/simple_animal/hostile/bullet_act(var/obj/item/projectile/Proj)
	var/oldhealth = health
	. = ..()
	if(!target_mob && health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = Proj.firer
		//MoveToTarget()
		stance = HOSTILE_STANCE_ATTACK
		Life()

/mob/living/simple_animal/hostile/proc/OpenFire(target_mob)
	RangedAttack(target_mob)
	stance = HOSTILE_STANCE_IDLE
	target_mob = null

/mob/living/simple_animal/hostile/proc/Shoot(var/target, var/start, var/user, var/bullet = 0)
	if(target == start)
		return
	var/projtype_use = projectiletype
	var/projsound_use = projectilesound
	if(using_vehicle_gun)
		projtype_use = using_vehicle_gun.projectile_fired
		projsound_use = using_vehicle_gun.fire_sound

	var/obj/item/projectile/A = new projtype_use(user:loc)
	A.permutated += user:loc
	playsound(user, projsound_use, 100, 1)
	if(!A)	return
	var/def_zone = get_exposed_defense_zone(target)
	A.launch(target, def_zone)

GLOBAL_LIST_INIT(hostile_attackables, list(\
	/obj/structure/window,\
	/obj/structure/closet,\
	/obj/structure/table,\
	/obj/structure/grille,\
	/obj/structure/girder,\
	/obj/structure/tanktrap,\
	/obj/structure/barricade,\
	/obj/structure/barricadeunsc,\
	/obj/structure/sandbag
))

/mob/living/simple_animal/hostile/proc/DestroySurroundings()
	if(prob(break_stuff_probability))
		for(var/checkdir in GLOB.cardinal) // North, South, East, West
			var/obj/effect/shield/S = locate(/obj/effect/shield, get_step(src, checkdir))
			if(S && S.gen && S.gen.check_flag(MODEFLAG_NONHUMANS))
				S.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
				return
			for(var/obj/structure/window/obstacle in get_step(src, checkdir))
				if(obstacle.dir == GLOB.reverse_dir[checkdir]) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, checkdir))
			if(obstacle && CheckDestroyAllowed(obstacle))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)

/mob/living/simple_animal/hostile/proc/CheckDestroyAllowed(var/obj/to_destroy)
	. = 0
	for(var/path in GLOB.hostile_attackables)
		if(istype(to_destroy,path))
			. = 1
			break
