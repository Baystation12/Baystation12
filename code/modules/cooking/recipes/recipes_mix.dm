
/singleton/cooking_recipe/meatburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatburger

/singleton/cooking_recipe/meatballburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatburger

/singleton/cooking_recipe/brainburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result_path = /obj/item/reagent_containers/food/snacks/brainburger

/singleton/cooking_recipe/roburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result_path = /obj/item/reagent_containers/food/snacks/roburger

/singleton/cooking_recipe/fishburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishburger

/singleton/cooking_recipe/tofuburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result_path = /obj/item/reagent_containers/food/snacks/tofuburger

/singleton/cooking_recipe/ghostburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/ectoplasm
	)
	result_path = /obj/item/reagent_containers/food/snacks/ghostburger

/singleton/cooking_recipe/clownburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result_path = /obj/item/reagent_containers/food/snacks/clownburger

/singleton/cooking_recipe/mimeburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result_path = /obj/item/reagent_containers/food/snacks/mimeburger

/singleton/cooking_recipe/bunbun
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result_path = /obj/item/reagent_containers/food/snacks/bunbun

/singleton/cooking_recipe/hotdog
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result_path = /obj/item/reagent_containers/food/snacks/hotdog

/singleton/cooking_recipe/meatkabob
	required_items = list(
		/obj/item/stack/material/rods,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatkabob

/singleton/cooking_recipe/tofukabob
	required_items = list(
		/obj/item/stack/material/rods,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result_path = /obj/item/reagent_containers/food/snacks/tofukabob

/singleton/cooking_recipe/stok_skewers
	required_reagents = list(
		/datum/reagent/nutriment/vinegar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	required_produce = list(
		"gukhe" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/stok_skewers

/singleton/cooking_recipe/spellburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meatburger,
		/obj/item/clothing/head/wizard
	)
	result_path = /obj/item/reagent_containers/food/snacks/spellburger

/singleton/cooking_recipe/bigbiteburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meatburger,
		/obj/item/reagent_containers/food/snacks/plainsteak,
		/obj/item/reagent_containers/food/snacks/plainsteak,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result_path = /obj/item/reagent_containers/food/snacks/bigbiteburger

/singleton/cooking_recipe/superbiteburger
	required_reagents = list(
		/datum/reagent/sodiumchloride = 5,
		/datum/reagent/blackpepper = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/plainsteak,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/superbiteburger

/singleton/cooking_recipe/slimeburger
	required_reagents = list(
		/datum/reagent/slimejelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result_path = /obj/item/reagent_containers/food/snacks/jellyburger

/singleton/cooking_recipe/candiedapple
	consumed_reagents = list(
		/datum/reagent/water = 10
	)
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_produce = list(
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/candiedapple

/singleton/cooking_recipe/jellyburger
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result_path = /obj/item/reagent_containers/food/snacks/jellyburger

/singleton/cooking_recipe/twobread
	required_reagents = list(
		/datum/reagent/ethanol/wine = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/twobread

/singleton/cooking_recipe/threebread
	required_reagents = list(
		/datum/reagent/ethanol/wine = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/threebread

/singleton/cooking_recipe/slimesandwich
	required_reagents = list(
		/datum/reagent/slimejelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/jellysandwich

/singleton/cooking_recipe/cherrysandwich
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/jellysandwich

/singleton/cooking_recipe/pbjsandwich_cherry
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5,
		/datum/reagent/nutriment/peanut/peanutbutter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/pbjsandwich

/singleton/cooking_recipe/pbjsandwich_slime
	required_reagents = list(
		/datum/reagent/slimejelly = 5,
		/datum/reagent/nutriment/peanut/peanutbutter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/pbjsandwich

/singleton/cooking_recipe/shrimp_cocktail
	required_reagents = list(
		/datum/reagent/nutriment/ketchup = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/shrimp,
		/obj/item/reagent_containers/food/snacks/shellfish/shrimp,
		/obj/item/reagent_containers/food/snacks/shellfish/shrimp,
		/obj/item/reagent_containers/food/drinks/glass2/cocktail
	)
	result_path = /obj/item/reagent_containers/food/snacks/shrimp_cocktail

/singleton/cooking_recipe/gukhe_fish
	required_reagents = list(
		/datum/reagent/sodiumchloride = 3,
		/datum/reagent/nutriment/vinegar = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	required_produce = list(
		"gukhe" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/gukhe_fish
