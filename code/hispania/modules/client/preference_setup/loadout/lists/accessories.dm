/datum/gear/accessory
	sort_category = "Accesorios"
	category = /datum/gear/accessory
	slot = slot_tie


/datum/gear/accessory/tie
	display_name = "seleccion de corbata"
	path = /obj/item/clothing/accessory


/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["corbata azul"] = /obj/item/clothing/accessory/blue
	ties["corbata roja"] = /obj/item/clothing/accessory/red
	ties["corbata azul, prensilla"] = /obj/item/clothing/accessory/blue_clip
	ties["corbata larga roja"] = /obj/item/clothing/accessory/red_long
	ties["Corbata negra"] = /obj/item/clothing/accessory/black
	ties["Corbata amarilla"] = /obj/item/clothing/accessory/yellow
	ties["corbata azul marino"] = /obj/item/clothing/accessory/navy
	ties["corbata horrible"] = /obj/item/clothing/accessory/horrible
	ties["corbata marron"] = /obj/item/clothing/accessory/brown
	gear_tweaks += new/datum/gear_tweak/path(ties)


/datum/gear/accessory/tie_color
	display_name = "corbata de color"
	path = /obj/item/clothing/accessory
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/accessory/tie_color/New()
	..()
	var/ties = list()
	ties["Corbata"] = /obj/item/clothing/accessory
	ties["corbata a rayas"] = /obj/item/clothing/accessory/long
	gear_tweaks += new/datum/gear_tweak/path(ties)


/datum/gear/accessory/locket
	display_name = "medallon"
	path = /obj/item/clothing/accessory/locket


/datum/gear/accessory/necklace
	display_name = "collar, selecciona color"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/accessory/bowtie
	display_name = "corbata de lazo, horrible"
	path = /obj/item/clothing/accessory/bowtie/ugly


/datum/gear/accessory/bowtie/color
	display_name = "corbata de lazo, selecciona color"
	path = /obj/item/clothing/accessory/bowtie/color
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/accessory/ntaward
	display_name = "premios corporativos"
	description = "una medalla o cinta otorgada al personal corporativo por logros significativos."
	path = /obj/item/clothing/accessory/medal
	cost = 8
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/ntaward/New()
	..()
	var/ntawards = list()
	ntawards["medalla de ciencias"] = /obj/item/clothing/accessory/medal/bronze/nanotrasen
	ntawards["servicio distinguido"] = /obj/item/clothing/accessory/medal/silver/nanotrasen
	ntawards["medalla de mando"] = /obj/item/clothing/accessory/medal/gold/nanotrasen
	gear_tweaks += new/datum/gear_tweak/path(ntawards)


/datum/gear/accessory/armband_security
	display_name = "brazalete de seguridad"
	path = /obj/item/clothing/accessory/armband
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/armband_cargo
	display_name = "brazalete de abastecimiento"
	path = /obj/item/clothing/accessory/armband/cargo
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/armband_medical
	display_name = "brazalete medico"
	path = /obj/item/clothing/accessory/armband/med
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/armband_emt
	display_name = "brazalete EMT"
	path = /obj/item/clothing/accessory/armband/medgreen
	allowed_roles = list(
		/datum/job/doctor
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/armband_engineering
	display_name = "brazalete de ingenieria"
	path = /obj/item/clothing/accessory/armband/engine
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/armband_hydro
	display_name = "brazalete de hidroponia"
	path = /obj/item/clothing/accessory/armband/hydro
	allowed_roles = list(
		/datum/job/rd,
		/datum/job/scientist,
		/datum/job/assistant
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/armband_nt
	display_name = "brazalete de corporativo"
	path = /obj/item/clothing/accessory/armband/whitered


/datum/gear/accessory/ftu_pin
	display_name = "insignia de la Free Trade Union"
	path = /obj/item/clothing/accessory/ftu_pin
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/chaplain
	display_name = "insignias de sacerdote"
	path = /obj/item/clothing/accessory/chaplain
	allowed_roles = list(
		/datum/job/chaplain
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/accessory/chaplain/New()
	..()
	var/options = list()
	options["cristiandad"] = /obj/item/clothing/accessory/chaplain/christianity
	options["judaismo"] = /obj/item/clothing/accessory/chaplain/judaism
	options["islam"] = /obj/item/clothing/accessory/chaplain/islam
	options["budismo"] = /obj/item/clothing/accessory/chaplain/buddhism
	options["hinduismo"] = /obj/item/clothing/accessory/chaplain/hinduism
	options["sijismo"] = /obj/item/clothing/accessory/chaplain/sikhism
	options["fe baha'i"] = /obj/item/clothing/accessory/chaplain/bahaifaith
	options["jainismo"] = /obj/item/clothing/accessory/chaplain/jainism
	options["taoismo"] = /obj/item/clothing/accessory/chaplain/taoism
	gear_tweaks += new/datum/gear_tweak/path (options)


/datum/gear/accessory/bracelet
	display_name = "pulsera, selecciona color"
	path = /obj/item/clothing/accessory/bracelet
	cost = 1
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/accessory/wristwatch
	display_name = "seleccion de reloj de pulsera"
	path = /obj/item/clothing/accessory/wristwatches
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION


/datum/gear/accessory/pronouns
	display_name = "seleccion de insignia de pronombre"
	description = "Una seleccion de insignias utilizadas para indicar los pronombres preferidos del usuario."
	path = /obj/item/clothing/accessory/pronouns


/datum/gear/accessory/pronouns/New()
	..()
	var/list/options = list()
	options["insignia de ellos / ellos"] = /obj/item/clothing/accessory/pronouns/they
	options["el insignia"] = /obj/item/clothing/accessory/pronouns/hehim
	options["ella / su placa"] = /obj/item/clothing/accessory/pronouns/sheher
	options["El / ellos insignia"] = /obj/item/clothing/accessory/pronouns/hethey
	options["Ella / ellos insignia"] = /obj/item/clothing/accessory/pronouns/shethey
	options["el / ella insignia"] = /obj/item/clothing/accessory/pronouns/heshe
	options["ze/hir insignia"] = /obj/item/clothing/accessory/pronouns/zehir
	options["preguntame insignia"] = /obj/item/clothing/accessory/pronouns/ask
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/accessory/pride_pins
	display_name = "seleccion de broche de orgullo"
	description = "Una selección de broches que se utilizan para señalar la pertenencia o el apoyo a una identidad o sexualidad."
	path = /obj/item/clothing/accessory/pride_pin


/datum/gear/accessory/pride_pins/New()
	..()
	var/list/options = list()
	options["orgullo transgenero broche"] = /obj/item/clothing/accessory/pride_pin/transgender
	options["orgullo lesbico broche"] = /obj/item/clothing/accessory/pride_pin/lesbian
	options["orgullo bisexual broche"] = /obj/item/clothing/accessory/pride_pin/bisexual
	options["orgullo gay broche"] = /obj/item/clothing/accessory/pride_pin/gay
	options["orgullo pansexual broche"] = /obj/item/clothing/accessory/pride_pin/pansexual
	options["orgullo no binario broche"] = /obj/item/clothing/accessory/pride_pin/nonbinary
	options["orgullo asexual broche"] = /obj/item/clothing/accessory/pride_pin/asexual
	options["orgullo intersexual broche"] = /obj/item/clothing/accessory/pride_pin/intersex
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/accessory/neckerchief
	display_name = "bandana, selecciona color"
	description = "Un trozo de tela atado alrededor del cuello. Un favorito de los marineros y partisanos en todas partes."
	path = /obj/item/clothing/accessory/neckerchief
	flags = GEAR_HAS_COLOR_SELECTION
