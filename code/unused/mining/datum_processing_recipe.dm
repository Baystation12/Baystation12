/**********************Ore to material recipes datum**************************/

var/list/AVAILABLE_ORES = typesof(/obj/item/weapon/ore)

/datum/material_recipe
	var/name
	var/list/obj/item/weapon/ore/recipe
	var/obj/prod_type  //produced material/object type

	New(var/param_name, var/param_recipe, var/param_prod_type)
		name = param_name
		recipe = param_recipe
		prod_type = param_prod_type

var/list/datum/material_recipe/MATERIAL_RECIPES = list(
		new/datum/material_recipe("Metal",list(/obj/item/weapon/ore/iron),/obj/item/stack/sheet/metal),
		new/datum/material_recipe("Glass",list(/obj/item/weapon/ore/glass),/obj/item/stack/sheet/glass),
		new/datum/material_recipe("Gold",list(/obj/item/weapon/ore/gold),/obj/item/stack/sheet/mineral/gold),
		new/datum/material_recipe("Silver",list(/obj/item/weapon/ore/silver),/obj/item/stack/sheet/mineral/silver),
		new/datum/material_recipe("Diamond",list(/obj/item/weapon/ore/diamond),/obj/item/stack/sheet/mineral/diamond),
		new/datum/material_recipe("Phoron",list(/obj/item/weapon/ore/phoron),/obj/item/stack/sheet/mineral/phoron),
	)