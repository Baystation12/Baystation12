// General items used in other crafting recipes.


// Components made from sheets of various materials.

/obj/item/material/small_blade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "small_blade"
	force_multiplier = 0.1
	thrown_force_multiplier = 0.1

/obj/item/material/large_blade
	name = "large blade"
	desc = "A large, heavy blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "large_blade"
	force_multiplier = 0.1
	thrown_force_multiplier = 0.1

/obj/item/material/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "butterfly1"
	force_multiplier = 0.1
	thrown_force_multiplier = 0.1

/obj/item/cannonframe
	name = "pneumatic cannon frame"
	desc = "A half-finished pneumatic cannon."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "pneumatic0"
	item_state = "pneumatic"

/obj/item/weapon_frame
	name = "weapon frame"
	desc = "It might be a weapon, someday."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "weapon_frame"
	item_state = "crossbow-solid"

// Components made out of rods, or rails.

/decl/crafting_stage/material/wired_rod
	begins_with_object_type = /obj/item/handcuffs/cable
	item_icon_state = "wiredrod"
	progress_message = "You wind the cable cuffs around the top of the rod."
	item_desc = "A rod with a cable knot tightly tied in one end."
	completion_trigger_type = /obj/item/stack/material/rods
	stack_consume_amount = 1
	next_stages = list(
		/decl/crafting_stage/spear_blade_shard,
		/decl/crafting_stage/spear_blade_blade,
		/decl/crafting_stage/stunprod_wirecutters,
		/decl/crafting_stage/material/rail_assembly,
	)

/decl/crafting_stage/material/rail_assembly
	completion_trigger_type = /obj/item/stack/material/rods
	stack_consume_amount = 1
	progress_message = "You wind the remaining length of cable around the new rod, securing them together."
	product = /obj/item/rail_assembly

/obj/item/rail_assembly
	name = "rail assembly"
	desc = "Two parallel rods tightly held together as a rail."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "rail_assembly"
	matter = list(MATERIAL_STEEL = 100)

// Components made out of aluminum cans.

/decl/crafting_stage/welding/hollow_can
	begins_with_object_type = /obj/item/reagent_containers/food/drinks/cans
	item_icon_state = "hollow_can"
	progress_message = "You remove the top lid and weld the can seams shut."
	item_desc = "An empty container with its edges welded shut."
	next_stages = list(
		/decl/crafting_stage/wiring/can_bomb,
		/decl/crafting_stage/can_barrel,
	)

/decl/crafting_stage/can_barrel
	completion_trigger_type = /obj/item/reagent_containers/food/drinks/cans
	item_icon_state = "can_stack"
	progress_message = "You rip the label off the can and affix it on top of the hollow container."
	item_desc = "Two cans that had their labels ripped off, tightly squeezed ontop of each other."
	next_stages = list(/decl/crafting_stage/welding/can_barrel)

/decl/crafting_stage/welding/can_barrel
	progress_message = "You weld both cans together, finishing off the makeshift barrel."
	product = /obj/item/makeshift_barrel

/obj/item/makeshift_barrel
	name = "makeshift weapon barrel"
	desc = "A hollow bore made of two cans tightly welded together. There's no way this is safe."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "can_barrel"
	matter = list(MATERIAL_ALUMINIUM = 60)