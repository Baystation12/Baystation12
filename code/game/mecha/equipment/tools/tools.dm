/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	name = "Hydraulic Clamp"
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 10
	var/dam_force = 20
	var/obj/mecha/working/ripley/cargo_holder

	can_attach(obj/mecha/M as obj)
		if(..())
			if(istype(M, /obj/mecha/working/ripley))
				return 1
		return 0

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
							chassis.occupant_message("<font color='blue'>[target] succesfully loaded.</font>")
							chassis.log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - cargo_holder.cargo.len]")
						else
							chassis.occupant_message("<font color='red'>You must hold still while handling objects.</font>")
							O.anchored = initial(O.anchored)
				else
					chassis.occupant_message("<font color='red'>Not enough room in cargo compartment.</font>")
			else
				chassis.occupant_message("<font color='red'>[target] is firmly secured.</font>")

		else if(istype(target,/mob/living))
			var/mob/living/M = target
			if(M.stat>1) return
			if(chassis.occupant.a_intent == "hurt")
				M.take_overall_damage(dam_force)
				M.adjustOxyLoss(round(dam_force/2))
				M.updatehealth()
				chassis.occupant_message("\red You squeese [target] with [src.name]. Something cracks.")
				chassis.visible_message("\red [chassis] squeeses [target].")
			else
				step_away(M,chassis)
				chassis.occupant_message("You push [target] out of the way.")
				chassis.visible_message("[chassis] pushes [target] out of the way.")
			set_ready_state(0)
			chassis.use_power(energy_drain)
			do_after_cooldown()
		return 1

/obj/item/mecha_parts/mecha_equipment/tool/drill
	name = "Drill"
	icon_state = "mecha_drill"
	equip_cooldown = 30
	energy_drain = 10
	force = 15

	action(atom/target)
		if(!action_checks(target)) return
		set_ready_state(0)
		chassis.use_power(energy_drain)
		chassis.visible_message("<font color='red'><b>[chassis] starts to drill [target]</b></font>", "You hear the drill.")
		chassis.occupant_message("<font color='red'><b>You start to drill [target]</b></font>")
		chassis.use_power(energy_drain)
		var/T = chassis.loc
		var/C = target.loc	//why are these backwards? we may never know -Pete
		if(do_after_cooldown(target))
			if(T == chassis.loc && src == chassis.selected)
				if(istype(target, /turf/simulated/wall/r_wall))
					chassis.occupant_message("<font color='red'>[target] is too durable to drill through.</font>")
				else if(istype(target, /turf/simulated/mineral))
					for(var/turf/simulated/mineral/M in range(chassis,1))
						if(get_dir(chassis,M)&chassis.dir)
							M.gets_drilled()
					chassis.log_message("Drilled through [target]")
					if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
						var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
						if(ore_box)
							for(var/obj/item/weapon/ore/ore in range(chassis,1))
								if(get_dir(chassis,ore)&chassis.dir)
									ore.Move(ore_box)
				else if(target.loc == C)
					chassis.log_message("Drilled through [target]")
					target.ex_act(2)
		return 1


/obj/item/mecha_parts/mecha_equipment/tool/extinguisher
	name = "Extinguisher"
	icon_state = "mecha_exting"
	equip_cooldown = 5
	energy_drain = 0
	range = MELEE|RANGED

	New()
		reagents = new/datum/reagents(200)
		reagents.my_atom = src
		reagents.add_reagent("water", 200)
		..()
		return

	action(atom/target) //copypasted from extinguisher. TODO: Rewrite from scratch.
		if(!action_checks(target) || get_dist(chassis, target)>3) return
		if(get_dist(chassis, target)>2) return
		set_ready_state(0)
		if(do_after_cooldown(target))
			if(istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(chassis,target) <= 1)
				var/obj/o = target
				o.reagents.trans_to(src, 200)
				chassis.occupant_message("\blue Extinguisher refilled")
				playsound(chassis, 'refill.ogg', 50, 1, -6)
			else
				if(src.reagents.total_volume > 0)
					playsound(chassis, 'extinguish.ogg', 75, 1, -3)
					var/direction = get_dir(chassis,target)
					var/turf/T = get_turf(target)
					var/turf/T1 = get_step(T,turn(direction, 90))
					var/turf/T2 = get_step(T,turn(direction, -90))

					var/list/the_targets = list(T,T1,T2)
					spawn(0)
						for(var/a=0, a<5, a++)
							var/obj/effect/effect/water/W = new /obj/effect/effect/water(get_turf(chassis))
							if(!W)
								return
							var/turf/my_target = pick(the_targets)
							var/datum/reagents/R = new/datum/reagents(5)
							W.reagents = R
							R.my_atom = W
							src.reagents.trans_to(W,1)
							for(var/b=0, b<4, b++)
								if(!W)
									return
								step_towards(W,my_target)
								if(!W)
									return
								var/turf/W_turf = get_turf(W)
								W.reagents.reaction(W_turf)
								for(var/atom/atm in W_turf)
									W.reagents.reaction(atm)
								if(W.loc == my_target)
									break
								sleep(2)
		return 1

	get_equip_info()
		return "[..()] \[[src.reagents.total_volume]\]"

	on_reagent_change()
		return


/obj/item/mecha_parts/mecha_equipment/tool/rcd
	name = "Mounted RCD"
	desc = "An exosuit-mounted Rapid Construction Device."
	icon_state = "mecha_rcd"
	origin_tech = "materials=4;bluespace=3;magnets=4;powerstorage=4"
	equip_cooldown = 20
	energy_drain = 250
	range = MELEE|RANGED
	construction_time = 1200
	construction_cost = list("metal"=30000,"plasma"=25000,"silver"=20000,"gold"=20000)
	var/mode = 0 //0 - deconstruct, 1 - wall or floor, 2 - airlock.
	var/disabled = 0 //malf

	action(atom/target)
		if(!istype(target, /turf) && !istype(target, /obj/machinery/door/airlock))
			target = get_turf(target)
		if(!action_checks(target) || disabled || get_dist(chassis, target)>3) return
		playsound(chassis, 'click.ogg', 50, 1)
		//meh
		switch(mode)
			if(0)
				if (istype(target, /turf/simulated/wall))
					chassis.occupant_message("Deconstructing [target]...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						chassis.spark_system.start()
						target:ReplaceWithFloor()
						playsound(target, 'Deconstruct.ogg', 50, 1)
						chassis.give_power(energy_drain)
				else if (istype(target, /turf/simulated/floor))
					chassis.occupant_message("Deconstructing [target]...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						chassis.spark_system.start()
						target:ReplaceWithSpace()
						playsound(target, 'Deconstruct.ogg', 50, 1)
						chassis.give_power(energy_drain)
				else if (istype(target, /obj/machinery/door/airlock))
					chassis.occupant_message("Deconstructing [target]...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						chassis.spark_system.start()
						del(target)
						playsound(target, 'Deconstruct.ogg', 50, 1)
						chassis.give_power(energy_drain)
			if(1)
				if(istype(target, /turf/space))
					chassis.occupant_message("Building Floor...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						target:ReplaceWithFloor()
						playsound(target, 'Deconstruct.ogg', 50, 1)
						chassis.spark_system.start()
						chassis.use_power(energy_drain*2)
				else if(istype(target, /turf/simulated/floor))
					chassis.occupant_message("Building Wall...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						target:ReplaceWithWall()
						playsound(target, 'Deconstruct.ogg', 50, 1)
						chassis.spark_system.start()
						chassis.use_power(energy_drain*2)
			if(2)
				if(istype(target, /turf/simulated/floor))
					chassis.occupant_message("Building Airlock...")
					set_ready_state(0)
					if(do_after_cooldown(target))
						if(disabled) return
						chassis.spark_system.start()
						var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock(target)
						T.autoclose = 1
						playsound(target, 'Deconstruct.ogg', 50, 1)
						playsound(target, 'sparks2.ogg', 50, 1)
						chassis.use_power(energy_drain*2)
		return


	Topic(href,href_list)
		..()
		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			switch(mode)
				if(0)
					chassis.occupant_message("Switched RCD to Deconstruct.")
				if(1)
					chassis.occupant_message("Switched RCD to Construct.")
				if(2)
					chassis.occupant_message("Switched RCD to Construct Airlock.")
		return

	get_equip_info()
		return "[..()] \[<a href='?src=\ref[src];mode=0'>D</a>|<a href='?src=\ref[src];mode=1'>C</a>|<a href='?src=\ref[src];mode=2'>A</a>\]"




/obj/item/mecha_parts/mecha_equipment/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	icon_state = "mecha_teleport"
	origin_tech = "bluespace=10"
	equip_cooldown = 150
	energy_drain = 1000
	range = RANGED

	action(atom/target)
		if(!action_checks(target)) return
		var/turf/T = get_turf(target)
		if(T)
			set_ready_state(0)
			chassis.use_power(energy_drain)
			do_teleport(chassis, T, 4)
			do_after_cooldown()
		return


/obj/item/mecha_parts/mecha_equipment/wormhole_generator
	name = "Wormhole Generator"
	desc = "An exosuit module that allows generating of small quasi-stable wormholes."
	icon_state = "mecha_wholegen"
	origin_tech = "bluespace=3"
	equip_cooldown = 50
	energy_drain = 300
	range = RANGED


	action(atom/target)
		if(!action_checks(target)) return
		var/list/theareas = list()
		for(var/area/AR in orange(100, chassis))
			if(AR in theareas) continue
			theareas += AR
		if(!theareas.len)
			return
		var/area/thearea = pick(theareas)
		var/list/L = list()
		for(var/turf/T in get_area_turfs(thearea.type))
			if(!T.density)
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
		P.icon = 'objects.dmi'
		P.failchance = 0
		P.icon_state = "anom"
		P.name = "wormhole"
		do_after_cooldown()
		src = null
		spawn(rand(150,300))
			del(P)
		return

/obj/item/mecha_parts/mecha_equipment/gravcatapult
	name = "Gravitational Catapult"
	desc = "An exosuit mounted Gravitational Catapult."
	icon_state = "mecha_teleport"
	origin_tech = "bluespace=2;magnets=3"
	equip_cooldown = 10
	energy_drain = 200
	range = MELEE|RANGED
	var/atom/movable/locked
	var/mode = 1 //1 - gravsling 2 - gravpush


	action(atom/movable/target)
		switch(mode)
			if(1)
				if(!action_checks(target) && !locked) return
				if(!locked)
					if(!istype(target) || target.anchored)
						chassis.occupant_message("Unable to lock on [target]")
						return
					locked = target
					chassis.occupant_message("Locked on [target]")
					send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
					return
				else if(target!=locked)
					if(locked in view(chassis))
						locked.throw_at(target, 14, 1.5)
						locked = null
						send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
						set_ready_state(0)
						chassis.use_power(energy_drain)
						do_after_cooldown()
					else
						locked = null
						chassis.occupant_message("Lock on [locked] disengaged.")
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
		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
		return


/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster //what is that noise? A BAWWW from TK mutants.
	name = "Armor Booster Module (Close Combat Weaponry)"
	desc = "Boosts exosuit armor against armed melee attacks. Requires energy to operate."
	icon_state = "mecha_abooster_ccw"
	origin_tech = "materials=3"
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	construction_cost = list("metal"=20000,"silver"=5000)
	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

	can_attach(obj/mecha/M as obj)
		if(..())
			if(!istype(M, /obj/mecha/combat/honker))
				if(!M.proc_res["dynattackby"])
					return 1
		return 0

	attach(obj/mecha/M as obj)
		..()
		chassis.proc_res["dynattackby"] = src
		return

	detach()
		chassis.proc_res["dynattackby"] = null
		..()
		return

	get_equip_info()
		if(!chassis) return
		return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name]"

	proc/dynattackby(obj/item/weapon/W as obj, mob/user as mob)
		if(!action_checks(user))
			return chassis.dynattackby(W,user)
		chassis.log_message("Attacked by [W]. Attacker - [user]")
		if(prob(chassis.deflect_chance*deflect_coeff))
			user << "\red The [W] bounces off [chassis] armor."
			chassis.log_append_to_last("Armor saved.")
		else
			chassis.occupant_message("<font color='red'><b>[user] hits [chassis] with [W].</b></font>")
			user.visible_message("<font color='red'><b>[user] hits [chassis] with [W].</b></font>", "<font color='red'><b>You hit [src] with [W].</b></font>")
			chassis.take_damage(round(W.force*damage_coeff),W.damtype)
			chassis.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
		return


/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster
	name = "Armor Booster Module (Ranged Weaponry)"
	desc = "Boosts exosuit armor against ranged attacks. Completely blocks taser shots. Requires energy to operate."
	icon_state = "mecha_abooster_proj"
	origin_tech = "materials=4"
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	construction_cost = list("metal"=20000,"gold"=5000)
	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

	can_attach(obj/mecha/M as obj)
		if(..())
			if(!istype(M, /obj/mecha/combat/honker))
				if(!M.proc_res["dynbulletdamage"] && !M.proc_res["dynhitby"])
					return 1
		return 0

	attach(obj/mecha/M as obj)
		..()
		chassis.proc_res["dynbulletdamage"] = src
		chassis.proc_res["dynhitby"] = src
		return

	detach()
		chassis.proc_res["dynbulletdamage"] = null
		chassis.proc_res["dynhitby"] = null
		..()
		return

	get_equip_info()
		if(!chassis) return
		return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name]"

	proc/dynbulletdamage(var/obj/item/projectile/Proj)
		if(!action_checks(src))
			return chassis.dynbulletdamage(Proj)
		if(prob(chassis.deflect_chance*deflect_coeff))
			chassis.occupant_message("\blue The armor deflects incoming projectile.")
			chassis.visible_message("The [chassis.name] armor deflects the projectile")
			chassis.log_append_to_last("Armor saved.")
		else
			chassis.take_damage(round(Proj.damage*src.damage_coeff),Proj.flag)
			chassis.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
		return

	proc/dynhitby(atom/movable/A)
		if(!action_checks(A))
			return chassis.dynhitby(A)
		if(prob(chassis.deflect_chance*deflect_coeff) || istype(A, /mob/living) || istype(A, /obj/item/mecha_tracking))
			chassis.occupant_message("\blue The [A] bounces off the armor.")
			chassis.visible_message("The [A] bounces off the [chassis] armor")
			chassis.log_append_to_last("Armor saved.")
			if(istype(A, /mob/living))
				var/mob/living/M = A
				M.take_organ_damage(10)
		else if(istype(A, /obj))
			var/obj/O = A
			if(O.throwforce)
				chassis.take_damage(round(O.throwforce*damage_coeff))
				chassis.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
		return


/obj/item/mecha_parts/mecha_equipment/repair_droid
	name = "Repair Droid"
	desc = "Automated repair droid. Scans exosuit for damage and repairs it. Can fix almost all types of external or internal damage."
	icon_state = "repair_droid"
	origin_tech = "magnets=3;programming=3"
	equip_cooldown = 20
	energy_drain = 20
	range = 0
	construction_cost = list("metal"=10000,"gold"=1000,"silver"=2000,"glass"=5000)
	var/health_boost = 2
	var/datum/global_iterator/pr_repair_droid
	var/icon/droid_overlay

	New()
		..()
		pr_repair_droid = new /datum/global_iterator/mecha_repair_droid(list(src),0)
		pr_repair_droid.set_delay(equip_cooldown)
		return

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
				chassis.log_message("[src] activated.")
			else
				droid_overlay = new(src.icon, icon_state = "repair_droid")
				chassis.log_message("[src] deactivated.")
				set_ready_state(1)
			chassis.overlays += droid_overlay
			send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
		return


/datum/global_iterator/mecha_repair_droid

	process(var/obj/item/mecha_parts/mecha_equipment/repair_droid/RD as obj)
		if(!RD.chassis)
			RD.set_ready_state(1)
			return src.stop()
		var/repaired = 0
		if(RD.chassis.health < initial(RD.chassis.health))
			RD.chassis.health += min(RD.health_boost, initial(RD.chassis.health)-RD.chassis.health)
			repaired = 1
		if(RD.chassis.internal_damage && prob(20))
			if(RD.chassis.internal_damage&MECHA_INT_TEMP_CONTROL)
				RD.chassis.internal_damage &= ~MECHA_INT_TEMP_CONTROL
				repaired = 1
			else if(RD.chassis.internal_damage&MECHA_INT_SHORT_CIRCUIT)
				RD.chassis.internal_damage &= ~MECHA_INT_SHORT_CIRCUIT
				repaired = 1
			else if(RD.chassis.internal_damage&MECHA_INT_TANK_BREACH)
				RD.chassis.internal_damage &= ~MECHA_INT_TANK_BREACH
				repaired = 1
			else if(RD.chassis.internal_damage&MECHA_INT_CONTROL_LOST)
				RD.chassis.internal_damage &= ~MECHA_INT_CONTROL_LOST
				repaired = 1
		if(repaired)
			RD.chassis.use_power(RD.energy_drain)
			RD.set_ready_state(0)
		else
			RD.set_ready_state(1)
		return


/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	name = "Energy Relay"
	desc = "Wirelessly drains energy from any available power channel in area. The performance index is quite low."
	icon_state = "tesla"
	origin_tech = "magnets=3"
	equip_cooldown = 10
	energy_drain = 0
	range = 0
	construction_cost = list("metal"=10000,"gold"=2000,"silver"=3000,"glass"=2000)
	var/datum/global_iterator/pr_energy_relay
	var/coeff = 100

	New()
		..()
		pr_energy_relay = new /datum/global_iterator/mecha_energy_relay(list(src),0)
		pr_energy_relay.set_delay(equip_cooldown)
		return

	detach()
		pr_energy_relay.stop()
		chassis.proc_res["dynusepower"] = null
		..()
		return

	attach(obj/mecha/M)
		..()
		chassis.proc_res["dynusepower"] = src
		return

	can_attach(obj/mecha/M)
		if(..())
			if(!M.proc_res["dynusepower"])
				return 1
		return 0

	Topic(href, href_list)
		..()
		if(href_list["toggle_relay"])
			if(pr_energy_relay.toggle())
				set_ready_state(0)
				chassis.log_message("[src] activated.")
			else
				set_ready_state(1)
				chassis.log_message("[src] deactivated.")
		return

	get_equip_info()
		if(!chassis) return
		return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_relay=1'>[pr_energy_relay.active()?"Dea":"A"]ctivate</a>"

	proc/dynusepower(amount)
		if(!equip_ready) //enabled
			var/area/A = get_area(chassis)
			if(A)
				var/pow_chan
				for(var/c in list(EQUIP,ENVIRON,LIGHT))
					if(A.master.powered(c))
						pow_chan = c
						break
				if(pow_chan)
					A.master.use_power(amount*coeff, pow_chan)
					return 1
		return chassis.dynusepower(amount)

/datum/global_iterator/mecha_energy_relay

	process(var/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/ER)
		if(!ER.chassis)
			ER.set_ready_state(1)
			return stop()
		var/cur_charge = ER.chassis.get_charge()
		if(isnull(cur_charge))
			ER.set_ready_state(1)
			ER.chassis.occupant_message("No powercell detected.")
			return stop()
		if(cur_charge<ER.chassis.cell.maxcharge)
			var/area/A = get_area(ER.chassis)
			if(A)
				var/pow_chan
				for(var/c in list(EQUIP,ENVIRON,LIGHT))
					if(A.master.powered(c))
						pow_chan = c
						break
				if(pow_chan)
					var/delta = min(2, ER.chassis.cell.maxcharge-cur_charge)
					ER.chassis.give_power(delta)
					A.master.use_power(delta*ER.coeff, pow_chan)
		return



/obj/item/mecha_parts/mecha_equipment/plasma_generator
	name = "Plasma Converter"
	desc = "Generates power using solid plasma as fuel. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = "plasmatech=2;powerstorage=2;engineering"
	equip_cooldown = 10
	energy_drain = 0
	range = MELEE
	construction_cost = list("metal"=10000,"silver"=500,"glass"=1000)
	var/datum/global_iterator/pr_mech_plasma_generator
	var/coeff = 100
	var/fuel = 0
	var/max_fuel = 150000
	var/fuel_per_cycle_idle = 100
	var/fuel_per_cycle_active = 500
	var/power_per_cycle = 10
	reliability = 999

	New()
		..()
		pr_mech_plasma_generator = new /datum/global_iterator/mecha_plasma_generator(list(src),0)
		pr_mech_plasma_generator.set_delay(equip_cooldown)
		return

	detach()
		pr_mech_plasma_generator.stop()
		..()
		return


	Topic(href, href_list)
		..()
		if(href_list["toggle"])
			if(pr_mech_plasma_generator.toggle())
				set_ready_state(0)
				chassis.log_message("[src] activated.")
			else
				set_ready_state(1)
				chassis.log_message("[src] deactivated.")
		return

	get_equip_info()
		var/output = ..()
		if(output)
			return "[output] \[Plasma: [fuel] cm<sup>3</sup>\] - <a href='?src=\ref[src];toggle=1'>[pr_mech_plasma_generator.active()?"Dea":"A"]ctivate</a>"
		return

	action(target)
		if(chassis)
			var/result = load_fuel(target)
			var/message
			if(isnull(result))
				message = "<font color='red'>Plasma traces in target minimal. [target] cannot be used as fuel.</font>"
			else if(!result)
				message = "Unit is full."
			else
				message = "[result] units of plasma successfully loaded."
				send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
			chassis.occupant_message(message)
		return

	proc/load_fuel(var/obj/item/stack/sheet/plasma/P)
		if(istype(P) && P.amount)
			var/to_load = max(max_fuel - fuel,0)
			if(to_load)
				var/units = min(max(round(to_load / P.perunit),1),P.amount)
				if(units)
					fuel += units * P.perunit
					P.use(units)
					return units
			else
				return 0
		return

	attackby(weapon,mob/user)
		var/result = load_fuel(weapon)
		if(isnull(result))
			user.visible_message("[user] tries to shove [weapon] into [src]. What a dumb-ass.","<font color='red'>Plasma traces minimal. [weapon] cannot be used as fuel.</font>")
		else if(!result)
			user << "Unit is full."
		else
			user.visible_message("[user] loads [src] with plasma.","[result] units of plasma successfully loaded.")
		return

	critfail()
		..()
		var/turf/simulated/T = get_turf(src)
		var/datum/gas_mixture/GM = new
		if(prob(10))
			GM.toxins += 100
			GM.temperature = 1500+T0C //should be enough to start a fire
			T.visible_message("The [src] suddenly disgorges a cloud of heated plasma.")
			destroy()
		else
			GM.toxins += 5
			GM.temperature = istype(T) ? T.air.return_temperature() : T20C
			T.assume_air(GM)
			T.visible_message("The [src] suddenly disgorges a cloud of plasma.")
		T.assume_air(GM)
		return

/datum/global_iterator/mecha_plasma_generator

	process(var/obj/item/mecha_parts/mecha_equipment/plasma_generator/EG)
		if(!EG.chassis)
			EG.set_ready_state(1)
			return stop()
		if(EG.fuel<=0)
			EG.set_ready_state(1)
			stop()
			EG.chassis.log_message("[src] deactivated.")
			send_byjax(EG.chassis.occupant,"exosuit.browser","\ref[EG]",EG.get_equip_info())
			return
		if(rand(0,1000)>EG.reliability)
			EG.critfail()
			return stop()
		var/cur_charge = EG.chassis.get_charge()
		if(isnull(cur_charge))
			EG.set_ready_state(1)
			EG.chassis.occupant_message("No powercell detected.")
			EG.chassis.log_message("[src] deactivated.")
			return stop()
		var/use_fuel = EG.fuel_per_cycle_idle
		if(cur_charge<EG.chassis.cell.maxcharge)
			use_fuel = EG.fuel_per_cycle_active
			EG.chassis.give_power(EG.power_per_cycle)
			send_byjax(EG.chassis.occupant,"exosuit.browser","\ref[EG]",EG.get_equip_info())
		EG.fuel -= use_fuel
		return



/*
/obj/item/mecha_parts/mecha_equipment/defence_shocker
	name = "Exosuit Defence Shocker"
	desc = ""
	icon_state = "mecha_teleport"
	equip_cooldown = 10
	energy_drain = 100
	range = RANGED
	var/shock_damage = 15
	var/active

	can_attach(obj/mecha/M as obj)
		if(..())
			if(!istype(M, /obj/mecha/combat/honker))
				if(!M.proc_res["dynattackby"] && !M.proc_res["dynattackhand"] && !M.proc_res["dynattackalien"])
					return 1
		return 0

	attach(obj/mecha/M as obj)
		..()
		chassis.proc_res["dynattackby"] = src
		return

	proc/dynattackby(obj/item/weapon/W as obj, mob/user as mob)
		if(!action_checks(user) || !active)
			return
		user.electrocute_act(shock_damage, src)
		return chassis.dynattackby(W,user)
*/
