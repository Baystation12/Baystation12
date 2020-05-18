/obj/item/weapon/zipgunframe
	name = "zip gun frame"
	desc = "A half-finished zip gun."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "zipgun0"
	item_state = "zipgun-solid"

/decl/crafting_stage/pipe/zipgun
	begins_with_object_type = /obj/item/weapon/zipgunframe
	item_desc = "A half-built zipgun with a barrel loosely fitted to the stock."
	item_icon_state = "zipgun1"
	progress_message = "You fit the pipe into the zipgun as a crude barrel."
	next_stages = list(/decl/crafting_stage/tape/zipgun)

/decl/crafting_stage/tape/zipgun
	item_icon_state = "zipgun2"
	item_desc = "A half-built zipgun with a barrel that has been secured to the stock with tape."
	progress_message = "You secure the zipgun assembly with the roll of tape."
	next_stages = list(/decl/crafting_stage/zipgun_trigger)

/decl/crafting_stage/zipgun_trigger
	item_icon_state = "zipgun3"
	completion_trigger_type = /obj/item/device/assembly/mousetrap
	item_desc = "A half-built zipgun with a trigger and firing pin assembly loosely fitted into place."
	progress_message = "You take the mousetrap apart and construct a crude trigger for the zipgun."
	next_stages = list(/decl/crafting_stage/screwdriver/zipgun)

/decl/crafting_stage/screwdriver/zipgun
	progress_message = "You secure the trigger assembly and finish off the zipgun."
	product = /obj/item/weapon/gun/projectile/pirate/unloaded
