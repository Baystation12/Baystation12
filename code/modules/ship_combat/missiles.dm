//TO-DO: Guided missiles

/obj/machinery/missile/standard
	name = "standard missile"
	desc = "A standard issue anti-ship missile."
	icon = 'icons/obj/missile.dmi'
	icon_state = "medium"

	req_grabs = 1
	width = 2
	space_only = 1
	delay_time = 30
	move_delay = 30
	range = 4
	damage = 20

	spawn_type = /obj/item/missile/ship/standard

/obj/item/missile/ship/standard/boom(atom/hit_atom)
	explosion(hit_atom, 0, (rand(1,3)*power), (rand(3,4)*power), 7)
	qdel(src)
	return

/obj/machinery/missile/heavy
	name = "heavy missile"
	desc = "A missile with a bigger warhead installed."
	icon_state = "heavy"

	req_grabs = 2
	delay_time = 60
	move_delay = 60
	range = 2
	damage = 50

	spawn_type = /obj/item/missile/ship/heavy

/obj/item/missile/ship/heavy/boom(atom/hit_atom)
	explosion(hit_atom, (rand(1,2)*power), (rand(2,3)*power), (rand(3,5)*power), 7)
	qdel(src)
	return

/obj/machinery/missile/scatter
	name = "scatter missile"
	desc = "A missile with multiple warheads installed."
	icon_state = "scatter"

	req_grabs = 2
	delay_time = 75
	move_delay = 60
	range = 3
	damage = 35

	spawn_type = /obj/item/missile/ship/scatter

/obj/item/missile/ship/scatter/boom(atom/hit_atom)
	explosion(hit_atom, 0, 0, (rand(3,6)*power), 7)
	qdel(src)
	return

/obj/machinery/missile/emp
	name = "emp missile"
	desc = "A missile made to distrupt enemy systems."
	icon_state = "missile_emp"

	req_grabs = 1
	delay_time = 40
	move_delay = 30

	spawn_type = /obj/item/missile/ship/emp/external

/obj/item/missile/ship/emp/external/boom(atom/hit_atom)
	explosion(hit_atom, 0, rand(0, 1), rand(2,4), 7)
	empulse(hit_atom, rand(3,6), rand(9,14))
	qdel(src)
	return

/obj/machinery/missile/emp/breach
	name = "emp breach missile"
	desc = "A missile capable of drilling into the enemy hull and detonating and electromagnetic warhead."

	req_grabs = 1
	delay_time = 40
	move_delay = 30

	spawn_type = /obj/item/missile/ship/emp/breach

/obj/item/missile/ship/emp/breach
	ap = 20

	throw_impact(atom/hit_atom, speed)
		if(speed && ap && target)
			if(breach())
				boom(hit_atom)
		else boom(hit_atom)

	boom(atom/hit_atom)
		explosion(hit_atom, 0, rand(0,1), rand(0,3), 7)
		empulse(hit_atom, rand(1,4), rand(5,10))
		qdel(src)
		return



