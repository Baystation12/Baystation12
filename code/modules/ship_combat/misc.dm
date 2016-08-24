/obj/machinery/space_battle
	icon = 'icons/obj/ship_battles.dmi'
	var/damage_level = 0
	var/id_tag = null
	var/melee_absorption = 20
	var/max_damage = 9
	var/component_type = null
	var/obj/item/weapon/component/component
	has_circuit = 1
	resistance = 1.5

	New()
		..()
		if(component_type)
			component = new component_type(src)


	process()
		..()
		if(!powered(power_channel))
			var/turf/T = get_turf(src)
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
		switch(severity)
			if(1)
				if(prob(55))
					break_machine(rand(2,4))
			if(2)
				if(prob(25))
					break_machine(rand(1,2))
			if(3)
				if(prob(5))
					break_machine(rand(0,1))

		for(var/obj/item/O in contents)
			O.emp_act(severity)

	update_icon()
		if(stat & NOPOWER && !(stat & BROKEN))
			icon_state = "[initial(icon_state)]_off"
		else if(!(stat & NOPOWER)  && !(stat & BROKEN))
			icon_state = initial(icon_state)

	proc/break_machine(var/dmg = 1)
		if(!dmg) return
		icon_state = "[initial(icon_state)]_broken"
		stat |= BROKEN
		damage_level += dmg
		if(damage_level > max_damage)
			if(!(stat & NOPOWER))
				src.visible_message("<span class='danger'>\The [src] fizzles and sparks violently!</span>")
				explosion(src, 0, rand(0,1), rand(1,3), rand(3,7))
			else
				src.visible_message("<span class='danger'>\The [src] collapses!</span>")
			qdel(src)

	proc/fix_machine(var/mob/user)
		icon_state = initial(icon_state)
		stat &= ~BROKEN
		damage_level = 0
		if(user && user.client)
			user.client.repairs_made += 1

	proc/reconnect()
		return 1

	bullet_act(var/obj/item/projectile/bullet/P)
		if(P && istype(P) && P.damage_type == BRUTE)
			break_machine(round(P.damage / 5, 1))

	attackby(var/obj/item/I, var/mob/living/carbon/human/user)
		if(istype(I, /obj/item/stack/cable_coil))
			user << "<span class='notice'>You rewire \the [src]'s cable connections!</span>"
			power_change()
		if(damage_level)
			if(istype(I, /obj/item/weapon/wrench))
				if(damage_level == 1)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					if(do_after(user,150))
						user << "<span class='notice'>You tighten the armour plating!"
						fix_machine(user)
						return
			if(istype(I, /obj/item/weapon/crowbar))
				if(damage_level == 2)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					if(do_after(user,150))
						user << "<span class='notice'>You fix the armour plating!"
						damage_level--
						return
			if(istype(I, /obj/item/stack/material/steel))
				if(damage_level == 3)
					var/obj/item/stack/material/steel/S = I
					if(!S.can_use(5))
						user << "<span class='warning'>You need atleast 5 sheets to do that!</span>"
					else
						user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
						if(do_after(user,150))
							damage_level--
							return
			if(istype(I,/obj/item/weapon/wirecutters))
				if(damage_level == 4)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					if(do_after(user,150))
						user << "<span class='notice'>You fix the loose wiring!</span>"
						damage_level--
						return
			if(istype(I, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = I
				if(C.can_use(5))
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					if(do_after(user,150))
						user << "<span class='notice'>You repair the internal wiring!</span>"
						damage_level--
				else
					user << "<span class='notice'>You need atleast 5 lengths of cable to do that!</span>"
				return
			if(istype(I, /obj/item/weapon/screwdriver))
				if(damage_level == 6)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					if(do_after(user,150))
						user << "<span class='notice'>You anchor the circuit boards in place!</span>"
						damage_level--
					return
			if(istype(I, /obj/item/device/multitool))
				if(damage_level == 7)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					if(do_after(user,150))
						user << "<span class='notice'>You tune the circuit boards!</span>"
						damage_level--
					return
			if(istype(I,/obj/item/stack/material/glass/reinforced))
				if(damage_level == 8)
					user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
					if(do_after(user,150))
						user << "<span class='notice'>You repair the circuit boards!</span>"
					return
			if(istype(I,/obj/item/weapon/weldingtool))
				if(damage_level >= 9)
					var/obj/item/weapon/weldingtool/F = I
					if(F.welding)
						user.visible_message("<span class='notice'>[user] begins repairing \the [src] with \the [I]...</span>")
						if(do_after(user,150))
							if(F.remove_fuel(1, user))
								damage_level--
								user << "<span class='notice'>You repair the structural frame!</span>"
							else
								user << "<span class='warning'>You need more fuel to do that!</span>"
					else
						user << "<span class='warning'>The welding tool must be on!</span>"
					return

		if(istype(I, /obj/item/weapon/screwdriver))
			if(!circuit_board)
				user << "<span class='notice'>\The [src] has no circuit board!</span>"
				return
			user.visible_message("<span class='notice'>[user] begins removing \the [circuit_board] from \the [src]..</span>")
			if(do_after(user, 100))
				circuit_board.forceMove(get_turf(user))
				user.put_in_hands(circuit_board)
				circuit_board = null

		if(istype(I, /obj/item/upgrade_module))
			if(circuit_board)
				user << "<span class='notice'>\The [src] already has a circuit board!</span>"
				return
			user.visible_message("<span class='notice'>[user] begins installing \the [I] into \the [src]..</span>")
			if(do_after(user, 100))
				user.drop_item()
				I.forceMove(src)
				src.circuit_board = I
			return
		if(istype(I, /obj/item/device/multitool))
			var/newid = text2num(input(user, "What would you like to set \the [src]'s id to?", "Fire Control"))
			if(newid)
				id_tag = newid
			reconnect()
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
				damagetext = "\The [src]'s circuitboards are extremely damaged. You need to repair them with some glass!"
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


/obj/machinery/door/firedoor/battle
	req_one_access = list(1,2,3,4)
	req_access = list()

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			switch(A.team)
				if(1)
					req_one_access = list(1)
				if(2)
					req_one_access = list(11)
				if(3)
					req_one_access = list(21)
				if(4)
					req_one_access = list(31)

/obj/machinery/alarm/battle
	req_one_access = list(1,2,3,4)
	req_access = list()
	has_circuit = 1

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			switch(A.team)
				if(1)
					req_one_access = list(5)
				if(2)
					req_one_access = list(15)
				if(3)
					req_one_access = list(25)
				if(4)
					req_one_access = list(35)

/obj/machinery/power/apc/battle
	req_one_access = list(1,2,3,4)
	req_access = list()
	has_circuit = 1

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			switch(A.team)
				if(1)
					req_one_access = list(5)
				if(2)
					req_one_access = list(15)
				if(3)
					req_one_access = list(25)
				if(4)
					req_one_access = list(35)


/obj/machinery/light/small/battle
	name = "emergency bulb"
	icon_state = "bulb1"
	base_state = "bulb"
	idle_power_usage = 1
	active_power_usage = 5
	brightness_color = "#da0205"
	brightness_range = 5
	brightness_power = 3
	desc = "A small lighting fixture."
	light_type = /obj/item/weapon/light/bulb/red

/datum/reagent/lexorin/necrosis
	name = "necrosa"
	id = "necrosa"
	description = "Causes body-wide necrosis."
	taste_description = "death"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = 20

/datum/reagent/lexorin/necrosis/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/I = pick(H.internal_organs)
		if(I)
			if(I.damage < (volume/2))
				I.damage++
	M.take_organ_damage(rand(1,10) * removed, 0)
	if(M.losebreath < 105)
		M.losebreath += rand(1,2)

/datum/reagent/lexorin/necrosis/overdose(var/mob/living/carbon/M, var/alien)
	if(M.losebreath < 140)
		M.losebreath += 2
	M.take_organ_damage(10,0)
	..()

/obj/item/weapon/gun/projectile/pirate/battle
	name = "navy musket"
	desc = "A cheap firearm afforded to low-rank officers."
	slot_flags = SLOT_BACK|SLOT_BELT

/obj/item/weapon/storage/belt/musket
	name = "ammunition belt"
	desc = "Holds ammunition."
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		/obj/item/ammo_casing/a10mm
		)

/obj/item/weapon/storage/belt/musket/New()
	..()
	var/num = rand(5,10)
	for(var/i=1, i<=num,i++)
		new /obj/item/ammo_casing/a10mm (src)

/obj/item/weapon/storage/belt/arrow
	name = "arrow holder"
	desc = "Can hold arrows"
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		/obj/item/weapon/arrow
		)

/obj/item/weapon/storage/belt/arrow/New()
	..()
	var/num = rand(3,8)
	for(var/i=1, i<=num,i++)
		new /obj/item/weapon/arrow (src)

/obj/item/weapon/storage/belt/ammo_pouch
	name = "ammo pouch"
	desc = "Can hold ammo."
	icon_state = "utilitybelt"
	item_state = "utility"
	can_hold = list(
		/obj/item/ammo_casing
		)

/obj/item/weapon/storage/belt/ammo_pouch/New()
	..()
	var/num = rand(3,8)
	for(var/i=1, i<=num,i++)
		new /obj/item/ammo_casing/a10mm (src)

/obj/machinery/vending/wallmed1/battle
	name = "Emergency NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	req_access = list()
	req_one_access = list(1,2,3,4)
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/stack/medical/bruise_pack = 1,/obj/item/stack/medical/ointment = 1,/obj/item/device/healthanalyzer = 1)

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			switch(A.team)
				if(1)
					req_one_access = list(1)
				if(2)
					req_one_access = list(11)
				if(3)
					req_one_access = list(21)
				if(4)
					req_one_access = list(31)
/obj/item/clothing/head/helmet/space/battle
	name = "battle helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = BLOCKHAIR
	item_state_slots = list(
		slot_l_hand_str = "s_helmet",
		slot_r_hand_str = "s_helmet",
		)
	permeability_coefficient = 0.01
	armor = list(melee = 15, bullet = 15, laser = 15,energy = 15, bomb = 30, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude","Diona", "Xenomorph")
	flash_protection = FLASH_PROTECTION_MAJOR
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/clothing/suit/space/battle
	name = "low-pressure suit"
	desc = "A suit that protects against low pressure environments."
	icon_state = "space"
	item_state = "s_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen,/obj/item/device/suit_cooling_unit)
	armor = list(melee = 15, bullet = 15, laser = 15,energy = 15, bomb = 15, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude","Diona", "Xenomorph")

/obj/item/device/radio/intercom/locked/ship
	name = "station intercom (Ship)"
	desc = "Talk through this."
	icon_state = "intercom"
	anchored = 1
	w_class = 4.0
	canhear_range = 7
	flags = CONDUCT | NOBLOODY

	var/global/team_one = 1441
	var/global/team_two = 1456
	var/global/team_three = 1492
	var/global/team_four = 1502

	var/team = 0

	internal_channels = list()

	New()
		..()

		spawn(4)
			var/area/ship_battle/A = get_area(src)
			if(A && istype(A))
				team = A.team
			switch(team)
				if(1)
					frequency = team_one
				if(2)
					frequency = team_two
				if(3)
					frequency = team_three
				if(4)
					frequency = team_four
			locked_frequency = frequency

/obj/item/device/radio/intercom/locked/ship/host
	name = "station intercom (Ship)"
	desc = "Talk through this."
	icon_state = "intercom"
	anchored = 1
	w_class = 4.0
	canhear_range = 6
	flags = CONDUCT | NOBLOODY

	New()
		team_one = rand(1410,1419)
		team_two = rand(1420,1429)
		team_three = rand(1430, 1439)
		team_four = rand(1440,1449)
		..()

/obj/machinery/power/smes/buildable/battle
	charge = 1e6

	output_attempt = 1



