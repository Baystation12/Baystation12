/datum/design/chassis
	name = "Chassis"
	build_type = CHASSIS
	build_path = null
	var/list/components = null

/datum/design/chassis/proc/suitablePart(var/name, var/datum/design/D)
	return 0

/datum/design/chassis/proc/setup(var/obj/item/I, var/obj/item/O, var/partname)
	return

/datum/design/chassis/revolver
	name = "Energy gun (small)"
	id = "chassis_gun_small"
	build_path = /obj/item/weapon/gun/energy/custom
	req_tech = list(TECH_MATERIAL = 2)
	components = list("Power source", "Beam generator")

/datum/design/chassis/revolver/suitablePart(var/name, var/datum/design/D)
	switch(name)
		if("Power source")
			if(ispath(D.build_path, /obj/item/weapon/cell))
				return 1
		if("Beam generator")
			if(ispath(D.build_path, /obj/item/beam_generator))
				return 1
	return 0

/datum/design/chassis/revolver/setup(var/obj/item/weapon/gun/energy/custom/I, var/obj/item/O, var/partname)
	if(!I || !istype(I))
		return
	switch(partname)
		if("Power source")
			I.power_supply = O
		if("Beam generator")
			var/obj/item/beam_generator/B = O
			if(!B || !istype(B))
				return
			I.charge_cost = B.energy_use
			I.projectile_type = B.beam_type
			I.fire_sound = B.shot_sound

/obj/item/weapon/gun/energy/custom
	name = "Prototype gun"
	desc = "This is a prototype gun built in R&D."
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	fire_sound = null
	charge_cost = 0
	projectile_type = null
	cell_type = null

/datum/design/beam_generator
	name = "Stun beam"
	id = "stun_beam_generator"
	req_tech = list(TECH_POWER = 3, TECH_COMBAT = 2)
	materials = list("metal" = 700, "glass" = 1000)
	build_path = /obj/item/beam_generator

/obj/item/beam_generator
	var/shot_sound = 'sound/weapons/Taser.ogg'
	var/beam_type = /obj/item/projectile/beam/stun
	var/energy_use = 150

/datum/design/beam_generator/laser
	name = "Laser beam"
	id = "laser_beam_generator"
	req_tech = list(TECH_POWER = 3, TECH_COMBAT = 4)
	materials = list("metal" = 1000, "glass" = 3000)
	build_path = /obj/item/beam_generator/laser

/obj/item/beam_generator/laser
	shot_sound = 'sound/weapons/Laser.ogg'
	beam_type = /obj/item/projectile/beam
	energy_use = 300
