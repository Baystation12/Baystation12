/datum/rdcontract/prototype
	name = "deliver prototype"
	desc = "deliver a prototype"
	ukey_name = "prototype"

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

/datum/rdcontract/prototype/get_ukey_id()
	if(LAZYLEN(possible_types) == 0)
		return null

	delivery_type = pick_n_take(possible_types)
	return delivery_type

/datum/rdcontract/prototype/setup()
	. = ..()

	var/obj/item/proto = delivery_type
	name = "Deliver \a [initial(proto.name)]"
	desc = "Deliver \a [initial(proto.name)] prototype for experimental use."
	proto = null

/datum/rdcontract/prototype/check_completion(var/obj/item/O)
	if(!istype(O, delivery_type))
		return 0

	return 1

// difficult contract but more money
/datum/rdcontract/prototype/highend
	highend = 1
	reward = 800
	possible_types = list(
		/obj/item/weapon/storage/backpack/holding,
		/obj/item/device/price_scanner,
		/obj/item/weapon/shield_diffuser,
		/obj/item/weapon/smes_coil/super_capacity,
		/obj/item/rig_module/cooling_unit
	)
