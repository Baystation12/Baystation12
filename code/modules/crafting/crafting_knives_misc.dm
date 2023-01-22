// Knives and sword crafting, along with all one-off items.

// Balisong

/decl/crafting_stage/balisong_blade
	begins_with_object_type = /obj/item/material/butterflyhandle
	item_desc = "It's an unfinished balisong with some loose screws."
	item_icon_state = "butterfly"
	progress_message = "You attach the knife blade to the handle."
	completion_trigger_type = /obj/item/material/small_blade
	next_stages = list(/decl/crafting_stage/screwdriver/balisong)

/decl/crafting_stage/screwdriver/balisong
	progress_message = "You secure the handle and the blade together."
	product = /obj/item/material/knife/folding/combat/balisong

/decl/crafting_stage/screwdriver/balisong/get_product(obj/item/work)
	var/obj/item/material/small_blade/blade = locate() in work
	. = ispath(product, /obj/item/material) && new product(get_turf(work), blade?.material?.name)

// Makeshift sword

/decl/crafting_stage/sword_wires
	begins_with_object_type = /obj/item/material/large_blade
	item_desc = "It's a large metal blade with wires winded as a handle."
	item_icon_state = "sword_wired"
	progress_message = "You thread the cable around an end of the blade."
	completion_trigger_type = /obj/item/handcuffs/cable
	next_stages = list(/decl/crafting_stage/material/sword_handle)

/decl/crafting_stage/material/sword_handle
	progress_message = "You slide the rod in besides the blade, tying it together with the wires."
	completion_trigger_type = /obj/item/stack/material/rods
	product = /obj/item/material/sword/makeshift

/decl/crafting_stage/sword_handle/get_product(obj/item/work)
	var/obj/item/material/large_blade/blade = locate() in work
	. = ispath(product, /obj/item/material) && new product(get_turf(work), blade?.material?.name)

// Improvised soda can bomb

/decl/crafting_stage/wiring/can_bomb
	item_icon_state = "ied_wired"
	progress_message = "You add a length of wire and secure it around the hollow frame."
	item_desc = "A can that had its label ripped off, with a length of wire jutting out of it."
	next_stages = list(/decl/crafting_stage/can_bomb)

/decl/crafting_stage/can_bomb
	completion_trigger_type  = /obj/item/welder_tank
	progress_message = "You add the welding fuel tank and rig the wire to its output, sealing the bomb."
	product = /obj/item/grenade/frag/makeshift // explosive.dm

// Splints

/decl/crafting_stage/tape/makeshift_splint
	begins_with_object_type = /obj/item/stack/material/rods
	progress_message = "You wrap the tape around the rod as a brace, fashioning a splint."
	product = /obj/item/stack/medical/splint/ghetto // stacks/medical.dm

// Sheet armor

/decl/crafting_stage/material/armor_half
	begins_with_object_type = /obj/item/rail_assembly
	item_desc = "It's an unfinished balisong with some loose screws."
	item_icon_state = "armor_half"
	progress_message = "You press the sheets together, securing them in place between the rods."
	next_stages = list(/decl/crafting_stage/armor_full)

/decl/crafting_stage/armor_full
	completion_trigger_type  = /obj/item/rail_assembly
	progress_message = "You affix the second rail assembly to the opposing side, finishing off the makeshift vest."
	product = /obj/item/clothing/suit/armor/makeshift // suits/armors.dm
