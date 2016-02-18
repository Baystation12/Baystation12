/obj/item/device/assembly/disposal_pad
	name = "disposal pad"
	desc = "A pressure pad placed inside of a disposal pipe"
	icon_state = "disp_pad"
	item_state = "assembly"
	throwforce = 6
	w_class = 4
	throw_speed = 2
	throw_range = 1
	density = 1
	weight = 3
	var/obj/structure/disposalpipe/target

	wires = WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND
	wire_num = 3

/obj/item/device/assembly/disposal_pad/disposal_trigger(var/obj/structure/disposalpipe/D)
	if(D == target)
		process_activation()
	return 1

/obj/item/device/assembly/disposal_pad/anchored(anchoring as num)
	if(anchoring)
		var/turf/T = get_turf(src)
		if(isturf(T))
			target = locate() in T
			target.attached_assembly = src
	else
		target = null
		target.attached_assembly = null
	return 1
