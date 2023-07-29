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

/singleton/crafting_stage/material/wired_rod
	begins_with_object_type = /obj/item/handcuffs/cable
	item_icon_state = "wiredrod"
	progress_message = "You wind the cable cuffs around the top of the rod."
	item_desc = "A rod with a cable knot tightly tied in one end."
	completion_trigger_type = /obj/item/stack/material/rods
	stack_consume_amount = 1
	next_stages = list(
		/singleton/crafting_stage/spear_blade_shard,
		/singleton/crafting_stage/spear_blade_blade,
		/singleton/crafting_stage/stunprod_wirecutters,
		/singleton/crafting_stage/material/rail_assembly,
	)

/singleton/crafting_stage/material/rail_assembly
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

/singleton/crafting_stage/welding/hollow_can
	begins_with_object_type = /obj/item/reagent_containers/food/drinks/cans
	item_icon_state = "hollow_can"
	progress_message = "You remove the top lid and weld the can seams shut."
	item_desc = "An empty container with its edges welded shut."
	next_stages = list(
		/singleton/crafting_stage/wiring/can_bomb,
		/singleton/crafting_stage/can_barrel,
	)

/singleton/crafting_stage/can_barrel
	completion_trigger_type = /obj/item/reagent_containers/food/drinks/cans
	item_icon_state = "can_stack"
	progress_message = "You rip the label off the can and affix it on top of the hollow container."
	item_desc = "Two cans that had their labels ripped off, tightly squeezed ontop of each other."
	next_stages = list(/singleton/crafting_stage/welding/can_barrel)

/singleton/crafting_stage/welding/can_barrel
	progress_message = "You weld both cans together, finishing off the makeshift barrel."
	product = /obj/item/makeshift_barrel

/obj/item/makeshift_barrel
	name = "makeshift weapon barrel"
	desc = "A hollow bore made of two cans tightly welded together. There's no way this is safe."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "can_barrel"
	matter = list(MATERIAL_ALUMINIUM = 60)


// Bomb Making

/obj/item/warhead_core_case
	name = "warhead core assembly frame"
	desc = "The first step to mass destruction."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "core0"
	item_state = "core0"


/obj/item/warhead_core
	name = "warhead core assembly"
	desc = "A cuboid osmium-carbide plasteel shell. This has a central chamber to hold a payload."
	icon = 'icons/obj/crafting_icons.dmi'
	icon_state = "core6"
	item_state = "core6"


/obj/item/warhead_core/uranium
	name = "uranium warhead core"
	desc = "A bulky uranium core with wires coiled around its length. A timer-detonator assembly sits snugly on it's frame. This one can cause a big explosion."
	icon = 'icons/obj/nuke.dmi'
	icon_state = "core_u"


/obj/item/warhead_core/tritium
	name = "tritium warhead core"
	desc = "A bulky tritium core with wires coiled around its length. A timer-detonator assembly sits snugly on it's frame. This one can cause a big fire."
	icon = 'icons/obj/nuke.dmi'
	icon_state = "core_t"


/obj/item/warhead_core/supermatter
	name = "supermatter warhead core"
	desc = "A bulky supermatter core with wires coiled around its length. A timer-detonator assembly sits snugly on it's frame. This one can cause a cascading delamination."
	icon = 'icons/obj/nuke.dmi'
	icon_state = "core_s"
