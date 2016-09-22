/proc/team2text(var/num = 0)
	switch(num)
		if(0)
			return "All"
		if(1)
			return "Team One"
		if(2)
			return "Team Two"
		if(3)
			return "Team Three"
		if(4)
			return "Team Four"
		if(5)
			return "Misc"
	return 0

/proc/team2num(var/team = "All")
	switch(team)
		if("All")
			return 0
		if("Team One")
			return 1
		if("Team Two")
			return 2
		if("Team Three")
			return 3
		if("Team Four")
			return 4
		if("Misc")
			return 5
	return 0

/obj/machinery/door/firedoor/battle

	New()
		..()
		req_access = list()
		req_one_access = list()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			req_access = list(A.team*10 - 9)

/obj/machinery/alarm/battle
	has_circuit = 1

	New()
		..()
		req_access = list()
		req_one_access = list()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			req_access = list(A.team*10 - 9)

/obj/machinery/power/apc/battle
	req_access = list()
	has_circuit = 1

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			req_access = list(A.team*10 - 9)

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
	light_type = /obj/item/weapon/light/bulb/red/battle

/obj/item/weapon/light/bulb/red/battle
	broken_chance = 0

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
	req_one_access = list(1,11,21,31)
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/stack/medical/bruise_pack = 1,/obj/item/stack/medical/ointment = 1,/obj/item/device/healthanalyzer = 1)

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			req_one_access = list(A.team*10 - 9)

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
	output_level = 20 KILOWATTS
	input_level = 20 KILOWATTS

	output_attempt = 1

/obj/machinery/power/smes/buildable/battle/recalc_coils()
	if ((cur_coils <= max_coils) && (cur_coils >= 1))
		capacity = 0
		input_level_max = 0
		output_level_max = 0
		for(var/obj/item/weapon/smes_coil/C in component_parts)
			capacity += C.ChargeCapacity
			input_level_max += C.IOCapacity
			output_level_max += C.IOCapacity
		charge = between(0, charge, capacity)
		return 1
	else
		return 0

//40KW Capacity, 2.5MW I/O
/obj/machinery/power/smes/buildable/battle/supercapacitor
	name = "supercapacitor"
	output_level = 100 KILOWATTS
	input_level = 100 KILOWATTS

/obj/machinery/power/smes/buildable/battle/supercapacitor/New()
	..(0)
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	recalc_coils()

//250KW Capacity, 100KW I/O
/obj/machinery/power/smes/buildable/battle/backup
	name = "backup capacitor"
	output_attempt = 0
	output_level = 10 KILOWATTS
	input_level = 10 KILOWATTS

/obj/machinery/power/smes/buildable/battle/backup/New()
	..(0)
	component_parts += new /obj/item/weapon/smes_coil/super_capacity(src)
	recalc_coils()

/obj/machinery/power/smes/buildable/battle/weak
	name = "cheap capacitor"
	output_attempt = 1
	input_attempt = 1

//20KW Capacity, 20KW I/O
/obj/machinery/power/smes/buildable/battle/weak/New()
	..(0)
	component_parts += new /obj/item/weapon/smes_coil/weak(src)
	component_parts += new /obj/item/weapon/smes_coil/weak(src)
	recalc_coils()

/obj/machinery/power/smes/buildable/battle/upgraded
	name = "advanced capacitor"
	output_level = 50 KILOWATTS
	input_level = 50 KILOWATTS

/obj/machinery/power/smes/buildable/battle/upgraded/New()
	..(0)
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	component_parts += new /obj/item/weapon/smes_coil/super_capacity(src)
	recalc_coils()

/obj/machinery/floor_light/prebuilt/battle
	name = "floor cover"
	alpha = 130
	layer = 2.5
	default_light_power = 1
	default_light_range = 2


