/obj/mecha/combat/hrunting
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	name = "HRUNTING/YGGDRASIL Mark I ADS"
	icon_state = "Hrunting"
	initial_icon = "Hrunting"
	step_in = 3
	dir_in = 1 //Facing North.
	health = 500
	deflect_chance = 35
	damage_absorption = list("brute"=0.5,"fire"=0.7,"bullet"=0.5,"laser"=0.5,"energy"=0.55,"bomb"=0.7)
	max_temperature = 25000
	infra_luminosity = 6
	var/overload = 0
	var/overload_coeff = 2
	wreckage = /obj/effect/decal/mecha_wreckage/hrunting
	internal_damage_threshold = 35
	max_equip = 5

/obj/mecha/combat/hrunting/add_cell()
	cell = new /obj/item/weapon/cell/hyper(src)

/obj/mecha/combat/hrunting/verb/overload()
	set category = "Exosuit Interface"
	set name = "Toggle leg actuators overload"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(overload)
		overload = 0
		step_in = initial(step_in)
		step_energy_drain = initial(step_energy_drain)
		src.occupant_message("<font color='blue'>You disable leg actuators overload.</font>")
	else
		overload = 1
		step_in = min(1, round(step_in/2))
		step_energy_drain = step_energy_drain*overload_coeff
		src.occupant_message("<font color='red'>You enable leg actuators overload.</font>")
	src.log_message("Toggled leg actuators overload.")
	return

/obj/mecha/combat/hrunting/do_move(direction)
	if(!..()) return
	if(overload)
		health--
		if(health < initial(health) - initial(health)/3)
			overload = 0
			step_in = initial(step_in)
			step_energy_drain = initial(step_energy_drain)
			src.occupant_message("<font color='red'>Leg actuators damage threshold exceded. Disabling overload.</font>")
	return


/obj/mecha/combat/hrunting/get_stats_part()
	var/output = ..()
	output += "<b>Leg actuators overload: [overload?"on":"off"]</b>"
	return output

/obj/mecha/combat/hrunting/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_leg_overload=1'>Toggle leg actuators overload</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/hrunting/Topic(href, href_list)
	..()
	if (href_list["toggle_leg_overload"])
		src.overload()
	return