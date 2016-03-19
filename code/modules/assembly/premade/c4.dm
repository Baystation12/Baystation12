/obj/item/device/assembly_holder/c4
	name = "Large explosive"
	desc = "This looks like it'll hurt..Alot."
	icon_state = "bomb"
	item_state = "assembly"
	throwforce = 9
	w_class = 5
	throw_speed = 1
	throw_range = 2
	flags = CONDUCT

	premade_devices = list(/obj/item/device/assembly/explosive/strong)

	New(var/type_change = 0)
		if(!type_change)
			var/obj/item/device/assembly/explosive/strong/S = new(src)
			attach_device(null, S)
		..()