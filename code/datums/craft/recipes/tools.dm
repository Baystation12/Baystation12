/datum/craft_recipe/tool
	category = "Tools"


/datum/craft_recipe/tool/webtape
	name = "Web tape"
	result = /obj/item/weapon/tool/tape_roll/web
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/medical/bruise_pack/handmade, 3),
		list(CRAFT_OBJECT, /obj/effect/spider/stickyweb)
	)

//A shard of glass wrapped in tape makes a crude sort of knife
/datum/craft_recipe/tool/shiv
	name = "Shiv"
	result = /obj/item/weapon/tool/shiv
	steps = list(
		list(CRAFT_OBJECT, /obj/item/weapon/material/shard),
		list(CRAFT_TOOL, QUALITY_ADHESIVE, 15, 70)
	)

//A rod wrapped in tape makes a crude screwthing
/datum/craft_recipe/tool/screwpusher
	name = "Screwpusher"
	result = /obj/item/weapon/tool/screwdriver/improvised
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods),
		list(CRAFT_TOOL, QUALITY_ADHESIVE, 15, 70)
	)

//Rods bent into wierd shapes and held together with a screw
/datum/craft_recipe/tool/wiremanglers
	name = "Wiremanglers"
	result = /obj/item/weapon/tool/wirecutters/improvised
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 1),
		list(CRAFT_TOOL, QUALITY_PRYING, 10, 70),
		list(CRAFT_STACK, /obj/item/stack/rods, 1),
		list(CRAFT_TOOL, QUALITY_PRYING, 10, 70),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 70)
	)


//A pair of rods laboriously twisted into a useful shape
/datum/craft_recipe/tool/rebar
	name = "Rebar"
	result = /obj/item/weapon/tool/crowbar/improvised
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 2, "time" = 300)
	)


//A metal sheet with some holes cut in it
/datum/craft_recipe/tool/sheetspanner
	name = "Sheet spanner"
	result = /obj/item/weapon/tool/wrench/improvised
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL),
		list(CRAFT_TOOL,QUALITY_SAWING, 10, 70)
	)


//A rod and a sheet bound together with ducks
/datum/craft_recipe/tool/junkshovel
	name = "Junk shovel"
	result = /obj/item/weapon/tool/shovel/improvised
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL),
		list(CRAFT_STACK,/obj/item/stack/rods, 1, 30),
		list(CRAFT_TOOL,QUALITY_ADHESIVE, 15, 150)
	)


//A rod with bits of pointy shrapnel stuck to it. Good weapon
/datum/craft_recipe/tool/choppa
	name = "Choppa"
	result = /obj/item/weapon/tool/saw/improvised
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 1, 30),
		list(CRAFT_OBJECT, /obj/item/weapon/material/shard/shrapnel, "time" = 30),
		list(CRAFT_OBJECT, /obj/item/weapon/material/shard/shrapnel, "time" = 30),
		list(CRAFT_TOOL, QUALITY_ADHESIVE, 15, 150)
	)

//Some pipes duct taped together, attached to a tank and an igniter
/datum/craft_recipe/tool/jurytorch
	name = "Jury-rigged torch"
	result = /obj/item/weapon/tool/weldingtool/improvised
	steps = list(
		list(CRAFT_OBJECT,/obj/item/pipe, "time" = 60),
		list(CRAFT_OBJECT,/obj/item/pipe, "time" = 60),
		list(CRAFT_TOOL, QUALITY_ADHESIVE, 15, 150),
		list(CRAFT_OBJECT,/obj/item/device/assembly/igniter),
		list(CRAFT_OBJECT,/obj/item/weapon/tank/emergency/oxygen, 1)
	)


/*************************
	TOOL MODS
*************************/
//Metal rods reinforced with fiber tape
/datum/craft_recipe/tool/brace
	name = "Tool mod: Brace bar"
	result = /obj/item/weapon/tool_upgrade/reinforcement/stick
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 1, 30),
		list(CRAFT_STACK, /obj/item/stack/rods, 1, 30),
		list(CRAFT_TOOL, QUALITY_ADHESIVE, 50, 150)
	)



//A metal plate with bolts drilled and wrenched into it
/datum/craft_recipe/tool/plate
	name = "Tool mod: reinforcement plate"
	result = /obj/item/weapon/tool_upgrade/reinforcement/plating
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2),
		list(CRAFT_TOOL,QUALITY_DRILLING, 10, 150),
		list(CRAFT_STACK, /obj/item/stack/rods, 4, 30),
		list(CRAFT_TOOL,QUALITY_BOLT_TURNING, 10, 150),
	)


//An array of sharpened bits of metal to turn a tool into more of a weapon
/datum/craft_recipe/tool/spikes
	name = "Tool mod: Spikes"
	result = /obj/item/weapon/tool_upgrade/augment/spikes
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 2, 30),
		list(CRAFT_TOOL,QUALITY_WELDING, 10, 150),
		list(CRAFT_OBJECT,/obj/item/weapon/material/shard/shrapnel, "time" = 30),
		list(CRAFT_OBJECT,/obj/item/weapon/material/shard/shrapnel, "time" = 30),
		list(CRAFT_OBJECT,/obj/item/weapon/material/shard/shrapnel, "time" = 30),
		list(CRAFT_OBJECT,/obj/item/weapon/material/shard/shrapnel, "time" = 30),
		list(CRAFT_TOOL,QUALITY_WELDING, 10, 150),
	)

