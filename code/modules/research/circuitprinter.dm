/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulfuric acis).

*/
/obj/machinery/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	icon_state = "circuit_imprinter"
	flags = OPENCONTAINER

	var/g_amount = 0
	var/gold_amount = 0
	var/diamond_amount = 0
	var/uranium_amount = 0
	var/max_material_amount = 75000.0
	var/mat_efficiency = 1

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/machinery/r_n_d/circuit_imprinter/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/circuit_imprinter(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	RefreshParts()

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	var/datum/reagents/R = new/datum/reagents(T)		//Holder for the reagents used as materials.
	reagents = R
	R.my_atom = src
	T = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		T += M.rating
	max_material_amount = T * 75000.0
	T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 1 - (T - 1) / 4

/obj/machinery/r_n_d/circuit_imprinter/update_icon()
	if(panel_open)
		icon_state = "circuit_imprinter_t"
	else
		icon_state = "circuit_imprinter"

/obj/machinery/r_n_d/circuit_imprinter/blob_act()
	if(prob(50))
		qdel(src)

/obj/machinery/r_n_d/circuit_imprinter/meteorhit()
	qdel(src)
	return

/obj/machinery/r_n_d/circuit_imprinter/proc/TotalMaterials()
	return g_amount + gold_amount + diamond_amount + uranium_amount

/obj/machinery/r_n_d/circuit_imprinter/dismantle()
	for(var/obj/I in component_parts)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	if(g_amount >= 3750)
		var/obj/item/stack/material/glass/G = new /obj/item/stack/material/glass(loc)
		G.amount = round(g_amount / 3750)
	if(gold_amount >= 2000)
		var/obj/item/stack/material/gold/G = new /obj/item/stack/material/gold(loc)
		G.amount = round(gold_amount / 2000)
	if(diamond_amount >= 2000)
		var/obj/item/stack/material/diamond/G = new /obj/item/stack/material/diamond(loc)
		G.amount = round(diamond_amount / 2000)
	if(uranium_amount >= 2000)
		var/obj/item/stack/material/uranium/G = new /obj/item/stack/material/uranium(loc)
		G.amount = round(uranium_amount / 2000)
	..()

/obj/machinery/r_n_d/circuit_imprinter/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(shocked)
		shock(user, 50)
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_imprinter = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(panel_open)
		user << "<span class='notice'>You can't load \the [src] while it's opened.</span>"
		return 1
	if(disabled)
		user << "\The [src] appears to not be working!"
		return
	if(!linked_console)
		user << "\The [src] must be linked to an R&D console first!"
		return 1
	if(O.is_open_container())
		return 0
	if(stat)
		return 1
	if(busy)
		user << "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>"
		return 1

	if(istype(O, /obj/item/stack/material) && O.get_material_name() in list("glass", "gold", "diamond", "uranium"))

		var/obj/item/stack/material/stack = O
		if((TotalMaterials() + stack.perunit) > max_material_amount)
			user << "<span class='notice'>\The [src] is full. Please remove glass from \the [src] in order to insert more.</span>"
			return 1

		var/amount = round(input("How many sheets do you want to add?") as num)
		if(amount < 0)
			amount = 0
		if(amount == 0)
			return
		if(amount > stack.amount)
			amount = min(stack.amount, round((max_material_amount - TotalMaterials()) / stack.perunit))

		busy = 1
		use_power(max(1000, (3750 * amount / 10)))
		var/stacktype = stack.type
		stack.use(amount)
		if(do_after(usr, 16))
			user << "<span class='notice'>You add [amount] sheets to \the [src].</span>"
			switch(stacktype)
				if(/obj/item/stack/material/glass)
					g_amount += amount * 3750
				if(/obj/item/stack/material/gold)
					gold_amount += amount * 2000
				if(/obj/item/stack/material/diamond)
					diamond_amount += amount * 2000
				if(/obj/item/stack/material/uranium)
					uranium_amount += amount * 2000
		else
			new stacktype(loc, amount)
		busy = 0
		updateUsrDialog()
		return

	..()

//This is to stop these machines being hackable via clicking.
/obj/machinery/r_n_d/circuit_imprinter/attack_hand(mob/user as mob)
	return