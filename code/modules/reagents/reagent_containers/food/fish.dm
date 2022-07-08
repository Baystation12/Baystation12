/obj/item/reagent_containers/food/snacks/fish
	abstract_type = /obj/item/reagent_containers/food/snacks/fish
	name = "base fish fillet"
	desc = "A fillet of fish."
	icon_state = "fishfillet"
	color = "#ff4040"
	filling_color = "#ff4040"
	center_of_mass = "x=17;y=13"
	bitesize = 6
	var/fish_type = "fish"


/obj/item/reagent_containers/food/snacks/fish/Initialize()
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)
	name = "[fish_type] fillet"


/obj/item/reagent_containers/food/snacks/fish/attackby(obj/item/item, mob/living/user)
	if (!item.sharp)
		return ..()
	var/turf/turf = get_turf(src)
	if (turf != loc || !(locate(/obj/structure/table) in turf))
		to_chat(user, SPAN_WARNING("You need a table to cut \the [src]."))
		return TRUE
	var/list/toxins = reagents.get_reagent_amount_list(/datum/reagent/toxin)
	for (var/toxin_type in toxins)
		if (user.skill_fail_prob(SKILL_COOKING, 90, SKILL_PROF))
			continue
		reagents.remove_reagent(toxin_type, toxins[toxin_type])
	var/transfer = Floor(reagents.total_volume * 0.3)
	for(var/i = 1 to 3)
		var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = new (turf, fish_type)
		reagents.trans_to(sashimi, transfer)
	user.visible_message(SPAN_ITALIC("\The [user] slices \the [src] into thin strips."))
	qdel(src)
	return TRUE


/// fish/generated permits arbitrary fish type and contents setting through new (loc, "type", list(/type = amount), 1/0)
/obj/item/reagent_containers/food/snacks/fish/generated/Initialize(_mapload, _fish_type, list/_reagents, _replace_reagents)
	. = ..()
	if (_fish_type)
		fish_type = _fish_type
		name = "[fish_type] fillet"
	if (_replace_reagents)
		reagents.clear_reagents()
	for (var/reagent in _reagents)
		reagents.add_reagent(reagent, _reagents[reagent])


/obj/item/reagent_containers/food/snacks/fish/space_carp
	fish_type = "space carp"
	color = "#e657aa"
	filling_color = "#e657aa"


/obj/item/reagent_containers/food/snacks/fish/space_carp/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/carpotoxin, 6)


/obj/item/reagent_containers/food/snacks/fish/space_pike
	fish_type = "space pike"
	color = "#f73fd6"
	filling_color = "#f73fd6"


/obj/item/reagent_containers/food/snacks/fish/space_pike/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/carpotoxin, 6)


/obj/item/reagent_containers/food/snacks/fish/space_shark
	fish_type = "cosmoshark"
	color = "#8925d4"
	filling_color = "#8925d4"


/obj/item/reagent_containers/food/snacks/fish/space_shark/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)
	reagents.add_reagent(/datum/reagent/space_drugs, 1)
	reagents.add_reagent(/datum/reagent/toxin/phoron, 1)


/obj/item/reagent_containers/food/snacks/fish/cod
	fish_type = "cod"
	color = "#ecc69e"
	filling_color = "#ecc69e"


/obj/item/reagent_containers/food/snacks/fish/hake
	fish_type = "hake"
	color = "#ecc69e"
	filling_color = "#ecc69e"


/obj/item/reagent_containers/food/snacks/fish/bream
	fish_type = "bream"
	color = "#ecc69e"
	filling_color = "#ecc69e"


/obj/item/reagent_containers/food/snacks/fish/salmon
	fish_type = "salmon"
	color = "#e69457"
	filling_color = "#e69457"


/obj/item/reagent_containers/food/snacks/fish/tuna
	fish_type = "tuna"


/obj/item/reagent_containers/food/snacks/fish/mackerel
	fish_type = "mackerel"
	color = "#ecc69e"
	filling_color = "#ecc69e"


/obj/item/reagent_containers/food/snacks/fish/trout
	fish_type = "trout"
	color = "#e69457"
	filling_color = "#e69457"


/obj/item/reagent_containers/food/snacks/fish/tilapia
	fish_type = "tilapia"
	color = "#ecc69e"
	filling_color = "#ecc69e"


/obj/item/reagent_containers/food/snacks/fish/bass
	fish_type = "bass"
	color = "#ecc69e"
	filling_color = "#ecc69e"


/obj/item/reagent_containers/food/snacks/fish/shark
	fish_type = "shark"


/obj/item/reagent_containers/food/snacks/fish/squid
	fish_type = "squid"
	color = "#dbd6d0"
	filling_color = "#dbd6d0"


/obj/item/reagent_containers/food/snacks/fish/octopus
	fish_type = "octopus"
	color = "#dbd6d0"
	filling_color = "#dbd6d0"


/obj/item/reagent_containers/food/snacks/fish/eel
	fish_type = "eel"
	color = "#ecc69e"
	filling_color = "#ecc69e"


/obj/item/reagent_containers/food/snacks/fish/carp
	fish_type = "carp"
	color = "#e66457"
	filling_color = "#e66457"


/obj/item/reagent_containers/food/snacks/fish/catfish
	fish_type = "catfish"
	color = "#dbd6d0"
	filling_color = "#dbd6d0"


/obj/item/reagent_containers/food/snacks/fish/unknown
	fish_type = "suspicious"
	color = "#ecc69e"
	filling_color = "#ecc69e"


/obj/random/fish
	name = "random fish fillet"
	desc = "This is a random fish fillet."
	icon = 'icons/obj/food.dmi'
	icon_state = "fishfillet"
	color = "#ff4040"


/obj/random/fish/spawn_choices()
	return list(
		/obj/item/reagent_containers/food/snacks/fish/cod = 4,
		/obj/item/reagent_containers/food/snacks/fish/hake = 4,
		/obj/item/reagent_containers/food/snacks/fish/bream = 4,
		/obj/item/reagent_containers/food/snacks/fish/tilapia = 4,
		/obj/item/reagent_containers/food/snacks/fish/bass = 4,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 3,
		/obj/item/reagent_containers/food/snacks/fish/tuna = 3,
		/obj/item/reagent_containers/food/snacks/fish/mackerel = 3,
		/obj/item/reagent_containers/food/snacks/fish/trout = 3,
		/obj/item/reagent_containers/food/snacks/fish/shark = 3,
		/obj/item/reagent_containers/food/snacks/fish/squid = 3,
		/obj/item/reagent_containers/food/snacks/fish/octopus = 2,
		/obj/item/reagent_containers/food/snacks/fish/eel = 2,
		/obj/item/reagent_containers/food/snacks/fish/carp = 2,
		/obj/item/reagent_containers/food/snacks/fish/catfish = 1
	)
