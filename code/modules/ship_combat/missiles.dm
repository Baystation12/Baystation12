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

	spawn_type = /obj/item/missile/ship/standard

/obj/machinery/missile/heavy
	name = "heavy missile"
	desc = "A missile with a bigger warhead installed."
	icon_state = "heavy"

	req_grabs = 2
	delay_time = 60

	spawn_type = /obj/item/missile/ship/heavy

/obj/machinery/missile/scatter
	name = "scatter missile"
	desc = "A missile with multiple warheads installed."
	icon_state = "scatter"

	req_grabs = 2
	delay_time = 75

	spawn_type = /obj/item/missile/ship/scatter

/obj/machinery/missile/emp
	name = "emp missile"
	desc = "A missile made to distrupt enemy systems."
	icon_state = "missile_emp"

	req_grabs = 1
	delay_time = 40

	spawn_type = /obj/item/missile/ship/emp/external

/obj/machinery/missile/emp/breach
	name = "emp breach missile"
	desc = "A missile capable of drilling into the enemy hull and detonating and electromagnetic warhead."

	req_grabs = 1
	delay_time = 40

	spawn_type = /obj/item/missile/ship/emp/breach



