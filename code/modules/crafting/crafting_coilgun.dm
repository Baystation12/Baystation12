// We really need some datums for this.
/obj/item/coilgun_assembly
	name = "coilgun stock"
	desc = "It might be a coilgun, someday."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "coilgun_construction_1"

/decl/crafting_stage/material/coilgun_body
	begins_with_object_type = /obj/item/coilgun_assembly
	item_desc = "It's a half-built coilgun with a metal frame loosely shaped around the stock."
	progress_message = "You shape some steel sheets around the stock to form a body."
	item_icon_state = "coilgun_construction_2"
	next_stages = list(/decl/crafting_stage/tape/coilgun)

/decl/crafting_stage/tape/coilgun
	progress_message = "You tape the coilgun components securely together"
	item_desc = "It's a half-built coilgun with a metal frame duct-taped to the stock."
	item_icon_state = "coilgun_construction_3"
	next_stages = list(/decl/crafting_stage/pipe/coilgun)

/decl/crafting_stage/pipe/coilgun
	progress_message = "You jam the pipe into the coilgun assembly, forming a barrel."
	item_desc = "It's a half-built coilgun with a length of pipe attached to the body."
	item_icon_state = "coilgun_construction_4"
	next_stages = list(/decl/crafting_stage/welding/coilgun)

/decl/crafting_stage/welding/coilgun
	progress_message = "You weld the barrel of the coilgun assembly into place."
	item_desc = "It's a half-built coilgun with a length of pipe welded to the body."
	item_icon_state = "coilgun_construction_5"
	next_stages = list(/decl/crafting_stage/wiring/coilgun)

/decl/crafting_stage/wiring/coilgun
	progress_message = "You wire the components of the coilgun assembly together."
	item_desc = "It's a half-built coilgun with a cable mount and capacitor jack wired to the frame."
	item_icon_state = "coilgun_construction_6"
	next_stages = list(/decl/crafting_stage/coilgun_coil)

/decl/crafting_stage/coilgun_coil
	progress_message = "You thread a superconducting coil over the barrel of the coilgun assembly."
	completion_trigger_type = /obj/item/stock_parts/smes_coil
	item_desc = "It's a half-built coilgun with a single superconducting coil threaded onto the barrel."
	item_icon_state = "coilgun_construction_7"
	next_stages = list(/decl/crafting_stage/coilgun_coil/two)

/decl/crafting_stage/coilgun_coil/two
	progress_message = "You thread a second superconducting coil over the barrel of the coilgun assembly."
	item_desc = "It's a half-built coilgun with a pair of superconducting coils threaded onto the barrel."
	item_icon_state = "coilgun_construction_8"
	next_stages = list(/decl/crafting_stage/coilgun_coil/three)

/decl/crafting_stage/coilgun_coil/three
	progress_message = "You thread a third and final superconducting coil over the barrel of the coilgun assembly."
	item_desc = "It's a half-built coilgun with three superconducting coils attached to the body, waiting to be secured."
	item_icon_state = "coilgun_construction_9"
	next_stages = list(/decl/crafting_stage/screwdriver/coilgun)

/decl/crafting_stage/screwdriver/coilgun
	progress_message = "You secure the coilgun assembly together, finishing it off."
	product = /obj/item/gun/magnetic
