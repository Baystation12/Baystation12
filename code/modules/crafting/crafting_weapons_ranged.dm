// A collection of guns done with the weapon stock, for all kinds of dubiously legal and definitely violent tasks.

// Coilgun

/decl/crafting_stage/material/coilgun_body
	begins_with_object_type = /obj/item/weapon_frame
	item_desc = "It's a half-built coilgun with a metal frame loosely shaped around the stock."
	item_icon_state = "coilgun1"
	progress_message = "You shape some steel sheets around the stock to form a body."
	next_stages = list(/decl/crafting_stage/tape/coilgun)

/decl/crafting_stage/tape/coilgun
	item_desc = "It's a half-built coilgun with a metal frame duct-taped to the stock."
	item_icon_state = "coilgun2"
	progress_message = "You tape the coilgun components securely together."
	next_stages = list(/decl/crafting_stage/pipe/coilgun)

/decl/crafting_stage/pipe/coilgun
	item_desc = "It's a half-built coilgun with a length of pipe attached to the body."
	item_icon_state = "coilgun3"
	progress_message = "You jam the pipe into the coilgun assembly, forming a barrel."
	next_stages = list(/decl/crafting_stage/welding/coilgun)

/decl/crafting_stage/welding/coilgun
	item_desc = "It's a half-built coilgun with a length of pipe welded to the body."
	item_icon_state = "coilgun4"
	progress_message = "You weld the barrel of the coilgun assembly into place."
	next_stages = list(/decl/crafting_stage/wiring/coilgun)

/decl/crafting_stage/wiring/coilgun
	item_desc = "It's a half-built coilgun with a cable mount and capacitor jack wired to the frame."
	item_icon_state = "coilgun5"
	progress_message = "You wire the components of the coilgun assembly together."
	next_stages = list(/decl/crafting_stage/coilgun_coil)

/decl/crafting_stage/coilgun_coil
	completion_trigger_type = /obj/item/stock_parts/smes_coil
	item_desc = "It's a half-built coilgun with a single superconducting coil threaded onto the barrel."
	item_icon_state = "coilgun6"
	progress_message = "You thread a superconducting coil over the barrel of the coilgun assembly."
	next_stages = list(/decl/crafting_stage/coilgun_coil/two)

/decl/crafting_stage/coilgun_coil/two
	item_desc = "It's a half-built coilgun with two superconducting coils threaded onto the barrel."
	item_icon_state = "coilgun7"
	progress_message = "You thread a second superconducting coil over the barrel of the coilgun assembly, and close the system."
	next_stages = list(/decl/crafting_stage/coilgun_rail)

/decl/crafting_stage/coilgun_rail
	completion_trigger_type = /obj/item/rail_assembly
	item_desc = "It's a half-built coilgun with a pair of superconducting coils threaded onto the barrel."
	item_icon_state = "coilgun8"
	progress_message = "You affix the rails across the coilgun assembly barrel, connecting them to the superconducting coils."
	next_stages = list(/decl/crafting_stage/screwdriver/coilgun)

/decl/crafting_stage/screwdriver/coilgun
	progress_message = "You secure the coilgun assembly together, finishing it off."
	product = /obj/item/gun/magnetic		//magnetic/magnetic.dm

// Zipgun

/decl/crafting_stage/pipe/zipgun
	begins_with_object_type = /obj/item/weapon_frame
	item_desc = "A half-built zipgun with a barrel loosely fitted to the stock."
	item_icon_state = "zipgun1"
	progress_message = "You fit the pipe into the zipgun as a crude barrel."
	next_stages = list(/decl/crafting_stage/tape/zipgun)

/decl/crafting_stage/tape/zipgun
	item_desc = "A half-built zipgun with a barrel that has been secured to the stock with tape."
	item_icon_state = "zipgun2"
	progress_message = "You secure the zipgun assembly with the roll of tape."
	next_stages = list(/decl/crafting_stage/zipgun_trigger)

/decl/crafting_stage/zipgun_trigger
	completion_trigger_type = /obj/item/device/assembly/mousetrap
	item_desc = "A half-built zipgun with a trigger and firing pin assembly loosely fitted into place."
	item_icon_state = "zipgun3"
	progress_message = "You take the mousetrap apart and construct a crude trigger for the zipgun."
	next_stages = list(/decl/crafting_stage/screwdriver/zipgun)

/decl/crafting_stage/screwdriver/zipgun
	progress_message = "You secure the trigger assembly and finish off the zipgun."
	product = /obj/item/gun/projectile/pirate/unloaded	//zipgun.dm

// Crossbow

/decl/crafting_stage/crossbow_switch
	begins_with_object_type = /obj/item/weapon_frame
	completion_trigger_type = /obj/item/frame/light_switch
	item_icon_state = "crossbow1"
	progress_message = "You disassemble the switch and amount it under the stock."
	next_stages = list(/decl/crafting_stage/crossbow_rods)

/decl/crafting_stage/crossbow_rods
	completion_trigger_type = /obj/item/stack/material/rods
	stack_consume_amount = 3
	item_icon_state = "crossbow2"
	progress_message = "You assemble a backbone of rods around the stock."
	next_stages = list(/decl/crafting_stage/welding/crossbow_rods)

/decl/crafting_stage/welding/crossbow_rods
	item_desc = "It is a half-built crossbow with a loose rod frame in place."
	item_icon_state = "crossbow3"
	progress_message = "You weld the rods into place."
	next_stages = list(/decl/crafting_stage/wiring/crossbow_battery)

/decl/crafting_stage/wiring/crossbow_battery
	item_desc = "It is a half-built crossbow with a steel backbone welded in place."
	item_icon_state = "crossbow4"
	progress_message = "You wire a crude cell mount into the top of the crossbow."
	next_stages = list(/decl/crafting_stage/material/crossbow_plastic)

/decl/crafting_stage/material/crossbow_plastic
	completion_trigger_type = /obj/item/stack/material
	stack_material = MATERIAL_PLASTIC
	stack_consume_amount  = 3
	progress_message = "You assemble and install a heavy plastic lath onto the crossbow."
	item_icon_state = "crossbow5"
	item_desc = "It is a half-built crossbow with a steel backbone and a cell mount installed."
	next_stages = list(/decl/crafting_stage/wiring/crossbow_string)

/decl/crafting_stage/wiring/crossbow_string
	item_desc = "It is a half-built crossbow with a backbone, plastic lath and a cell mount installed."
	item_icon_state = "crossbow6"
	progress_message = "You string a steel cable across the crossbow's lath."
	next_stages = list(/decl/crafting_stage/screwdriver/crossbow)

/decl/crafting_stage/screwdriver/crossbow
	progress_message = "You secure the crossbow's various parts."
	product = /obj/item/gun/launcher/crossbow //crossbow.dm
