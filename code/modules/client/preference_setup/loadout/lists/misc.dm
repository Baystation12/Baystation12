/datum/gear/cane
	display_name = "cane"
	path = /obj/item/cane

/datum/gear/union_card
	display_name = "union membership"
	path = /obj/item/card/union

/datum/gear/union_card/spawn_on_mob(var/mob/living/carbon/human/H, var/metadata)
	. = ..()
	if(.)
		var/obj/item/card/union/card = .
		card.signed_by = H.real_name

/datum/gear/dice
	display_name = "dice pack"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/dice/nerd
	display_name = "dice pack (gaming)"
	path = /obj/item/storage/pill_bottle/dice_nerd

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/deck/tarot

/datum/gear/holder
	display_name = "card holder"
	path = /obj/item/deck/holder

/datum/gear/cardemon_pack
	display_name = "Cardemon booster pack"
	path = /obj/item/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "Spaceball booster pack"
	path = /obj/item/pack/spaceball

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/coffeecup
	display_name = "coffee cup"
	path = /obj/item/reagent_containers/food/drinks/glass2/coffeecup
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/knives
	display_name = "knives selection"
	description = "A selection of knives."
	path = /obj/item/material/knife

/datum/gear/knives/New()
	..()
	var/knives = list()
	knives["Folding knife"] = /obj/item/material/knife/folding
	knives["peasant folding knife"] = /obj/item/material/knife/folding/wood
	knives["tactical folding knife"] = /obj/item/material/knife/folding/tacticool
	knives["utility knife"] = /obj/item/material/knife/utility
	knives["lightweight utility knife"] = /obj/item/material/knife/utility/lightweight
	gear_tweaks += new/datum/gear_tweak/path(knives)

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/storage/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/storage/lunchbox))
		var/obj/item/storage/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	gear_tweaks += new/datum/gear_tweak/path(lunchboxes)
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/towel
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/plush_toy
	display_name = "plush toy"
	description = "A plush toy."
	path = /obj/item/toy/plushie

/datum/gear/plush_toy/New()
	..()
	var/plushes = list()
	plushes["diona nymph plush"] = /obj/item/toy/plushie/nymph
	plushes["mouse plush"] = /obj/item/toy/plushie/mouse
	plushes["kitten plush"] = /obj/item/toy/plushie/kitten
	plushes["lizard plush"] = /obj/item/toy/plushie/lizard
	plushes["spider plush"] = /obj/item/toy/plushie/spider
	plushes["farwa plush"] = /obj/item/toy/plushie/farwa
	gear_tweaks += new /datum/gear_tweak/path(plushes)

/datum/gear/workvisa
	display_name = "work visa"
	description = "A work visa issued by the Sol Central Government for the purpose of work."
	path = /obj/item/paper/workvisa

/datum/gear/travelvisa
	display_name = "travel visa"
	description = "A travel visa issued by the Sol Central Government for the purpose of recreation."
	path = /obj/item/paper/travelvisa

/datum/gear/passport
	display_name = "passports selection"
	description = "A selection of passports."
	cost = 0
	path = /obj/item/passport
	flags = GEAR_HAS_SUBTYPE_SELECTION
	custom_setup_proc = /obj/item/passport/proc/set_info

/datum/gear/mirror
	display_name = "handheld mirror"
	sort_category = "Cosmetics"
	path = /obj/item/mirror

/datum/gear/lipstick
	display_name = "lipstick selection"
	path = /obj/item/lipstick
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/comb
	display_name = "plastic comb"
	path = /obj/item/haircomb
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/mask
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/datum/gear/smokingpipe
	display_name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/cornpipe
	display_name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/storage/box/matches

/datum/gear/lighter
	display_name = "cheap lighter"
	path = /obj/item/flame/lighter

/datum/gear/lighter/New()
	..()
	var/colours = list()
	colours["random"] = /obj/item/flame/lighter/random
	colours["red"] = /obj/item/flame/lighter/red
	colours["yellow"] = /obj/item/flame/lighter/yellow
	colours["cyan"] = /obj/item/flame/lighter/cyan
	colours["green"] = /obj/item/flame/lighter/green
	colours["pink"] = /obj/item/flame/lighter/pink
	gear_tweaks += new/datum/gear_tweak/path(colours)

/datum/gear/zippo
	display_name = "zippo"
	path = /obj/item/flame/lighter/zippo

/datum/gear/zippo/New()
	..()
	var/colours = list()
	colours["random"] = /obj/item/flame/lighter/zippo/random
	colours["silver"] = /obj/item/flame/lighter/zippo
	colours["blackened"] = /obj/item/flame/lighter/zippo/black
	colours["gunmetal"] = /obj/item/flame/lighter/zippo/gunmetal
	colours["bronze"] = /obj/item/flame/lighter/zippo/bronze
	colours["pink"] = /obj/item/flame/lighter/zippo/pink
	gear_tweaks += new/datum/gear_tweak/path(colours)

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/material/ashtray/plastic

/datum/gear/cigscase
	display_name = "fancy cigarette case"
	path = /obj/item/storage/fancy/cigarettes/case
	cost = 2

/datum/gear/cigars
	display_name = "fancy cigar case"
	path = /obj/item/storage/fancy/cigar
	cost = 2

/datum/gear/cigar
	display_name = "fancy cigar"
	path = /obj/item/clothing/mask/smokable/cigarette/cigar

/datum/gear/cigar/New()
	..()
	var/cigar_type = list()
	cigar_type["premium"] = /obj/item/clothing/mask/smokable/cigarette/cigar
	cigar_type["Cohiba Robusto"] = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	gear_tweaks += new/datum/gear_tweak/path(cigar_type)

/datum/gear/ecig
	display_name = "electronic cigarette"
	path = /obj/item/clothing/mask/smokable/ecig/util

/datum/gear/ecig/deluxe
	display_name = "electronic cigarette, deluxe"
	path = /obj/item/clothing/mask/smokable/ecig/deluxe
	cost = 2

/datum/gear/bible
	display_name = "holy book"
	path = /obj/item/storage/bible
	cost = 2

/datum/gear/bible/New()
	..()
	var/books = list()
	books["bible (adjustable)"] = /obj/item/storage/bible
	books["Bible"] = /obj/item/storage/bible/bible
	books["Tanakh"] = /obj/item/storage/bible/tanakh
	books["Quran"] = /obj/item/storage/bible/quran
	books["Kitab-i-Aqdas"] = /obj/item/storage/bible/aqdas
	books["Kojiki"] = /obj/item/storage/bible/kojiki
	books["Guru Granth Sahib"] = /obj/item/storage/bible/guru
	gear_tweaks += new/datum/gear_tweak/path(books)

/datum/gear/swiss
	display_name = "multi-tool"
	path = /obj/item/material/knife/folding/swiss
	cost = 4
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/cross
	display_name = "cross"
	path = /obj/item/material/cross
	cost = 2

/datum/gear/cross/New()
	..()
	var/crosstype = list()
	crosstype["cross, wood"] = /obj/item/material/cross/wood
	crosstype["cross, silver"] = /obj/item/material/cross/silver
	crosstype["cross, gold"] = /obj/item/material/cross/gold
	gear_tweaks += new/datum/gear_tweak/path(crosstype)

/datum/gear/coin
	display_name = "coin"
	path = /obj/item/material/coin
	cost = 2

/datum/gear/coin/New()
	..()
	var/cointype = list()
	cointype["coin, gold"] = /obj/item/material/coin/gold
	cointype["coin, silver"] = /obj/item/material/coin/silver
	cointype["coin, iron"] = /obj/item/material/coin/iron
	cointype["coin, diamond"] = /obj/item/material/coin/diamond
	cointype["coin, uranium"] = /obj/item/material/coin/uranium
	cointype["coin, phoron"] = /obj/item/material/coin/phoron
	cointype["coin, platinum"] = /obj/item/material/coin/platinum
	gear_tweaks += new/datum/gear_tweak/path(cointype)
