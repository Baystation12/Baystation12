// Shim for non-stock_parts machine components
/obj/item/weapon/stock_parts/building_material
	name = "building materials"
	desc = "Various standard wires, pipes, and other materials."
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	part_flags = PART_FLAG_QDEL
	var/list/materials

/obj/item/weapon/stock_parts/building_material/Destroy()
	QDEL_NULL_LIST(materials)
	. = ..()

/obj/item/weapon/stock_parts/building_material/proc/number_of_type(var/type)
	. = 0
	for(var/obj/item/thing in materials)
		if(istype(thing, type))
			if(isstack(thing))
				var/obj/item/stack/stack = thing
				. += stack.amount
			else
				.++

/obj/item/weapon/stock_parts/building_material/proc/add_material(var/obj/item/new_material)
	if(istype(new_material, /obj/item/stack))
		var/obj/item/stack/stack = new_material
		for(var/obj/item/stack/old_stack in materials)
			if(stack.transfer_to(old_stack) && QDELETED(stack))
				return
	LAZYADD(materials, new_material)
	new_material.forceMove(null)

// amount will cap the amount given in a stack, but may return less than amount specified.
/obj/item/weapon/stock_parts/building_material/proc/remove_material(material_type, amount)
	if(ispath(material_type, /obj/item/stack))
		for(var/obj/item/stack/stack in materials)
			if(stack.stacktype == material_type)
				var/stack_amount = stack.get_amount()
				if(stack_amount <= amount)
					materials -= stack
					stack.dropInto(loc)
					amount -= stack_amount
					return stack
				var/obj/item/stack/new_stack = stack.split(amount)
				new_stack.dropInto(loc)
				return new_stack
	for(var/obj/item/item in materials)
		if(istype(item, material_type))
			materials -= item
			item.dropInto(loc)
			return item

/obj/item/weapon/stock_parts/building_material/on_uninstall(var/obj/machinery/machine)
	for(var/obj/item/I in materials)
		I.dropInto(loc)
	materials = null
	..()