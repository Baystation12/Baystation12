/datum/gear/cane
	display_name = "Baston"
	path = /obj/item/cane

/datum/gear/union_card
	display_name = "Membresia de la union"
	path = /obj/item/card/union

/datum/gear/union_card/spawn_on_mob(var/mob/living/carbon/human/H, var/metadata)
	. = ..()
	if(.)
		var/obj/item/card/union/card = .
		card.signed_by = H.real_name

/datum/gear/dice
	display_name = "paquete de dados"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/dice/nerd
	display_name = "paquete de dados (juego)"
	path = /obj/item/storage/pill_bottle/dice_nerd

/datum/gear/cards
	display_name = "Mazo de cartas"
	path = /obj/item/deck/cards

/datum/gear/tarot
	display_name = "baraja de cartas del tarot"
	path = /obj/item/deck/tarot

/datum/gear/holder
	display_name = "titular"
	path = /obj/item/deck/holder

/datum/gear/cardemon_pack
	display_name = "Paquete de Cardemon"
	path = /obj/item/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "Paquete de Spaceball"
	path = /obj/item/pack/spaceball

/datum/gear/flask
	display_name = "matraz"
	path = /obj/item/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "dosis de vacuna"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/coffeecup
	display_name = "taza de cafe"
	path = /obj/item/reagent_containers/food/drinks/glass2/coffeecup
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/knives
	display_name = "seleccion de cuchillos"
	description = "Una seleccion de cuchillos."
	path = /obj/item/material/knife

/datum/gear/knives/New()
	..()
	var/knives = list()
	knives["Cuchillo plegable"] = /obj/item/material/knife/folding
	knives["navaja campesina"] = /obj/item/material/knife/folding/wood
	knives["cuchillo plegable tactico"] = /obj/item/material/knife/folding/tacticool
	knives["cuchillo utilitario"] = /obj/item/material/knife/utility
	knives["cuchillo utilitario ligero"] = /obj/item/material/knife/utility/lightweight
	gear_tweaks += new/datum/gear_tweak/path(knives)

/datum/gear/lunchbox
	display_name = "caja de almuerzo"
	description = "Una lonchera."
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
	display_name = "toalla"
	path = /obj/item/towel
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/plush_toy
	display_name = "juguete de peluche"
	description = "Un juguete de peluche."
	path = /obj/item/toy/plushie

/datum/gear/plush_toy/New()
	..()
	var/plushes = list()
	plushes["ninfa diona de peluche"] = /obj/item/toy/plushie/nymph
	plushes["raton de peluche"] = /obj/item/toy/plushie/mouse
	plushes["gatito de peluche"] = /obj/item/toy/plushie/kitten
	plushes["lagarto de peluche"] = /obj/item/toy/plushie/lizard
	plushes["aracnido de peluche"] = /obj/item/toy/plushie/spider
	plushes["farwa de peluche de juguete"] = /obj/item/toy/plushie/farwa
	gear_tweaks += new /datum/gear_tweak/path(plushes)

/datum/gear/workvisa
	display_name = "visa de trabajo"
	description = "Una visa de trabajo emitida por el Gobierno Central del Sol con el proposito de trabajar."
	path = /obj/item/paper/workvisa

/datum/gear/travelvisa
	display_name = "visa de viaje"
	description = "Una visa de viaje emitida por el Gobierno Central del Sol con el propósito de recreacion."
	path = /obj/item/paper/travelvisa

/datum/gear/passport
	display_name = "seleccion de pasaportes"
	description = "Una seleccion de pasaportes."
	path = /obj/item/passport
	flags = GEAR_HAS_SUBTYPE_SELECTION
	custom_setup_proc = /obj/item/passport/proc/set_info

/datum/gear/mirror
	display_name = "espejo de mano"
	sort_category = "Productos cosmeticos"
	path = /obj/item/mirror

/datum/gear/lipstick
	display_name = "seleccion de lapiz labial"
	path = /obj/item/lipstick
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/comb
	display_name = "peine de plastico"
	path = /obj/item/haircomb
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/smokingpipe
	display_name = "pipa"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/cornpipe
	display_name = "pipa de maiz"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe

/datum/gear/matchbook
	display_name = "caja de cerillas"
	path = /obj/item/storage/box/matches

/datum/gear/lighter
	display_name = "encendedor barato"
	path = /obj/item/flame/lighter

/datum/gear/lighter/New()
	..()
	var/colours = list()
	colours["aleatorio"] = /obj/item/flame/lighter/random
	colours["rojo"] = /obj/item/flame/lighter/red
	colours["amarillo"] = /obj/item/flame/lighter/yellow
	colours["cian"] = /obj/item/flame/lighter/cyan
	colours["verde"] = /obj/item/flame/lighter/green
	colours["rosa"] = /obj/item/flame/lighter/pink
	gear_tweaks += new/datum/gear_tweak/path(colours)

/datum/gear/zippo
	display_name = "zippo"
	path = /obj/item/flame/lighter/zippo

/datum/gear/zippo/New()
	..()
	var/colours = list()
	colours["aleatorio"] = /obj/item/flame/lighter/zippo/random
	colours["plata"] = /obj/item/flame/lighter/zippo
	colours["ennegrecido"] = /obj/item/flame/lighter/zippo/black
	colours["bronce gris"] = /obj/item/flame/lighter/zippo/gunmetal
	colours["bronce"] = /obj/item/flame/lighter/zippo/bronze
	colours["rosado"] = /obj/item/flame/lighter/zippo/pink
	gear_tweaks += new/datum/gear_tweak/path(colours)

/datum/gear/ashtray
	display_name = "cenicero, plastico"
	path = /obj/item/material/ashtray/plastic

/datum/gear/cigscase
	display_name = "caja de cigarrillos de lujo"
	path = /obj/item/storage/fancy/cigarettes/case
	cost = 2

/datum/gear/cigars
	display_name = "caja de puros de lujo"
	path = /obj/item/storage/fancy/cigar
	cost = 2

/datum/gear/cigar
	display_name = "cigarro de lujo"
	path = /obj/item/clothing/mask/smokable/cigarette/cigar

/datum/gear/cigar/New()
	..()
	var/cigar_type = list()
	cigar_type["premium"] = /obj/item/clothing/mask/smokable/cigarette/cigar
	cigar_type["Cohiba Robusto"] = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	gear_tweaks += new/datum/gear_tweak/path(cigar_type)

/datum/gear/ecig
	display_name = "cigarrillo electronico"
	path = /obj/item/clothing/mask/smokable/ecig/util

/datum/gear/ecig/deluxe
	display_name = "cigarrillo electrónico, de lujo"
	path = /obj/item/clothing/mask/smokable/ecig/deluxe
	cost = 2

/datum/gear/bible
	display_name = "libro sagrado"
	path = /obj/item/storage/bible
	cost = 2

/datum/gear/bible/New()
	..()
	var/books = list()
	books["biblia (ajustable)"] = /obj/item/storage/bible
	books["Biblia"] = /obj/item/storage/bible/bible
	books["Tanakh"] = /obj/item/storage/bible/tanakh
	books["Quran"] = /obj/item/storage/bible/quran
	books["Kitab-i-Aqdas"] = /obj/item/storage/bible/aqdas
	books["Kojiki"] = /obj/item/storage/bible/kojiki
	books["Guru Granth Sahib"] = /obj/item/storage/bible/guru
	gear_tweaks += new/datum/gear_tweak/path(books)

/datum/gear/swiss
	display_name = "herramienta multiple"
	path = /obj/item/material/knife/folding/swiss
	cost = 4
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/cross
	display_name = "cruz"
	path = /obj/item/material/cross
	cost = 2

/datum/gear/cross/New()
	..()
	var/crosstype = list()
	crosstype["cruz, madera"] = /obj/item/material/cross/wood
	crosstype["cruz, plata"] = /obj/item/material/cross/silver
	crosstype["cruz, oro"] = /obj/item/material/cross/gold
	gear_tweaks += new/datum/gear_tweak/path(crosstype)

/datum/gear/coin
	display_name = "moneda"
	path = /obj/item/material/coin
	cost = 2

/datum/gear/coin/New()
	..()
	var/cointype = list()
	cointype["moneda, oio"] = /obj/item/material/coin/gold
	cointype["moneda, plata"] = /obj/item/material/coin/silver
	cointype["moneda, hierro"] = /obj/item/material/coin/iron
	cointype["moneda, diamante"] = /obj/item/material/coin/diamond
	cointype["moneda, uranio"] = /obj/item/material/coin/uranium
	cointype["moneda, phoron"] = /obj/item/material/coin/phoron
	cointype["moneda, platino"] = /obj/item/material/coin/platinum
	gear_tweaks += new/datum/gear_tweak/path(cointype)
