/datum/microwave_recipe/friedegg
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_path = /obj/item/reagent_containers/food/snacks/friedegg


/datum/microwave_recipe/friedegg2
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_path = /obj/item/reagent_containers/food/snacks/friedegg


/datum/microwave_recipe/boiledegg
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_path = /obj/item/reagent_containers/food/snacks/boiledegg


/datum/microwave_recipe/dionaroast
	required_reagents = list(
		/datum/reagent/acid/polyacid = 5
	)
	required_items = list(
		/obj/item/holder/diona
	)
	required_produce = list(
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/dionaroast


/datum/microwave_recipe/classichotdog
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/corgi
	)
	result_path = /obj/item/reagent_containers/food/snacks/classichotdog


/datum/microwave_recipe/jellydonut
	required_reagents = list(
		/datum/reagent/drink/juice/berry = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/jelly


/datum/microwave_recipe/jellydonut/slime
	required_reagents = list(
		/datum/reagent/slimejelly = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/slimejelly


/datum/microwave_recipe/jellydonut/cherry
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/cherryjelly


/datum/microwave_recipe/donut
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/normal


/datum/microwave_recipe/meatburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatburger


/datum/microwave_recipe/brainburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result_path = /obj/item/reagent_containers/food/snacks/brainburger


/datum/microwave_recipe/roburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result_path = /obj/item/reagent_containers/food/snacks/roburger


/datum/microwave_recipe/xenoburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result_path = /obj/item/reagent_containers/food/snacks/xenoburger


/datum/microwave_recipe/fishburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishburger


/datum/microwave_recipe/tofuburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result_path = /obj/item/reagent_containers/food/snacks/tofuburger


/datum/microwave_recipe/ghostburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/ectoplasm
	)
	result_path = /obj/item/reagent_containers/food/snacks/ghostburger


/datum/microwave_recipe/clownburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result_path = /obj/item/reagent_containers/food/snacks/clownburger


/datum/microwave_recipe/mimeburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result_path = /obj/item/reagent_containers/food/snacks/mimeburger


/datum/microwave_recipe/bunbun
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result_path = /obj/item/reagent_containers/food/snacks/bunbun


/datum/microwave_recipe/hotdog
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result_path = /obj/item/reagent_containers/food/snacks/hotdog


/datum/microwave_recipe/waffles
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 20
	)
	result_path = /obj/item/reagent_containers/food/snacks/waffles


/datum/microwave_recipe/pancakesblu
	required_reagents = list(
		/datum/reagent/nutriment/batter = 20
	)
	required_produce = list(
		"blueberries" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/pancakesblu


/datum/microwave_recipe/pancakes
	required_reagents = list(
		/datum/reagent/nutriment/batter = 20
	)
	result_path = /obj/item/reagent_containers/food/snacks/pancakes


/datum/microwave_recipe/hot_donkpocket
	required_reagents = list()
	required_items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result_path = /obj/item/reagent_containers/food/snacks/donkpocket


/datum/microwave_recipe/hot_donkpocket/CreateResult(obj/machinery/microwave/microwave)
	var/obj/item/reagent_containers/food/snacks/donkpocket/donk = locate() in microwave
	donk?.SetHot()
	return donk


/datum/microwave_recipe/meatbread
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/meatbread


/datum/microwave_recipe/xenomeatbread
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread


/datum/microwave_recipe/bananabread
	required_reagents = list(
		/datum/reagent/drink/milk = 5,
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


/datum/microwave_recipe/omelette
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/omelette


/datum/microwave_recipe/muffin
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 10
	)
	result_path = /obj/item/reagent_containers/food/snacks/muffin


/datum/microwave_recipe/eggplantparm
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"eggplant" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/eggplantparm


/datum/microwave_recipe/soylenviridians
	required_reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	required_produce = list(
		"soybeans" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/soylenviridians


/datum/microwave_recipe/soylentgreen
	required_reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result_path = /obj/item/reagent_containers/food/snacks/soylentgreen


/datum/microwave_recipe/meatpie
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatpie


/datum/microwave_recipe/tofupie
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result_path = /obj/item/reagent_containers/food/snacks/tofupie


/datum/microwave_recipe/xemeatpie
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result_path = /obj/item/reagent_containers/food/snacks/xemeatpie


/datum/microwave_recipe/bananapie
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


/datum/microwave_recipe/cherrypie
	required_reagents = list(
		/datum/reagent/sugar = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"cherries" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/cherrypie


/datum/microwave_recipe/berryclafoutis
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"berries" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/berryclafoutis


/datum/microwave_recipe/chaosdonut
	required_reagents = list(
		/datum/reagent/frostoil = 5,
		/datum/reagent/capsaicin = 5,
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/donut/chaos


/datum/microwave_recipe/meatkabob
	required_items = list(
		/obj/item/stack/material/rods,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatkabob


/datum/microwave_recipe/tofukabob
	required_items = list(
		/obj/item/stack/material/rods,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result_path = /obj/item/reagent_containers/food/snacks/tofukabob


/datum/microwave_recipe/tofubread
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


/datum/microwave_recipe/loadedbakedpotato
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"potato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/loadedbakedpotato


/datum/microwave_recipe/cheesyfries
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/cheesyfries


/datum/microwave_recipe/cubancarp
	required_reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	required_produce = list(
		"chili" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/cubancarp


/datum/microwave_recipe/popcorn
	required_reagents = list(
		/datum/reagent/sodiumchloride = 5
	)
	required_produce = list(
		"corn" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/popcorn


/datum/microwave_recipe/cookie
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 5,
		/datum/reagent/nutriment/coco = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/cookie


/datum/microwave_recipe/fortunecookie
	required_reagents = list(
		/datum/reagent/sugar = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper
	)
	result_path = /obj/item/reagent_containers/food/snacks/fortunecookie


/datum/microwave_recipe/fortunecookie/CreateResult(obj/machinery/microwave/microwave)
	var/obj/item/reagent_containers/food/snacks/fortunecookie/cookie = ..()
	var/obj/item/paper/paper = locate() in microwave
	if (paper)
		paper.forceMove(cookie)
		cookie.trash = paper
		paper.loc = null
	return cookie


/datum/microwave_recipe/fortunecookie/CheckItems(obj/machinery/microwave/microwave)
	. = ..()
	if (.)
		var/obj/item/paper/paper = locate() in microwave
		if (!paper?.info)
			return FALSE


/datum/microwave_recipe/plainsteak
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	result_path = /obj/item/reagent_containers/food/snacks/plainsteak


/datum/microwave_recipe/meatsteak
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatsteak


/datum/microwave_recipe/loadedsteak
	required_reagents = list(
		/datum/reagent/nutriment/garlicsauce = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	required_produce = list(
		"onion" = 1,
		"mushroom" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/loadedsteak


/datum/microwave_recipe/syntisteak
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatsteak/synthetic


/datum/microwave_recipe/pizzamargherita
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita


/datum/microwave_recipe/meatpizza
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza


/datum/microwave_recipe/mushroompizza
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"mushroom" = 5,
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza


/datum/microwave_recipe/vegetablepizza
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"eggplant" = 1,
		"carrot" = 1,
		"corn" = 1,
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza


/datum/microwave_recipe/fruitpizza
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 20,
		/datum/reagent/sugar = 20
	)
	required_produce = list(
		"pineapple" = 1,
		"banana" = 1,
		"blueberries" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/fruitpizza


/datum/microwave_recipe/spacylibertyduff
	required_reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/ethanol/vodka = 5,
		/datum/reagent/drugs/psilocybin = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/spacylibertyduff


/datum/microwave_recipe/amanitajelly
	required_reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/ethanol/vodka = 5,
		/datum/reagent/toxin/amatoxin = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/amanitajelly


/datum/microwave_recipe/amanitajelly/CreateResult(obj/machinery/microwave/microwave)
		var/obj/item/reagent_containers/food/snacks/amanitajelly/jelly = ..()
		jelly.reagents.del_reagent(/datum/reagent/toxin/amatoxin)
		return jelly


/datum/microwave_recipe/meatballsoup
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meatball
	)
	required_produce = list(
		"carrot" = 1,
		"potato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatballsoup

/datum/microwave_recipe/onionsoup
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_produce = list(
		"onion" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/onionsoup


/datum/microwave_recipe/vegetablesoup
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_produce = list(
		"carrot" = 1,
		"potato" = 1,
		"corn" = 1,
		"eggplant" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/vegetablesoup


/datum/microwave_recipe/nettlesoup
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	required_produce = list(
		"nettle" = 1,
		"potato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/nettlesoup


/datum/microwave_recipe/wishsoup
	required_reagents = list(
		/datum/reagent/water = 20
	)
	result_path = /obj/item/reagent_containers/food/snacks/wishsoup


/datum/microwave_recipe/hotchili
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	required_produce = list(
		"chili" = 1,
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/hotchili


/datum/microwave_recipe/coldchili
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	required_produce = list(
		"icechili" = 1,
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/coldchili


/datum/microwave_recipe/amanita_pie
	required_reagents = list(
		/datum/reagent/toxin/amatoxin = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result_path = /obj/item/reagent_containers/food/snacks/amanita_pie


/datum/microwave_recipe/plump_pie
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"plumphelmet" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/plump_pie


/datum/microwave_recipe/spellburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meatburger,
		/obj/item/clothing/head/wizard
	)
	result_path = /obj/item/reagent_containers/food/snacks/spellburger


/datum/microwave_recipe/bigbiteburger
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meatburger,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_path = /obj/item/reagent_containers/food/snacks/bigbiteburger


/datum/microwave_recipe/enchiladas
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	required_produce = list(
		"chili" = 2,
		"corn" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/enchiladas


/datum/microwave_recipe/creamcheesebread
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread


/datum/microwave_recipe/monkeysdelight
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1,
		/datum/reagent/nutriment/flour = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/monkeycube
	)
	required_produce = list(
		"banana" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/monkeysdelight


/datum/microwave_recipe/baguette
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result_path = /obj/item/reagent_containers/food/snacks/baguette


/datum/microwave_recipe/fishandchips
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishandchips


/datum/microwave_recipe/bread
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/bread


/datum/microwave_recipe/sandwich
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sandwich


/datum/microwave_recipe/toastedsandwich
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result_path = /obj/item/reagent_containers/food/snacks/toastedsandwich


/datum/microwave_recipe/grilledcheese
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/grilledcheese


/datum/microwave_recipe/tomatosoup
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_produce = list(
		"tomato" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/tomatosoup


/datum/microwave_recipe/rofflewaffles
	required_reagents = list(
		/datum/reagent/drugs/psilocybin = 5,
		/datum/reagent/nutriment/batter/cakebatter = 20
	)
	result_path = /obj/item/reagent_containers/food/snacks/rofflewaffles


/datum/microwave_recipe/stew
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	required_produce = list(
		"potato" = 1,
		"tomato" = 1,
		"carrot" = 1,
		"eggplant" = 1,
		"mushroom" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/stew


/datum/microwave_recipe/slimetoast
	required_reagents = list(
		/datum/reagent/slimejelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime


/datum/microwave_recipe/jelliedtoast
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry


/datum/microwave_recipe/pbtoast
	required_reagents = list(
		/datum/reagent/nutriment/peanutbutter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/pbtoast


/datum/microwave_recipe/ntella_bread
	required_reagents = list(
		/datum/reagent/nutriment/choconutspread = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/ntella_bread


/datum/microwave_recipe/milosoup
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result_path = /obj/item/reagent_containers/food/snacks/milosoup


/datum/microwave_recipe/stewedsoymeat
	required_items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	required_produce = list(
		"carrot" = 1,
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/stewedsoymeat


/datum/microwave_recipe/boiledspagetti
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	result_path = /obj/item/reagent_containers/food/snacks/boiledspagetti


/datum/microwave_recipe/boiledrice
	required_reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/nutriment/rice = 10
	)
	result_path = /obj/item/reagent_containers/food/snacks/boiledrice


/datum/microwave_recipe/chazuke
	required_reagents = list(
		/datum/reagent/nutriment/rice/chazuke = 10
	)
	result_path = /obj/item/reagent_containers/food/snacks/boiledrice/chazuke


/datum/microwave_recipe/katsucurry
	required_reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/nutriment/rice = 10,
		/datum/reagent/nutriment/flour = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	required_produce = list(
		"apple" = 1,
		"carrot" = 1,
		"potato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/katsucurry


/datum/microwave_recipe/ricepudding
	required_reagents = list(
		/datum/reagent/drink/milk = 5,
		/datum/reagent/nutriment/rice = 10
	)
	result_path = /obj/item/reagent_containers/food/snacks/ricepudding


/datum/microwave_recipe/pastatomato
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	required_produce = list(
		"tomato" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/pastatomato


/datum/microwave_recipe/poppypretzel
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	required_produce = list(
		"poppy" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/poppypretzel


/datum/microwave_recipe/meatballspagetti
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatballspagetti


/datum/microwave_recipe/spesslaw
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result_path = /obj/item/reagent_containers/food/snacks/spesslaw


/datum/microwave_recipe/nanopasta
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/stack/nanopaste
	)
	result_path = /obj/item/reagent_containers/food/snacks/nanopasta


/datum/microwave_recipe/superbiteburger
	required_reagents = list(
		/datum/reagent/sodiumchloride = 5,
		/datum/reagent/blackpepper = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/superbiteburger


/datum/microwave_recipe/candiedapple
	required_reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/sugar = 5
	)
	required_produce = list(
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/candiedapple


/datum/microwave_recipe/applepie
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/applepie


/datum/microwave_recipe/slimeburger
	required_reagents = list(
		/datum/reagent/slimejelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result_path = /obj/item/reagent_containers/food/snacks/jellyburger/slime


/datum/microwave_recipe/jellyburger
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result_path = /obj/item/reagent_containers/food/snacks/jellyburger/cherry


/datum/microwave_recipe/twobread
	required_reagents = list(
		/datum/reagent/ethanol/wine = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/twobread


/datum/microwave_recipe/threebread
	required_items = list(
		/obj/item/reagent_containers/food/snacks/twobread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/threebread


/datum/microwave_recipe/slimesandwich
	required_reagents = list(
		/datum/reagent/slimejelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/jellysandwich/slime


/datum/microwave_recipe/cherrysandwich
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/jellysandwich/cherry


/datum/microwave_recipe/pbjsandwich_cherry
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5,
		/datum/reagent/nutriment/peanutbutter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/pbjsandwich/cherry


/datum/microwave_recipe/pbjsandwich_slime
	required_reagents = list(
		/datum/reagent/slimejelly = 5,
		/datum/reagent/nutriment/peanutbutter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/pbjsandwich/slime


/datum/microwave_recipe/bloodsoup
	required_reagents = list(
		/datum/reagent/blood = 30
	)
	result_path = /obj/item/reagent_containers/food/snacks/bloodsoup


/datum/microwave_recipe/slimesoup
	required_reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/slimejelly = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/slimesoup


/datum/microwave_recipe/boiledslimeextract
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/slime_extract
	)
	result_path = /obj/item/reagent_containers/food/snacks/boiledslimecore


/datum/microwave_recipe/chocolateegg
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result_path = /obj/item/reagent_containers/food/snacks/chocolateegg


/datum/microwave_recipe/sausage
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/sausage


/datum/microwave_recipe/fatsausage
	required_reagents = list(
		/datum/reagent/blackpepper = 2
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/fatsausage


/datum/microwave_recipe/fishfingers
	required_reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishfingers


/datum/microwave_recipe/mysterysoup
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/mysterysoup


/datum/microwave_recipe/pumpkinpie
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


/datum/microwave_recipe/plumphelmetbiscuit
	required_reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	required_produce = list(
		"plumphelmet" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit


/datum/microwave_recipe/plumphelmetbiscuitvegan
	required_reagents = list(
		/datum/reagent/nutriment/flour = 10,
		/datum/reagent/water = 10
	)
	required_produce = list(
		"plumphelmet" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit


/datum/microwave_recipe/mushroomsoup
	required_reagents = list(
		/datum/reagent/drink/milk = 10
	)
	required_produce = list(
		"mushroom" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/mushroomsoup


/datum/microwave_recipe/chawanmushi
	required_reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/nutriment/soysauce = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	required_produce = list(
		"mushroom" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/chawanmushi


/datum/microwave_recipe/beetsoup
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_produce = list(
		"whitebeet" = 1,
		"cabbage" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/beetsoup


/datum/microwave_recipe/appletart
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_produce = list(
		"goldapple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/appletart


/datum/microwave_recipe/tossedsalad
	required_produce = list(
		"lettuce" = 2,
		"tomato" = 1,
		"carrot" = 1,
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/tossedsalad


/datum/microwave_recipe/aesirsalad
	required_produce = list(
		"goldapple" = 1,
		"ambrosiadeus" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/aesirsalad


/datum/microwave_recipe/validsalad
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meatball
	)
	required_produce = list(
		"potato" = 1,
		"ambrosia" = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/validsalad


/datum/microwave_recipe/validsalad/CreateResult(obj/machinery/microwave/microwave)
	var/obj/item/reagent_containers/food/snacks/validsalad/salad = ..()
	salad.reagents.del_reagent(/datum/reagent/toxin)
	return salad


/datum/microwave_recipe/cracker
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result_path = /obj/item/reagent_containers/food/snacks/cracker


/datum/microwave_recipe/stuffing
	required_reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/stuffing


/datum/microwave_recipe/tofurkey
	required_items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result_path = /obj/item/reagent_containers/food/snacks/tofurkey


/datum/microwave_recipe/taco
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/taco


/datum/microwave_recipe/bun
	required_items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result_path = /obj/item/reagent_containers/food/snacks/bun


/datum/microwave_recipe/flatbread
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result_path = /obj/item/reagent_containers/food/snacks/flatbread


/datum/microwave_recipe/meatball
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball
	)
	result_path = /obj/item/reagent_containers/food/snacks/meatball


/datum/microwave_recipe/cutlet
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result_path = /obj/item/reagent_containers/food/snacks/cutlet

/datum/microwave_recipe/bacon
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon
	)
	result_path = /obj/item/reagent_containers/food/snacks/bacon

/datum/microwave_recipe/fries
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result_path = /obj/item/reagent_containers/food/snacks/fries


/datum/microwave_recipe/onionrings
	required_reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	required_produce = list(
		"onion" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/onionrings


/datum/microwave_recipe/mint
	required_reagents = list(
		/datum/reagent/sugar = 5,
		/datum/reagent/frostoil = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/mint


/datum/microwave_recipe/cake
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 60
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/plaincake


/datum/microwave_recipe/cake/carrot
	required_produce = list(
		"carrot" = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake


/datum/microwave_recipe/cake/cheese
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake


/datum/microwave_recipe/cake/ntella_cheesecake
	required_reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/choconutspread = 15, /datum/reagent/sugar = 10)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cookie,
		/obj/item/reagent_containers/food/snacks/cookie,
		/obj/item/reagent_containers/food/snacks/cookie
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/ntella_cheesecake


/datum/microwave_recipe/cake/orange
	required_produce = list(
		"orange" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/orangecake


/datum/microwave_recipe/cake/lime
	required_produce = list(
		"lime" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/limecake


/datum/microwave_recipe/cake/lemon
	required_produce = list(
		"lemon" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake


/datum/microwave_recipe/cake/chocolate
	required_items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake


/datum/microwave_recipe/cake/birthday
	required_reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 60,
		/datum/reagent/nutriment/sprinkles = 10
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake


/datum/microwave_recipe/cake/apple
	required_produce = list(
		"apple" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/applecake


/datum/microwave_recipe/cake/brain
	required_items = list(
		/obj/item/organ/internal/brain
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/braincake


/datum/microwave_recipe/cake/chocolatebar
	required_reagents = list(
		/datum/reagent/drink/milk/chocolate = 10,
		/datum/reagent/nutriment/coco = 5,
		/datum/reagent/sugar = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/chocolatebar


/datum/microwave_recipe/boiledspiderleg
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/spider
	)
	result_path = /obj/item/reagent_containers/food/snacks/spider/cooked


/datum/microwave_recipe/chilied_eggs
	required_items = list(
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/hotchili
	)
	result_path = /obj/item/reagent_containers/food/snacks/chilied_eggs


/datum/microwave_recipe/hatchling_surprise
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result_path = /obj/item/reagent_containers/food/snacks/hatchling_surprise


/datum/microwave_recipe/red_sun_special
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/red_sun_special


/datum/microwave_recipe/sea_delight
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	required_produce = list(
		"gukhe" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/sea_delight

/datum/microwave_recipe/stok_skewers
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


/datum/microwave_recipe/gukhe_fish
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


/datum/microwave_recipe/aghrassh_cake
	required_reagents = list(
		/datum/reagent/nutriment/protein = 8,
		/datum/reagent/nutriment/coco = 3,
		/datum/reagent/blackpepper = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	required_produce = list(
		"aghrassh" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/aghrassh_cake


/datum/microwave_recipe/clam_chowder
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/clam
	)
	required_produce = list(
		"potato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/clam_chowder


/datum/microwave_recipe/bisque
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/shellfish/crab
	)
	result_path = /obj/item/reagent_containers/food/snacks/bisque


/datum/microwave_recipe/stuffed_clam
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/clam,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/stuffed_clam


/datum/microwave_recipe/steamed_mussels
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


/datum/microwave_recipe/oysters_rockefeller
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/oyster,
		/obj/item/reagent_containers/food/snacks/shellfish/oyster,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/oysters_rockefeller


/datum/microwave_recipe/crab_cakes
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_path = /obj/item/reagent_containers/food/snacks/crab_cakes


/datum/microwave_recipe/crab_rangoon
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result_path = /obj/item/reagent_containers/food/snacks/crab_rangoon


/datum/microwave_recipe/crab_dinner
	required_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/shellfish/crab,
		/obj/item/reagent_containers/food/snacks/fruit_slice
	)
	result_path = /obj/item/reagent_containers/food/snacks/crab_dinner


/datum/microwave_recipe/shrimp_cocktail
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


/datum/microwave_recipe/shrimp_tempura
	required_reagents = list(
		/datum/reagent/nutriment/batter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/shrimp
	)
	result_path = /obj/item/reagent_containers/food/snacks/shrimp_tempura


/datum/microwave_recipe/seafood_paella
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

/datum/microwave_recipe/unscotti
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

/datum/microwave_recipe/biscotti
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/unscotti
	)
	result_path = /obj/item/reagent_containers/food/snacks/biscotti
