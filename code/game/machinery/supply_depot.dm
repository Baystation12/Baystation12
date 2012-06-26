/*
*	Control console
*/
/obj/machinery/supply_depot_console
	name = "Supply Depot Console"
	icon = 'terminals.dmi'
	icon_state = "production_console"
	density = 0
	anchored = 1
	var/id = ""
	var/obj/machinery/supply_depot/machine = null
	var/machinedir = SOUTHWEST

/obj/machinery/supply_depot_console/New()
	..()
	spawn(7)
		src.machine = locate(/obj/machinery/supply_depot, get_step(src, machinedir))
		if (machine)
			machine.CONSOLE = src
		else
			del(src)

/obj/machinery/supply_depot_console/attack_hand(user as mob)
	var/dat

	dat += text("<h3>Raw Materials Storage</h3>")

	var/canrelease = 0
	if (machine.totalmaterial > 0)
		// Loop through the items in our inventory
		for (var/material in machine.inventory)
			var/temp = machine.inventory[material]
			if (temp["amt"] > 0)

				// Can we press the "release" button?
				if (temp["rel"] > 0)
					canrelease = 1

				// The things I do to make it look good...
				dat += text("<span style='text-transform:capitalize;'>[(temp["name"]) ? temp["name"] : material]:</span> <a href='?src=\ref[src];setrelease=[material]'>[temp["rel"]]</a> ([temp["amt"]] remaining)<br>")
	else
		dat += "No materials loaded."

	dat += text("<br>Storage space remaining: [(machine.MAX_MATERIAL - machine.totalmaterial < 1000) ? "<span class='warning'>" : ""][machine.MAX_MATERIAL - machine.totalmaterial][(machine.MAX_MATERIAL - machine.totalmaterial < 1000) ? "</span>" : ""]<br>")
	dat += text("Print manifest: <a href='?src=\ref[src];toggleprint=1>'>[machine.printmanifest ? "Yes" : "No"]</a><br><br>")

	dat += text("<a href='?src=\ref[src];load=1'>Load materials</a><br>")
	if (canrelease)
		dat += text("<a href='?src=\ref[src];release=1'>Release materials</a><br>")

	user << browse("[dat]", "window=console_stacking_machine")

/obj/machinery/supply_depot_console/Topic(href, href_list)
	if (..())
		return
	usr.machine = src
	src.add_fingerprint(usr)

	if (href_list["setrelease"])
		if (machine.inventory[href_list["setrelease"]]["amt"] > 0)
			var/release = text2num(sanitize(input("Amount of [lowertext(machine.inventory[href_list["setrelease"]]["name"])] to release (max 500):", "Amount to release", num2text(machine.inventory[href_list["setrelease"]]["rel"]))))

			// For sanity's sake, we don't drop more than 10 stacks at a time.
			if (release > 500)
				release = 500
			else if (release < 0)
				release = 0

			machine.inventory[href_list["setrelease"]]["rel"] = release

	else if (href_list["toggleprint"])

		machine.printmanifest = !machine.printmanifest

	else if (href_list["load"])

		machine.load_materials(machine.output.loc)

	else if (href_list["release"])

		// Do it.
		machine.release_materials()

	src.updateUsrDialog()
	return

/*
*	Storage machine
*/
/obj/machinery/supply_depot
	name = "supply depot"
	icon_state = "supply_depot"
	density = 1
	anchored = 1
	var/id = ""
	var/machine = null
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/supply_depot_console/CONSOLE

	var/MAX_MATERIAL = 7500 // The upper limit of -all- materials in the machine (default 150 stacks of 50)
	var/totalmaterial = 0 // The total amount it's holding
	var/printmanifest = 1 // Print a manifest when releasing material?
	var/inventory[0] // See below.

/obj/machinery/supply_depot/New()
	..()

	// name is a display name if the item name isn't suitable
	// amt is how much is in the machine
	// rel is how much we're releasing in this shipment
	inventory["metal"] = list(name = "iron", "amt" = 0, "rel" = 50)
	inventory["plasteel"] = list("amt" = 0, "rel" = 50)
	inventory["glass"] = list("amt" = 0, "rel" = 50)
	inventory["rglass"] = list("name" = "reinforced glass", "amt" = 0, "rel" = 50)
	inventory["plasma"] = list("amt" = 0, "rel" = 50)
	inventory["gold"] = list("amt" = 0, "rel" = 50)
	inventory["silver"] = list("amt" = 0, "rel" = 50)
	inventory["uranium"] = list("amt" = 0, "rel" = 50)
	inventory["diamond"] = list("amt" = 0, "rel" = 50)
	inventory["clown"] = list("name" = "bananium", "amt" = 0, "rel" = 50) // HONK
	inventory["adamantine"] = list("amt" = 0, "rel" = 50)
	inventory["mythril"] = list("amt" = 0, "rel" = 50)

	spawn(5)
		// Find input
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if (src.input) break
		// Find output
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if (src.output) break
		// process_objects.Add(src)
		return
	return

// Suck up all processable matter from a given location, moving anything we can't
// process to an arbitrary location.
/obj/machinery/supply_depot/proc/load_materials(target, passthrough)
	// No overloading.
	if (totalmaterial >= MAX_MATERIAL)
		return

	if (target)
		var/obj/item/stack/sheet/O
		while (locate(/obj/item/stack/sheet, target))
			O = locate(/obj/item/stack/sheet, target)
			var/found = 0

			// Can we fit any more in?
			if (totalmaterial + O.amount < MAX_MATERIAL)
				for (var/material in inventory)
					if (istype(O, text2path("/obj/item/stack/sheet/[material]")))
						inventory[material]["amt"] += O.amount
						totalmaterial += O.amount
						del(O)
						found = 1
						break
			else
				// Nope. Max us out and edit the material's amount. We're not deleting it.
				for (var/material in inventory)
					if (istype(O, text2path("/obj/item/stack/sheet/[material]")))
						inventory[material]["amt"] += (MAX_MATERIAL - totalmaterial)
						totalmaterial = MAX_MATERIAL
						O.amount = MAX_MATERIAL - totalmaterial
						found = 1
						break

			if (found)
				continue
			else
				// Anything we don't want gets moved through
				if (passthrough)
					O.loc = passthrough

// Release a given batch of materials
/obj/machinery/supply_depot/proc/release_materials()

	// Can we actually release anything in the first place?
	var/canrelease = 0
	for (var/material in inventory)
		if (inventory[material]["amt"] > 0 && inventory[material]["rel"] > 0)
			canrelease = 1
	if (!canrelease) return

	// Get us a cargo manifest if applicable...
	if (ordernum)
		ordernum++
	else
		ordernum = rand(500,5000)

	var/obj/item/weapon/paper/manifest/slip
	if (printmanifest)
		slip = new /obj/item/weapon/paper/manifest(output.loc)
		slip.info = ""
		slip.info +="<h3>[command_name()] Internal Shipping Manifest</h3><hr><br>"
		slip.info +="Order #: [ordernum]<br>"
		slip.info +="CONTENTS:<br><ul>"

	// Now actually spawn the items we're releasing and add them to the manifest
	for (var/material in inventory)
		var/temp = inventory[material]
		if (temp["amt"] <= 0 || temp["rel"] <= 0)
			continue

		// If we're trying to draw more than we have, correct it.
		if (temp["rel"] > temp["amt"])
			temp["rel"] = temp["amt"]

		// Subtract material before we go any further
		inventory[material]["amt"] -= temp["rel"]
		totalmaterial -= temp["rel"]

		var/path = text2path("/obj/item/stack/sheet/[material]")
		if (path)
			// Need this outside of the ifs so we can get the name afterward.
			var obj/item/stack/sheet/G

			// Get our full stacks
			for (var/i = 1, i <= round(temp["rel"] / 50), i++)
				G = new path
				G.amount = 50
				G.loc = output.loc

			// Get our remainder
			if (temp["rel"] % 50)
				G = new path
				G.amount = temp["rel"] % 50
				G.loc = output.loc

			// Try to get the "official" object name if possible.
			if (printmanifest)
				slip.info += "<li>[temp["rel"]] units [(G.name) ? G.name : (temp["name"]) ? temp["name"] : material]</li>"

	// Close up the cargo manifest
	if (printmanifest)
		slip.info += "</ul><br>CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
		slip.loc = output.loc

/obj/machinery/supply_depot/process()
	if (src.input && src.output)
		load_materials(input.loc, output.loc)