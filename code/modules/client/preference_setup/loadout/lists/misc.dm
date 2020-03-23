/datum/gear/cane
	display_name = "cane"
	path = /obj/item/weapon/cane

/datum/gear/union_card
	display_name = "union membership"
	path = /obj/item/weapon/card/union

/datum/gear/union_card/spawn_on_mob(var/mob/living/carbon/human/H, var/metadata)
	. = ..()
	if(.)
		var/obj/item/weapon/card/union/card = .
		card.signed_by = H.real_name

/datum/gear/dice
	display_name = "dice pack"
	path = /obj/item/weapon/storage/pill_bottle/dice

/datum/gear/dice/nerd
	display_name = "dice pack (gaming)"
	path = /obj/item/weapon/storage/pill_bottle/dice_nerd

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/weapon/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/weapon/deck/tarot

/datum/gear/holder
	display_name = "card holder"
	path = /obj/item/weapon/deck/holder

/datum/gear/cardemon_pack
	display_name = "Cardemon booster pack"
	path = /obj/item/weapon/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "Spaceball booster pack"
	path = /obj/item/weapon/pack/spaceball

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/coffeecup
	display_name = "coffee cup"
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/coffeecup
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/knives
	display_name = "knives selection"
	description = "A selection of knives."
	path = /obj/item/weapon/material/knife

/datum/gear/knives/New()
	..()
	var/knives = list()
	knives["Folding knife"] = /obj/item/weapon/material/knife/folding
	knives["peasant folding knife"] = /obj/item/weapon/material/knife/folding/wood
	knives["tactical folding knife"] = /obj/item/weapon/material/knife/folding/tacticool
	knives["utility knife"] = /obj/item/weapon/material/knife/utility
	knives["lightweight utility knife"] = /obj/item/weapon/material/knife/utility/lightweight
	gear_tweaks += new/datum/gear_tweak/path(knives)

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/weapon/storage/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/weapon/storage/lunchbox))
		var/obj/item/weapon/storage/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	gear_tweaks += new/datum/gear_tweak/path(lunchboxes)
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/weapon/towel
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
	path = /obj/item/weapon/paper/workvisa

/datum/gear/mirror/
	display_name = "handheld mirror"
	sort_category = "Cosmetics"
	path = /obj/item/weapon/mirror

/datum/gear/lipstick
	display_name = "lipstick selection"
	path = /obj/item/weapon/lipstick
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/comb
	display_name = "plastic comb"
	path = /obj/item/weapon/haircomb
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
	path = /obj/item/weapon/storage/box/matches

/datum/gear/lighter
	display_name = "cheap lighter"
	path = /obj/item/weapon/flame/lighter

/datum/gear/lighter/New()
	..()
	var/colours = list()
	colours["random"] = /obj/item/weapon/flame/lighter/random
	colours["red"] = /obj/item/weapon/flame/lighter/red
	colours["yellow"] = /obj/item/weapon/flame/lighter/yellow
	colours["cyan"] = /obj/item/weapon/flame/lighter/cyan
	colours["green"] = /obj/item/weapon/flame/lighter/green
	colours["pink"] = /obj/item/weapon/flame/lighter/pink
	gear_tweaks += new/datum/gear_tweak/path(colours)

/datum/gear/zippo
	display_name = "zippo"
	path = /obj/item/weapon/flame/lighter/zippo

/datum/gear/zippo/New()
	..()
	var/colours = list()
	colours["random"] = /obj/item/weapon/flame/lighter/zippo/random
	colours["silver"] = /obj/item/weapon/flame/lighter/zippo
	colours["blackened"] = /obj/item/weapon/flame/lighter/zippo/black
	colours["gunmetal"] = /obj/item/weapon/flame/lighter/zippo/gunmetal
	colours["bronze"] = /obj/item/weapon/flame/lighter/zippo/bronze
	colours["pink"] = /obj/item/weapon/flame/lighter/zippo/pink
	gear_tweaks += new/datum/gear_tweak/path(colours)

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/weapon/material/ashtray/plastic

/datum/gear/cigars
	display_name = "fancy cigar case"
	path = /obj/item/weapon/storage/fancy/cigar
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
	path = /obj/item/weapon/storage/bible
	cost = 2

/datum/gear/bible/New()
	..()
	var/books = list()
	books["bible (adjustable)"] = /obj/item/weapon/storage/bible
	books["Bible"] = /obj/item/weapon/storage/bible/bible
	books["Tanakh"] = /obj/item/weapon/storage/bible/tanakh
	books["Quran"] = /obj/item/weapon/storage/bible/quran
	books["Kitab-i-Aqdas"] = /obj/item/weapon/storage/bible/aqdas
	books["Kojiki"] = /obj/item/weapon/storage/bible/kojiki
	gear_tweaks += new/datum/gear_tweak/path(books)

/datum/gear/swiss
	display_name = "multi-tool"
	path = /obj/item/weapon/material/knife/folding/swiss
	cost = 4
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/cross
	display_name = "cross"
	path = /obj/item/weapon/material/cross
	cost = 2

/datum/gear/cross/New()
	..()
	var/crosstype = list()
	crosstype["cross, wood"] = /obj/item/weapon/material/cross/wood
	crosstype["cross, silver"] = /obj/item/weapon/material/cross/silver
	crosstype["cross, gold"] = /obj/item/weapon/material/cross/gold
	gear_tweaks += new/datum/gear_tweak/path(crosstype)