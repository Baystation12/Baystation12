//Dummy's 101 on crafting home-made WMDs!!!!!!!!!!!

/* CORE FRAME */

/singleton/crafting_stage/material/warhead_core_assembly_start
	begins_with_object_type = /obj/item/warhead_core_case
	stack_material = MATERIAL_OSMIUM
	stack_consume_amount = 7
	item_desc = "It's a flimsy core frame shaped from steel and lined with osmium. It will need some reinforcements."
	item_icon_state = "core1"
	progress_message = "You bend osmium, lining the interior of the case assembly."
	next_stages = list(/singleton/crafting_stage/material/warhead_core_assembly_rod)

/singleton/crafting_stage/material/warhead_core_assembly_rod
	stack_material = MATERIAL_OSMIUM_CARBIDE_PLASTEEL
	skill_req = SKILL_CONSTRUCTION
	skill_level = SKILL_BASIC
	stack_consume_amount = 5
	item_desc = "A reinforced core case with osmium lining, and osmium-carbide-plasteel structural reinforcements. The rods look unfinished."
	item_icon_state = "core2"
	progress_message = "You bend rods out of the osmium-carbide-plasteel, fitting them in the case assembly."
	next_stages = list(/singleton/crafting_stage/welding/warhead_core_assembly)

/singleton/crafting_stage/welding/warhead_core_assembly
	item_desc = "A slightly reinforced warhead case. The rods are in place and it is lined with osmium-carbide plasteel. It can accept wiring, now."
	item_icon_state = "core3"
	progress_message = "You carefully weld the osmium-carbine-plasteel reinforcements into place."
	next_stages = list(/singleton/crafting_stage/wiring/warhead_core_assembly)

/singleton/crafting_stage/wiring/warhead_core_assembly
	item_desc = "A reinforced core case, with wires attached to the breakpoints and interior."
	item_icon_state = "core4"
	progress_message = "You twist wires into the casing's interior with precision, allowing for connections."
	next_stages = list(/singleton/crafting_stage/screwdriver/warhead_core_assembly)

/singleton/crafting_stage/screwdriver/warhead_core_assembly
	item_desc = "A reinforced core case with secured wires. It can likely attach an ignition assembly, now."
	item_icon_state = "core5"
	progress_message = "You precisely screw in the electrical connections to the sockets."
	next_stages = list(/singleton/crafting_stage/warhead_core_assembly_finish)

/singleton/crafting_stage/warhead_core_assembly_finish
	item_desc = "A reinforced core case with strewn wires. The connections can likely be secured now with a screwdriver."
	item_icon_state = "core5"
	progress_message = "You attach the timer-igniter assembly into the connection points."
	completion_trigger_type = /obj/item/device/assembly_holder/timer_igniter
	product = /obj/item/warhead_core_case

/* CORE */
/singleton/crafting_stage/screwdriver/core
	skill_req = SKILL_DEVICES
	skill_req = SKILL_BASIC
	begins_with_object_type = /obj/item/warhead_core_case
	progress_message = "You unsecure the support hinges in the core case."
	item_desc = "A bomb core, ready to receive a payload."
	item_icon_state = "core5"
	next_stages = list(
		/singleton/crafting_stage/core/uranium,
		/singleton/crafting_stage/core/tritium,
		/singleton/crafting_stage/core/supermatter
		)

//URANIUM
/singleton/crafting_stage/core/uranium
	completion_trigger_type = /obj/item/fuel_assembly/uranium
	progress_message = "You attach the uranium fuel rod to the case. Unifying it."
	item_desc = "An unsecured uranium bomb core."
	item_icon_state = "core6u"
	next_stages = list(/singleton/crafting_stage/screwdriver/core/uranium_secured)

/singleton/crafting_stage/screwdriver/core/uranium_secured
	progress_message = "You secure the connecting end-points in the core."
	product = /obj/item/warhead_core/uranium

//TRITIUM
/singleton/crafting_stage/core/tritium
	completion_trigger_type = /obj/item/fuel_assembly/tritium
	progress_message = "You attach the fuel rod to the case. Unifying it."
	item_desc = "An unsecured tritium bomb core."
	item_icon_state = "core6t"
	next_stages = list(/singleton/crafting_stage/screwdriver/core/tritium_secured)

/singleton/crafting_stage/screwdriver/core/tritium_secured
	progress_message = "You secure the connecting end-points in the core."
	product = /obj/item/warhead_core/tritium

//SUPERMATTER
/singleton/crafting_stage/core/supermatter
	completion_trigger_type = /obj/item/fuel_assembly/supermatter
	progress_message = "You attach the payload to the case. Unifying it."
	item_desc = "An unsecured supermatter bomb core."
	item_icon_state = "core6s"
	next_stages = list(/singleton/crafting_stage/screwdriver/core/supermatter_secured)

/singleton/crafting_stage/screwdriver/core/supermatter_secured
	progress_message = "You secure the connecting end-points in the core."
	product = /obj/item/warhead_core/supermatter
