//DECORATIONS

/obj/structure/hallowlights
	name = "halloween lights"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "hallowlights"
	anchored = TRUE
	light_color = "#e58775"
	light_range = 2
	light_power = 3

/obj/structure/string_light/Initialize()
	. = ..()
	set_light(7, 7, "#e09d37")

/obj/structure/cauldron/left
	name = "large cauldron"
	icon = 'packs/halloween2026/cauldron.dmi'
	icon_state = "cauldronleft"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	density = FALSE

/obj/structure/cauldron/right
	name = "large cauldron"
	icon = 'packs/halloween2026/cauldron.dmi'
	icon_state = "cauldronright"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	density = FALSE

/obj/structure/tombstone1
	name = "small tombstone"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tombstone1"
	anchored = TRUE

/obj/structure/tombstone2
	name = "tiered tombstone"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tombstone2"
	anchored = TRUE

/obj/structure/tombstone3
	name = "cross tombstone"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tombstone3"
	anchored = TRUE

/obj/structure/cornerdecoweb
	name = "fake spider web"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "cornerweb"
	anchored = TRUE

/obj/structure/bigdecoweb
	name = "big fake spider web"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "bigweb"
	anchored = TRUE

/obj/structure/decospider
	name = "big fake spider"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "spiderdeco"
	anchored = TRUE

/obj/structure/decoghost
	name = "cute spooky ghost"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "cuteghost"
	anchored = TRUE

/turf/simulated/floor/darkcobble
	name = "dark cobblestone floor"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "darkcobblestone"

/turf/simulated/floor/wornwood
	name = "worn wooden floor"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "wornwood"

/obj/structure/girder/hedge
    name = "hedge"
    icon = 'packs/halloween2026/icons.dmi'
    icon_state = "hedge"
    opacity = TRUE

// FOOD
/obj/item/reagent_containers/food/snacks/platter/dipchipbowl
	name = "a bowl of chips"
	desc = "A small bowl of tortilla chips."
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "dipchipbowl"
	nutriment_desc = list("crunchy salty chips" = 1)
	vendingobject = /obj/item/reagent_containers/food/snacks/dipchip
	unitname = "tortilla chip"

/obj/item/reagent_containers/food/snacks/carmapop
	name = "caramel apple lollipop"
	desc = "A green apple lollipop dipped in caramel."
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "carmapop"

/obj/item/reagent_containers/food/snacks/pumpkinlolli
	name = "pumpkin lollipop"
	desc = "An orange flavored lollipop decorated to look like a pumpkin."
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "pumpkinlolli"

/obj/item/reagent_containers/food/snacks/tortilla
	name = "flour tortilla"
	desc = "A soft tortilla"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tortilla"


// FOOD RECIPES

/singleton/cooking_recipe/tortilla
	appliance = COOKING_APPLIANCE_SKILLET
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/tortilla

/singleton/cooking_recipe/dipchipbowl
	appliance = COOKING_APPLIANCE_FRYER
	required_items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/platter/dipchipbowl

/singleton/cooking_recipe/dip
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 5
	)
	required_produce = list(
		"onion" = 1,
		"garlic" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/dip

// FOOD OBJECT SNACKY THING

/obj/item/reagent_containers/food/snacks/tortilla
	name = "tortilla"
	desc = "A soft tortilla."
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tortilla"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 2
	nutriment_desc = list("warm and soft flatbread" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/dipchip
	name = "tortilla chip"
	desc = "A small bowl of tortilla chips"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "dipchip"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 1
	nutriment_desc = list("cruncy salty chip" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 1
	var/datum/reagents/dipped_reagents
	/// Descriptive string for currently loaded food object
	var/loaded

	var/loaded_icon = "chipdip"

/obj/item/reagent_containers/food/snacks/dip
	name = "dip"
	desc = "A bowl of savory dip for chips."
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "dip"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 1
	nutriment_desc = list("savory and creamy dip" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 1

/obj/item/reagent_containers/food/snacks/dip/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(!is_open_container())
		to_chat(user, SPAN_WARNING("\The [src] isn't open!"))
		return TRUE
	// Eating with forks
	if(istype(W,/obj/item/reagent_containers/food/snacks/dipchip))
		var/obj/item/reagent_containers/food/snacks/dipchip/U = W
		if(!U.dipped_reagents)
			U.dipped_reagents = new/datum/reagents(5, GLOB.temp_reagents_holder)

		if (U.dipped_reagents.total_volume > 0)
			to_chat(user, SPAN_WARNING("You already have something on \the [U]."))
			return TRUE

		to_chat(user, SPAN_NOTICE("You scoop up some \the [src] with \the [U]!"))

		bitecount++
		U.ClearOverlays()
		U.loaded = "[src]"
		var/image/I = new(icon, U.loaded_icon)
		I.color = src.filling_color
		U.AddOverlays(I)
		U.nutriment_desc += list(src.nutriment_desc)

		if(!reagents)
			crash_with("A snack [type] failed to have a reagent holder when attacked with a [W.type]. It was [QDELETED(src) ? "" : "not"] being deleted.")
		else
			reagents.trans_to_obj(U, min(reagents.total_volume,5))
			if (reagents.total_volume <= 0)
				if (loc && trash)
					if (ispath(trash))
						trash = new trash
					trash.dropInto(loc)
					trash = null
				qdel(src)
		return TRUE
	return ..()

// TREAT BAG
/obj/item/storage/bag/plasticbag/treatbag
	name = "treat bag"
	desc = "A hard plastic bag with a smiling jack-o-lantern on the front."
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "treatbasket"
	item_state = "treatbasket"
