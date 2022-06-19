/datum/gear/uniform
	sort_category = "Uniformes y Vestimenta Casual"
	slot = slot_w_uniform
	category = /datum/gear/uniform

/datum/gear/uniform/jumpsuit
	display_name = "mono, seleccione color"
	path = /obj/item/clothing/under/color
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/shortjumpskirt
	display_name = "falda corta, seleccione color"
	path = /obj/item/clothing/under/shortjumpskirt
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/blackjumpshorts
	display_name = "pantalones cortos de mono negro"
	path = /obj/item/clothing/under/color/blackjumpshorts

/datum/gear/uniform/roboticist_skirt
	display_name = "falda, roboticista"
	path = /obj/item/clothing/under/rank/roboticist/skirt

/datum/gear/uniform/suit
	display_name = "seleccion de ropa"
	path = /obj/item/clothing/under

/datum/gear/uniform/suit/New()
	..()
	var/suits = list()
	suits += /obj/item/clothing/under/sl_suit
	suits += /obj/item/clothing/under/suit_jacket
	suits += /obj/item/clothing/under/lawyer/blue
	suits += /obj/item/clothing/under/suit_jacket/burgundy
	suits += /obj/item/clothing/under/suit_jacket/charcoal
	suits += /obj/item/clothing/under/suit_jacket/checkered
	suits += /obj/item/clothing/under/suit_jacket/really_black
	suits += /obj/item/clothing/under/suit_jacket/female
	suits += /obj/item/clothing/under/gentlesuit
	suits += /obj/item/clothing/under/suit_jacket/navy
	suits += /obj/item/clothing/under/lawyer/oldman
	suits += /obj/item/clothing/under/lawyer/purpsuit
	suits += /obj/item/clothing/under/suit_jacket/red
	suits += /obj/item/clothing/under/lawyer/red
	suits += /obj/item/clothing/under/lawyer/black
	suits += /obj/item/clothing/under/suit_jacket/tan
	suits += /obj/item/clothing/under/scratch
	suits += /obj/item/clothing/under/lawyer/bluesuit
	suits += /obj/item/clothing/under/rank/internalaffairs/plain
	suits += /obj/item/clothing/under/blazer
	suits += /obj/item/clothing/under/blackjumpskirt
	suits += /obj/item/clothing/under/kilt
	suits += /obj/item/clothing/under/dress/dress_hr
	suits += /obj/item/clothing/under/det
	suits += /obj/item/clothing/under/det/black
	suits += /obj/item/clothing/under/det/grey
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(suits)

/datum/gear/uniform/scrubs
	display_name = "batas medicas estandar"
	path = /obj/item/clothing/under/rank/medical/scrubs
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/scrubs/custom
	display_name = "matorrales, seleccione color"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/dress
	display_name = "seleccion de vestidos"
	path = /obj/item/clothing/under

/datum/gear/uniform/dress/New()
	..()
	var/dresses = list()
	dresses += /obj/item/clothing/under/sundress_white
	dresses += /obj/item/clothing/under/dress/dress_fire
	dresses += /obj/item/clothing/under/dress/dress_green
	dresses += /obj/item/clothing/under/dress/dress_orange
	dresses += /obj/item/clothing/under/dress/dress_pink
	dresses += /obj/item/clothing/under/dress/dress_purple
	dresses += /obj/item/clothing/under/sundress
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(dresses)

/datum/gear/uniform/cheongsam
	display_name = "cheongsam, seleccione color"
	path = /obj/item/clothing/under/cheongsam
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/abaya
	display_name = "abaya, seleccione color"
	path = /obj/item/clothing/under/abaya
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/skirt
	display_name = "seleccion de falda"
	path = /obj/item/clothing/under/skirt
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/skirt_c
	display_name = "falda corta, seleccione color"
	path = /obj/item/clothing/under/skirt_c
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/skirt_c/dress
	display_name = "vestido sencillo, seleccione color"
	path = /obj/item/clothing/under/skirt_c/dress
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/casual_pants
	display_name = "seleccion de pantalones casuales"
	path = /obj/item/clothing/under/casual_pants
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/formal_pants
	display_name = "selección de pantalones formales"
	path = /obj/item/clothing/under/formal_pants
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/formal_pants/custom
	display_name = "pantalones de traje, seleccione color"
	path = /obj/item/clothing/under/formal_pants
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/formal_pants/baggycustom
	display_name = "pantalones de traje holgados, seleccione color"
	path = /obj/item/clothing/under/formal_pants/baggy
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/shorts
	display_name = "seleccion de pantalones cortos"
	path = /obj/item/clothing/under/shorts/jeans
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/shorts/custom
	display_name = "Pantalones deportivos, seleccione color"
	path = /obj/item/clothing/under/shorts
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/turtleneck
	display_name = "sueter, seleccione color"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/kimono
	display_name = "kimono, seleccione color"
	path = /obj/item/clothing/under/kimono
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/corporate
	display_name = "seleccion de uniformes corporativos"
	path = /obj/item/clothing/under

/datum/gear/uniform/corporate/New()
	..()
	var/corps = list()
	corps += /obj/item/clothing/under/rank/scientist/nanotrasen
	corps += /obj/item/clothing/under/rank/scientist/heph
	corps += /obj/item/clothing/under/rank/scientist/zeng
	corps += /obj/item/clothing/under/mbill
	corps += /obj/item/clothing/under/saare
	corps += /obj/item/clothing/under/aether
	corps += /obj/item/clothing/under/hephaestus
	corps += /obj/item/clothing/under/pcrc
	corps += /obj/item/clothing/under/pcrcsuit
	corps += /obj/item/clothing/under/wardt
	corps += /obj/item/clothing/under/grayson
	corps += /obj/item/clothing/under/focal
	corps += /obj/item/clothing/under/rank/ntwork
	corps += /obj/item/clothing/under/morpheus
	corps += /obj/item/clothing/under/skinner
	corps += /obj/item/clothing/under/dais
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(corps)

/datum/gear/uniform/corp_exec
	display_name = "colores corporativos, investigador supervisor"
	path = /obj/item/clothing/under/rank/scientist/executive
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/corp_overalls
	display_name = "colores corporativos, overoles"
	path = /obj/item/clothing/under/rank/ntwork
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/corp_flight
	display_name = "colores corporativos, traje de vuelo"
	path = /obj/item/clothing/under/rank/ntpilot
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/corp_exec_jacket
	display_name = "colores corporativos, traje de enlace"
	path = /obj/item/clothing/under/suit_jacket/corp
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/sterile
	display_name = "mono esteril"
	path = /obj/item/clothing/under/sterile
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/hazard
	display_name = "mono de peligro"
	path = /obj/item/clothing/under/hazard

/datum/gear/uniform/frontier
	display_name = "ropa de frontera"
	path = /obj/item/clothing/under/frontier