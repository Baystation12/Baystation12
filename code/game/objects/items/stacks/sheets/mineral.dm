/*
Mineral Sheets
	Contains:
		- Sandstone
		- Diamond
		- Uranium
		- Phoron
		- Gold
		- Silver
		- Clown
	Others:
		- Enriched Uranium
*/

var/global/list/datum/stack_recipe/sandstone_recipes = list ( \
	new/datum/stack_recipe("pile of dirt", /obj/machinery/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/silver_recipes = list ( \
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/diamond_recipes = list ( \
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/uranium_recipes = list ( \
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/gold_recipes = list ( \
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/phoron_recipes = list ( \
	new/datum/stack_recipe("phoron door", /obj/structure/mineral_door/transparent/phoron, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/plastic_recipes = list ( \
	new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("plastic ashtray", /obj/item/ashtray/plastic, 2, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("plastic fork", /obj/item/weapon/kitchen/utensil/pfork, 1, on_floor = 1), \
	new/datum/stack_recipe("plastic spoon", /obj/item/weapon/kitchen/utensil/pspoon, 1, on_floor = 1), \
	new/datum/stack_recipe("plastic knife", /obj/item/weapon/kitchen/utensil/pknife, 1, on_floor = 1), \
	new/datum/stack_recipe("plastic bag", /obj/item/weapon/storage/bag/plasticbag, 3, on_floor = 1), \
	)

/obj/item/stack/sheet/mineral
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3

/obj/item/stack/sheet/mineral/New()
	..()
	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4

/obj/item/stack/sheet/mineral/sandstone
	name = "sandstone brick"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	throw_speed = 4
	throw_range = 5
	origin_tech = "materials=1"
	sheettype = "sandstone"

/obj/item/stack/sheet/mineral/sandstone/New()
	..()
	recipes = sandstone_recipes

/obj/item/stack/sheet/mineral/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	origin_tech = "materials=6"
	perunit = 3750
	sheettype = "diamond"


/obj/item/stack/sheet/mineral/diamond/New()
	..()
	recipes = diamond_recipes

/obj/item/stack/sheet/mineral/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	origin_tech = "materials=5"
	perunit = 2000
	sheettype = "uranium"

/obj/item/stack/sheet/mineral/uranium/New()
	..()
	recipes = uranium_recipes

/obj/item/stack/sheet/mineral/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	origin_tech = "phorontech=2;materials=2"
	perunit = 2000
	sheettype = "phoron"

/obj/item/stack/sheet/mineral/phoron/New()
	..()
	recipes = phoron_recipes

/obj/item/stack/sheet/mineral/plastic
	name = "Plastic"
	icon_state = "sheet-plastic"
	origin_tech = "materials=3"
	perunit = 2000

/obj/item/stack/sheet/mineral/plastic/New()
	..()
	recipes = plastic_recipes

/obj/item/stack/sheet/mineral/plastic/cyborg
	name = "plastic sheets"
	icon_state = "sheet-plastic"
	perunit = 2000

/obj/item/stack/sheet/mineral/gold
	name = "gold"
	icon_state = "sheet-gold"
	origin_tech = "materials=4"
	perunit = 2000
	sheettype = "gold"

/obj/item/stack/sheet/mineral/gold/New()
	..()
	recipes = gold_recipes

/obj/item/stack/sheet/mineral/silver
	name = "silver"
	icon_state = "sheet-silver"
	origin_tech = "materials=3"
	perunit = 2000
	sheettype = "silver"

/obj/item/stack/sheet/mineral/silver/New()
	..()
	recipes = silver_recipes

/obj/item/stack/sheet/mineral/enruranium
	name = "enriched uranium"
	icon_state = "sheet-enruranium"
	origin_tech = "materials=5"
	perunit = 1000

/obj/item/stack/sheet/mineral/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	sheettype = "platinum"
	perunit = 2000

/obj/item/stack/sheet/mineral/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	sheettype = "mhydrogen"
	perunit = 2000

/obj/item/stack/sheet/mineral/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	sheettype = "tritium"
	color = "#777777"
	perunit = 2000

/obj/item/stack/sheet/mineral/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	sheettype = "osmium"
	color = "#9999FF"
	perunit = 2000

obj/item/stack/sheet/mineral/iron
	name = "iron"
	icon_state = "sheet-silver"
	sheettype = "iron"
	color = "#333333"
	perunit = 3750
