/datum/gear/accessory
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/vest
	display_name = "black vest"
	path = /obj/item/clothing/accessory/toggleable/vest


/datum/gear/accessory/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders


/datum/gear/accessory/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat


/datum/gear/accessory/zhongshan
	display_name = "zhongshan jacket"
	path = /obj/item/clothing/accessory/toggleable/zhongshan
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/dashiki
	display_name = "dashiki selection"
	path = /obj/item/clothing/accessory/dashiki


/datum/gear/accessory/dashiki/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/dashiki)

/datum/gear/accessory/thawb
	display_name = "thawb"
	path = /obj/item/clothing/accessory/thawb


/datum/gear/accessory/sherwani
	display_name = "sherwani"
	path = /obj/item/clothing/accessory/sherwani
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/qipao
	display_name = "qipao blouse"
	path = /obj/item/clothing/accessory/qipao
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/sweater
	display_name = "turtleneck sweater"
	path = /obj/item/clothing/accessory/sweater
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tangzhuang
	display_name = "tangzhuang jacket"
	path = /obj/item/clothing/accessory/tangzhuang
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/necklace
	display_name = "necklace"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/bowtie
	display_name = "bowtie, horrible"
	path = /obj/item/clothing/accessory/bowtie/ugly

/datum/gear/accessory/bowtie/color
	display_name = "bowtie, colored"
	path = /obj/item/clothing/accessory/bowtie/color
	flags = GEAR_HAS_COLOR_SELECTION

//have to break up armbands to restrict access
/datum/gear/accessory/armband_security
	display_name = "security armband"
	path = /obj/item/clothing/accessory/armband


/datum/gear/accessory/armband_mp
	display_name = "military police armband"
	path = /obj/item/clothing/accessory/armband/mp


/datum/gear/accessory/armband_cargo
	display_name = "cargo armband"
	path = /obj/item/clothing/accessory/armband/cargo


/datum/gear/accessory/armband_medical
	display_name = "medical armband"
	path = /obj/item/clothing/accessory/armband/med


/datum/gear/accessory/armband_emt
	display_name = "EMT armband"
	path = /obj/item/clothing/accessory/armband/medgreen


/datum/gear/accessory/armband_corpsman
	display_name = "medical corps armband"
	path = /obj/item/clothing/accessory/armband/medblue


/datum/gear/accessory/armband_engineering
	display_name = "engineering armband"
	path = /obj/item/clothing/accessory/armband/engine


/datum/gear/accessory/armband_hydro
	display_name = "hydroponics armband"
	path = /obj/item/clothing/accessory/armband/hydro


/datum/gear/accessory/armband_nt
	display_name = "NanoTrasen armband"
	path = /obj/item/clothing/accessory/armband/whitered

/datum/gear/accessory/armband_solgov
	display_name = "peacekeeper armband"
	path = /obj/item/clothing/accessory/armband/bluegold


/datum/gear/accessory/wallet
	display_name = "wallet"
	path = /obj/item/weapon/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/weapon/storage/wallet/poly
	cost = 2

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster
	cost = 3

/datum/gear/accessory/holster/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/holster)

/datum/gear/accessory/ubac
	display_name = "ubac selection"
	path = /obj/item/clothing/accessory/ubac


/datum/gear/accessory/ubac/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/ubac)

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

/datum/gear/accessory/stethoscope
	display_name = "stethoscope"
	path = /obj/item/clothing/accessory/stethoscope
	cost = 2

/datum/gear/accessory/hawaii
	display_name = "hawaii shirt"
	path = /obj/item/clothing/accessory/toggleable/hawaii
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/accessory/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["blue hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii
	shirts["red hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/red
	shirts["random colored hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/accessory/scarf
	display_name = "scarf"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/accessory/solawardmajor
	display_name = "UNSC major award selection"
	description = "A medal or ribbon awarded to UNSC personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal/iron/star
	cost = 8


/datum/gear/accessory/solawardmajor/New()
	..()
	var/solmajors = list()
	solmajors["iron star"] = /obj/item/clothing/accessory/medal/iron/star
	solmajors["bronze heart"] = /obj/item/clothing/accessory/medal/bronze/heart
	solmajors["silver sword"] = /obj/item/clothing/accessory/medal/silver/sword
	solmajors["medical heart"] = /obj/item/clothing/accessory/medal/heart
	solmajors["valor medal"] = /obj/item/clothing/accessory/medal/silver/sol
	solmajors["sapienterian medal"] = /obj/item/clothing/accessory/medal/gold/sol
	solmajors["peacekeeper ribbon"] = /obj/item/clothing/accessory/ribbon/peace
	solmajors["marksman ribbon"] = /obj/item/clothing/accessory/ribbon/marksman
	gear_tweaks += new/datum/gear_tweak/path(solmajors)

/datum/gear/accessory/solawardminor
	display_name = "UNSC minor award selection"
	description = "A medal or ribbon awarded to UNSC personnel for minor accomplishments."
	path = /obj/item/clothing/accessory/medal/iron/sol
	cost = 5


/datum/gear/accessory/solawardminor/New()
	..()
	var/solminors = list()
	solminors["expeditionary medal"] = /obj/item/clothing/accessory/medal/iron/sol
	solminors["operations medal"] = /obj/item/clothing/accessory/medal/bronze/sol
	solminors["frontier ribbon"] = /obj/item/clothing/accessory/ribbon/frontier
	solminors["instructor ribbon"] = /obj/item/clothing/accessory/ribbon/instructor
	gear_tweaks += new/datum/gear_tweak/path(solminors)

/datum/gear/accessory/tags
	display_name = "dog tags"
	path = /obj/item/clothing/accessory/badge/tags


/datum/gear/accessory/kneepads
	display_name = "kneepads"
	path = /obj/item/clothing/accessory/kneepads

/datum/gear/accessory/flannel
	display_name = "flannel (colorable)"
	path = /obj/item/clothing/accessory/toggleable/flannel
	slot = slot_tie
	flags = GEAR_HAS_COLOR_SELECTION
	sort_category = "Accessories"
