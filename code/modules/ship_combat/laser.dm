/obj/machinery/space_battle/laser_emitter
	name = "laser emitter"
	var/obj/item/projectile/beam/ship_laser/laser_type
	var/list/laser_types = list(/obj/item/projectile/beam/ship_laser/weak = list(10, 5, 800, 720, "Weak Laser"), /obj/item/projectile/beam/ship_laser/anti_personnel = list(12, 5, 4800, 720, "Anti-Personnel Laser"))

	var/laser_name = "NULL"
	var/max_amount = 0
	var/fire_delay = 0
	var/shot_cost = 0
	var/wait_time = 0

	var/next_fire_time = 0

	var/obj/machinery/space_battle/computer/targeting/laser/computer
	icon_state = "laser_emitter"
	min_broken = 4

/obj/machinery/space_battle/laser_emitter/New()
	..()
	change_firemode()

/obj/machinery/space_battle/laser_emitter/proc/change_firemode()
	var/index = (laser_types.Find(laser_type) + 1)
	if(index > laser_types.len)
		index = 1
	laser_type = laser_types[index]
	var/list/laser_settings = laser_types[laser_type]
	max_amount = laser_settings[1]
	fire_delay = laser_settings[2]
	shot_cost = laser_settings[3]
	wait_time = laser_settings[4]
	laser_name = laser_settings[5]
	return "<span class='notice'>Laser Mode set to: [laser_name]</span>"

/obj/machinery/space_battle/laser_emitter/proc/fire_at(atom/target as mob|obj|turf, var/params, turf/start, amount = 1, var/mob/user)
	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return
	var/power_draw = amount*shot_cost*get_efficiency(-1,1)
	var/turf/T = src.loc
	var/datum/powernet/powernet
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)	powernet = C.powernet
	if(!powernet || powernet.avail < power_draw)
		return "ERROR: Insufficient power! ([powernet.avail]w/[power_draw]w)"
	powernet.draw_power(power_draw)
	var/lasers = amount
	var/shoot_time = (lasers)*fire_delay
	user.setClickCooldown(shoot_time) //no clicking on things while shooting
	next_fire_time = world.time + shoot_time
	while(lasers)
		var/obj/item/projectile/beam/ship_laser/L = new laser_type(src)
		var/obj/effect/overmap/O = map_sectors["[start.z]"]
		if(O.shielding)
			if(O.shielding.take_damage(L.damage))
				qdel(L)
				return "Laser was intercepted by shielding!"
		L.set_clickpoint(params)
		L.loc = get_turf(start) //move the projectile out into the world
		L.launch(target, pick("chest", "head"), 0, 0, 0)
		lasers -= 1
		playsound(user, L.fire_sound, 5, 1)
		sleep(fire_delay)
	return "<span class='notice'>Success!</span>"


/obj/item/projectile/beam/ship_laser
	name = "laser"
	desc = "It hurts your eyes just looking at it."
	damage = 50
	var/list/hit_types = list(/mob/living = 100, /turf/simulated/wall = 100, /obj/machinery = 100, /obj/structure = 100)
	muzzle_type = /obj/effect/projectile/laser_pulse/muzzle
	tracer_type = /obj/effect/projectile/laser_pulse/tracer
	impact_type = /obj/effect/projectile/laser_pulse/impact
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/projectile/beam/ship_laser/Bump(atom/A as mob|obj|turf|area)
	for(var/T in hit_types)
		if(istype(A, T))
			if(prob(hit_types[T]))
				if(!(istype(A, /mob/living)))
					on_hit(A)
				return ..()
	if(istype(A, /turf))
		loc = A
	else
		loc = A.loc
	return 1

/obj/item/projectile/beam/ship_laser/on_hit(var/atom/target)
	..()

/obj/item/projectile/beam/ship_laser/weak
	damage = 30

/obj/item/projectile/beam/ship_laser/strong
	damage = 70

/obj/item/projectile/beam/ship_laser/strong/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		target.ex_act(pick(2,3))
	..()

/obj/item/projectile/beam/ship_laser/destroyer
	damage = 100

/obj/item/projectile/beam/ship_laser/strong/on_hit(var/atom/target, var/blocked = 0)
	target.ex_act(1)
	..()

/obj/item/projectile/beam/ship_laser/anti_personnel
	damage = 25
	weaken = 5
	stun = 10
	stutter = 10
	hit_types = list(/mob/living = 90, /turf/simulated/wall = 20, /obj/machinery = 40, /obj/structure = 20)

/obj/item/projectile/beam/ship_laser/emp
	damage = 10
	stutter = 2
	hit_types = list(/mob/living = 30, /turf/simulated/wall = 20, /obj/machinery = 90, /obj/structure = 20)

/obj/item/projectile/beam/ship_laser/emp/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /obj/machinery))
		empulse(target, 1, 2)
	..()

/obj/item/projectile/beam/ship_laser/emp/heavy
	damage = 15
	stutter = 5
	hit_types = list(/mob/living = 65, /turf/simulated/wall = 25, /obj/machinery = 100, /obj/structure = 25)

/obj/item/projectile/beam/ship_laser/emp/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /obj/machinery))
		empulse(target, 2, rand(1,4))
	..()

/obj/item/projectile/beam/ship_laser/microwave
	damage = 5
	stutter = 2
	hit_types = list(/mob/living = 30, /turf/simulated/wall = 20, /obj/machinery = 90, /obj/structure = 20)

/obj/item/projectile/beam/ship_laser/microwave/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /obj/machinery))
		var/obj/machinery/M = target
		if(M.has_circuit && M.circuit_board)
			var/obj/item/upgrade_module/circuit = M.circuit_board
			circuit.scramble(1)
			empulse(target, 1, 2)
	..()

/obj/item/projectile/beam/ship_laser/piercing
	damage = 40
	weaken = 3
	hit_types = list(/mob/living = 70, /turf/simulated/wall = 5, /obj/machinery = 70, /obj/structure = 45)

/obj/item/projectile/beam/ship_laser/kinetic
	damage = 30
	damage_type = BRUTE
	stutter = 2
	weaken = 5
	hit_types = list(/mob/living = 100, /turf/simulated/wall = 20, /obj/machinery = 50, /obj/structure = 20)

/obj/item/projectile/beam/ship_laser/kinetic/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/))
		target.visible_message("<span class='warning'>\The [target] gets sent flying back!</span>")
		src.throw_at(get_edge_target_turf(src,dir),1,100)
	..()

/obj/item/projectile/beam/ship_laser/thermal
	damage = 30
	damage_type = BURN
	stutter = 2
	weaken = 5
	hit_types = list(/mob/living = 100, /turf/simulated/wall = 20, /obj/machinery = 80, /obj/structure = 80)

/obj/item/projectile/beam/ship_laser/thermal/on_hit(var/atom/target, var/blocked = 0)
	var/turf/T = get_turf(target)
	if(T)
		T.hotspot_expose(1000,500,1)
	..()

/obj/machinery/space_battle/laser_emitter/fenrir
	name = "\improper Fenrir 2X3Z"
	desc = "A light anti-personnel weapon normally used to deter fighter crafts."
	laser_type = /obj/item/projectile/beam/ship_laser/weak
	laser_name = "Weak Laser"
	max_amount = 10
	fire_delay = 5
	shot_cost = 1000
	wait_time = 600
	laser_types = list(/obj/item/projectile/beam/ship_laser/weak = list(10, 5, 1000, 15, "Weak Laser"), /obj/item/projectile/beam/ship_laser/anti_personnel = list(12, 5, 6000, 60, "Anti-Personnel Laser"))

/obj/machinery/space_battle/laser_emitter/fenrir/two
	name = "\improper Fenrir 2X3Z-B"
	desc = "A light anti-personnel weapon normally used to deter fighter crafts. This is a more efficient variant."
	laser_types = list(/obj/item/projectile/beam/ship_laser/weak = list(10, 5, 800, 10, "Weak Laser"), /obj/item/projectile/beam/ship_laser/anti_personnel = list(12, 5, 4800, 50, "Anti-Personnel Laser"))

/obj/machinery/space_battle/laser_emitter/destroyer
	name = "\improper Hercules Mk I"
	desc = "A heavy laser cannon, made to bore through enemy ships."
	laser_type = /obj/item/projectile/beam/ship_laser/destroyer
	laser_name = "Weak Laser"
	max_amount = 1
	fire_delay = 5
	shot_cost = 20000
	wait_time = 1200
	laser_types = list(/obj/item/projectile/beam/ship_laser/destroyer = list(1, 5, 20000, 400, "Destroyer Type Laser"))

/obj/machinery/space_battle/laser_emitter/ion
	name = "\improper Zeus X-380 Mk I"
	desc = "A distruptive laser weapon."
	laser_type = /obj/item/projectile/beam/ship_laser/emp
	laser_name = "Ionic Laser"
	max_amount = 3
	fire_delay = 10
	shot_cost = 10000
	wait_time = 900
	laser_types = list(/obj/item/projectile/beam/ship_laser/emp = list(3, 10, 10000, 900, "Ionic Laser"), /obj/item/projectile/beam/ship_laser/emp/heavy = list(1, 10, 15000, 1200, "Heavy Ionic Laser"))

/obj/machinery/space_battle/laser_emitter/ion/two
	name = "\improper Zeus X-380 Mk I"
	desc = "A distruptive laser weapon."
	laser_type = /obj/item/projectile/beam/ship_laser/emp
	laser_name = "Ionic Laser"
	max_amount = 3
	fire_delay = 10
	shot_cost = 8000
	wait_time = 720
	laser_types = list(/obj/item/projectile/beam/ship_laser/emp = list(3, 10, 8000, 300, "Ionic Laser"), /obj/item/projectile/beam/ship_laser/emp/heavy = list(1, 10, 12000, 600, "Heavy Ionic Laser"))

/obj/machinery/space_battle/laser_emitter/hades
	name = "\improper Hades Mk I"
	desc = "A fiery weapon of destruction."
	laser_type = /obj/item/projectile/beam/ship_laser/thermal
	laser_name = "Thermal Beam"
	max_amount = 2
	fire_delay = 10
	shot_cost = 15000
	wait_time = 800
	laser_types = list(/obj/item/projectile/beam/ship_laser/thermal = list(2, 10, 15000, 300, "Thermal Beam"), /obj/item/projectile/beam/ship_laser/piercing = list(1, 10, 12000, 200, "Piercing Beam"))

/obj/machinery/space_battle/laser_emitter/generic
	name = "\improper Thriller Mk I"
	desc = "A rather mundane laser arnament."
	laser_type = /obj/item/projectile/beam/ship_laser/weak
	laser_name = "Weak Laser"
	max_amount = 10
	fire_delay = 10
	shot_cost = 1000
	wait_time = 600
	laser_types = list(/obj/item/projectile/beam/ship_laser/weak = list(10, 10, 1000, 20, "Weak Laser"), /obj/item/projectile/beam/ship_laser/strong = list(1, 10, 10000, 100, "Strong Laser"))
