//PROGRESSION SYSTEM: Miners start with a basic ass manual pickaxe. They can shortly buy an autodrill, or save up for a /TG/ Kinetic Accelerator.
//HARDSUITS: Miners all start with an *empty* industrial hardsuit. Many of the items they can buy here (auto-drill, kinetic accelerator) can be converted into modules
//			with a special machine.
//VENDOR: Obj/item's are immediately dispensed by the vendor. Machines, structures, vehicles, and etc get spawned on the cargo shuttle.
//Think up of lots of items. Not everything needs to be unique or even mining-special, but it should be neat. Convert most of /tg/'s items. 25% of this at least
//	should be bling. Things that shorten the distance between base and mining. Instant-teleporters should be one use.
var/global/list/minevendor_list = list( //keep in order of price
	new /datum/data/mining_equipment("Food Ration",					/obj/item/weapon/reagent_containers/food/snacks/liquidfood,	10,					5),
	new /datum/data/mining_equipment("Poster",						/obj/item/weapon/contraband/poster,							10,					20),
	new /datum/data/mining_equipment("Ore Scanner Pad",				/obj/item/weapon/ore_radar,									10,					50),
	new /datum/data/mining_equipment("5 Red Flags",					/obj/item/stack/flag/red,									10,					50),
	new /datum/data/mining_equipment("5 Green Flags",				/obj/item/stack/flag/green,									10,					50),
	new /datum/data/mining_equipment("5 Yellow Flags",				/obj/item/stack/flag/yellow,								10,					50),
	new /datum/data/mining_equipment("Ore-bag",						/obj/item/weapon/storage/ore,								25,					50),
	new /datum/data/mining_equipment("Meat Pizza",					/obj/item/pizzabox/meat,									25,					50),
	new /datum/data/mining_equipment("Lantern",						/obj/item/device/flashlight/lantern,						10,					75),
	new /datum/data/mining_equipment("Shovel",						/obj/item/weapon/shovel,									15,					100),
	new /datum/data/mining_equipment("Silver Pickaxe",				/obj/item/weapon/pickaxe/silver,							10,					100),
	new /datum/data/mining_equipment("Ore Box",						/obj/structure/ore_box,										-1,					150,	1),
	new /datum/data/mining_equipment("Emergency Floodlight",		/obj/item/weapon/floodlight_diy, 							-1,					150,	1),
	new /datum/data/mining_equipment("Premium Cigar",				/obj/item/clothing/mask/smokable/cigarette/cigar/havana, 	30,					150),
	new /datum/data/mining_equipment("Lottery Chip",				/obj/item/weapon/spacecash/ewallet/lotto,					50,					200),
	new /datum/data/mining_equipment("Ripley Paint Kit",			/obj/item/device/kit/paint/ripley/random,					15,					200),
	new /datum/data/mining_equipment("Mining Drill",				/obj/item/weapon/pickaxe,									10,					200),
	new /datum/data/mining_equipment("Deep Ore Scanner",			/obj/item/weapon/mining_scanner,							10,					250),
	new /datum/data/mining_equipment("Magboots",					/obj/item/clothing/shoes/magboots,							10,					300),
	new /datum/data/mining_equipment("Autochisel",					/obj/item/weapon/autochisel,								10,					400),
	new /datum/data/mining_equipment("Jetpack",						/obj/item/weapon/tank/jetpack,								10,					400),
	new /datum/data/mining_equipment("Industrial Drill Brace",		/obj/machinery/mining/brace,								-1,					500,	1),
	new /datum/data/mining_equipment("Point Transfer Card",			/obj/item/weapon/card/mining_point_card,					-1,					500),
	new /datum/data/mining_equipment("Explorer's Belt",				/obj/item/weapon/storage/belt/mining,						10,					500),
	new /datum/data/mining_equipment("First-Aid Kit",				/obj/item/weapon/storage/firstaid/regular,					30,					600),
	new /datum/data/mining_equipment("Ore Magnet",					/obj/item/weapon/oremagnet,									10,					600),
	new /datum/data/mining_equipment("Minecart",					/obj/structure/closet/crate/miningcar,						-1,					600,	1),
	new /datum/data/mining_equipment("Resonator",					/obj/item/weapon/resonator,									10,					700),
	new /datum/data/mining_equipment("Mining RIG",					/obj/item/weapon/rig/industrial,							5,					750),
	new /datum/data/mining_equipment("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,						10,					750),
	new /datum/data/mining_equipment("Kinetic Accelerator",			/obj/item/weapon/gun/energy/kinetic_accelerator,			10,					750),
	new /datum/data/mining_equipment("Ore Summoner",					/obj/item/weapon/oreportal,								3,					800),
	new /datum/data/mining_equipment("KA Cooldown Decrease",		/obj/item/borg/upgrade/modkit/cooldown,						15,					1000),
	new /datum/data/mining_equipment("Lazarus Injector",			/obj/item/weapon/lazarus_injector,							25,					1000),
	new /datum/data/mining_equipment("Industrial Drill Head",		/obj/machinery/mining/drill,								-1,					1000,	1),
	new /datum/data/mining_equipment("Super Resonator",				/obj/item/weapon/resonator/upgraded,						10,					1250),
	new /datum/data/mining_equipment("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/turfs,					15,					1500),
	new /datum/data/mining_equipment("Diamond Pickaxe",				/obj/item/weapon/pickaxe/diamond,							10,					1500),
	new /datum/data/mining_equipment("Plasmacutter",				/obj/item/weapon/gun/energy/plasmacutter,					1,					3750)
	)

/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = 1
	anchored = 1
	var/obj/item/weapon/card/id/inserted_id

/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/amount = 0 // -1 is the special number for infinite items like things that can be ordered from the shuttle
	var/cost = 0
	var/shuttle

/datum/data/mining_equipment/New(name, path, amount, cost, shuttle)
	src.equipment_name = name
	src.equipment_path = path
	src.amount = amount
	src.cost = cost
	src.shuttle = shuttle

/obj/item/weapon/circuitboard/machine/mining_equipment_vendor
	name = "circuit board (Mining Equipment Vendor)"
	build_path = /obj/machinery/mineral/equipment_vendor
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/matter_bin = 3)

/obj/machinery/mineral/equipment_vendor/power_change()
	..()
	update_icon()

/obj/machinery/mineral/equipment_vendor/update_icon()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"
	return

/obj/machinery/mineral/equipment_vendor/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/mineral/equipment_vendor/interact(mob/user)
	var/dat
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.mining_points] mining points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"
	dat += "</div>"
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='300'>"
	for(var/datum/data/mining_equipment/prize in minevendor_list)
		if(prize.amount > 0)
			dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A> ([prize.amount])</td></tr>"
		else if(prize.amount == -1)
			dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A> (No limit.)</td></tr>"
		else
			dat += "<tr><td>[prize.equipment_name]</td><td>(Out of stock!)</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "miningvendor", "Mining Equipment Vendor", 400, 350)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/mineral/equipment_vendor/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				inserted_id.loc = loc
				if(!usr.get_active_hand())
					usr.put_in_hands(inserted_id)
				inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if(istype(I))
				usr.drop_item()
				I.loc = src
				inserted_id = I
			else usr << "<span class='danger'>No valid ID.</span>"
	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/data/mining_equipment/prize = locate(href_list["purchase"])
			if (!prize || !(prize in minevendor_list))
				return
			if(prize.amount <= 0 && prize.amount != -1)
				return
			if(prize.cost > inserted_id.mining_points)
				return
			else
				inserted_id.mining_points -= prize.cost
				if(prize.amount != -1)
					prize.amount--
				new prize.equipment_path(src.loc)

	updateUsrDialog()
	return

/obj/machinery/mineral/equipment_vendor/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/C = usr.get_active_hand()
		if(istype(C) && !istype(inserted_id))
			usr.drop_item()
			C.loc = src
			inserted_id = C
			interact(user)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()
