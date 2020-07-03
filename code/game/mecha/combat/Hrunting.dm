/obj/mecha/combat/hrunting
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	name = "HRUNTING/YGGDRASIL Mark I ADS"
	icon_state = "Hrunting"
	initial_icon = "Hrunting"
	step_in = 3
	dir_in = 1 //Facing North.
	health = 500
	deflect_chance = 5
	damage_absorption = list("brute"=0.8,"fire"=0.7,"bullet"=0.7,"laser"=0.7,"energy"=0.7,"bomb"=0.7)
	max_temperature = 25000
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/hrunting
	max_equip = 3

/obj/mecha/combat/hrunting/add_cell()
	cell = new /obj/item/weapon/cell/hyper(src)