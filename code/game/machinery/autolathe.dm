/obj/machinery/autolathe
	name = "\improper autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100

	var/list/stored_material =  list("metal" = 0, "glass" = 0, "phoron" = 0, "osmium" = 0)
	var/list/storage_capacity = list("metal" = 0, "glass" = 0, "phoron" = 0, "osmium" = 0)
	var/show_category = "All"

	var/opened = 0
	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/busy = 0

	var/list/wires = list()
	var/hack_wire
	var/disable_wire
	var/shock_wire

/obj/machinery/autolathe/interact(mob/user as mob)

	if(..() || disabled)
		return

	if (shocked)
		shock(user,50)

	var/dat = "<center><h1>Autolathe Control Panel</h1><hr/>"

	dat += "<table width = '100%'>"
	var/material_top = "<tr>"
	var/material_bottom = "<tr>"

	for(var/material in stored_material)
		material_top += "<td width = '25%' align = center><b>[material]</b></td>"
		material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"

	dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"
	dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"

	for(var/datum/autolathe/recipe/R in autolathe_recipes)
		if(R.hidden && !hacked || (show_category != "All" && show_category != R.category))
			continue

		var/can_make = 1
		var/material_string = ""

		var/comma
		if(!R.resources || !R.resources.len)
			material_string = "No resources required.</td>"
		else
			for(var/material in R.resources)

				if(!isnull(stored_material[material]) && stored_material[material] < R.resources[material])
					can_make = 0
				if(!comma)
					comma = 1
				else
					material_string += ", "
				material_string += "[R.resources[material]] [material]"
			material_string += ".<br></td>"

		dat += "<tr><td width = 180><b>[can_make ? "<a href='?src=\ref[src];make=\ref[R]'>" : ""][R.name][can_make ? "</a>" : ""]</b></td><td align = right>[material_string]</tr>"

	dat += "</table><hr>"

	//Hacking.
	if(opened)
		dat += "<h2>Maintenance Panel</h2>"
		for(var/wire in wires)
			dat += "[wire] Wire: <A href='?src=\ref[src];wire=[wire];act=wire'>[wires[wire] ? "Mend" : "Cut"]</A> <A href='?src=\ref[src];wire=[wire];act=pulse'>Pulse</A><BR>"
		dat += "<br>"
		dat += "The red light is [disabled ? "off" : "on"].<br>"
		dat += "The green light is [shocked ? "off" : "on"].<br>"
		dat += "The blue light is [hacked ? "off" : "on"].<br>"

		dat += "<hr>"

	user << browse(dat, "window=autolathe")
	onclose(user, "autolathe")

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (stat)
		return

	if (busy)
		user << "\red \The [src] is busy. Please wait for completion of previous operation."
		return

	if(istype(O, /obj/item/weapon/screwdriver))
		opened = !opened
		icon_state = (opened ? "autolathe_t": "autolathe")
		user << "You [opened ? "open" : "close"] the maintenance hatch of [src]."
		updateUsrDialog()
		return

	if (opened)
		//Dismantle the frame.
		if(istype(O, /obj/item/weapon/crowbar))
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
			M.state = 2
			M.icon_state = "box_1"
			for(var/obj/I in component_parts)
				if(I.reliability != 100 && crit_fail)
					I.crit_fail = 1
				I.loc = loc
			del(src)
			return 1

	//Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.matter)
		user << "\The [eating] does not contain significant amounts of useful materials and cannot be accepted."
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)

		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.amount

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(!filltype)
		user << "\red \The [src] is full. Please remove material from the autolathe in order to insert more."
		return
	else if(filltype == 1)
		user << "You fill \the [src] to capacity with \the [eating]."
	else
		user << "You fill \the [src] with \the [eating]."

	flick("autolathe_o",src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1,round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else
		user.drop_item(O)
		del(O)

	updateUsrDialog()
	return

/obj/machinery/autolathe/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/Topic(href, href_list)

	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		usr << "\red The autolathe is busy. Please wait for completion of previous operation."
		return

	if(href_list["change_category"])

		var/choice = input("Which category do you wish to display?") as null|anything in autolathe_categories+"All"
		if(!choice) return
		show_category = choice

	if(href_list["make"] && autolathe_recipes)

		var/datum/autolathe/recipe/making
		for(var/datum/autolathe/recipe/R in autolathe_recipes)
			if(R == href_list["make"])
				making = R
				break

		//Exploit detection, not sure if necessary after rewrite.
		if(!making)
			var/turf/exploit_loc = get_turf(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])", 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate an item!")
			return

		busy = 1
		use_power(max(2000, making.power_use))

		//Check if we still have the materials.
		for(var/material in making.resources)
			if(!isnull(stored_material[material]))
				if(stored_material[material] < making.resources[material])
					return

		//Consume materials.
		for(var/material in making.resources)
			if(!isnull(stored_material[material]))
				stored_material[material] = max(0,stored_material[material]-making.resources[material])

		//Fancy autolathe animation.
		flick("autolathe_n",src)

		sleep(50)

		//Sanity check.
		if(!making || !src) return

		//Create the desired item.
		new making.path(get_step(loc, get_dir(src,usr)))

	if(href_list["act"])

		var/temp_wire = href_list["wire"]
		if(href_list["act"] == "pulse")

			if (!istype(usr.get_active_hand(), /obj/item/device/multitool))
				usr << "You need a multitool!"
				return

			if(wires[temp_wire])
				usr << "You can't pulse a cut wire."
				return

			if(hack_wire == temp_wire)
				hacked = !hacked

				spawn(100)
					hacked = !hacked

			if(disable_wire == temp_wire)
				disabled = !disabled
				shock(usr,50)

				spawn(100)
					disabled = !disabled

			if(shock_wire == temp_wire)
				shocked = !shocked
				shock(usr,50)

				spawn(100)
					shocked = !shocked

		else if(href_list["act"] == "wire")

			if (!istype(usr.get_active_hand(), /obj/item/weapon/wirecutters))
				usr << "You need wirecutters!"
				return

			wires[temp_wire] = !wires[temp_wire]

			if(hack_wire == temp_wire)
				hacked = !hacked

			if(disable_wire == temp_wire)
				disabled = !disabled
				shock(usr,50)

			if(shock_wire == temp_wire)
				shocked = !shocked
				shock(usr,50)

	updateUsrDialog()


/obj/machinery/autolathe/New()

	..()

	//Create global autolathe recipe list if it hasn't been made already.
	if(isnull(autolathe_recipes))
		autolathe_recipes = list()
		autolathe_categories = list()
		for(var/R in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe)
			var/datum/autolathe/recipe/recipe = new R
			autolathe_recipes += recipe
			autolathe_categories |= recipe.category

			var/obj/item/I = new recipe.path
			if(I.matter && !recipe.resources) //This can be overidden in the datums.
				recipe.resources = list()
				for(var/material in I.matter)
					if(!isnull(storage_capacity[material]))
						recipe.resources[material] = round(I.matter[material]*1.25) // More expensive to produce than they are to recycle.
				del(I)

	//Create parts for lathe.
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/autolathe(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

	//Init wires.
	wires = list(
		"Light Red" = 0,
		"Dark Red" = 0,
		"Blue" = 0,
		"Green" = 0,
		"Yellow" = 0,
		"Black" = 0,
		"White" = 0,
		"Gray" = 0,
		"Orange" = 0,
		"Pink" = 0
		)

	//Randomize wires.
	var/list/w = list("Light Red","Dark Red","Blue","Green","Yellow","Black","White","Gray","Orange","Pink")
	hack_wire = pick(w)
	w -= hack_wire
	shock_wire = pick(w)
	w -= shock_wire
	disable_wire = pick(w)
	w -= disable_wire

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/tot_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		tot_rating += MB.rating

	storage_capacity["metal"] = tot_rating  * 25000
	storage_capacity["glass"] = tot_rating  * 25000
	storage_capacity["phoron"] = tot_rating * 12500
	storage_capacity["osmium"] = tot_rating *  7500


	//max_m_amount = tot_rating * 2
	//max_g_amount = tot_rating