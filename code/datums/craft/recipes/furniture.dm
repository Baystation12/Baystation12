/datum/craft_recipe/furniture
	category = "Furniture"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	time = 80


/datum/craft_recipe/furniture/railing
	name = "railing"
	result = /obj/structure/railing
	steps = list(
		list(CRAFT_MATERIAL, 4, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/table
	name = "table frame"
	result = /obj/structure/table
	steps = list(
		list(CRAFT_MATERIAL, 2, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/rack
	name = "rack"
	result = /obj/structure/table/rack
	steps = list(
		list(CRAFT_MATERIAL, 2, MATERIAL_STEEL),
	)




/datum/craft_recipe/furniture/closet
	name = "closet"
	result = /obj/structure/closet
	steps = list(
		list(CRAFT_MATERIAL, 3, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/closet
	name = "closet"
	result = /obj/structure/closet
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/crate/plasteel
	name = "Metal crate"
	result = /obj/structure/closet/crate
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTEEL),
	)

/datum/craft_recipe/furniture/crate/plastic
	name = "plastic crate"
	result = /obj/structure/closet/crate/plastic
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_PLASTIC),
	)

/datum/craft_recipe/furniture/bookshelf
	name = "book shelf"
	result = /obj/structure/bookcase
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_WOOD),
	)

/datum/craft_recipe/furniture/barricade
	name = "barricade"
	result = /obj/structure/barricade
	steps = list(
		list(CRAFT_MATERIAL, 5, MATERIAL_WOOD),
	)

/datum/craft_recipe/furniture/coffin
	name = "coffin"
	result = /obj/structure/closet/coffin
	steps = list(
		list(CRAFT_MATERIAL, 10, MATERIAL_WOOD),
	)

/datum/craft_recipe/furniture/bed
	name = "bed"
	result = /obj/structure/bed
	steps = list(
		list(CRAFT_MATERIAL, 5, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/stool
	name = "stool"
	result = /obj/item/weapon/stool
	time = 30
	steps = list(
		list(CRAFT_MATERIAL, 1, MATERIAL_STEEL),
	)
	flags = null


//Common chairs
/datum/craft_recipe/furniture/chair
	name = "chair"
	result = /obj/structure/bed/chair
	steps = list(
		list(CRAFT_MATERIAL, 5, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/wooden_chair
	name = "wooden chair"
	result = /obj/structure/bed/chair/wood
	steps = list(
		list(CRAFT_MATERIAL, 6, MATERIAL_WOOD),
	)

// Office chairs
/datum/craft_recipe/furniture/office_chair
	name = "dark office chair"
	result = /obj/structure/bed/chair/office/dark
	steps = list(
		list(CRAFT_MATERIAL, 5, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/office_chair/light
	name = "light office chair"
	result = /obj/structure/bed/chair/office/light

// Comfy chairs
/datum/craft_recipe/furniture/comfy_chair
	name = "beige comfy chair"
	result = /obj/structure/bed/chair/comfy/beige
	steps = list(
		list(CRAFT_MATERIAL, 5, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/comfy_chair/black
	name = "black comfy chair"
	result = /obj/structure/bed/chair/comfy/black

/datum/craft_recipe/furniture/comfy_chair/brown
	name = "brown comfy chair"
	result = /obj/structure/bed/chair/comfy/brown

/datum/craft_recipe/furniture/comfy_chair/lime
	name = "lime comfy chair"
	result = /obj/structure/bed/chair/comfy/lime

/datum/craft_recipe/furniture/comfy_chair/teal
	name = "teal comfy chair"
	result = /obj/structure/bed/chair/comfy/teal

/datum/craft_recipe/furniture/comfy_chair/red
	name = "red comfy chair"
	result = /obj/structure/bed/chair/comfy/red

/datum/craft_recipe/furniture/comfy_chair/blue
	name = "blue comfy chair"
	result = /obj/structure/bed/chair/comfy/blue



/datum/craft_recipe/furniture/comfy_chair/green
	name = "green comfy chair"
	result = /obj/structure/bed/chair/comfy/green

//Nonexistent target recipes
/*
/datum/craft_recipe/furniture/shelf
	name = "shelf"
	result = /obj/structure/table/rack/shelf
	steps = list(
		list(CRAFT_MATERIAL, 2, MATERIAL_STEEL),
	)

/datum/craft_recipe/furniture/comfy_chair/purple
	name = "purple comfy chair"
	result = /obj/structure/bed/chair/comfy/purp
*/