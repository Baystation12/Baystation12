/datum/rdcontract/prototype
	name = "deliver prototype"
	desc = "deliver a prototype"

	reward = 400
	var/list/possible_types = list(
		/obj/item/weapon/cell/super,
		/obj/item/weapon/stock_parts/capacitor/adv,
		/obj/item/weapon/stock_parts/manipulator/nano,
		/obj/item/weapon/stock_parts/matter_bin/adv,
		/obj/item/weapon/stock_parts/micro_laser/high,
		/obj/item/weapon/stock_parts/scanning_module/adv,
		/obj/item/device/mmi,
		/obj/item/device/mmi/radio_enabled,
		/obj/item/weapon/pinpointer/radio,
		/obj/item/weapon/circuitboard/aicore,
		/obj/item/weapon/aiModule/oxygen,
		/obj/item/weapon/aiModule/purge
	)

/datum/rdcontract/prototype/setup()
	..()

	delivery_type = pick(possible_types)

	// make a unique key for this contract
	var/ukey = "prototype-[delivery_type]"
	while(GLOB.used_rd_contracts.Find(ukey))
		possible_types.Remove(delivery_type)
		// this while should always complete unless we run out of original contracts
		if(possible_types.len == 0)
			qdel(src)
			return 0

		delivery_type = pick(possible_types)
		ukey = "prototype-[delivery_type]"
	GLOB.used_rd_contracts.Add(ukey)

	var/obj/item/proto = new delivery_type()
	name = "Deliver a [proto.name]"
	desc = "Deliver a [proto.name] prototype for experimental use."
	proto = null

/datum/rdcontract/prototype/check_completion(var/obj/item/O)
	if(!istype(O, delivery_type))
		return 0

	return 1

// difficult contract but more money
/datum/rdcontract/prototype/highend
	reward = 800
	possible_types = list(
		/obj/item/weapon/storage/backpack/holding,
		/obj/item/device/price_scanner,
		/obj/item/weapon/shield_diffuser,
		/obj/item/weapon/smes_coil/super_capacity,
		/obj/item/rig_module/cooling_unit
	)
