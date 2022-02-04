/material/proc/get_recipes(var/reinf_mat)
	var/key = reinf_mat ? reinf_mat : "base"
	if(!LAZYACCESS(recipes,key))
		LAZYSET(recipes,key,generate_recipes(reinf_mat))
	return recipes[key]

/material/proc/create_recipe_list(base_type)
	. = list()
	for(var/recipe_type in subtypesof(base_type))
		. += new recipe_type(src)

/material/proc/generate_recipes(var/reinforce_material)
	. = list()

	if(opacity < 0.6)
		. += new/datum/stack_recipe/furniture/borderwindow(src, reinforce_material)
		. += new/datum/stack_recipe/furniture/fullwindow(src, reinforce_material)
		if(integrity > 75 || reinforce_material)
			. += new/datum/stack_recipe/furniture/windoor(src, reinforce_material)

	if(reinforce_material)	//recipes below don't support composite materials
		return

	// If is_brittle() returns true, these are only good for a single strike.
	. += new/datum/stack_recipe/ashtray(src)
	. += new/datum/stack_recipe/ring(src)
	. += new/datum/stack_recipe/clipboard(src)
	. += new/datum/stack_recipe/cross(src)

	if(hardness >= MATERIAL_FLEXIBLE)
		. += new/datum/stack_recipe/baseball_bat(src)
		. += new/datum/stack_recipe/urn(src)
		. += new/datum/stack_recipe/spoon(src)
		. += new/datum/stack_recipe/coin(src)
		. += new/datum/stack_recipe/furniture/door(src)

	if(integrity >= 50 && hardness >= MATERIAL_FLEXIBLE + 10)
		. += new/datum/stack_recipe/furniture/barricade(src)
		. += new/datum/stack_recipe/furniture/stool(src)
		. += new/datum/stack_recipe/furniture/bar_stool(src)
		. += new/datum/stack_recipe/furniture/bed(src)
		. += new/datum/stack_recipe/furniture/pew(src)
		. += new/datum/stack_recipe/furniture/pew_left(src)
		. += new/datum/stack_recipe/furniture/chair(src) //NOTE: the wood material has it's own special chair recipe
		. += new/datum/stack_recipe_list("padded [display_name] chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/padded))
		. += new/datum/stack_recipe/lock(src)
		. += new/datum/stack_recipe/railing(src)
		. += new/datum/stack_recipe/rod(src)
		. += new/datum/stack_recipe/furniture/wall_frame(src)
		. += new/datum/stack_recipe/furniture/table_frame(src)

	if(hardness > MATERIAL_RIGID + 10)
		. += new/datum/stack_recipe/fork(src)
		. += new/datum/stack_recipe/knife(src)
		. += new/datum/stack_recipe/bell(src)
		. += new/datum/stack_recipe/blade(src)
		. += new/datum/stack_recipe/drill_head(src)

/material/steel/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe_list("office chairs",list(
		new/datum/stack_recipe/furniture/chair/office/dark(src),
		new/datum/stack_recipe/furniture/chair/office/light(src)
		))
	. += new/datum/stack_recipe_list("comfy office chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/office/comfy))
	. += new/datum/stack_recipe_list("comfy chairs", create_recipe_list(/datum/stack_recipe/furniture/chair/comfy))
	. += new/datum/stack_recipe_list("armchairs", create_recipe_list(/datum/stack_recipe/furniture/chair/arm))
	. += new/datum/stack_recipe/key(src)
	. += new/datum/stack_recipe/furniture/table_frame(src)
	. += new/datum/stack_recipe/furniture/rack(src)
	. += new/datum/stack_recipe/furniture/closet(src)
	. += new/datum/stack_recipe/furniture/canister(src)
	. += new/datum/stack_recipe/furniture/tank(src)
	. += new/datum/stack_recipe/cannon(src)
	. += create_recipe_list(/datum/stack_recipe/tile/metal)
	. += new/datum/stack_recipe/furniture/computerframe(src)
	. += new/datum/stack_recipe/furniture/girder(src)
	. += new/datum/stack_recipe/furniture/machine(src)
	. += new/datum/stack_recipe/furniture/turret(src)
	. += new/datum/stack_recipe_list("airlock assemblies", create_recipe_list(/datum/stack_recipe/furniture/door_assembly))
	. += new/datum/stack_recipe/grenade(src)
	. += new/datum/stack_recipe/light(src)
	. += new/datum/stack_recipe/light_small(src)
	. += new/datum/stack_recipe/light_large(src)
	. += new/datum/stack_recipe/light_switch(src)
	. += new/datum/stack_recipe/light_switch/windowtint(src)
	. += new/datum/stack_recipe/apc(src)
	. += new/datum/stack_recipe/air_alarm(src)
	. += new/datum/stack_recipe/fire_alarm(src)
	. += new/datum/stack_recipe/intercom(src)
	. += new/datum/stack_recipe/supermatter_alarm(src)
	. += new/datum/stack_recipe_list("modular computer frames", create_recipe_list(/datum/stack_recipe/computer))
	. += new/datum/stack_recipe/furniture/coffin(src)

/material/plasteel/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/ai_core(src)
	. += new/datum/stack_recipe/furniture/crate(src)
	. += new/datum/stack_recipe/grip(src)

/material/stone/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/planting_bed(src)

/material/plastic/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/crate/plastic(src)
	. += new/datum/stack_recipe/bag(src)
	. += new/datum/stack_recipe/ivbag(src)
	. += create_recipe_list(/datum/stack_recipe/cartridge)
	. += create_recipe_list(/datum/stack_recipe/tile/light)
	. += new/datum/stack_recipe/hazard_cone(src)
	. += new/datum/stack_recipe/furniture/flaps(src)

/material/wood/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/sandals(src)
	. += new/datum/stack_recipe/tile/wood(src)
	. += create_recipe_list(/datum/stack_recipe/furniture/chair/wood)
	. += new/datum/stack_recipe/crossbowframe(src)
	. += new/datum/stack_recipe/furniture/coffin/wooden(src)
	. += new/datum/stack_recipe/beehive_assembly(src)
	. += new/datum/stack_recipe/beehive_frame(src)
	. += new/datum/stack_recipe/furniture/bookcase(src)
	. += new/datum/stack_recipe/zipgunframe(src)
	. += new/datum/stack_recipe/coilgun(src)
	. += new/datum/stack_recipe/stick(src)
	. += new/datum/stack_recipe/noticeboard(src)
	. += new/datum/stack_recipe/furniture/table_frame(src)
	. += new/datum/stack_recipe/shield(src)

/material/wood/mahogany/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/tile/mahogany(src)

/material/wood/maple/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/tile/maple(src)

/material/wood/ebony/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/tile/ebony(src)

/material/wood/walnut/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/tile/walnut(src)

/material/cardboard/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += create_recipe_list(/datum/stack_recipe/box)
	. += new/datum/stack_recipe/cardborg_suit(src)
	. += new/datum/stack_recipe/cardborg_helmet(src)
	. += new/datum/stack_recipe_list("folders", create_recipe_list(/datum/stack_recipe/folder))

/material/aluminium/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/grenade(src)
