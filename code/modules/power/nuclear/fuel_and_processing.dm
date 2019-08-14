/obj/item/weapon/nuclearfuel    //Nuclear assemblies, for rods refueling
	var/list/reactants = new /list(0)
	icon = 'icons/obj/machines/nuclearcore.dmi'

/obj/item/weapon/nuclearfuel/New(var/newloc, var/list/r)
	if(r)
		reactants = r
	..(newloc)

/obj/item/weapon/nuclearfuel/rod
	icon_state = "assembly"
	name = "Nuclear fuel assembly"
	desc = "A nuclear fuel assemby, necessery to refuel nuclear rods ."


/obj/item/weapon/nuclearfuel/pellet
	icon_state = "pellet"
	name = "Nuclear fuel pellet"
	desc = "A small pellet of nuclear fuel. ."



/obj/machinery/rod_fabricator   //Finally fixed!
	name = "Fuel assembly fabricator"
	icon = 'icons/obj/machines/nuclearcore.dmi'
	icon_state = "fabricator"
	density = 1
	anchored = 1
	layer = 4
	var/list/areactants = new /list(0)
	var/list/buffer = new /list(0)
	var/summarymass
	var/transfering_sub
	use_power = 1
	var/obj/item/weapon/nuclearfuel/F = null
	var/load = 50


/obj/machinery/rod_fabricator/proc/power(var/power_usage = 0)
	var/area/A = get_area(src)
	if(!istype(A) || !A.powered(EQUIP))
		return FALSE

	A.use_power(power_usage, EQUIP)
	return TRUE

/obj/machinery/rod_fabricator/on_update_icon()
	if(power(load))
		icon_state = "fabricator_active"
	else
		icon_state = "fabricator"

/obj/machinery/rod_fabricator/Process()
	summarymass = 0
	for(var/mass_reactant in areactants)
		summarymass += areactants[mass_reactant]
	if(transfering_sub && areactants[transfering_sub] > 0.01 && power(load))
		for(var/reactant in areactants)
			var/amount = 0
			if(reactant == transfering_sub)
				amount = 0.2 * areactants[reactant]
			else
				amount = 0.01 * areactants[reactant]
			areactants[reactant] -= amount
			if(reactant in buffer)
				buffer[reactant] += amount
			else
				buffer.Add(reactant)
				buffer[reactant] = amount
	updateDialog()
	update_icon()

/obj/machinery/rod_fabricator/interface_interact(mob/user)
	interact(user)

/obj/machinery/rod_fabricator/attackby(obj/item/weapon/Pel, mob/user)   //UI is quite outdated, but at least it works
	if(istype(Pel, /obj/item/weapon/nuclearfuel))
		src.F = Pel
		user.unEquip(Pel, src)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		for (var/reactant in F.reactants)
			while (F.reactants[reactant])
				var/amount = 5
				if(F.reactants[reactant] > amount)
					amount = 5
				else
					amount = F.reactants[reactant]

				if ((summarymass + amount) <= 3000)
					if(reactant in areactants)
						areactants[reactant] += amount
					else
						areactants.Add(reactant)
						areactants[reactant] = amount
					summarymass += amount
				else
					if(reactant in buffer)
						buffer[reactant] += amount
					else
						buffer.Add(reactant)
						buffer[reactant] = amount
				F.reactants[reactant] -= amount


	add_fingerprint(user)

/obj/machinery/rod_fabricator/interact(var/mob/user)
	if(power(load))
		if(stat & !power(load))
			user.unset_machine()
			user << browse(null, "window=fuel_assembly")
			return

		if (get_dist(src, user) > 1)
			user.unset_machine()
			user << browse(null, "window=fuel_assembly")
			return
		var/dat = "<B>Assembly fabricator</B><BR>"


		dat += "<b>Assembly</b><hr>"

		dat += {"
			<hr>
			<table border=1 width='100%'>
			<tr>
			<td><b>Reactant</b></td>
			<td><b>Amount</b></td>
			</tr>"}
		for(var/reac in areactants)

			dat += "<tr>"

			dat += "<td>[reac]</td>"
			dat += "<td>[areactants[reac]/summarymass*100] %</td>"
			dat += "</tr>"
		dat += "</table><hr>"
		dat += "<b>Buffer</b><hr>"

		dat += {"
			<hr>
			<table border=1 width='100%'>
			<tr>
			<td><b>Reactant</b></td>
			<td><b>Amount</b></td>
			</tr>"}

		for(var/react in buffer)

			dat += "<tr>"

			dat += "<td>[react]</td>"
			dat += "<td>[buffer[react]] moles</td>"
			dat += "</tr>"

		dat += {"</table><hr>
			<A href='?src=\ref[src];transfer=1'>Transfer to buffer</A>
			<A href='?src=\ref[src];ctransfer=1'>Cease transfer</A>
			<A href='?src=\ref[src];create=1'>Create assembly</A>
			<A href='?src=\ref[src];eject=1'>Eject buffer</A>
			<A href='?src=\ref[src];close=1'>Close</A><BR>"}

		var/datum/browser/popup = new(user, "fabricator_control", "Assembly fabricator", 800, 400, src)
		popup.set_content(dat)
		popup.open()
		user.set_machine(src)

/obj/machinery/rod_fabricator/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)  //Buttons, displayed in UI
	if(href_list["eject"])
		if(buffer.len)
			var/obj/item/weapon/nuclearfuel/pellet/P = new(get_turf(src), buffer)
			user.put_in_hands(P)
			buffer = list()
			playsound(src.loc, 'sound/items/jaws_pry.ogg', 50, 1)

	if(href_list["create"])
		if(areactants.len)
			var/obj/item/weapon/nuclearfuel/rod/R = new(get_turf(src), areactants)
			user.put_in_hands(R)
			areactants = list()
			playsound(src.loc, 'sound/items/jaws_pry.ogg', 50, 1)

	if(href_list["ctransfer"])
		transfering_sub = null

	if(href_list["transfer"])
		var/new_val = input("Enter reactant", "Processing", transfering_sub) as null|text
		if(new_val in areactants)
			transfering_sub = new_val

	if( href_list["close"] )
		user << browse(null, "window=fuel_assembly")
		user.unset_machine()

	return TOPIC_REFRESH



/obj/machinery/centrifuge            // For making fuel without pellets on start.
	name = "Uranium processing centrifuge"
	icon = 'icons/obj/machines/nuclearcore.dmi'
	icon_state = "centrifuge"
	density = 1
	anchored = 1
	layer = 4
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 5000
	var/obj/item/stack/material/uranium/N = null
	var/amount = 0
	var/load = 0

/obj/machinery/centrifuge/proc/power(var/power_usage = 0)
	var/area/A = get_area(src)
	if(!istype(A) || !A.powered(EQUIP))
		return FALSE


	A.use_power(power_usage, EQUIP)
	return TRUE

/obj/machinery/centrifuge/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/material/uranium))

		src.N = W
		user.unEquip(W, src)
		amount += N.amount
		N = null

/obj/machinery/centrifuge/on_update_icon()
	if(!power(load))
		icon_state = "centrifuge_off"
	else
		if(amount > 0 && power(load))
			icon_state = "centrifuge_active"
		else
			icon_state = "centrifuge"

/obj/machinery/centrifuge/Process()
	update_icon()
	if(amount)
		load = 300
	else
		load = 20
	if(amount >= 20 && power(load))
		amount -= 20
		update_icon()
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 1)
		spawn(50)
			var/obj/item/weapon/nuclearfuel/pellet/Pl = new(get_turf(src), list("U235" = 550, "U238" = 2250))
			Pl.name = "Enriched uranium pellet"
			playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
			visible_message("<span class='notice'>[Pl] drops from the centrifuge.</span>")
			update_icon()
			if(amount < 20)
				amount = 0


/obj/item/weapon/nuclearfuel/rod/nrod
	name = "Enriched uranium rod"
	reactants = list("U235" = 800)

/obj/item/weapon/nuclearfuel/pellet/enrichedU
	name = "Enriched uranium pellet"
	reactants = list("U235" = 600, "U238" = 1500)

/obj/item/weapon/nuclearfuel/pellet/waste
	name = "Waste pellet"
	reactants = list("nuclear waste" = 1000)

/obj/item/weapon/nuclearfuel/pellet/thor
	name = "Thorium pellet"
	reactants = list("nuclear waste" = 500, "Th232" = 300)
