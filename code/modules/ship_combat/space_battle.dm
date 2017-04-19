/obj/machinery/space_battle
	icon = 'icons/obj/ship_battles.dmi'
	var/broken_state
	var/damage_level = 0
	var/id_tag = null
	var/melee_absorption = 20
	var/max_damage = 9
	var/component_type = null
	var/obj/item/weapon/component/component
	var/can_be_destroyed = 1
	var/team = 0
	has_circuit = 1
	resistance = 1.5
	density = 1
	anchored = 1
	var/id_num = 0
	var/repairing = 0
	var/obj/effect/overmap/linked
	var/min_broken = 1

	var/em_signature = 0
	var/thermal_signature = 0

	New()
		..()
		if(component_type)
			component = new component_type(src)
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			team = A.team

	initialize()
		reconnect()
		..()

	proc/rename(var/identification)
		return 1

	proc/change_team(var/new_team as num)
		team = new_team
		return 1

	process()
		..()
		if(!powered(power_channel))
			var/turf/T = get_turf(src)
			if(T)
				var/obj/structure/cable/C = T.get_cable_node()
				var/datum/powernet/PN
				if(C)	PN = C.powernet		// find the powernet of the connected cable

				if(PN)
					if(PN.draw_power(idle_power_usage) >= idle_power_usage)
						if(stat & NOPOWER)
							stat &= ~NOPOWER
					else
						stat |= NOPOWER
						return 1
		update_icon()


	ex_act(severity)
		switch(severity)
			if(1)
				break_machine(rand(7,12))
			if(2)
				break_machine(rand(1,8))
			if(1)
				break_machine(rand(0,4))

		for(var/obj/item/O in contents)
			O.ex_act(severity)

	emp_act(severity)
		return 0

	update_icon()
		if(stat & BROKEN)
			if(broken_state)
				icon_state = broken_state
			else
				icon_state = "[initial(icon_state)]_broken"
		else if(stat & NOPOWER)
			icon_state = "[initial(icon_state)]_off"
		else
			icon_state = initial(icon_state)

	proc/break_machine(var/dmg = 1)
		if(!dmg) return
		dmg = min(dmg, max_damage-1) // So it cannot be one-hitted.
		damage_level = min(damage_level+dmg, max_damage)
		if(min_broken <= damage_level)
			stat |= BROKEN
		if(can_be_destroyed && damage_level >= max_damage)
			if(!(stat & NOPOWER))
				src.visible_message("<span class='danger'>\The [src] fizzles and sparks violently!</span>")
				explosion(src, 0, 0, rand(1,3), rand(3,7))
			else
				src.visible_message("<span class='danger'>\The [src] collapses!</span>")
			qdel(src)
			return
		update_icon()

	proc/fix_machine(var/mob/user)
		icon_state = initial(icon_state)
		stat &= ~BROKEN
		damage_level = 0
		if(user && user.client)
			user.client.repairs_made += 1
		update_icon()

	proc/reconnect()
		linked = map_sectors["[z]"]
		return 1

	proc/fetch_em()
		return em_signature

	proc/fetch_thermal()
		return thermal_signature

	bullet_act(var/obj/item/projectile/bullet/P)
		if(P && istype(P) && P.damage_type == BRUTE)
			break_machine(round(P.damage / 5, 1))

	attackby(var/obj/item/I, var/mob/living/carbon/human/user)
		update_icon()
		if(istype(I, /obj/item/stack/cable_coil))
			user << "<span class='notice'>You rewire \the [src]'s cable connections!</span>"
			power_change()
		if(damage_level)
			if(istype(I, /obj/item/weapon/wrench))
				if(damage_level == 1 && !repairing)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					repairing = 1
					if(do_after(user,150))
						user << "<span class='notice'>You tighten the armour plating!"
						fix_machine(user)
						repairing = 0
						return
					else repairing = 0
			if(istype(I, /obj/item/weapon/crowbar))
				if(damage_level == 2 && !repairing)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					repairing = 1
					if(do_after(user,150))
						user << "<span class='notice'>You fix the armour plating!"
						damage_level--
						repairing = 0
						return
					else repairing = 0
			if(istype(I, /obj/item/stack/material/steel))
				if(damage_level == 3 && !repairing)
					var/obj/item/stack/material/steel/S = I
					if(!S.can_use(5))
						user << "<span class='warning'>You need atleast 5 sheets to do that!</span>"
					else
						user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
						repairing = 1
						if(do_after(user,150))
							damage_level--
							repairing = 0
							return
						else repairing = 0
			if(istype(I,/obj/item/weapon/wirecutters))
				if(damage_level == 4 && !repairing)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					repairing = 1
					if(do_after(user,150))
						user << "<span class='notice'>You fix the loose wiring!</span>"
						damage_level--
						repairing = 0
						return
					else repairing = 0
			if(istype(I, /obj/item/stack/cable_coil) && !repairing)
				var/obj/item/stack/cable_coil/C = I
				if(C.can_use(5))
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					repairing = 1
					if(do_after(user,150))
						user << "<span class='notice'>You repair the internal wiring!</span>"
						damage_level--
						repairing = 0
					else repairing = 0
				else
					user << "<span class='notice'>You need atleast 5 lengths of cable to do that!</span>"
				return
			if(istype(I, /obj/item/weapon/screwdriver))
				if(damage_level == 6 && !repairing)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					repairing = 1
					if(do_after(user,150))
						user << "<span class='notice'>You anchor the circuit boards in place!</span>"
						damage_level--
						repairing = 0
						return
					else repairing = 0
			if(istype(I, /obj/item/device/multitool))
				if(damage_level == 7 && !repairing)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					repairing = 1
					if(do_after(user,150))
						user << "<span class='notice'>You tune the circuit boards!</span>"
						damage_level--
						repairing = 0
						return
					else repairing = 0
			if(istype(I,/obj/item/stack/material/glass/reinforced))
				if(damage_level == 8 && !repairing)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					repairing = 1
					if(do_after(user,150))
						user << "<span class='notice'>You repair the circuit boards!</span>"
						damage_level--
						repairing = 0
					return
			if(istype(I,/obj/item/weapon/weldingtool))
				if(damage_level >= 9 && !repairing)
					var/obj/item/weapon/weldingtool/F = I
					if(F.welding)
						user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
						repairing = 1
						if(do_after(user,150))
							if(F.remove_fuel(1, user))
								damage_level--
								user << "<span class='notice'>You repair the structural frame!</span>"
							else
								user << "<span class='warning'>You need more fuel to do that!</span>"
							repairing = 0
						else repairing = 0
					else
						user << "<span class='warning'>The welding tool must be on!</span>"
					return
		if(istype(I, /obj/item/device/multitool))
			user << "<span class='notice'>\The [src]'s ID tag is set to: \"[id_tag]\"</span>"
			var/newid = input(user, "What would you like to set \the [src]'s id to? (Nothing to cancel)", "Multitool")
			if(!newid)
				user << "<span class='warning'>Invalid ID tag!</span>"
				return
			if(length(newid) < 25)
				id_tag = lowertext(newid)
			else
				user << "<span class='warning'>Too long!</span>"
				return
			reconnect()
			return
		if(..())
			return 1
		else
			if(I.force > 4)
				if(user.a_intent == I_HURT)
					if(melee_absorption > 0)
						melee_absorption -= I.force / 2
					else
						if(prob(10*I.force))
							break_machine(1)
					user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [I]!</span>")
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
					user.do_attack_animation(src)
					playsound(loc, 'sound/weapons/smash.ogg', 75, 1)
			else
				user << "<span class='warning'>\The [I] rebounds off of \the [src] harmlessly!</span>"
			return


	examine(var/mob/user)
		..()
		var/damagetext = ""
		switch(damage_level)
			if(1)
				damagetext = "\The [src]'s armour plates are loose! Use a wrench to tighten them!"
			if(2)
				damagetext = "\The [src]'s armour plates are out of shape! Use a crowbar to batter them into place!"
			if(3)
				damagetext = "\The [src]'s armour plates are missing! You need to replace them with steel!"
			if(4)
				damagetext = "\The [src]'s wires are hanging out loosely! You need to fix them with wirecutters!"
			if(5)
				damagetext = "\The [src]'s wiring is damaged beyond belief! You need to replace it with cable!"
			if(6)
				damagetext = "\The [src]'s circuitboards are knocked out of place! You need to anchor them with screws!"
			if(7)
				damagetext = "\The [src]'s circuitboards need tuning! You need to repair them using a multitool."
			if(8)
				damagetext = "\The [src]'s circuitboards are extremely damaged. You need to repair them with some reinforced glass!"
			if(9 to INFINITY)
				damagetext = "\The [src]'s structure is battered. You need to repair it	using a welder!"
		user << "<span class='warning'>[damagetext]</span>"
		if(stat & NOPOWER)
			user << "<span class='warning'>It appears to be unpowered!</span>"
		if(component)
			user << "<span class='notice'>It has a [component] installed!</span>"

	attack_hand(var/mob/user)
		if(circuit_board)
			circuit_board.attack_self(user)
		..()