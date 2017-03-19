/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	name = "hydraulic clamp"
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 1 KILOWATTS
	var/dam_force = 20
	var/obj/mecha/working/ripley/cargo_holder
	required_type = /obj/mecha/working

	attach(obj/mecha/M as obj)
		..()
		cargo_holder = M
		return

	action(atom/target)
		if(!action_checks(target)) return
		if(!cargo_holder) return

		//loading
		if(istype(target,/obj))
			var/obj/O = target
			if(O.buckled_mob)
				return
			if(locate(/mob/living) in O)
				occupant_message("<span class='warning'>You can't load living things into the cargo compartment.</span>")
				return
			if(O.anchored)
				occupant_message("<span class='warning'>[target] is firmly secured.</span>")
				return
			if(cargo_holder.cargo.len >= cargo_holder.cargo_capacity)
				occupant_message("<span class='warning'>Not enough room in cargo compartment.</span>")
				return

			occupant_message("You lift [target] and start to load it into cargo compartment.")
			chassis.visible_message("[chassis] lifts [target] and starts to load it into cargo compartment.")
			set_ready_state(0)
			chassis.use_power(energy_drain)
			O.anchored = 1
			var/T = chassis.loc
			if(do_after_cooldown(target))
				if(T == chassis.loc && src == chassis.selected)
					cargo_holder.cargo += O
					O.loc = chassis
					O.anchored = 0
					occupant_message("<span class='notice'>[target] succesfully loaded.</span>")
					log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - cargo_holder.cargo.len]")
				else
					occupant_message("<span class='warning'>You must hold still while handling objects.</span>")
					O.anchored = initial(O.anchored)

		//attacking
		else if(istype(target,/mob/living))
			var/mob/living/M = target
			if(M.stat>1) return
			if(chassis.occupant.a_intent == I_HURT)
				M.take_overall_damage(dam_force)
				M.adjustOxyLoss(round(dam_force/2))
				M.updatehealth()
				occupant_message("<span class='warning'>You squeeze [target] with [src.name]. Something cracks.</span>")
				chassis.visible_message("<span class='warning'>[chassis] squeezes [target].</span>")
			else
				step_away(M,chassis)
				occupant_message("You push [target] out of the way.")
				chassis.visible_message("[chassis] pushes [target] out of the way.")
			set_ready_state(0)
			chassis.use_power(energy_drain)
			do_after_cooldown()
		return 1

/obj/item/mecha_parts/mecha_equipment/tool/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens! (Can be attached to: Combat and Engineering Exosuits)"
	icon_state = "mecha_drill"
	equip_cooldown = 30
	energy_drain = 10
	force = 15
	required_type = list(/obj/mecha/working/ripley, /obj/mecha/combat)

	action(atom/target)
		if(!action_checks(target)) return
		if(isobj(target))
			var/obj/target_obj = target
			if(!target_obj.vars.Find("unacidable") || target_obj.unacidable)	return
		set_ready_state(0)
		chassis.use_power(energy_drain)
		chassis.visible_message("<span class='danger'>\The [chassis] starts to drill \the [target]</span>", "<span class='warning'>You hear a large drill.</span>")
		occupant_message("<span class='danger'>You start to drill \the [target]</span>")
		var/T = chassis.loc
		var/C = target.loc	//why are these backwards? we may never know -Pete
		if(do_after_cooldown(target))
			if(T == chassis.loc && src == chassis.selected)
				if(istype(target, /turf/simulated/wall))
					var/turf/simulated/wall/W = target
					if(W.reinf_material)
						occupant_message("<span class='warning'>\The [target] is too durable to drill through.</span>")
					else
						log_message("Drilled through \the [target]")
						target.ex_act(2)
				else if(istype(target, /turf/simulated/mineral))
					for(var/turf/simulated/mineral/M in range(chassis,1))
						if(get_dir(chassis,M)&chassis.dir)
							M.GetDrilled()
					log_message("Drilled through \the [target]")
					if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
						var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
						if(ore_box)
							for(var/obj/item/weapon/ore/ore in range(chassis,1))
								if(get_dir(chassis,ore)&chassis.dir)
									ore.Move(ore_box)
				else if(istype(target, /turf/simulated/floor/asteroid))
					for(var/turf/simulated/floor/asteroid/M in range(chassis,1))
						if(get_dir(chassis,M)&chassis.dir)
							M.gets_dug()
					log_message("Drilled through \the [target]")
					if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
						var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
						if(ore_box)
							for(var/obj/item/weapon/ore/ore in range(chassis,1))
								if(get_dir(chassis,ore)&chassis.dir)
									ore.Move(ore_box)
				else if(target.loc == C)
					log_message("Drilled through \the [target]")
					target.ex_act(2)
		return 1

/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill
	name = "diamond drill"
	desc = "This is an upgraded version of the drill that'll pierce the heavens! (Can be attached to: Combat and Engineering Exosuits)"
	icon_state = "mecha_diamond_drill"
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	equip_cooldown = 20
	force = 15

	action(atom/target)
		if(!action_checks(target)) return
		if(isobj(target))
			var/obj/target_obj = target
			if(target_obj.unacidable)	return
		set_ready_state(0)
		chassis.use_power(energy_drain)
		chassis.visible_message("<span class='danger'>\The [chassis] starts to drill \the [target]</span>", "<span class='warning'>You hear a large drill.</span>")
		occupant_message("<span class='danger'>You start to drill \the [target]</span>")
		var/T = chassis.loc
		var/C = target.loc	//why are these backwards? we may never know -Pete
		if(do_after_cooldown(target))
			if(T == chassis.loc && src == chassis.selected)
				if(istype(target, /turf/simulated/wall))
					var/turf/simulated/wall/W = target
					if(!W.reinf_material || do_after_cooldown(target))//To slow down how fast mechs can drill through the station
						log_message("Drilled through \the [target]")
						target.ex_act(3)
				else if(istype(target, /turf/simulated/mineral))
					for(var/turf/simulated/mineral/M in range(chassis,1))
						if(get_dir(chassis,M)&chassis.dir)
							M.GetDrilled()
					log_message("Drilled through \the [target]")
					if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
						var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
						if(ore_box)
							for(var/obj/item/weapon/ore/ore in range(chassis,1))
								if(get_dir(chassis,ore)&chassis.dir)
									ore.Move(ore_box)
				else if(istype(target,/turf/simulated/floor/asteroid))
					for(var/turf/simulated/floor/asteroid/M in range(target,1))
						M.gets_dug()
					log_message("Drilled through \the [target]")
					if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
						var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
						if(ore_box)
							for(var/obj/item/weapon/ore/ore in range(target,1))
								ore.Move(ore_box)
				else if(target.loc == C)
					log_message("Drilled through \the [target]")
					target.ex_act(2)
		return 1

/obj/item/mecha_parts/mecha_equipment/tool/extinguisher
	name = "extinguisher"
	desc = "Exosuit-mounted extinguisher (Can be attached to: Engineering exosuits)"
	icon_state = "mecha_exting"
	equip_cooldown = 5
	energy_drain = 0
	range = MELEE|RANGED
	required_type = /obj/mecha/working
	var/spray_particles = 5
	var/spray_amount = 5	//units of liquid per particle. 5 is enough to wet the floor - it's a big fire extinguisher, so should be fine
	var/max_water = 1000

	New()
		reagents = new/datum/reagents(max_water)
		reagents.my_atom = src
		reagents.add_reagent("water", max_water)
		..()
		return

	action(atom/target) //copypasted from extinguisher. TODO: Rewrite from scratch.
		if(!action_checks(target) || get_dist(chassis, target)>3) return
		if(get_dist(chassis, target)>2) return
		set_ready_state(0)
		if(do_after_cooldown(target))
			if( istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(chassis,target) <= 1)
				var/obj/o = target
				var/amount = o.reagents.trans_to_obj(src, 200)
				occupant_message("<span class='notice'>[amount] units transferred into internal tank.</span>")
				playsound(chassis, 'sound/effects/refill.ogg', 50, 1, -6)
				return

			if (src.reagents.total_volume < 1)
				occupant_message("<span class='warning'>\The [src] is empty.</span>")
				return

			playsound(chassis, 'sound/effects/extinguish.ogg', 75, 1, -3)

			var/direction = get_dir(chassis,target)

			var/turf/T = get_turf(target)
			var/turf/T1 = get_step(T,turn(direction, 90))
			var/turf/T2 = get_step(T,turn(direction, -90))

			var/list/the_targets = list(T,T1,T2)

			for(var/a = 1 to 5)
				spawn(0)
					var/obj/effect/effect/water/W = new /obj/effect/effect/water(get_turf(chassis))
					var/turf/my_target
					if(a == 1)
						my_target = T
					else if(a == 2)
						my_target = T1
					else if(a == 3)
						my_target = T2
					else
						my_target = pick(the_targets)
					W.create_reagents(5)
					if(!W || !src)
						return
					reagents.trans_to_obj(W, spray_amount)
					W.set_color()
					W.set_up(my_target)
			return 1

	get_equip_info()
		return "[..()] \[[src.reagents.total_volume]\]"

	on_reagent_change()
		return


/obj/item/mecha_parts/mecha_equipment/tool/rcd
	name = "mounted RCD"
	desc = "An exosuit-mounted Rapid Construction Device. (Can be attached to: Any exosuit)"
	icon_state = "mecha_rcd"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4)
	equip_cooldown = 10
	energy_drain = 25 KILOWATTS
	range = MELEE|RANGED
	var/mode = 0 //0 - deconstruct, 1 - wall or floor, 2 - airlock.
	var/disabled = 0 //malf

	action(atom/target)
		if(istype(target,/area/shuttle)||istype(target, /turf/space/transit))//>implying these are ever made -Sieve
			disabled = 1
		else
			disabled = 0
		if(!istype(target, /turf) && !istype(target, /obj/machinery/door/airlock))
			target = get_turf(target)
		if(!action_checks(target) || disabled || get_dist(chassis, target)>3) return
		playsound(chassis, 'sound/machines/click.ogg', 50, 1)
		//meh
		switch(mode)
			if(0)
				if (istype(target, /turf/simulated/wall))
					occupant_message("Deconstructing [target]...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						chassis.spark_system.start()
						target:ChangeTurf(/turf/simulated/floor/plating)
						playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
						chassis.use_power(energy_drain)
				else if (istype(target, /turf/simulated/floor))
					occupant_message("Deconstructing [target]...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						chassis.spark_system.start()
						target:ChangeTurf(get_base_turf_by_area(target))
						playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
						chassis.use_power(energy_drain)
				else if (istype(target, /obj/machinery/door/airlock))
					occupant_message("Deconstructing [target]...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						chassis.spark_system.start()
						qdel(target)
						playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
						chassis.use_power(energy_drain)
			if(1)
				if(istype(target, /turf/space) || istype(target,get_base_turf_by_area(target)))
					occupant_message("Building Floor...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						target:ChangeTurf(/turf/simulated/floor/plating)
						playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
						chassis.spark_system.start()
						chassis.use_power(energy_drain*2)
				else if(istype(target, /turf/simulated/floor))
					occupant_message("Building Wall...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						target:ChangeTurf(/turf/simulated/wall)
						playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
						chassis.spark_system.start()
						chassis.use_power(energy_drain*2)
			if(2)
				if(istype(target, /turf/simulated/floor))
					occupant_message("Building Airlock...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						chassis.spark_system.start()
						var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock(target)
						T.autoclose = 1
						playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
						playsound(target, 'sound/effects/sparks2.ogg', 50, 1)
						chassis.use_power(energy_drain*2)
		return


	Topic(href,href_list)
		..()
		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			switch(mode)
				if(0)
					occupant_message("Switched RCD to Deconstruct.")
				if(1)
					occupant_message("Switched RCD to Construct.")
				if(2)
					occupant_message("Switched RCD to Construct Airlock.")
		return

	get_equip_info()
		return "[..()] \[<a href='?src=\ref[src];mode=0'>D</a>|<a href='?src=\ref[src];mode=1'>C</a>|<a href='?src=\ref[src];mode=2'>A</a>\]"




/obj/item/mecha_parts/mecha_equipment/teleporter
	name = "teleporter"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	icon_state = "mecha_teleport"
	origin_tech = list(TECH_BLUESPACE = 10)
	equip_cooldown = 150
	energy_drain = 200 KILOWATTS
	range = RANGED

/obj/item/mecha_parts/mecha_equipment/teleporter/action(atom/target)
	if(!action_checks(target)) return
	var/turf/T = get_turf(target)
	if(T)
		if(isAdminLevel(T.z))
			return		
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_teleport(chassis, T, 4)
		do_after_cooldown()


/obj/item/mecha_parts/mecha_equipment/wormhole_generator
	name = "wormhole generator"
	desc = "An exosuit module that allows generating of small quasi-stable wormholes."
	icon_state = "mecha_wholegen"
	origin_tech = list(TECH_BLUESPACE = 3)
	equip_cooldown = 50
	energy_drain = 50 KILOWATTS
	range = RANGED


	action(atom/target)
		if(!action_checks(target) || src.loc.z == 2) return
		var/list/theareas = list()
		for(var/area/AR in orange(100, chassis))
			if(AR in theareas) continue
			theareas += AR
		if(!theareas.len)
			return
		var/area/thearea = pick(theareas)
		var/list/L = list()
		var/turf/pos = get_turf(src)
		for(var/turf/T in get_area_turfs(thearea))
			if(!T.density && pos.z == T.z)
				var/clear = 1
				for(var/obj/O in T)
					if(O.density)
						clear = 0
						break
				if(clear)
					L+=T
		if(!L.len)
			return
		var/turf/target_turf = pick(L)
		if(!target_turf)
			return
		chassis.use_power(energy_drain)
		set_ready_state(0)
		var/obj/effect/portal/P = new /obj/effect/portal(get_turf(target))
		P.target = target_turf
		P.creator = null
		P.icon = 'icons/obj/objects.dmi'
		P.failchance = 0
		P.icon_state = "anom"
		P.name = "wormhole"
		do_after_cooldown()
		src = null
		spawn(rand(150,300))
			qdel(P)
		return

/obj/item/mecha_parts/mecha_equipment/gravcatapult
	name = "gravitational catapult"
	desc = "An exosuit mounted Gravitational Catapult."
	icon_state = "mecha_teleport"
	origin_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3)
	equip_cooldown = 10
	energy_drain = 10 KILOWATTS
	range = MELEE|RANGED
	var/atom/movable/locked
	var/mode = 1 //1 - gravsling 2 - gravpush

	var/last_fired = 0  //Concept stolen from guns.
	var/fire_delay = 10 //Used to prevent spam-brute against humans.

	action(atom/movable/target)

		if(world.time >= last_fired + fire_delay)
			last_fired = world.time
		else
			if (world.time % 3)
				occupant_message("<span class='warning'>[src] is not ready to fire again!</span>")
			return 0

		switch(mode)
			if(1)
				if(!action_checks(target) && !locked) return
				if(!locked)
					if(!istype(target) || target.anchored)
						occupant_message("Unable to lock on [target]")
						return
					locked = target
					occupant_message("Locked on [target]")
					send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
					return
				else if(target!=locked)
					if(locked in view(chassis))
						locked.throw_at(target, 14, 1.5, chassis)
						locked = null
						send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
						set_ready_state(0)
						chassis.use_power(energy_drain)
						do_after_cooldown()
					else
						locked = null
						occupant_message("Lock on [locked] disengaged.")
						send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
			if(2)
				if(!action_checks(target)) return
				var/list/atoms = list()
				if(isturf(target))
					atoms = range(target,3)
				else
					atoms = orange(target,3)
				for(var/atom/movable/A in atoms)
					if(A.anchored) continue
					spawn(0)
						var/iter = 5-get_dist(A,target)
						for(var/i=0 to iter)
							step_away(A,target)
							sleep(2)
				set_ready_state(0)
				chassis.use_power(energy_drain)
				do_after_cooldown()
		return

	get_equip_info()
		return "[..()] [mode==1?"([locked||"Nothing"])":null] \[<a href='?src=\ref[src];mode=1'>S</a>|<a href='?src=\ref[src];mode=2'>P</a>\]"

	Topic(href, href_list)
		..()
		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
		return


/obj/item/mecha_parts/mecha_equipment/armor_booster
	name = "armor booster"
	desc = "Powered armor-enhancing mech equipment."
	icon_state = "mecha_abooster_proj"
	equip_cooldown = 10
	energy_drain = 5 KILOWATTS
	range = 0
	var/deflect_coeff = 1
	var/damage_coeff = 1
	var/melee

	attach(obj/mecha/M as obj)
		..()
		activate_boost()
		return

	detach()
		if(equip_ready)
			deactivate_boost()
		..()
		return

	get_equip_info()
		if(!chassis) return
		return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name]"

	proc/activate_boost()
		if(!src.chassis)
			return 0
		return 1

	proc/deactivate_boost()
		if(!src.chassis)
			return 0
		return 1

	set_ready_state(state)
		if(state && !equip_ready)
			activate_boost()
		else if(equip_ready)
			deactivate_boost()
		..()


/obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster //what is that noise? A BAWWW from TK mutants.
	name = "\improper CCW armor booster"
	desc = "Close-combat armor booster. Boosts exosuit armor against armed melee attacks. Requires energy to operate."
	icon_state = "mecha_abooster_ccw"
	origin_tech = list(TECH_MATERIAL = 3)
	deflect_coeff = 1.15
	damage_coeff = 0.8
	melee = 1

	activate_boost()
		if(..())
			chassis.m_deflect_coeff *= deflect_coeff
			chassis.m_damage_coeff *= damage_coeff
			chassis.mhit_power_use += energy_drain


	deactivate_boost()
		if(..())
			chassis.m_deflect_coeff /= deflect_coeff
			chassis.m_damage_coeff /= damage_coeff
			chassis.mhit_power_use -= energy_drain


/obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster
	name = "\improper RW armor booster"
	desc = "Ranged-weaponry armor booster. Boosts exosuit armor against ranged attacks. Completely blocks taser shots, but requires energy to operate."
	icon_state = "mecha_abooster_proj"
	origin_tech = list(TECH_MATERIAL = 4)
	deflect_coeff = 1.15
	damage_coeff = 0.8
	melee = 0

	activate_boost()
		if(..())
			chassis.r_deflect_coeff *= deflect_coeff
			chassis.r_damage_coeff *= damage_coeff
			chassis.rhit_power_use += energy_drain

	deactivate_boost()
		if(..())
			chassis.r_deflect_coeff /= deflect_coeff
			chassis.r_damage_coeff /= damage_coeff
			chassis.rhit_power_use -= energy_drain


/obj/item/mecha_parts/mecha_equipment/repair_droid
	name = "repair droid"
	desc = "Automated repair droid. Scans exosuit for damage and repairs it. Can fix almost any type of external or internal damage."
	icon_state = "repair_droid"
	origin_tech = list(TECH_MAGNET = 3, TECH_DATA = 3)
	equip_cooldown = 20
	energy_drain = 10 KILOWATTS
	range = 0
	var/health_boost = 2
	var/datum/global_iterator/pr_repair_droid
	var/icon/droid_overlay
	var/list/repairable_damage = list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH)

	New()
		..()
		pr_repair_droid = new /datum/global_iterator/mecha_repair_droid(list(src),0)
		pr_repair_droid.set_delay(equip_cooldown)
		return

	Destroy()
		qdel(pr_repair_droid)
		pr_repair_droid = null
		..()

	attach(obj/mecha/M as obj)
		..()
		droid_overlay = new(src.icon, icon_state = "repair_droid")
		M.overlays += droid_overlay
		return

	destroy()
		chassis.overlays -= droid_overlay
		..()
		return

	detach()
		chassis.overlays -= droid_overlay
		pr_repair_droid.stop()
		..()
		return

	get_equip_info()
		if(!chassis) return
		return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_repairs=1'>[pr_repair_droid.active()?"Dea":"A"]ctivate</a>"


	Topic(href, href_list)
		..()
		if(href_list["toggle_repairs"])
			chassis.overlays -= droid_overlay
			if(pr_repair_droid.toggle())
				droid_overlay = new(src.icon, icon_state = "repair_droid_a")
				log_message("Activated.")
			else
				droid_overlay = new(src.icon, icon_state = "repair_droid")
				log_message("Deactivated.")
				set_ready_state(1)
			chassis.overlays += droid_overlay
			send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
		return


/datum/global_iterator/mecha_repair_droid

	process(var/obj/item/mecha_parts/mecha_equipment/repair_droid/RD as obj)
		if(!RD.chassis)
			stop()
			RD.set_ready_state(1)
			return
		var/health_boost = RD.health_boost
		var/repaired = 0
		if(RD.chassis.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
			health_boost *= -2
		else if(RD.chassis.hasInternalDamage() && prob(15))
			for(var/int_dam_flag in RD.repairable_damage)
				if(RD.chassis.hasInternalDamage(int_dam_flag))
					RD.chassis.clearInternalDamage(int_dam_flag)
					repaired = 1
					break
		if(health_boost<0 || RD.chassis.health < initial(RD.chassis.health))
			RD.chassis.health += min(health_boost, initial(RD.chassis.health)-RD.chassis.health)
			repaired = 1
		if(repaired)
			if(RD.chassis.use_power(RD.energy_drain))
				RD.set_ready_state(0)
			else
				stop()
				RD.set_ready_state(1)
				return
		else
			RD.set_ready_state(1)
		return


/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	name = "energy relay"
	desc = "Wirelessly drains energy from any available power channel in area. The performance index is quite low."
	icon_state = "tesla"
	origin_tech = list(TECH_MAGNET = 4, TECH_ILLEGAL = 2)
	equip_cooldown = 10
	energy_drain = 0
	range = 0
	var/datum/global_iterator/pr_energy_relay
	var/coeff = 100
	var/list/use_channels = list(EQUIP,ENVIRON,LIGHT)

	New()
		..()
		pr_energy_relay = new /datum/global_iterator/mecha_energy_relay(list(src),0)
		pr_energy_relay.set_delay(equip_cooldown)
		return

	Destroy()
		qdel(pr_energy_relay)
		pr_energy_relay = null
		..()

	detach()
		pr_energy_relay.stop()
		..()
		return

	attach(obj/mecha/M)
		..()
		return

	proc/get_power_channel(var/area/A)
		var/pow_chan
		if(A)
			for(var/c in use_channels)
				if(A.powered(c))
					pow_chan = c
					break
		return pow_chan

	Topic(href, href_list)
		..()
		if(href_list["toggle_relay"])
			if(pr_energy_relay.toggle())
				set_ready_state(0)
				log_message("Activated.")
			else
				set_ready_state(1)
				log_message("Deactivated.")
		return

	get_equip_info()
		if(!chassis) return
		return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_relay=1'>[pr_energy_relay.active()?"Dea":"A"]ctivate</a>"

/datum/global_iterator/mecha_energy_relay

	process(var/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/ER)
		if(!ER.chassis || ER.chassis.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
			stop()
			ER.set_ready_state(1)
			return
		var/cur_charge = ER.chassis.get_charge()
		if(isnull(cur_charge) || !ER.chassis.cell)
			stop()
			ER.set_ready_state(1)
			ER.occupant_message("No powercell detected.")
			return
		if(cur_charge<ER.chassis.cell.maxcharge)
			var/area/A = get_area(ER.chassis)
			if(A)
				var/pow_chan
				for(var/c in list(EQUIP,ENVIRON,LIGHT))
					if(A.powered(c))
						pow_chan = c
						break
				if(pow_chan)
					var/delta = min(12, ER.chassis.cell.maxcharge-cur_charge)
					ER.chassis.give_power(delta)
					A.use_power(delta*ER.coeff, pow_chan)
		return



/obj/item/mecha_parts/mecha_equipment/generator
	name = "phoron generator"
	desc = "Generates power using solid phoron as fuel. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = list(TECH_PHORON = 2, TECH_POWER = 2, TECH_ENGINEERING = 1)
	equip_cooldown = 10
	energy_drain = 0
	range = MELEE
	var/datum/global_iterator/pr_mech_generator
	var/coeff = 100
	var/obj/item/stack/material/fuel
	var/max_fuel = 150000
	var/fuel_per_cycle_idle = 100
	var/fuel_per_cycle_active = 500
	var/power_per_cycle = 1 KILOWATTS

	New()
		..()
		init()
		return

	Destroy()
		qdel(pr_mech_generator)
		pr_mech_generator = null
		..()

	proc/init()
		fuel = new /obj/item/stack/material/phoron(src)
		fuel.amount = 0
		pr_mech_generator = new /datum/global_iterator/mecha_generator(list(src),0)
		pr_mech_generator.set_delay(equip_cooldown)
		return

	detach()
		pr_mech_generator.stop()
		..()
		return


	Topic(href, href_list)
		..()
		if(href_list["toggle"])
			if(pr_mech_generator.toggle())
				set_ready_state(0)
				log_message("Activated.")
			else
				set_ready_state(1)
				log_message("Deactivated.")
		return

	get_equip_info()
		var/output = ..()
		if(output)
			return "[output] \[[fuel]: [round(fuel.amount*fuel.perunit,0.1)] cm<sup>3</sup>\] - <a href='?src=\ref[src];toggle=1'>[pr_mech_generator.active()?"Dea":"A"]ctivate</a>"
		return

	action(target)
		if(chassis)
			var/result = load_fuel(target)
			var/message
			if(isnull(result))
				message = "<span class='warning'>[fuel] traces in target minimal. [target] cannot be used as fuel.</span>"
			else if(!result)
				message = "Unit is full."
			else
				message = "[result] unit\s of [fuel] successfully loaded."
				send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
			occupant_message(message)
		return

	proc/load_fuel(var/obj/item/stack/material/P)
		if(P.type == fuel.type && P.amount)
			var/to_load = max(max_fuel - fuel.amount*fuel.perunit,0)
			if(to_load)
				var/units = min(max(round(to_load / P.perunit),1),P.amount)
				if(units)
					fuel.amount += units
					P.use(units)
					return units
			else
				return 0
		return

	attackby(weapon,mob/user)
		var/result = load_fuel(weapon)
		if(isnull(result))
			user.visible_message("[user] tries to shove [weapon] into [src]. What a dumb-ass.","<span class='warning'>[fuel] traces minimal. [weapon] cannot be used as fuel.</span>")
		else if(!result)
			to_chat(user, "Unit is full.")
		else
			user.visible_message("[user] loads [src] with [fuel].","[result] unit\s of [fuel] successfully loaded.")
		return

	critfail()
		..()
		var/turf/simulated/T = get_turf(src)
		if(!T)
			return
		var/datum/gas_mixture/GM = new
		if(prob(10))
			T.assume_gas("phoron", 100, 1500+T0C)
			T.visible_message("The [src] suddenly disgorges a cloud of heated phoron.")
			destroy()
		else
			T.assume_gas("phoron", 5, istype(T) ? T.air.temperature : T20C)
			T.visible_message("The [src] suddenly disgorges a cloud of phoron.")
		T.assume_air(GM)
		return

/datum/global_iterator/mecha_generator

	process(var/obj/item/mecha_parts/mecha_equipment/generator/EG)
		if(!EG.chassis)
			stop()
			EG.set_ready_state(1)
			return 0
		if(EG.fuel.amount<=0)
			stop()
			EG.log_message("Deactivated - no fuel.")
			EG.set_ready_state(1)
			return 0
		var/cur_charge = EG.chassis.get_charge()
		if(isnull(cur_charge))
			EG.set_ready_state(1)
			EG.occupant_message("No powercell detected.")
			EG.log_message("Deactivated.")
			stop()
			return 0
		var/use_fuel = EG.fuel_per_cycle_idle
		if(cur_charge<EG.chassis.cell.maxcharge)
			use_fuel = EG.fuel_per_cycle_active
			EG.chassis.give_power(EG.power_per_cycle)
		EG.fuel.amount -= min(use_fuel/EG.fuel.perunit,EG.fuel.amount)
		EG.update_equip_info()
		return 1


/obj/item/mecha_parts/mecha_equipment/generator/nuclear
	name = "\improper ExoNuclear reactor"
	desc = "Generates power using uranium. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	max_fuel = 50000
	fuel_per_cycle_idle = 10
	fuel_per_cycle_active = 30
	power_per_cycle = 5 KILOWATTS
	var/rad_per_cycle = 0.3

	init()
		fuel = new /obj/item/stack/material/uranium(src)
		fuel.amount = 0
		pr_mech_generator = new /datum/global_iterator/mecha_generator/nuclear(list(src),0)
		pr_mech_generator.set_delay(equip_cooldown)
		return

	critfail()
		return

/datum/global_iterator/mecha_generator/nuclear

	process(var/obj/item/mecha_parts/mecha_equipment/generator/nuclear/EG)
		if(..())
			radiation_repository.radiate(EG, (EG.rad_per_cycle * 3))
		return 1



//This is pretty much just for the death-ripley so that it is harmless
/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp
	name = "\improper KILL CLAMP"
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 0
	var/dam_force = 0
	var/obj/mecha/working/ripley/cargo_holder
	required_type = /obj/mecha/working/ripley

	attach(obj/mecha/M as obj)
		..()
		cargo_holder = M
		return

	action(atom/target)
		if(!action_checks(target)) return
		if(!cargo_holder) return
		if(istype(target,/obj))
			var/obj/O = target
			if(!O.anchored)
				if(cargo_holder.cargo.len < cargo_holder.cargo_capacity)
					chassis.occupant_message("You lift [target] and start to load it into cargo compartment.")
					chassis.visible_message("[chassis] lifts [target] and starts to load it into cargo compartment.")
					set_ready_state(0)
					chassis.use_power(energy_drain)
					O.anchored = 1
					var/T = chassis.loc
					if(do_after_cooldown(target))
						if(T == chassis.loc && src == chassis.selected)
							cargo_holder.cargo += O
							O.loc = chassis
							O.anchored = 0
							chassis.occupant_message("<span class='notice'>[target] succesfully loaded.</span>")
							chassis.log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - cargo_holder.cargo.len]")
						else
							chassis.occupant_message("<span class='warning'>You must hold still while handling objects.</span>")
							O.anchored = initial(O.anchored)
				else
					chassis.occupant_message("<span class='warning'>Not enough room in cargo compartment.</span>")
			else
				chassis.occupant_message("<span class='warning'>[target] is firmly secured.</span>")

		else if(istype(target,/mob/living))
			var/mob/living/M = target
			if(M.stat>1) return
			if(chassis.occupant.a_intent == I_HURT)
				chassis.occupant_message("<span class='danger'>You obliterate [target] with [src.name], leaving blood and guts everywhere.</span>")
				chassis.visible_message("<span class='danger'>[chassis] destroys [target] in an unholy fury.</span>")
			if(chassis.occupant.a_intent == I_DISARM)
				chassis.occupant_message("<span class='danger'>You tear [target]'s limbs off with [src.name].</span>")
				chassis.visible_message("<span class='danger'>[chassis] rips [target]'s arms off.</span>")
			else
				step_away(M,chassis)
				chassis.occupant_message("You smash into [target], sending them flying.")
				chassis.visible_message("[chassis] tosses [target] like a piece of paper.")
			set_ready_state(0)
			chassis.use_power(energy_drain)
			do_after_cooldown()
		return 1

/obj/item/mecha_parts/mecha_equipment/tool/passenger
	name = "passenger compartment"
	desc = "A mountable passenger compartment for exo-suits. Rather cramped."
	icon_state = "mecha_abooster_ccw"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	energy_drain = 1 KILOWATTS
	range = MELEE
	equip_cooldown = 20
	var/mob/living/carbon/occupant = null
	var/door_locked = 1
	salvageable = 0

/obj/item/mecha_parts/mecha_equipment/tool/passenger/destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
		to_chat(AM, "<span class='danger'>You tumble out of the destroyed [src.name]!</span>")
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/passenger/Exit(atom/movable/O)
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/passenger/proc/move_inside(var/mob/user)
	if (chassis)
		chassis.visible_message("<span class='notice'>[user] starts to climb into [chassis].</span>")

	if(do_after(user, 40, src, needhand=0))
		if(!src.occupant)
			user.forceMove(src)
			occupant = user
			log_message("\The [user] boarded.")
			occupant_message("\The [user] boarded.")
		else if(src.occupant != user)
			to_chat(user, "<span class='warning'>[src.occupant] was faster. Try better next time, loser.</span>")
	else
		to_chat(user, "You stop entering the exosuit.")

/obj/item/mecha_parts/mecha_equipment/tool/passenger/verb/eject()
	set name = "Eject"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0

	if(usr != occupant)
		return
	to_chat(occupant, "You climb out from \the [src].")
	go_out()
	occupant_message("[occupant] disembarked.")
	log_message("[occupant] disembarked.")
	add_fingerprint(usr)

/obj/item/mecha_parts/mecha_equipment/tool/passenger/proc/go_out()
	if(!occupant)
		return
	occupant.forceMove(get_turf(src))
	occupant = null

/obj/item/mecha_parts/mecha_equipment/tool/passenger/attach()
	..()
	if (chassis)
		chassis.verbs |= /obj/mecha/proc/move_inside_passenger

/obj/item/mecha_parts/mecha_equipment/tool/passenger/detach()
	if(occupant)
		occupant_message("Unable to detach [src] - equipment occupied.")
		return

	var/obj/mecha/M = chassis
	..()
	if (M && !(locate(/obj/item/mecha_parts/mecha_equipment/tool/passenger) in M))
		M.verbs -= /obj/mecha/proc/move_inside_passenger

/obj/item/mecha_parts/mecha_equipment/tool/passenger/get_equip_info()
	return "[..()] <br />[occupant? "\[Occupant: [occupant]\]|" : ""]Exterior Hatch: <a href='?src=\ref[src];toggle_lock=1'>Toggle Lock</a>"

/obj/item/mecha_parts/mecha_equipment/tool/passenger/Topic(href,href_list)
	..()
	if (href_list["toggle_lock"])
		door_locked = !door_locked
		occupant_message("Passenger compartment hatch [door_locked? "locked" : "unlocked"].")
		if (chassis)
			chassis.visible_message("The hatch on \the [chassis] [door_locked? "locks" : "unlocks"].", "You hear something latching.")


#define LOCKED 1
#define OCCUPIED 2

/obj/mecha/proc/move_inside_passenger()
	set category = "Object"
	set name = "Enter Passenger Compartment"
	set src in oview(1)

	//check that usr can climb in
	if (usr.stat || !ishuman(usr))
		return

	if (!usr.Adjacent(src))
		return

	if (!isturf(usr.loc))
		to_chat(usr, "<span class='danger'>You can't reach the passenger compartment from here.</span>")
		return

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			to_chat(usr, "<span class='danger'>Kinda hard to climb in while handcuffed don't you think?</span>")
			return

	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			to_chat(usr, "<span class='danger'>You're too busy getting your life sucked out of you.</span>")
			return

	//search for a valid passenger compartment
	var/feedback = 0 //for nicer user feedback
	for(var/obj/item/mecha_parts/mecha_equipment/tool/passenger/P in src)
		if (P.occupant)
			feedback |= OCCUPIED
			continue
		if (P.door_locked)
			feedback |= LOCKED
			continue

		//found a boardable compartment
		P.move_inside(usr)
		return

	//didn't find anything
	switch (feedback)
		if (OCCUPIED)
			to_chat(usr, "<span class='danger'>The passenger compartment is already occupied!</span>")
		if (LOCKED)
			to_chat(usr, "<span class='warning'>The passenger compartment hatch is locked!</span>")
		if (OCCUPIED|LOCKED)
			to_chat(usr, "<span class='danger'>All of the passenger compartments are already occupied or locked!</span>")
		if (0)
			to_chat(usr, "<span class='warning'>\The [src] doesn't have a passenger compartment.</span>")

#undef LOCKED
#undef OCCUPIED

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer
	name = "Cable Layer"
	icon_state = "mecha_wire"
	var/datum/event/event
	var/turf/old_turf
	var/obj/structure/cable/last_piece
	var/obj/item/stack/cable_coil/cable
	var/max_cable = 1000
	required_type = /obj/mecha/working

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/New()
	cable = new(src)
	cable.amount = 0
	..()

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/attach()
	..()
	event = chassis.events.addEvent("onMove",src,"layCable")
	return

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/detach()
	chassis.events.clearEvent("onMove",event)
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/destroy()
	chassis.events.clearEvent("onMove",event)
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/action(var/obj/item/stack/cable_coil/target)
	if(!action_checks(target))
		return
	var/result = load_cable(target)
	var/message
	if(isnull(result))
		message = "<font color='red'>Unable to load [target] - no cable found.</font>"
	else if(!result)
		message = "Reel is full."
	else
		message = "[result] meters of cable successfully loaded."
		send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
	occupant_message(message)
	return

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/Topic(href,href_list)
	..()
	if(href_list["toggle"])
		set_ready_state(!equip_ready)
		occupant_message("[src] [equip_ready?"dea":"a"]ctivated.")
		log_message("[equip_ready?"Dea":"A"]ctivated.")
		return
	if(href_list["cut"])
		if(cable && cable.amount)
			var/m = round(input(chassis.occupant,"Please specify the length of cable to cut","Cut cable",min(cable.amount,30)) as num, 1)
			m = min(m, cable.amount)
			if(m)
				use_cable(m)
				var/obj/item/stack/cable_coil/CC = new (get_turf(chassis))
				CC.amount = m
		else
			occupant_message("There's no more cable on the reel.")
	return

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/get_equip_info()
	var/output = ..()
	if(output)
		return "[output] \[Cable: [cable ? cable.amount : 0] m\][(cable && cable.amount) ? "- <a href='?src=\ref[src];toggle=1'>[!equip_ready?"Dea":"A"]ctivate</a>|<a href='?src=\ref[src];cut=1'>Cut</a>" : null]"
	return

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/proc/load_cable(var/obj/item/stack/cable_coil/CC)
	if(istype(CC) && CC.amount)
		var/cur_amount = cable? cable.amount : 0
		var/to_load = max(max_cable - cur_amount,0)
		if(to_load)
			to_load = min(CC.amount, to_load)
			if(!cable)
				cable = new(src)
				cable.amount = 0
			cable.amount += to_load
			CC.use(to_load)
			return to_load
		else
			return 0
	return

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/proc/use_cable(amount)
	if(!cable || cable.amount<1)
		set_ready_state(1)
		occupant_message("Cable depleted, [src] deactivated.")
		log_message("Cable depleted, [src] deactivated.")
		return
	if(cable.amount < amount)
		occupant_message("No enough cable to finish the task.")
		return
	cable.use(amount)
	update_equip_info()
	return 1

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/proc/reset()
	last_piece = null

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_plating())
			T.make_plating(!(T.broken || T.burnt))
	return new_turf.is_plating()

/obj/item/mecha_parts/mecha_equipment/tool/cable_layer/proc/layCable(var/turf/new_turf)
	if(equip_ready || !istype(new_turf) || !dismantleFloor(new_turf))
		return reset()
	var/fdirn = turn(chassis.dir,180)
	for(var/obj/structure/cable/LC in new_turf)		// check to make sure there's not a cable there already
		if(LC.d1 == fdirn || LC.d2 == fdirn)
			return reset()
	if(!use_cable(1))
		return reset()
	var/obj/structure/cable/NC = new(new_turf)
	NC.cableColor("red")
	NC.d1 = 0
	NC.d2 = fdirn
	NC.update_icon()

	var/datum/powernet/PN
	if(last_piece && last_piece.d2 != chassis.dir)
		last_piece.d1 = min(last_piece.d2, chassis.dir)
		last_piece.d2 = max(last_piece.d2, chassis.dir)
		last_piece.update_icon()
		PN = last_piece.powernet

	if(!PN)
		PN = new()
	PN.add_cable(NC)
	NC.mergeConnectedNetworks(NC.d2)

	//NC.mergeConnectedNetworksOnTurf()
	last_piece = NC
	return 1