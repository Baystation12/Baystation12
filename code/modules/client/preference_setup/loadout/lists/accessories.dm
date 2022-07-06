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

//proxima code start
/datum/gear/accessory/ec_sweater
	display_name = "expeditionary fleece jacket"
	path = /obj/item/clothing/accessory/ec_sweater
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)

/datum/gear/accessory/ec_sweater/officer
	display_name = "expeditionary officer's fleece jacket"
	path = /obj/item/clothing/accessory/ec_sweater/officer
	allowed_branches = list(/datum/mil_branch/expeditionary_corps)
	allowed_roles = list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos, /datum/job/bridgeofficer)

/datum/gear/accessory/ec_sweater/fleet
	display_name = "fleet sweater"
	path = /obj/item/clothing/accessory/ec_sweater/fleet
	allowed_branches = list(/datum/mil_branch/fleet)

//proxima code end

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


/datum/gear/accessory/ftu_pin
	display_name = "Free Trade Union pin"
	path = /obj/item/clothing/accessory/ftu_pin


/datum/gear/accessory/chaplain
	display_name = "chaplain insignia"
	path = /obj/item/clothing/accessory/chaplain
	allowed_roles = list(/datum/job/chaplain)


/datum/gear/accessory/chaplain/New()
	..()
	var/options = list()
	options["Christianity"] = /obj/item/clothing/accessory/chaplain/christianity
	options["Judaism"] = /obj/item/clothing/accessory/chaplain/judaism
	options["Islam"] = /obj/item/clothing/accessory/chaplain/islam
	options["Buddhism"] = /obj/item/clothing/accessory/chaplain/buddhism
	options["Hinduism"] = /obj/item/clothing/accessory/chaplain/hinduism
	options["Sikhism"] = /obj/item/clothing/accessory/chaplain/sikhism
	options["Baha'i Faith"] = /obj/item/clothing/accessory/chaplain/bahaifaith
	options["Jainism"] = /obj/item/clothing/accessory/chaplain/jainism
	options["Taoism"] = /obj/item/clothing/accessory/chaplain/taoism
	gear_tweaks += new/datum/gear_tweak/path (options)


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
	options["they/them badge"] = /obj/item/clothing/accessory/pronouns/they
	options["he/him badge"] = /obj/item/clothing/accessory/pronouns/hehim
	options["she/her badge"] = /obj/item/clothing/accessory/pronouns/sheher
	options["he/they badge"] = /obj/item/clothing/accessory/pronouns/hethey
	options["she/they badge"] = /obj/item/clothing/accessory/pronouns/shethey
	options["he/she badge"] = /obj/item/clothing/accessory/pronouns/heshe
	options["ask me badge"] = /obj/item/clothing/accessory/pronouns/ask
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/accessory/pride_pins
	display_name = "pride pin selection"
	description = "A selection of pins used to signal membership or support of an identity or sexuality."
	path = /obj/item/clothing/accessory/pride_pin


/datum/gear/accessory/pride_pins/New()
	..()
	var/list/options = list()
	options["transgender pride pin"] = /obj/item/clothing/accessory/pride_pin/transgender
	options["lesbian pride pin"] = /obj/item/clothing/accessory/pride_pin/lesbian
	options["bisexual pride pin"] = /obj/item/clothing/accessory/pride_pin/bisexual
	options["gay pride pin"] = /obj/item/clothing/accessory/pride_pin/gay
	options["pansexual pride pin"] = /obj/item/clothing/accessory/pride_pin/pansexual
	options["nonbinary pride pin"] = /obj/item/clothing/accessory/pride_pin/nonbinary
	options["asexual pride pin"] = /obj/item/clothing/accessory/pride_pin/asexual
	options["intersex pride pin"] = /obj/item/clothing/accessory/pride_pin/intersex
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/accessory/neckerchief
	display_name = "neckerchief, colour select"
	description = "A piece of cloth tied around the neck. A favorite of Sailors and Partisans everywhere."
	path = /obj/item/clothing/accessory/neckerchief
	flags = GEAR_HAS_COLOR_SELECTION
