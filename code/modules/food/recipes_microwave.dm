/datum/recipe/friedegg
	reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg


/datum/recipe/friedegg2
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg


/datum/recipe/boiledegg
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/boiledegg


/datum/recipe/dionaroast
	reagents = list(
		/datum/reagent/acid/polyacid = 5
	)
	items = list(
		/obj/item/holder/diona
	)
	fruit = list(
		"apple" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/dionaroast


/datum/recipe/classichotdog
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/corgi
	)
	result = /obj/item/reagent_containers/food/snacks/classichotdog


/datum/recipe/jellydonut
	reagents = list(
		/datum/reagent/drink/juice/berry = 5,
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/jelly


/datum/recipe/jellydonut/slime
	reagents = list(
		/datum/reagent/slimejelly = 5,
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/slimejelly


/datum/recipe/jellydonut/cherry
	reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5,
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/cherryjelly


/datum/recipe/donut
	reagents = list(
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/normal


/datum/recipe/meatburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/meatburger


/datum/recipe/brainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/reagent_containers/food/snacks/brainburger


/datum/recipe/roburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/reagent_containers/food/snacks/roburger


/datum/recipe/xenoburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xenoburger


/datum/recipe/fishburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/fishburger


/datum/recipe/tofuburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofuburger


/datum/recipe/ghostburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/ectoplasm
	)
	result = /obj/item/reagent_containers/food/snacks/ghostburger


/datum/recipe/clownburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/reagent_containers/food/snacks/clownburger


/datum/recipe/mimeburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/reagent_containers/food/snacks/mimeburger


/datum/recipe/bunbun
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/bunbun


/datum/recipe/hotdog
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/hotdog


/datum/recipe/waffles
	reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 20
	)
	result = /obj/item/reagent_containers/food/snacks/waffles


/datum/recipe/pancakesblu
	reagents = list(
		/datum/reagent/nutriment/batter = 20
	)
	fruit = list(
		"blueberries" = 2
	)
	result = /obj/item/reagent_containers/food/snacks/pancakesblu


/datum/recipe/pancakes
	reagents = list(
		/datum/reagent/nutriment/batter = 20
	)
	result = /obj/item/reagent_containers/food/snacks/pancakes


/datum/recipe/hot_donkpocket
	reagents = list()
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket


/datum/recipe/hot_donkpocket/warm/make_food(obj/container)
	var/obj/item/reagent_containers/food/snacks/donkpocket/donk = locate() in container
	donk?.SetHot()
	return donk


/datum/recipe/meatbread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread


/datum/recipe/xenomeatbread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread


/datum/recipe/bananabread
	reagents = list(
		/datum/reagent/drink/milk = 5,
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	fruit = list(
		"banana" = 2
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bananabread


/datum/recipe/omelette
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/omelette


/datum/recipe/muffin
	reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 10
	)
	result = /obj/item/reagent_containers/food/snacks/muffin


/datum/recipe/eggplantparm
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list(
		"eggplant" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm


/datum/recipe/soylenviridians
	reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	fruit = list(
		"soybeans" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/soylenviridians


/datum/recipe/soylentgreen
	reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result = /obj/item/reagent_containers/food/snacks/soylentgreen


/datum/recipe/meatpie
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/meatpie


/datum/recipe/tofupie
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofupie


/datum/recipe/xemeatpie
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xemeatpie


/datum/recipe/bananapie
	reagents = list(
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	fruit = list(
		"banana" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/bananapie


/datum/recipe/cherrypie
	reagents = list(
		/datum/reagent/sugar = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	fruit = list(
		"cherries" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/cherrypie


/datum/recipe/berryclafoutis
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	fruit = list(
		"berries" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis


/datum/recipe/chaosdonut
	reagents = list(
		/datum/reagent/frostoil = 5,
		/datum/reagent/capsaicin = 5,
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/chaos


/datum/recipe/meatkabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/meatkabob


/datum/recipe/tofukabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofukabob


/datum/recipe/tofubread
	items = list(
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
	result = /obj/item/reagent_containers/food/snacks/sliceable/tofubread


/datum/recipe/loadedbakedpotato
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list(
		"potato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato


/datum/recipe/cheesyfries
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries


/datum/recipe/cubancarp
	reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	fruit = list(
		"chili" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp


/datum/recipe/popcorn
	reagents = list(
		/datum/reagent/sodiumchloride = 5
	)
	fruit = list(
		"corn" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/popcorn


/datum/recipe/cookie
	reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 5,
		/datum/reagent/nutriment/coco = 5
	)
	result = /obj/item/reagent_containers/food/snacks/cookie


/datum/recipe/fortunecookie
	reagents = list(
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie


/datum/recipe/fortunecookie/make_food(obj/container)
	var/obj/item/reagent_containers/food/snacks/fortunecookie/cookie = ..(container)
	var/obj/item/paper/paper = locate() in container
	if (paper)
		paper.forceMove(cookie)
		cookie.trash = paper
		paper.loc = null
	return cookie


/datum/recipe/fortunecookie/check_items(obj/container)
	. = ..()
	if (.)
		var/obj/item/paper/paper = locate() in container
		if (!paper?.info)
			return 0
	return .


/datum/recipe/plainsteak
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/plainsteak


/datum/recipe/meatsteak
	reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/meatsteak


/datum/recipe/loadedsteak
	reagents = list(
		/datum/reagent/nutriment/garlicsauce = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	fruit = list(
		"onion" = 1,
		"mushroom" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/loadedsteak


/datum/recipe/syntisteak
	reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/reagent_containers/food/snacks/meatsteak/synthetic


/datum/recipe/pizzamargherita
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list(
		"tomato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita


/datum/recipe/meatpizza
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list(
		"tomato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza


/datum/recipe/mushroompizza
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list(
		"mushroom" = 5,
		"tomato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza


/datum/recipe/vegetablepizza
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list(
		"eggplant" = 1,
		"carrot" = 1,
		"corn" = 1,
		"tomato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza


/datum/recipe/fruitpizza
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	reagents = list(
		/datum/reagent/drink/milk/cream = 20,
		/datum/reagent/sugar = 20
	)
	fruit = list(
		"pineapple" = 1,
		"banana" = 1,
		"blueberries" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/fruitpizza


/datum/recipe/spacylibertyduff
	reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/ethanol/vodka = 5,
		/datum/reagent/psilocybin = 5
	)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff


/datum/recipe/amanitajelly
	reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/ethanol/vodka = 5,
		/datum/reagent/toxin/amatoxin = 5
	)
	result = /obj/item/reagent_containers/food/snacks/amanitajelly


/datum/recipe/amanitajelly/make_food(obj/container)
		var/obj/item/reagent_containers/food/snacks/amanitajelly/jelly = ..(container)
		jelly.reagents.del_reagent(/datum/reagent/toxin/amatoxin)
		return jelly


/datum/recipe/meatballsoup
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball
	)
	fruit = list(
		"carrot" = 1,
		"potato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/meatballsoup

/datum/recipe/onionsoup
	reagents = list(
		/datum/reagent/water = 10
	)
	fruit = list(
		"onion" = 2
	)
	result = /obj/item/reagent_containers/food/snacks/onionsoup


/datum/recipe/vegetablesoup
	reagents = list(
		/datum/reagent/water = 10
	)
	fruit = list(
		"carrot" = 1,
		"potato" = 1,
		"corn" = 1,
		"eggplant" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/vegetablesoup


/datum/recipe/nettlesoup
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	fruit = list(
		"nettle" = 1,
		"potato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/nettlesoup


/datum/recipe/wishsoup
	reagents = list(
		/datum/reagent/water = 20
	)
	result= /obj/item/reagent_containers/food/snacks/wishsoup


/datum/recipe/hotchili
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	fruit = list(
		"chili" = 1,
		"tomato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/hotchili


/datum/recipe/coldchili
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	fruit = list(
		"icechili" = 1,
		"tomato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/coldchili


/datum/recipe/amanita_pie
	reagents = list(
		/datum/reagent/toxin/amatoxin = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie


/datum/recipe/plump_pie
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	fruit = list(
		"plumphelmet" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/plump_pie


/datum/recipe/spellburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meatburger,
		/obj/item/clothing/head/wizard
	)
	result = /obj/item/reagent_containers/food/snacks/spellburger


/datum/recipe/bigbiteburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meatburger,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/bigbiteburger


/datum/recipe/enchiladas
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	fruit = list(
		"chili" = 2,
		"corn" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/enchiladas


/datum/recipe/creamcheesebread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread


/datum/recipe/monkeysdelight
	reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1,
		/datum/reagent/nutriment/flour = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeycube
	)
	fruit = list(
		"banana" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/monkeysdelight


/datum/recipe/baguette
	reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/baguette


/datum/recipe/fishandchips
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips


/datum/recipe/bread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bread


/datum/recipe/sandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sandwich


/datum/recipe/toastedsandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/reagent_containers/food/snacks/toastedsandwich


/datum/recipe/grilledcheese
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese


/datum/recipe/tomatosoup
	reagents = list(
		/datum/reagent/water = 10
	)
	fruit = list(
		"tomato" = 2
	)
	result = /obj/item/reagent_containers/food/snacks/tomatosoup


/datum/recipe/rofflewaffles
	reagents = list(
		/datum/reagent/psilocybin = 5,
		/datum/reagent/nutriment/batter/cakebatter = 20
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles


/datum/recipe/stew
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	fruit = list(
		"potato" = 1,
		"tomato" = 1,
		"carrot" = 1,
		"eggplant" = 1,
		"mushroom" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/stew


/datum/recipe/slimetoast
	reagents = list(
		/datum/reagent/slimejelly = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime


/datum/recipe/jelliedtoast
	reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry


/datum/recipe/milosoup
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/milosoup


/datum/recipe/stewedsoymeat
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	fruit = list(
		"carrot" = 1,
		"tomato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat


/datum/recipe/boiledspagetti
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	result = /obj/item/reagent_containers/food/snacks/boiledspagetti


/datum/recipe/boiledrice
	reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/nutriment/rice = 10
	)
	result = /obj/item/reagent_containers/food/snacks/boiledrice


/datum/recipe/chazuke
	reagents = list(
		/datum/reagent/nutriment/rice/chazuke = 10
	)
	result = /obj/item/reagent_containers/food/snacks/boiledrice/chazuke


/datum/recipe/katsucurry
	reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/nutriment/rice = 10,
		/datum/reagent/nutriment/flour = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	fruit = list(
		"apple" = 1,
		"carrot" = 1,
		"potato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/katsucurry


/datum/recipe/ricepudding
	reagents = list(
		/datum/reagent/drink/milk = 5,
		/datum/reagent/nutriment/rice = 10
	)
	result = /obj/item/reagent_containers/food/snacks/ricepudding


/datum/recipe/pastatomato
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	fruit = list(
		"tomato" = 2
	)
	result = /obj/item/reagent_containers/food/snacks/pastatomato


/datum/recipe/poppypretzel
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	fruit = list(
		"poppy" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel


/datum/recipe/meatballspagetti
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatballspagetti


/datum/recipe/spesslaw
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/spesslaw


/datum/recipe/nanopasta
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/stack/nanopaste
	)
	result = /obj/item/reagent_containers/food/snacks/nanopasta


/datum/recipe/superbiteburger
	reagents = list(
		/datum/reagent/sodiumchloride = 5,
		/datum/reagent/blackpepper = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	fruit = list(
		"tomato" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/superbiteburger


/datum/recipe/candiedapple
	reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/sugar = 5
	)
	fruit = list(
		"apple" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/candiedapple


/datum/recipe/applepie
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	fruit = list(
		"apple" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/applepie


/datum/recipe/slimeburger
	reagents = list(
		/datum/reagent/slimejelly = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/slime


/datum/recipe/jellyburger
	reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/cherry


/datum/recipe/twobread
	reagents = list(
		/datum/reagent/ethanol/wine = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/twobread


/datum/recipe/threebread
	items = list(
		/obj/item/reagent_containers/food/snacks/twobread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/threebread


/datum/recipe/slimesandwich
	reagents = list(
		/datum/reagent/slimejelly = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/slime


/datum/recipe/cherrysandwich
	reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/cherry


/datum/recipe/bloodsoup
	reagents = list(
		/datum/reagent/blood = 30
	)
	result = /obj/item/reagent_containers/food/snacks/bloodsoup


/datum/recipe/slimesoup
	reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/slimejelly = 5
	)
	result = /obj/item/reagent_containers/food/snacks/slimesoup


/datum/recipe/boiledslimeextract
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/slime_extract
	)
	result = /obj/item/reagent_containers/food/snacks/boiledslimecore


/datum/recipe/chocolateegg
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolateegg


/datum/recipe/sausage
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/sausage


/datum/recipe/fatsausage
	reagents = list(
		/datum/reagent/blackpepper = 2
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/fatsausage


/datum/recipe/fishfingers
	reagents = list(
		/datum/reagent/nutriment/flour = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/fishfingers


/datum/recipe/mysterysoup
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/mysterysoup


/datum/recipe/pumpkinpie
	reagents = list(
		/datum/reagent/sugar = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	fruit = list(
		"pumpkin" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie


/datum/recipe/plumphelmetbiscuit
	reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	fruit = list(
		"plumphelmet" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit


/datum/recipe/plumphelmetbiscuitvegan
	reagents = list(
		/datum/reagent/nutriment/flour = 10,
		/datum/reagent/water = 10
	)
	fruit = list(
		"plumphelmet" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit


/datum/recipe/mushroomsoup
	reagents = list(
		/datum/reagent/drink/milk = 10
	)
	fruit = list(
		"mushroom" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/mushroomsoup


/datum/recipe/chawanmushi
	reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/nutriment/soysauce = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	fruit = list(
		"mushroom" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/chawanmushi


/datum/recipe/beetsoup
	reagents = list(
		/datum/reagent/water = 10
	)
	fruit = list(
		"whitebeet" = 1,
		"cabbage" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/beetsoup


/datum/recipe/appletart
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	fruit = list(
		"goldapple" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/appletart


/datum/recipe/tossedsalad
	fruit = list(
		"lettuce" = 2,
		"tomato" = 1,
		"carrot" = 1,
		"apple" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/tossedsalad


/datum/recipe/aesirsalad
	fruit = list(
		"goldapple" = 1,
		"ambrosiadeus" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/aesirsalad


/datum/recipe/validsalad
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball
	)
	fruit = list(
		"potato" = 1,
		"ambrosia" = 3
	)
	result = /obj/item/reagent_containers/food/snacks/validsalad


/datum/recipe/validsalad/make_food(obj/container)
	var/obj/item/reagent_containers/food/snacks/validsalad/salad = ..(container)
	salad.reagents.del_reagent(/datum/reagent/toxin)
	return salad


/datum/recipe/cracker
	reagents = list(
		/datum/reagent/sodiumchloride = 1
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/cracker


/datum/recipe/stuffing
	reagents = list(
		/datum/reagent/water = 10,
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/bread
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing


/datum/recipe/tofurkey
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey


/datum/recipe/taco
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco


/datum/recipe/bun
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/bun


/datum/recipe/flatbread
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/flatbread


/datum/recipe/meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatball


/datum/recipe/cutlet
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/cutlet

/datum/recipe/bacon
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon

/datum/recipe/fries
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/fries


/datum/recipe/onionrings
	reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	fruit = list(
		"onion" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/onionrings


/datum/recipe/mint
	reagents = list(
		/datum/reagent/sugar = 5,
		/datum/reagent/frostoil = 5
	)
	result = /obj/item/reagent_containers/food/snacks/mint


/datum/recipe/cake
	reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 60
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/plaincake


/datum/recipe/cake/carrot
	fruit = list(
		"carrot" = 3
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake


/datum/recipe/cake/cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake


/datum/recipe/cake/orange
	fruit = list(
		"orange" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/orangecake


/datum/recipe/cake/lime
	fruit = list(
		"lime" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/limecake


/datum/recipe/cake/lemon
	fruit = list(
		"lemon" = 1
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake


/datum/recipe/cake/chocolate
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake


/datum/recipe/cake/birthday
	reagents = list(
		/datum/reagent/nutriment/batter/cakebatter = 60,
		/datum/reagent/nutriment/sprinkles = 10
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake


/datum/recipe/cake/apple
	fruit = list(
		"apple" = 2
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/applecake


/datum/recipe/cake/brain
	items = list(
		/obj/item/organ/internal/brain
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/braincake


/datum/recipe/cake/chocolatebar
	reagents = list(
		/datum/reagent/drink/milk/chocolate = 10,
		/datum/reagent/nutriment/coco = 5,
		/datum/reagent/sugar = 5
	)
	result = /obj/item/reagent_containers/food/snacks/chocolatebar


/datum/recipe/boiledspiderleg
	reagents = list(
		/datum/reagent/water = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/spider
	)
	result = /obj/item/reagent_containers/food/snacks/spider/cooked
