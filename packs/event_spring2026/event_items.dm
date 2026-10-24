// EGGS

/obj/item/reagent_containers/food/snacks/egg/decorated
	abstract_type = /obj/item/reagent_containers/food/snacks/egg/decorated
	icon = 'packs/event_spring2026/icons.dmi'

/obj/item/reagent_containers/food/snacks/egg/decorated/void
	icon_state = "egg_void"

/obj/item/reagent_containers/food/snacks/egg/decorated/gold
	icon_state = "egg_gold"

/obj/item/reagent_containers/food/snacks/egg/decorated/gaia
	icon_state = "egg_gaia"

/obj/item/reagent_containers/food/snacks/egg/decorated/flowers
	icon_state = "egg_flowers"

/obj/item/reagent_containers/food/snacks/egg/decorated/fancy
	icon_state = "egg_fancy"

/obj/item/reagent_containers/food/snacks/egg/decorated/expo
	icon_state = "egg_expo"

/obj/item/reagent_containers/food/snacks/egg/decorated/engi
	icon_state = "egg_engi"

/obj/item/reagent_containers/food/snacks/egg/decorated/med
	icon_state = "egg_med"

/obj/item/reagent_containers/food/snacks/egg/decorated/sol
	icon_state = "egg_med"

/obj/item/reagent_containers/food/snacks/egg/decorated/green
	icon_state = "egg_green"

/obj/item/reagent_containers/food/snacks/egg/decorated/sec
	icon_state = "egg_sec"

/obj/item/reagent_containers/food/snacks/egg/decorated/egg_sciplo
	icon_state = "egg_sciplo"

/obj/item/reagent_containers/food/snacks/egg/decorated/egg_tiedye
	icon_state = "egg_tiedye"

// FLAGS

/obj/structure/flag
	abstract_type = /obj/structure/flag
	icon = 'packs/event_spring2026/icons.dmi'

/obj/structure/flag/yellow
	name = "yellow flag"
	icon_state = "flag_yellow"

/obj/structure/flag/ec
	name = "\improper Expeditionary Corps flag"
	icon_state = "flag_ec"

/obj/structure/flag/blue
	name = "blue flag"
	icon_state = "flag_blue"

/obj/structure/flag/pink
	name = "pink flag"
	icon_state = "flag_pink"

/obj/structure/flag/orange
	name = "orange flag"
	icon_state = "flag_green"

/obj/structure/flag/gcc
	name = "\improper Gilgamesh Colonial Confederation flag"
	icon_state = "flag_gcc"

/obj/structure/flag/gaia
	name = "\improper Gaia flag"
	icon_state = "flag_gaia"

/obj/structure/flag/red
	name = "red flag"
	icon_state = "flag_red"

/obj/structure/flag/purple
	name = "purple flag"
	icon_state = "flag_purple"

/obj/structure/flag/sol
	name = "\improper Sol flag"
	icon_state = "flag_sol"

// TOWELS

/obj/item/towel/event
	abstract_type = /obj/item/towel/event
	icon = 'packs/event_spring2026/icons.dmi'

/obj/item/towel/event/blue
	icon_state = "towel_blue"

/obj/item/towel/event/green
	icon_state = "towel_green"

/obj/item/towel/event/red
	icon_state = "towel_red"

// OTHER STUFFS

/obj/structure/umbrella
	name = "umbrella"
	icon = 'packs/event_spring2026/icons.dmi'
	icon_state = "umbrella"

// TODO toggle on/off on click here
/obj/structure/string_light
	name = "string light"
	icon = 'packs/event_spring2026/icons.dmi'
	icon_state = "stringlights_on"
	anchored = TRUE

/obj/structure/string_light/Initialize()
	. = ..()
	set_light(3, 1, "#ffc58f")

/obj/structure/tiki_torch
	name = "tiki torch"
	icon = 'packs/event_spring2026/icons.dmi'
	icon_state = "tiki"

/obj/structure/tiki_torch/Initialize()
	. = ..()
	set_light(3, 1, "#f8ec3b")

/obj/structure/umbrella/big/left
	name = "big umbrella"
	icon = 'packs/event_spring2026/beach.dmi'
	icon_state = "umbrellaright"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	density = FALSE

/obj/structure/umbrella/big/right
	name = "big umbrella"
	icon = 'packs/event_spring2026/beach.dmi'
	icon_state = "umbrellaleft"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	density = FALSE

/obj/structure/big_towel
	name = "red towel"
	icon = 'packs/event_spring2026/beach.dmi'
	icon_state = "redtowel2"
	anchored = TRUE
	density = FALSE

/obj/floor_decal/sandborder
	name = "sand border"
	icon_state = "sandborder"

/obj/floor_decal/sandcorner
	name = "sand corner"
	icon_state = "sandcorner"

/obj/floor_decal/junglecorner
	name = "jungle corner"
	icon_state = "junglecorner"

/obj/structure/railing/mapped/wood
	material = MATERIAL_WOOD
	anchored = TRUE
	init_color = COLOR_BROWN

/obj/floor_decal/beach/sand
	name = "sandy border"
	icon = 'packs/event_spring2026/icons.dmi'
	icon_state = "sandborder1"

/obj/floor_decal/beach/corner/sand
	icon = 'packs/event_spring2026/icons.dmi'
	icon_state = "sandcorner1"

/obj/item/stack/tile/stone/cobble
	name = "cobblestone slabs"
	singular_name = "cobblestone slab"
	desc = "A bumpy but smooth brown and tan rocky slab."
	icon_state = "tile_stonecobble"

/singleton/flooring/tiling/stone/cobble
	icon = 'packs/event_spring2026/icons.dmi'
	icon_base = "Cobblestonetest"
	build_type = /obj/item/stack/tile/stone/cobble

/turf/simulated/floor/tiled/stone/cobble
	name = "cobblestone floor"
	icon_state = "Cobblestonetest"
	icon = 'packs/event_spring2026/icons.dmi'
	initial_flooring = /singleton/flooring/tiling/stone/cobble

/obj/structure/fake_stairs
	name = "stairs"
	desc = "You go up and down!"
	icon = 'packs/event_spring2026/woodstairsup.dmi'
	icon_state = "woodstairup"

// FOOD

/obj/item/reagent_containers/food/snacks/ramen
	name = "bowl of ramen"
	desc = "A large bowl of ramen with all the trimmings."
	icon_state = "newramen"

/obj/item/reagent_containers/food/snacks/bbqwich
	name = "bbq sandwich"
	desc = "A pulled bbq sandwich with bbq sauce."
	icon_state = "bbqwich"

/obj/item/reagent_containers/food/snacks/ribs
	name = "honey ribs"
	desc = "A rack of ribs slow cooked with honey and sweet BBQ sauce."
	icon_state = "ribs"

// FOOD RECIPES

/datum/extension/scent/food/bbq
	scent = "bbq"

/singleton/cooking_recipe/ribs
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	required_reagents = list(
		/datum/reagent/nutriment/honey = 5,
		/datum/reagent/spacespice = 3,
		/datum/reagent/nutriment/barbecue = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/ribs
	cooked_scent = /datum/extension/scent/food/bbq

/singleton/cooking_recipe/bbqwich
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	required_reagents = list(
		/datum/reagent/nutriment/barbecue = 5,
		/datum/reagent/spacespice = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/bbqwich
	cooked_scent = /datum/extension/scent/food/bbq

/singleton/cooking_recipe/ramen
	appliance = COOKING_APPLIANCE_SAUCEPAN | COOKING_APPLIANCE_POT
	required_items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/egg
	)
	required_reagents = list(
		/datum/reagent/nutriment/soysauce = 3,
		/datum/reagent/spacespice = 3
	)
	required_produce = list(
		"onion" = 1,
		"cabbage" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/ramen
	cooked_scent = /datum/extension/scent/food/veg

// FOOD OBJECT SNACKY THING

/obj/item/reagent_containers/food/snacks/ribs
	name = "honey ribs"
	desc = "A rack of ribs slow cooked with honey and sweet BBQ sauce."
	icon = 'packs/event_spring2026/icons.dmi'
	icon_state = "ribs"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 10
	nutriment_desc = list("sticky sweet meat" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 3
	volume = 15

/obj/item/reagent_containers/food/snacks/ramen
	name = "bowl of ramen"
	desc = "A large bowl of ramen with all the trimmings."
	icon = 'packs/event_spring2026/icons.dmi'
	icon_state = "newramen"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 10
	nutriment_desc = list("warm salty broth" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 3
	volume = 15

/obj/item/reagent_containers/food/snacks/bbqwich
	name = "\improper BBQ sandwich"
	desc = "A pulled bbq sandwich with bbq sauce."
	icon = 'packs/event_spring2026/icons.dmi'
	icon_state = "bbqwich"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 5
	nutriment_desc = list("sweet and spicy meat" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 3
	volume = 15
