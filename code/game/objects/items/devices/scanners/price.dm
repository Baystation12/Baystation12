/obj/item/device/scanner/price
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	icon_state = "price_scanner"
	origin_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4)
	scan_sound = 'sound/effects/checkout.ogg'

/obj/item/device/scanner/price/is_valid_scan_target(atom/movable/target)
	return !!get_value(target)

/obj/item/device/scanner/price/scan(atom/movable/target, mob/user)
	scan_title = "Price estimations"
	var/data = "\The [target]: [get_value(target)] [GLOB.using_map.local_currency_name]"
	if(!scan_data)
		scan_data = data
	else
		scan_data += "<br>[data]"
	user.show_message(data)