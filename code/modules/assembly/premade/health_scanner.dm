/obj/item/device/assembly_holder/health_scanner
	name = "health scanner"
	desc = "A health scanner!"
	icon_state = "assembly"
	item_state = "assembly"
	throwforce = 9
	w_class = 5
	throw_speed = 1
	throw_range = 2
	flags = CONDUCT

	New(var/type_change = 0)
		if(!type_change)
			var/obj/item/device/assembly/target_finder/T = new(src)
			attach_device(null, T)
			var/obj/item/device/assembly/scanner/healthanalyzer/H = new(src)
			attach_device(null, H)
		..()