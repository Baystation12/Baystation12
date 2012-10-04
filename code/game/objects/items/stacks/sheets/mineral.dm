/* Mineral Sheets
 * Contains:
 *		Sandstone
 *		Diamond
 *		Uranium
 *		Plasma
 *		Gold
 *		Silver
 */

/*
 * Sandstone
 */
var/global/list/datum/stack_recipe/sandstone_recipes = list ( \
	new/datum/stack_recipe("pile of dirt", /obj/machinery/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = 1, on_floor = 1), \
/*	new/datum/stack_recipe("sandstone wall", ???), \
		new/datum/stack_recipe("sandstone floor", ???),\*/
	)

/obj/item/stack/sheet/sandstone
	name = "sandstone bricks"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	throw_speed = 4
	throw_range = 5
	origin_tech = "materials=1"

/obj/item/stack/sheet/sandstone
	New(var/loc, var/amount=null)
		recipes = sandstone_recipes
		return ..()

/*
 * Diamond
 */
var/global/list/datum/stack_recipe/diamond_recipes = list ( \
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1), \
	)

/obj/item/stack/sheet/diamond
	New(var/loc, var/amount=null)
		recipes = diamond_recipes
		return ..()

/*
 * Uranium
 */
var/global/list/datum/stack_recipe/uranium_recipes = list ( \
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1), \
	)

/obj/item/stack/sheet/uranium
	New(var/loc, var/amount=null)
		recipes = uranium_recipes
		return ..()

/*
 * Plasma
 */
var/global/list/datum/stack_recipe/plasma_recipes = list ( \
	new/datum/stack_recipe("plasma door", /obj/structure/mineral_door/transparent/plasma, 10, one_per_turf = 1, on_floor = 1), \
	)

/obj/item/stack/sheet/plasma
	New(var/loc, var/amount=null)
		recipes = plasma_recipes
		return ..()

/*
 * Gold
 */
var/global/list/datum/stack_recipe/gold_recipes = list ( \
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1), \
	)

/obj/item/stack/sheet/gold
	New(var/loc, var/amount=null)
		recipes = gold_recipes
		return ..()

/*
 * Silver
 */
var/global/list/datum/stack_recipe/silver_recipes = list ( \
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1), \
	)

/obj/item/stack/sheet/silver
	New(var/loc, var/amount=null)
		recipes = silver_recipes
		return ..()