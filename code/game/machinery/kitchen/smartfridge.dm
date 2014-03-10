/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/vending.dmi'
	icon_state = "smartfridge"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	flags = NOREACT
	var/global/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/icon_panel = "smartfridge-panel"
	var/item_quants = list()
	var/ispowered = 1 //starts powered
	var/isbroken = 0
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/panel_open = 0 //Hacking a smartfridge
	var/wires = 7
	var/const/WIRE_SHOCK = 1
	var/const/WIRE_SHOOTINV = 2
	var/const/WIRE_SCANID = 3 //Only used by the secure smartfridge, but required by the cut, mend and pulse procs.


/obj/machinery/smartfridge/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "seeds"
	icon_on = "seeds"
	icon_off = "seeds-off"

/obj/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/extract
	name = "\improper Slime Extract Storage"
	desc = "A refrigerated storage unit for slime extracts"
	req_access_txt = "47"

/obj/machinery/smartfridge/secure/extract/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/slime_extract))
		return 1
	return 0

/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Medicine Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	icon_state = "smartfridge" //To fix the icon in the map editor.
	icon_on = "smartfridge_chem"
	req_one_access_txt = "5;33"

/obj/machinery/smartfridge/secure/medbay/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/))
		return 1
	if(istype(O,/obj/item/weapon/storage/pill_bottle/))
		return 1
	if(istype(O,/obj/item/weapon/reagent_containers/pill/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	req_access_txt = "39"
	icon_state = "smartfridge_virology"
	icon_on = "smartfridge_virology"
	icon_off = "smartfridge_virology-off"

/obj/machinery/smartfridge/secure/virology/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/beaker/vial/))
		return 1
	if(istype(O,/obj/item/weapon/virusdish/))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."

/obj/machinery/smartfridge/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/storage/pill_bottle) || istype(O,/obj/item/weapon/reagent_containers))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."


/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/food/condiment))
		return 1

/obj/machinery/smartfridge/process()
	if(!src.ispowered)
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/smartfridge/power_change()
	if( powered() )
		src.ispowered = 1
		stat &= ~NOPOWER
		if(!isbroken)
			icon_state = icon_on
	else
		spawn(rand(0, 15))
		src.ispowered = 0
		stat |= NOPOWER
		if(!isbroken)
			icon_state = icon_off


/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(!src.ispowered)
		user << "<span class='notice'>\The [src] is unpowered and useless.</span>"
		return

	if(accept_check(O))
		if(contents.len >= max_n_of_items)
			user << "<span class='notice'>\The [src] is full.</span>"
			return 1
		else
			user.before_take_item(O)
			O.loc = src
			if(item_quants[O.name])
				item_quants[O.name]++
			else
				item_quants[O.name] = 1
			user.visible_message("<span class='notice'>[user] has added \the [O] to \the [src].", \
								 "<span class='notice'>You add \the [O] to \the [src].")

	else if(istype(O, /obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/storage/bag/plants/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				if(contents.len >= max_n_of_items)
					user << "<span class='notice'>\The [src] is full.</span>"
					return 1
				else
					P.remove_from_storage(G,src)
					if(item_quants[G.name])
						item_quants[G.name]++
					else
						item_quants[G.name] = 1
					plants_loaded++
		if(plants_loaded)

			user.visible_message("<span class='notice'>[user] loads \the [src] with \the [P].</span>", \
								 "<span class='notice'>You load \the [src] with \the [P].</span>")
			if(P.contents.len > 0)
				user << "<span class='notice'>Some items are refused.</span>"

	else
		user << "<span class='notice'>\The [src] smartly refuses [O].</span>"
		return 1

	updateUsrDialog()

/obj/machinery/smartfridge/secure/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/weapon/card/emag))
		src.emagged = 1
		user << "You short out the product lock on [src]"
		return
	else if(istype(O, /obj/item/weapon/screwdriver))
		src.panel_open = !src.panel_open
		user << "You [src.panel_open ? "open" : "close"] the maintenance panel."
		src.overlays.Cut()
		if(src.panel_open)
			src.overlays += image(src.icon, src.icon_panel)
		src.updateUsrDialog()
		return
	else if(istype(O, /obj/item/device/multitool)||istype(O, /obj/item/weapon/wirecutters))
		if(src.panel_open)
			attack_hand(user)
		return
	..()
	return

/obj/machinery/smartfridge/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/smartfridge/attack_ai(mob/user as mob)
	return 0

/obj/machinery/smartfridge/attack_hand(mob/user as mob)
	user.set_machine(src)
	if(src.seconds_electrified != 0)
		if(src.shock(user, 100))
			return
	interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/interact(mob/user as mob)
	if(!src.ispowered)
		return

	var/dat = "<TT><b>Select an item:</b><br>"

	if (contents.len == 0)
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		for (var/O in item_quants)
			if(item_quants[O] > 0)
				var/N = item_quants[O]
				dat += "<FONT color = 'blue'><B>[capitalize(O)]</B>:"
				dat += " [N] </font>"
				dat += "<a href='byond://?src=\ref[src];vend=[O];amount=1'>Vend</A> "
				if(N > 5)
					dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=5'>x5</A>)"
					if(N > 10)
						dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=10'>x10</A>)"
						if(N > 25)
							dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=25'>x25</A>)"
				if(N > 1)
					dat += "(<a href='?src=\ref[src];vend=[O];amount=[N]'>All</A>)"
				dat += "<br>"

		dat += "</TT>"
	if(panel_open)
		//One of the wires does absolutely nothing.
		var/list/vendwires = list(
			"Blue" = 1,
			"Red" = 2,
			"Black" = 3
		)
		dat += "<br><hr><br><B>Access Panel</B><br>"
		for(var/wiredesc in vendwires)
			var/is_uncut = src.wires & APCWireColorToFlag[vendwires[wiredesc]]
			dat += "[wiredesc] wire: "
			if(!is_uncut)
				dat += "<a href='?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Mend</a>"
			else
				dat += "<a href='?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Cut</a> "
				dat += "<a href='?src=\ref[src];pulsewire=[vendwires[wiredesc]]'>Pulse</a> "
			dat += "<br>"

		dat += "<br>"
		dat += "The orange light is [(src.seconds_electrified == 0) ? "off" : "on"].<BR>"
		dat += "The red light is [src.shoot_inventory ? "off" : "blinking"].<BR>"
	user << browse("<HEAD><TITLE>[src] Supplies</TITLE></HEAD><TT>[dat]</TT>", "window=smartfridge")
	return

/obj/machinery/smartfridge/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)

	if ((href_list["cutwire"]) && (src.panel_open))
		var/twire = text2num(href_list["cutwire"])
		if (!( istype(usr.get_active_hand(), /obj/item/weapon/wirecutters) ))
			usr << "You need wirecutters!"
			return
		if (src.isWireColorCut(twire))
			src.mend(twire)
		else
			src.cut(twire)
	else if ((href_list["pulsewire"]) && (src.panel_open))
		var/twire = text2num(href_list["pulsewire"])
		if (!istype(usr.get_active_hand(), /obj/item/device/multitool))
			usr << "You need a multitool!"
			return
		if (src.isWireColorCut(twire))
			usr << "You can't pulse a cut wire."
			return
		else
			src.pulse(twire)
	else if (href_list["vend"])
		var/N = href_list["vend"]
		var/amount = text2num(href_list["amount"])

		if(item_quants[N] <= 0) // Sanity check, there are probably ways to press the button when it shouldn't be possible.
			return

		item_quants[N] = max(item_quants[N] - amount, 0)

		var/i = amount
		for(var/obj/O in contents)
			if(O.name == N)
				O.loc = src.loc
				i--
				if(i <= 0)
					break
	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/*************
*	Hacking
**************/

/obj/machinery/smartfridge/proc/cut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor]
	src.wires &= ~wireFlag
	switch(wireIndex)
		if(WIRE_SHOCK)
			src.seconds_electrified = -1
		if (WIRE_SHOOTINV)
			if(!src.shoot_inventory)
				src.shoot_inventory = 1
		if(WIRE_SCANID)
			src.locked = 1

/obj/machinery/smartfridge/proc/mend(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	var/wireIndex = APCWireColorToIndex[wireColor] //not used in this function
	src.wires |= wireFlag
	switch(wireIndex)
		if(WIRE_SHOCK)
			src.seconds_electrified = 0
		if (WIRE_SHOOTINV)
			src.shoot_inventory = 0
		if(WIRE_SCANID)
			src.locked = 0

/obj/machinery/smartfridge/proc/pulse(var/wireColor)
	var/wireIndex = APCWireColorToIndex[wireColor]
	switch(wireIndex)
		if(WIRE_SHOCK)
			src.seconds_electrified = 30
		if (WIRE_SHOOTINV)
			src.shoot_inventory = !src.shoot_inventory
		if(WIRE_SCANID)
			src.locked = -1

/obj/machinery/smartfridge/proc/isWireColorCut(var/wireColor)
	var/wireFlag = APCWireColorToFlag[wireColor]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/smartfridge/proc/isWireCut(var/wireIndex)
	var/wireFlag = APCIndexToFlag[wireIndex]
	return ((src.wires & wireFlag) == 0)

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for (var/O in item_quants)
		if(item_quants[O] <= 0) //Try to use a record that actually has something to dump.
			continue

		item_quants[O]--
		for(var/obj/T in contents)
			if(T.name == O)
				T.loc = src.loc
				throw_item = T
				break
		break
	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target,16,3)
	src.visible_message("\red <b>[src] launches [throw_item.name] at [target.name]!</b>")
	return 1

/obj/machinery/smartfridge/proc/shock(mob/user, prb)
	if(!src.ispowered)		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/Topic(href, href_list)
	usr.set_machine(src)
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		if ((!src.allowed(usr)) && (!src.emagged) && (src.locked != -1) && href_list["vend"]) //For SECURE VENDING MACHINES YEAH
			usr << "\red Access denied." //Unless emagged of course
			return
	..()
	return

/obj/machinery/smartfridge/secure/interact(mob/user as mob)

	if(!src.ispowered)
		return

	var/dat = "<TT><b>Select an item:</b><br>"

	if (contents.len == 0)
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		for (var/O in item_quants)
			if(item_quants[O] > 0)
				var/N = item_quants[O]
				dat += "<FONT color = 'blue'><B>[capitalize(O)]</B>:"
				dat += " [N] </font>"
				dat += "<a href='byond://?src=\ref[src];vend=[O];amount=1'>Vend</A> "
				if(N > 5)
					dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=5'>x5</A>)"
					if(N > 10)
						dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=10'>x10</A>)"
						if(N > 25)
							dat += "(<a href='byond://?src=\ref[src];vend=[O];amount=25'>x25</A>)"
				if(N > 1)
					dat += "(<a href='?src=\ref[src];vend=[O];amount=[N]'>All</A>)"
				dat += "<br>"

		dat += "</TT>"
	if(panel_open)
		var/list/vendwires = list(
			"Violet" = 1,
			"Orange" = 2,
			"Green" = 3
		)
		dat += "<br><hr><br><B>Access Panel</B><br>"
		for(var/wiredesc in vendwires)
			var/is_uncut = src.wires & APCWireColorToFlag[vendwires[wiredesc]]
			dat += "[wiredesc] wire: "
			if(!is_uncut)
				dat += "<a href='?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Mend</a>"
			else
				dat += "<a href='?src=\ref[src];cutwire=[vendwires[wiredesc]]'>Cut</a> "
				dat += "<a href='?src=\ref[src];pulsewire=[vendwires[wiredesc]]'>Pulse</a> "
			dat += "<br>"

		dat += "<br>"
		dat += "The orange light is [(src.seconds_electrified == 0) ? "off" : "on"].<BR>"
		//dat += "The red light is [src.shoot_inventory ? "off" : "blinking"].<BR>"
		dat += "The green light is [src.locked == 1 ? "off" : "[src.locked == -1 ? "blinking" : "on"]"].<BR>"
	user << browse("<HEAD><TITLE>[src] Supplies</TITLE></HEAD><TT>[dat]</TT>", "window=smartfridge")
	return

//TODO: Make smartfridges hackable. - JoeyJo0
