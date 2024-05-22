/datum/gear/cane
	display_name = "cane"
	path = /obj/item

/datum/gear/cane/New()
	..()
	var/canes = list()
	canes["cane"] = /obj/item/cane
	canes["crutch, single"] = /obj/item/cane/crutch
	canes["crutches, box of two"] = /obj/item/storage/box/large/crutches
	canes["telescopic cane"] = /obj/item/cane/telescopic
	canes["white guide cane"] = /obj/item/cane/white
	gear_tweaks += new/datum/gear_tweak/path(canes)

/datum/gear/union_card
	display_name = "union membership"
	path = /obj/item/card/union

/datum/gear/union_card/spawn_on_mob(mob/living/carbon/human/H, metadata)
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
	var/list/types = subtypesof(/obj/item/storage/lunchbox) - /obj/item/storage/lunchbox/caltrops
	var/list/options = list()
	for (var/obj/item/storage/lunchbox/lunchbox as anything in types)
		if (!initial(lunchbox.filled))
			options[initial(lunchbox.name)] = lunchbox
	gear_tweaks += new/datum/gear_tweak/path(options)
	gear_tweaks += new/datum/gear_tweak/contents(
		lunchables_lunches(),
		lunchables_snacks(),
		lunchables_drinks()
	)

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
	plushes["crow plush"] = /obj/item/toy/plushie/crow
	plushes["spider plush"] = /obj/item/toy/plushie/spider
	plushes["farwa plush"] = /obj/item/toy/plushie/farwa
	plushes["golden carp plush"] = /obj/item/toy/plushie/carp_gold
	plushes["purple carp plush"] = /obj/item/toy/plushie/carp_purple
	plushes["pink carp plush"] = /obj/item/toy/plushie/carp_pink
	plushes["corgi plush"] = /obj/item/toy/plushie/corgi
	plushes["corgi plush with bow"] = /obj/item/toy/plushie/corgi_bow
	plushes["deer plush"] = /obj/item/toy/plushie/deer
	plushes["blue squid plush"] = /obj/item/toy/plushie/squid_blue
	plushes["orange squid plush"] = /obj/item/toy/plushie/squid_orange
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
	path = /obj/item/passport
	flags = GEAR_HAS_SUBTYPE_SELECTION
	custom_setup_proc = /obj/item/passport/proc/set_info

/datum/gear/foundation_civilian
	display_name = "operant registration card"
	description = "A registration card in a faux-leather case. It marks the named individual as a registered, law-abiding psionic."
	path = /obj/item/card/operant_card
	custom_setup_proc = /obj/item/card/operant_card/proc/set_info

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

/datum/gear/smokingpipe
	display_name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/cornpipe
	display_name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe

/datum/gear/matchbox
	display_name = "matchbox"
	path = /obj/item/storage/fancy/matches/matchbox

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/storage/fancy/matches/matchbook

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
	path = /obj/item/storage/fancy/smokable/case
	cost = 2

/datum/gear/cigars
	display_name = "fancy cigar case"
	path = /obj/item/storage/fancy/smokable/cigar
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
