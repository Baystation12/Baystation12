
/singleton/cooking_recipe/dionaroast
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/acid/polyacid = 5
	)
	required_items = list(
		/obj/item/holder/diona
	)
	required_produce = list(
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/dionaroast
	cooked_scent = /datum/extension/scent/food/meat

/singleton/cooking_recipe/donut
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/normal
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/jellydonut
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/drink/juice/berry = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/jelly
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/jellydonut/slime
	required_reagents = list(
		/datum/reagent/slimejelly = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/slimejelly
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/jellydonut/cherry
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/cherryjelly
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/chaosdonut
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/frostoil = 5,
		/datum/reagent/capsaicin = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/chaos
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/chaosdonutheat
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/capsaicin = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/chaos
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/chaosdonutcold
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/frostoil = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/chaos
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/frosteddonut
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 3,
		/datum/reagent/nutriment/sprinkles = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/normal
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/frostedjellydonut
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/sprinkles = 3,
		/datum/reagent/drink/juice/berry = 5,
		/datum/reagent/sugar = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/jelly
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/frostedjellydonut/slime
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/sprinkles = 3,
		/datum/reagent/slimejelly = 5,
		/datum/reagent/sugar = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/slimejelly
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/frostedjellydonut/cherry
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/sprinkles = 3,
		/datum/reagent/nutriment/cherryjelly = 5,
		/datum/reagent/sugar = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/cherryjelly
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/frostedchaosdonut
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/frostoil = 5,
		/datum/reagent/capsaicin = 5,
		/datum/reagent/sugar = 3,
		/datum/reagent/nutriment/sprinkles = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/chaos
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/frostedchaosdonutheat
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/capsaicin = 5,
		/datum/reagent/sugar = 3,
		/datum/reagent/nutriment/sprinkles = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/chaos
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/frostedchaosdonutcold
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/frostoil = 5,
		/datum/reagent/sugar = 3,
		/datum/reagent/nutriment/sprinkles = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/chaos
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/waffles
	appliance = COOKING_APPLIANCE_SKILLET
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 20
	)

	result_path = /obj/item/reagent_containers/food/snacks/waffles
	cooked_scent = /datum/extension/scent/food/waffles

/singleton/cooking_recipe/pancakesblu
	appliance = COOKING_APPLIANCE_SKILLET
	required_reagents = list(
		/datum/reagent/nutriment/batter = 20
	)
	required_produce = list(
		"blueberries" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/pancakesblu
	cooked_scent = /datum/extension/scent/food/pancakes

/singleton/cooking_recipe/pancakes
	appliance = COOKING_APPLIANCE_SKILLET
	required_reagents = list(
		/datum/reagent/nutriment/batter = 20
	)
	result_path = /obj/item/reagent_containers/food/snacks/pancakes
	cooked_scent = /datum/extension/scent/food/pancakes

/singleton/cooking_recipe/hot_donkpocket/CreateResult(obj/container as obj, ...)
	var/obj/item/reagent_containers/food/snacks/donkpocket/donk = locate() in container
	donk?.SetHot()
	return donk

/singleton/cooking_recipe/meatbread
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/meatbread
	cooked_scent = /datum/extension/scent/food/meat

/singleton/cooking_recipe/bananabread
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/drink/milk = 5
	)
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	required_produce = list(
		"banana" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/bananabread
	cooked_scent = /datum/extension/scent/food/banana

/singleton/cooking_recipe/muffin
	appliance = COOKING_APPLIANCE_OVEN | COOKING_APPLIANCE_MICROWAVE
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 10
	)
	result_path = /obj/item/reagent_containers/food/snacks/muffin
	cooked_scent = /datum/extension/scent/food/cake

/singleton/cooking_recipe/eggplantparm
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"eggplant" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/eggplantparm
	cooked_scent = /datum/extension/scent/food/veg

/singleton/cooking_recipe/soylenviridians
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	required_produce = list(
		"soybeans" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/soylenviridians
	cooked_scent = /datum/extension/scent/food/veg


/singleton/cooking_recipe/soylentgreen
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result_path = /obj/item/reagent_containers/food/snacks/soylentgreen
	cooked_scent = /datum/extension/scent/food/meat

/singleton/cooking_recipe/meatpie
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatpie
	cooked_scent = /datum/extension/scent/food/meat

/singleton/cooking_recipe/tofupie
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result_path = /obj/item/reagent_containers/food/snacks/tofupie
	cooked_scent = /datum/extension/scent/food/tofu

/singleton/cooking_recipe/bananapie
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"banana" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/bananapie
	cooked_scent = /datum/extension/scent/food/banana

/singleton/cooking_recipe/tofubread
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/tofubread
	cooked_scent = /datum/extension/scent/food/tofu

/singleton/cooking_recipe/cherrypie
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"cherries" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/cherrypie
	cooked_scent = /datum/extension/scent/food/pie

/singleton/cooking_recipe/berryclafoutis
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"berries" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/berryclafoutis
	cooked_scent = /datum/extension/scent/food/pie

/singleton/cooking_recipe/loadedbakedpotato
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"potato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/loadedbakedpotato
	cooked_scent = /datum/extension/scent/food/veg

/singleton/cooking_recipe/cheesyfries
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/cheesyfries
	cooked_scent = /datum/extension/scent/food/grease

/singleton/cooking_recipe/cookie
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 5,
		/datum/reagent/nutriment/coco = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/cookie
	cooked_scent = /datum/extension/scent/food/cookie

/singleton/cooking_recipe/fortunecookie
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper
	)
	result_path = /obj/item/reagent_containers/food/snacks/fortunecookie
	cooked_scent = /datum/extension/scent/food/cookie

/singleton/cooking_recipe/fortunecookie/CreateResult(obj/container as obj, ...)
	var/obj/item/paper/paper = locate() in container
	if (paper.info)
		container -= paper
	return ..(container)

/singleton/cooking_recipe/spacylibertyduff
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/water = 10
	)
	required_reagents = list(
		/datum/reagent/ethanol/vodka = 5,
		/datum/reagent/drugs/psilocybin = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/singleton/cooking_recipe/amanita_pie
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/toxin/amatoxin = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result_path = /obj/item/reagent_containers/food/snacks/amanita_pie
	cooked_scent = /datum/extension/scent/food/pie

/singleton/cooking_recipe/plump_pie
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"plumphelmet" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/plump_pie
	cooked_scent = /datum/extension/scent/food/pie

/singleton/cooking_recipe/enchiladas
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	required_produce = list(
		"chili" = 2,
		"corn" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/enchiladas
	cooked_scent = /datum/extension/scent/food/spicy

/singleton/cooking_recipe/creamcheesebread
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/monkeysdelight
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/monkeycube
	)
	required_produce = list(
		"banana" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/monkeysdelight
	cooked_scent = /datum/extension/scent/food/meat

/singleton/cooking_recipe/baguette
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result_path = /obj/item/reagent_containers/food/snacks/baguette
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/bread
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/bread
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/rofflewaffles
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/drugs/psilocybin = 5,
		/datum/reagent/nutriment/batter/cakebatter = 20
	)
	result_path = /obj/item/reagent_containers/food/snacks/rofflewaffles
	cooked_scent = /datum/extension/scent/food/waffles

/singleton/cooking_recipe/ntella_bread
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/choconutspread = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/ntella_bread
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/poppypretzel
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	required_produce = list(
		"poppy" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/poppypretzel
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/applepie
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/applepie
	cooked_scent = /datum/extension/scent/food/pie

/singleton/cooking_recipe/pumpkinpie
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"pumpkin" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	cooked_scent = /datum/extension/scent/food/pie

/singleton/cooking_recipe/plumphelmetbiscuit
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	required_produce = list(
		"plumphelmet" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	cooked_scent = /datum/extension/scent/food/cookie

/singleton/cooking_recipe/appletart
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"goldapple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/appletart
	cooked_scent = /datum/extension/scent/food/pie

/singleton/cooking_recipe/cracker
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/cracker

/singleton/cooking_recipe/stuffing
	appliance = COOKING_APPLIANCE_OVEN | COOKING_APPLIANCE_MICROWAVE
	consumed_reagents = list(
		/datum/reagent/water = 10
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/stuffing
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/bun
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result_path = /obj/item/reagent_containers/food/snacks/bun
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/flatbread
	appliance = COOKING_APPLIANCE_OVEN | COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result_path = /obj/item/reagent_containers/food/snacks/flatbread
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/mint
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 5,
		/datum/reagent/frostoil = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/mint
	cooked_scent = /datum/extension/scent/food/mint

/singleton/cooking_recipe/cake
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 60
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/plaincake
	cooked_scent = /datum/extension/scent/food/cake

/singleton/cooking_recipe/cake/carrot
	required_produce = list(
		"carrot" = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake

/singleton/cooking_recipe/cake/cheese
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake

/singleton/cooking_recipe/cake/ntella_cheesecake
	required_reagents = list(
		/datum/reagent/nutriment/choconutspread = 15,
		/datum/reagent/nutriment/batter/cakebatter = 60
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cookie,
		/obj/item/reagent_containers/food/snacks/cookie,
		/obj/item/reagent_containers/food/snacks/cookie
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/ntella_cheesecake

/singleton/cooking_recipe/cake/orange
	required_produce = list(
		"orange" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/orangecake

/singleton/cooking_recipe/cake/lime
	required_produce = list(
		"lime" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/limecake

/singleton/cooking_recipe/cake/lemon
	required_produce = list(
		"lemon" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake

/singleton/cooking_recipe/cake/chocolate
	required_items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake

/singleton/cooking_recipe/cake/birthday
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 60,
		/datum/reagent/nutriment/sprinkles = 10
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake

/singleton/cooking_recipe/cake/apple
	required_produce = list(
		"apple" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/applecake

/singleton/cooking_recipe/cake/brain
	required_items = list(
		/obj/item/organ/internal/brain
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/braincake

///This recipe exceptionally initializes reagent at new() and doesn't carry those over since it can also be produced by chemistry recipes.
/singleton/cooking_recipe/cake/chocolatebar
	consumed_reagents = list(
		/datum/reagent/drink/milk/chocolate = 10,
		/datum/reagent/nutriment/coco = 5,
		/datum/reagent/sugar = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/chocolatebar

/singleton/cooking_recipe/cake/clown
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 30,
		/datum/reagent/nutriment/sprinkles = 2,
	)
	required_produce = list(
		"banana" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/clowncake

/singleton/cooking_recipe/aghrassh_cake
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/protein = 8,
		/datum/reagent/nutriment/coco = 3,
		/datum/reagent/blackpepper = 3,
		/datum/reagent/nutriment/protein/egg = 3
	)
	required_produce = list(
		"aghrassh" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/aghrassh_cake
	cooked_scent = /datum/extension/scent/food/cake

/singleton/cooking_recipe/stuffed_clam
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/clam,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/stuffed_clam
	cooked_scent = /datum/extension/scent/food/seafood

/singleton/cooking_recipe/steamed_mussels
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/ethanol/wine/premium = 10,
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/mussel,
		/obj/item/reagent_containers/food/snacks/shellfish/mussel,
		/obj/item/reagent_containers/food/snacks/shellfish/mussel
	)
	result_path = /obj/item/reagent_containers/food/snacks/steamed_mussels
	cooked_scent = /datum/extension/scent/food/seafood

/singleton/cooking_recipe/oysters_rockefeller
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/oyster,
		/obj/item/reagent_containers/food/snacks/shellfish/oyster,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/oysters_rockefeller
	cooked_scent = /datum/extension/scent/food/seafood

/singleton/cooking_recipe/crab_cakes
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/protein/egg = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/crab_cakes
	cooked_scent = /datum/extension/scent/food/seafood

/singleton/cooking_recipe/crab_rangoon
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/shellfish/crab
	)
	result_path = /obj/item/reagent_containers/food/snacks/crab_rangoon
	cooked_scent = /datum/extension/scent/food/seafood

/singleton/cooking_recipe/crab_dinner
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/fruit_slice
	)
	result_path = /obj/item/reagent_containers/food/snacks/crab_dinner
	cooked_scent = /datum/extension/scent/food/seafood

/singleton/cooking_recipe/seafood_paella
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/ethanol/wine/premium = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/shrimp,
		/obj/item/reagent_containers/food/snacks/shellfish/shrimp,
		/obj/item/reagent_containers/food/snacks/shellfish/mussel,
		/obj/item/reagent_containers/food/snacks/shellfish/mussel,
		/obj/item/reagent_containers/food/snacks/boiledrice
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/seafood_paella
	cooked_scent = /datum/extension/scent/food/seafood

/singleton/cooking_recipe/unscotti
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 10,
		/datum/reagent/drink/syrup_vanilla = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	required_produce = list(
		"almond" = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/unscottiloaf
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/biscotti
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/unscotti
	)
	result_path = /obj/item/reagent_containers/food/snacks/biscotti
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/roast_chicken
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	required_produce = list(
		"potato" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/roast_chicken
	cooked_scent = /datum/extension/scent/food/poultry

/singleton/cooking_recipe/tofurkey
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/tofurkey
	cooked_scent = /datum/extension/scent/food/poultry

/singleton/cooking_recipe/figgypudding
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 20,
		/datum/reagent/ethanol/lunabrandy = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/no_raisin
	)
	required_produce = list(
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/figgypudding
	cooked_scent = /datum/extension/scent/food/cake

/singleton/cooking_recipe/chocolateroulade
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/sugar = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/chocolateroulade
	cooked_scent = /datum/extension/scent/food/cake

/singleton/cooking_recipe/macandcheese
	appliance = COOKING_APPLIANCE_OVEN | COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE
	consumed_reagents = list(
		/datum/reagent/water = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	result_path = /obj/item/reagent_containers/food/snacks/macandcheese
	cooked_scent = /datum/extension/scent/food/cheese


/singleton/cooking_recipe/macandcheese_bacon
	appliance = COOKING_APPLIANCE_OVEN | COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE
	required_reagents = list(
		/datum/reagent/water = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result_path = /obj/item/reagent_containers/food/snacks/macandcheese/bacon
	cooked_scent = /datum/extension/scent/food/cheese

/singleton/cooking_recipe/puffpuff
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/nutriment/flour = 20,
		/datum/reagent/water = 5
	)
	required_reagents = list(
		/datum/reagent/spacespice = 2,
		/datum/reagent/sodiumchloride = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/platter/puffpuffs
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/latkes
	appliance = COOKING_APPLIANCE_OVEN
	consumed_reagents = list(
		/datum/reagent/nutriment/flour = 5,
		/datum/reagent/nutriment/protein/egg = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks,
		/obj/item/reagent_containers/food/snacks/rawsticks,
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result_path = /obj/item/reagent_containers/food/snacks/platter/latkes
	cooked_scent = /datum/extension/scent/food/dough

/singleton/cooking_recipe/rugelach
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/cinnamon = 2,
		/datum/reagent/sugar = 2
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/rugelach
	cooked_scent = /datum/extension/scent/food/sugar

/singleton/cooking_recipe/rugelach_berry
	appliance = COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/drink/juice/berry = 2,
		/datum/reagent/sugar = 2
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/rugelach_berry
	cooked_scent = /datum/extension/scent/food/sugar
