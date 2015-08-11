/*
Protolathe

Similar to an autolathe, you load glass and metal sheets (but not other objects) into it to be used as raw materials for the stuff
it creates. All the menus and other manipulation commands are in the R&D console.

Note: Must be placed west/left of and R&D console to function.

*/
/obj/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon_state = "protolathe"
	flags = OPENCONTAINER

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 5000

	var/max_material_storage = 100000 //All this could probably be done better with a list but meh.
	var/m_amount = 0.0
	var/g_amount = 0.0
	var/gold_amount = 0.0
	var/silver_amount = 0.0
	var/phoron_amount = 0.0
	var/uranium_amount = 0.0
	var/diamond_amount = 0.0

	var/mat_efficiency = 1

/obj/machinery/r_n_d/protolathe/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/protolathe(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	RefreshParts()

/obj/machinery/r_n_d/protolathe/proc/TotalMaterials() //returns the total of all the stored materials. Makes code neater.
	return m_amount + g_amount + gold_amount + silver_amount + phoron_amount + uranium_amount + diamond_amount

/obj/machinery/r_n_d/protolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	var/datum/reagents/R = new/datum/reagents(T)		//Holder for the reagents used as materials.
	reagents = R
	R.my_atom = src
	T = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		T += M.rating
	max_material_storage = T * 75000
	T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 1 - (T - 2) / 8

/obj/machinery/r_n_d/protolathe/dismantle()
	for(var/obj/I in component_parts)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	if(m_amount >= 3750)
		var/obj/item/stack/material/steel/G = new /obj/item/stack/material/steel(loc)
		G.amount = round(m_amount / G.perunit)
	if(g_amount >= 3750)
		var/obj/item/stack/material/glass/G = new /obj/item/stack/material/glass(loc)
		G.amount = round(g_amount / G.perunit)
	if(phoron_amount >= 2000)
		var/obj/item/stack/material/phoron/G = new /obj/item/stack/material/phoron(loc)
		G.amount = round(phoron_amount / G.perunit)
	if(silver_amount >= 2000)
		var/obj/item/stack/material/silver/G = new /obj/item/stack/material/silver(loc)
		G.amount = round(silver_amount / G.perunit)
	if(gold_amount >= 2000)
		var/obj/item/stack/material/gold/G = new /obj/item/stack/material/gold(loc)
		G.amount = round(gold_amount / G.perunit)
	if(uranium_amount >= 2000)
		var/obj/item/stack/material/uranium/G = new /obj/item/stack/material/uranium(loc)
		G.amount = round(uranium_amount / G.perunit)
	if(diamond_amount >= 2000)
		var/obj/item/stack/material/diamond/G = new /obj/item/stack/material/diamond(loc)
		G.amount = round(diamond_amount / G.perunit)
	..()

/obj/machinery/r_n_d/protolathe/update_icon()
	if(panel_open)
		icon_state = "protolathe_t"
	else
		icon_state = "protolathe"

/obj/machinery/r_n_d/protolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(shocked)
		shock(user, 50)
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_lathe = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(O.is_open_container())
		return 1
	if(panel_open)
		user << "<span class='notice'>You can't load \the [src] while it's opened.</span>"
		return 1
	if(disabled)
		return
	if(!linked_console)
		user << "<span class='notice'>\The [src] must be linked to an R&D console first!</span>"
		return 1
	if(busy)
		user << "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>"
		return 1
	if(stat)
		return 1
	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/S = O
		if(TotalMaterials() + S.perunit > max_material_storage)
			user << "<span class='notice'>\The [src]'s material bin is full. Please remove material before adding more.</span>"
			return 1

		var/obj/item/stack/material/stack = O
		var/amount = round(input("How many sheets do you want to add?") as num)//No decimals
		if(!O)
			return
		if(amount < 0)//No negative numbers
			amount = 0
		if(amount == 0)
			return
		if(amount > stack.get_amount())
			amount = stack.get_amount()
		if(max_material_storage - TotalMaterials() < (amount * stack.perunit))//Can't overfill
			amount = min(stack.amount, round((max_material_storage - TotalMaterials()) / stack.perunit))

		overlays += "protolathe_[stack.name]"
		sleep(10)
		overlays -= "protolathe_[stack.name]"

		icon_state = "protolathe"
		busy = 1
		use_power(max(1000, (3750 * amount / 10)))
		var/material/material = stack.get_material()
		if(istype(material) && do_after(user, 16) && stack.use(amount))
			user << "<span class='notice'>You add [amount] sheets to \the [src].</span>"
			icon_state = "protolathe"
			
			var/amount_to_add = amount * material.stack_per_sheet
			switch(material.name)
				if(DEFAULT_WALL_MATERIAL)
					m_amount += amount_to_add
				if("glass")
					g_amount += amount_to_add
				if("gold")
					gold_amount += amount_to_add
				if("silver")
					silver_amount += amount_to_add
				if("phoron")
					phoron_amount += amount_to_add
				if("uranium")
					uranium_amount += amount_to_add
				if("diamond")
					diamond_amount += amount_to_add
		busy = 0
		updateUsrDialog()
		return
	..()

//This is to stop these machines being hackable via clicking.
/obj/machinery/r_n_d/protolathe/attack_hand(mob/user as mob)
	return