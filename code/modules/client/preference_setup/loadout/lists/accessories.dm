
/datum/gear/accessory
	sort_category = "Accessories"
	category = /datum/gear/accessory
	slot = slot_tie

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["blue tie"] = /obj/item/clothing/accessory/blue
	ties["red tie"] = /obj/item/clothing/accessory/red
	ties["blue tie, clip"] = /obj/item/clothing/accessory/blue_clip
	ties["red long tie"] = /obj/item/clothing/accessory/red_long
	ties["black tie"] = /obj/item/clothing/accessory/black
	ties["yellow tie"] = /obj/item/clothing/accessory/yellow
	ties["navy tie"] = /obj/item/clothing/accessory/navy
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	ties["brown tie"] = /obj/item/clothing/accessory/brown
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/tie_color
	display_name = "colored tie"
	path = /obj/item/clothing/accessory
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie_color/New()
	..()
	var/ties = list()
	ties["tie"] = /obj/item/clothing/accessory
	ties["striped tie"] = /obj/item/clothing/accessory/long
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/locket
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/necklace
	display_name = "necklace, colour select"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/bowtie
	display_name = "bowtie, horrible"
	path = /obj/item/clothing/accessory/bowtie/ugly

/datum/gear/accessory/bowtie/color
	display_name = "bowtie, colour select"
	path = /obj/item/clothing/accessory/bowtie/color
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/ntaward
	display_name = "corporate award selection"
	description = "A medal or ribbon awarded to corporate personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal
	cost = 8

/datum/gear/accessory/ntaward/New()
	..()
	var/ntawards = list()
	ntawards["sciences medal"] = /obj/item/clothing/accessory/medal/bronze/nanotrasen
	ntawards["distinguished service"] = /obj/item/clothing/accessory/medal/silver/nanotrasen
	ntawards["command medal"] = /obj/item/clothing/accessory/medal/gold/nanotrasen
	gear_tweaks += new/datum/gear_tweak/path(ntawards)

//have to break up armbands to restrict access
/datum/gear/accessory/armband_security
	display_name = "security armband"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband_cargo
	display_name = "cargo armband"
	path = /obj/item/clothing/accessory/armband/cargo

/datum/gear/accessory/armband_medical
	display_name = "medical armband"
	path = /obj/item/clothing/accessory/armband/med

/datum/gear/accessory/armband_emt
	display_name = "EMT armband"
	path = /obj/item/clothing/accessory/armband/medgreen
	allowed_roles = list(/datum/job/doctor)

/datum/gear/accessory/armband_engineering
	display_name = "engineering armband"
	path = /obj/item/clothing/accessory/armband/engine

/datum/gear/accessory/armband_hydro
	display_name = "hydroponics armband"
	path = /obj/item/clothing/accessory/armband/hydro
	allowed_roles = list(/datum/job/rd, /datum/job/scientist, /datum/job/assistant)

/datum/gear/accessory/armband_nt
	display_name = "corporate armband"
	path = /obj/item/clothing/accessory/armband/whitered

/datum/gear/accessory/ftupin
	display_name = "Free Trade Union pin"
	path = /obj/item/clothing/accessory/ftupin

/datum/gear/accessory/chaplaininsignia
	display_name = "chaplain insignia"
	path = /obj/item/clothing/accessory/chaplaininsignia
	cost = 1
	allowed_roles = list(/datum/job/chaplain)

/datum/gear/accessory/chaplaininsignia/New()
	..()
	var/insignia = list()
	insignia["chaplain insignia (christianity)"] = /obj/item/clothing/accessory/chaplaininsignia
	insignia["chaplain insignia (judaism)"] = /obj/item/clothing/accessory/chaplaininsignia/judaism
	insignia["chaplain insignia (islam)"] = /obj/item/clothing/accessory/chaplaininsignia/islam
	insignia["chaplain insignia (buddhism)"] = /obj/item/clothing/accessory/chaplaininsignia/buddhism
	insignia["chaplain insignia (hinduism)"] = /obj/item/clothing/accessory/chaplaininsignia/hinduism
	insignia["chaplain insignia (sikhism)"] = /obj/item/clothing/accessory/chaplaininsignia/sikhism
	insignia["chaplain insignia (baha'i faith)"] = /obj/item/clothing/accessory/chaplaininsignia/bahaifaith
	insignia["chaplain insignia (jainism)"] = /obj/item/clothing/accessory/chaplaininsignia/jainism
	insignia["chaplain insignia (taoism)"] = /obj/item/clothing/accessory/chaplaininsignia/taoism
	gear_tweaks += new/datum/gear_tweak/path(insignia)

/datum/gear/accessory/bracelet
	display_name = "bracelet, color select"
	path = /obj/item/clothing/accessory/bracelet
	cost = 1
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/wristwatch
	display_name = "wrist watch selection"
	path = /obj/item/clothing/accessory/wristwatches
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/accessory/pronouns
	display_name = "pronoun badge selection"
	description = "A selection of badges used to indicate the preferred pronouns of the wearer."
	path = /obj/item/clothing/accessory/pronouns


/datum/gear/accessory/pronouns/New()
	..()
	var/list/options = list()
	options["they/them badge"] = /obj/item/clothing/accessory/pronouns
	options["he/him badge"] = /obj/item/clothing/accessory/pronouns/hehimbadge
	options["she/her badge"] = /obj/item/clothing/accessory/pronouns/sheherbadge
	options["he/they badge"] = /obj/item/clothing/accessory/pronouns/hetheybadge
	options["she/they badge"] = /obj/item/clothing/accessory/pronouns/shetheybadge
	options["he/she badge"] = /obj/item/clothing/accessory/pronouns/heshebadge
	options["ask me badge"] = /obj/item/clothing/accessory/pronouns/pleaseaskbadge
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/accessory/pride_pins
	display_name = "pride pin selection"
	description = "A selection of pins used to signal membership or support of an identity or sexuality."
	path = /obj/item/clothing/accessory/pridepins


/datum/gear/accessory/pride_pins/New()
	..()
	var/list/options = list()
	options["transgender pride pin"] = /obj/item/clothing/accessory/pridepins
	options["lesbian pride pin"] = /obj/item/clothing/accessory/pridepins/lesbianpin
	options["bisexual pride pin"] = /obj/item/clothing/accessory/pridepins/bisexualpin
	options["gay pride pin"] = /obj/item/clothing/accessory/pridepins/gaypin
	options["pansexual pride pin"] = /obj/item/clothing/accessory/pridepins/pansexualpin
	options["nonbinary pride pin"] = /obj/item/clothing/accessory/pridepins/nonbinarypin
	options["asexual pride pin"] = /obj/item/clothing/accessory/pridepins/asexualpin
	options["intersex pride pin"] = /obj/item/clothing/accessory/pridepins/intersexpin
	gear_tweaks += new /datum/gear_tweak/path (options)

/datum/gear/accessory/neckerchief
	display_name = "neckerchief, colour select"
	description = "A piece of cloth tied around the neck. A favorite of Sailors and Partisans everywhere."
	path = /obj/item/clothing/accessory/neckerchief
	flags = GEAR_HAS_COLOR_SELECTION
