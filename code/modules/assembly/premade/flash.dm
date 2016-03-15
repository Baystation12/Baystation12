/obj/item/device/assembly_holder/flash
	name = "flash"
	desc = "Used for blinding and being an asshole."
	icon_state = "flash"
	item_state = "flashtool"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT

	New(var/type_change = 0)
		if(!type_change)
			var/obj/item/device/assembly/flash/flash = new (src)
			var/obj/item/device/assembly/button/button = new (src)
			var/obj/item/device/assembly/power_bank/power = new (src)
			attach_device(null, button)
			attach_device(null, flash)
			attach_device(null, power)
			flash.connects_to.Cut()
			power.connects_to = list("2")
		..()