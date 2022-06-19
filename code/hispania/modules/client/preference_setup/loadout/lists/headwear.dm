/datum/gear/head
	sort_category = "Sombreros y articulos para la cabeza"
	slot = slot_head
	category = /datum/gear/head

/datum/gear/head/beret
	display_name = "boina, seleccione color"
	path = /obj/item/clothing/head/beret/plaincolor
	flags = GEAR_HAS_COLOR_SELECTION
	description = "Una boina simple de color solido. Este no tiene emblemas ni insignias."

/datum/gear/head/bandana
	display_name = "seleccion de bandana"
	path = /obj/item/clothing

/datum/gear/head/bandana/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(typesof(/obj/item/clothing/mask/bandana) + typesof(/obj/item/clothing/head/bandana))

/datum/gear/head/beanie
	display_name = "gorro, seleccione color"
	path = /obj/item/clothing/head/beanie
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/bow
	display_name = "lazo para el pelo, seleccione color"
	path = /obj/item/clothing/head/hairflower/bow
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/flat_cap
	display_name = "gorra plano, seleccione color"
	path = /obj/item/clothing/head/flatcap
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/mariner
	display_name = "gorra de marin, seleccione color"
	path = /obj/item/clothing/head/mariner
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/cap
	display_name = "seleccion de gorra"
	path = /obj/item/clothing/head

/datum/gear/head/cap/New()
	..()
	var/caps = list()
	caps["gorra negra"] = /obj/item/clothing/head/soft/black
	caps["gorra azul"] = /obj/item/clothing/head/soft/blue
	caps["gorra verde"] = /obj/item/clothing/head/soft/green
	caps["gorra gris"] = /obj/item/clothing/head/soft/grey
	caps["gorra de cartero"] = /obj/item/clothing/head/mailman
	caps["gorra naranja"] = /obj/item/clothing/head/soft/orange
	caps["gorra morada"] = /obj/item/clothing/head/soft/purple
	caps["gorra arcoiris"] = /obj/item/clothing/head/soft/rainbow
	caps["gorra roja"] = /obj/item/clothing/head/soft/red
	caps["gorra blanca"] = /obj/item/clothing/head/soft/mime
	caps["gorra amarilla"] = /obj/item/clothing/head/soft/yellow
	caps["gorra major bill's shipping"] = /obj/item/clothing/head/soft/mbill
	gear_tweaks += new/datum/gear_tweak/path(caps)

/datum/gear/head/hairflower
	display_name = "broche de flor"
	path = /obj/item/clothing/head/hairflower

/datum/gear/head/hairflower/New()
	..()
	var/pins = list()
	pins["broche azul"] = /obj/item/clothing/head/hairflower/blue
	pins["broche rosado"] = /obj/item/clothing/head/hairflower/pink
	pins["broche rojo"] = /obj/item/clothing/head/hairflower
	pins["broche amarillo"] = /obj/item/clothing/head/hairflower/yellow
	gear_tweaks += new/datum/gear_tweak/path(pins)

/datum/gear/head/hardhat
	display_name = "seleccion de cascos"
	path = /obj/item/clothing/head/hardhat
	cost = 2

/datum/gear/head/hardhat/New()
	..()
	var/hardhats = list()
	hardhats["casco azul"] = /obj/item/clothing/head/hardhat/dblue
	hardhats["casco naranja"] = /obj/item/clothing/head/hardhat/orange
	hardhats["casco rojo"] = /obj/item/clothing/head/hardhat/red
	hardhats["casco ligero de contruccion"] = /obj/item/clothing/head/hardhat/EMS/DC_light
	hardhats["Casco de Manejo de Emergencias"] = /obj/item/clothing/head/hardhat/damage_control/EMB
	hardhats["casco antiguo rojo de Manejo de Emergencias"] = /obj/item/clothing/head/hardhat/damage_control/EMB_Ancient
	hardhats["casco antiguo amarillo de Manejo de Emergencias"] = /obj/item/clothing/head/hardhat/damage_control/EMB_Ancient/yellow
	hardhats["casco antiguo blanco de Manejo de Emergencias"] = /obj/item/clothing/head/hardhat/damage_control/EMB_Ancient/white
	gear_tweaks += new/datum/gear_tweak/path(hardhats)

/datum/gear/head/formalhat
	display_name = "seleccion de sombreros formales"
	path = /obj/item/clothing/head

/datum/gear/head/formalhat/New()
	..()
	var/formalhats = list()
	formalhats["sombrero de barquero"] = /obj/item/clothing/head/boaterhat
	formalhats["bombín"] = /obj/item/clothing/head/bowler
	formalhats["sombrero de fieltro"] = /obj/item/clothing/head/fedora //m'lady
	formalhats["trilby de plumas"] = /obj/item/clothing/head/feathertrilby
	formalhats["fez"] = /obj/item/clothing/head/fez
	formalhats["sombrero de copa"] = /obj/item/clothing/head/that
	formalhats["sombrero de fieltro, marrón"] = /obj/item/clothing/head/det
	formalhats["sombrero de fieltro, gris"] = /obj/item/clothing/head/det/grey
	formalhats["sombrero panama"] = /obj/item/clothing/head/panama
	gear_tweaks += new/datum/gear_tweak/path(formalhats)

/datum/gear/head/informalhat
	display_name = "selección informal de sombreros"
	path = /obj/item/clothing/head

/datum/gear/head/informalhat/New()
	..()
	var/informalhats = list()
	informalhats["sombrero de vaquero"] = /obj/item/clothing/head/cowboy_hat
	informalhats["ushanka"] = /obj/item/clothing/head/ushanka
	gear_tweaks += new/datum/gear_tweak/path(informalhats)

/datum/gear/head/hijab
	display_name = "hijab, seleccione color"
	path = /obj/item/clothing/head/hijab
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/kippa
	display_name = "kippa, seleccione color"
	path = /obj/item/clothing/head/kippa
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/turban
	display_name = "turban, seleccione color"
	path = /obj/item/clothing/head/turban
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/taqiyah
	display_name = "taqiyah, seleccione color"
	path = /obj/item/clothing/head/taqiyah
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/rastacap
	display_name = "gorra rastafari"
	path = /obj/item/clothing/head/rastacap

/datum/gear/head/surgical
	display_name = "gorros quirurgicos estandar"
	path = /obj/item/clothing/head/surgery
	flags = GEAR_HAS_TYPE_SELECTION | GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/surgical/custom
	display_name = "gorro quirúrgico, seleccione color"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/welding
	display_name = "seleccion de mascara de soldadura"
	path = /obj/item/clothing/head/welding

/datum/gear/head/welding/New()
	..()
	var/welding_masks = list()
	welding_masks += /obj/item/clothing/head/welding/demon
	welding_masks += /obj/item/clothing/head/welding/engie
	welding_masks += /obj/item/clothing/head/welding/fancy
	welding_masks += /obj/item/clothing/head/welding/knight
	welding_masks += /obj/item/clothing/head/welding/carp
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(welding_masks)

/datum/gear/head/tankccap
	display_name = "gorra acolchada"
	path = /obj/item/clothing/head/tank

/datum/gear/tactical/balaclava
	display_name = "pasamontanas"
	path = /obj/item/clothing/mask/balaclava

/datum/gear/head/corporateberet
	display_name = "seleccion de boinas corporativas"
	path = /obj/item/clothing/head/beret
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/head/corporateberet/New()
	..()
	var/list/options = list()
	options += /obj/item/clothing/head/beret/pcrc
	options += /obj/item/clothing/head/beret/saare
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(options)
