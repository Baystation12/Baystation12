var/global/list/gear_datums = list()

/hook/startup/proc/populate_gear_list()
	var/list/sort_categories = list(
		"[slot_head]"		= list(),
		"ears"				= list(),
		"[slot_glasses]" 	= list(),
		"[slot_wear_mask]"	= list(),
		"[slot_w_uniform]"	= list(),
		"[slot_tie]"		= list(),
		"[slot_wear_suit]"	= list(),
		"[slot_gloves]"		= list(),
		"[slot_shoes]"		= list(),
		"utility"			= list(),
		"misc"				= list(),
		"unknown"			= list(),
	)

	//create a list of gear datums to sort
	for(var/type in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = type
		if(!initial(G.display_name))
			error("Loadout - Missing display name: [G]")
			continue
		if(!initial(G.cost))
			error("Loadout - Missing cost: [G]")
			continue
		if(!initial(G.path))
			error("Loadout - Missing path definition: [G]")
			continue
		G = new G()

		var/category = (G.sort_category in sort_categories)? G.sort_category : "unknown"
		sort_categories[category][G.display_name] = G

	for (var/category in sort_categories)
		gear_datums.Add(sortAssoc(sort_categories[category]))

	return 1

/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/path               //Path to item.
	var/cost               //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/whitelisted        //Term to check the whitelist for..
	var/sort_category

/datum/gear/New()
	..()
	if (!sort_category)
		sort_category = "[slot]"

// This is sorted both by slot and alphabetically! Don't fuck it up!
// Headslot items

/datum/gear/gbandana
	display_name = "bandana, green"
	path = /obj/item/clothing/head/greenbandana
	cost = 1
	slot = slot_head

/datum/gear/obandana
	display_name = "bandana, orange"
	path = /obj/item/clothing/head/orangebandana
	cost = 1
	slot = slot_head

/datum/gear/bandana
	display_name = "bandana, pirate-red"
	path = /obj/item/clothing/head/bandana
	cost = 1
	slot = slot_head

/datum/gear/bsec_beret
	display_name = "beret, blue (security)"
	path = /obj/item/clothing/head/beret/sec/alt
	cost = 1
	slot = slot_head
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eng_beret
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/eng
	cost = 1
	slot = slot_head
//	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/purp_beret
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/jan
	cost = 1
	slot = slot_head

/datum/gear/red_beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret
	cost = 1
	slot = slot_head

/datum/gear/sec_beret
	display_name = "beret, red (security)"
	path = /obj/item/clothing/head/beret/sec
	cost = 1
	slot = slot_head
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/bcap
	display_name = "cap, blue"
	path = /obj/item/clothing/head/soft/blue
	cost = 1
	slot = slot_head

/datum/gear/mailman
	display_name = "cap, blue station"
	path = /obj/item/clothing/head/mailman
	cost = 1
	slot = slot_head

/datum/gear/flatcap
	display_name = "cap, brown-flat"
	path = /obj/item/clothing/head/flatcap
	cost = 1
	slot = slot_head

/datum/gear/corpcap
	display_name = "cap, corporate (Security)"
	path = /obj/item/clothing/head/soft/sec/corp
	cost = 1
	slot = slot_head
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/gcap
	display_name = "cap, green"
	path = /obj/item/clothing/head/soft/green
	cost = 1
	slot = slot_head

/datum/gear/grcap
	display_name = "cap, grey"
	path = /obj/item/clothing/head/soft/grey
	cost = 1
	slot = slot_head

/datum/gear/ocap
	display_name = "cap, orange"
	path = /obj/item/clothing/head/soft/orange
	cost = 1
	slot = slot_head

/datum/gear/purcap
	display_name = "cap, purple"
	path = /obj/item/clothing/head/soft/purple
	cost = 1
	slot = slot_head

/datum/gear/raincap
	display_name = "cap, rainbow"
	path = /obj/item/clothing/head/soft/rainbow
	cost = 1
	slot = slot_head

/datum/gear/rcap
	display_name = "cap, red"
	path = /obj/item/clothing/head/soft/red
	cost = 1
	slot = slot_head

/datum/gear/ycap
	display_name = "cap, yellow"
	path = /obj/item/clothing/head/soft/yellow
	cost = 1
	slot = slot_head

/datum/gear/wcap
	display_name = "cap, white"
	path = /obj/item/clothing/head/soft/mime
	cost = 1
	slot = slot_head

/datum/gear/hairflower
	display_name = "hair flower pin"
	path = /obj/item/clothing/head/hairflower
	cost = 1
	slot = slot_head

/datum/gear/dbhardhat
	display_name = "hardhat, blue"
	path = /obj/item/clothing/head/hardhat/dblue
	cost = 2
	slot = slot_head

/datum/gear/ohardhat
	display_name = "hardhat, orange"
	path = /obj/item/clothing/head/hardhat/orange
	cost = 2
	slot = slot_head

/datum/gear/rhardhat
	display_name = "hardhat, red"
	path = /obj/item/clothing/head/hardhat/red
	cost = 2
	slot = slot_head

/datum/gear/yhardhat
	display_name = "hardhat, yellow"
	path = /obj/item/clothing/head/hardhat
	cost = 2
	slot = slot_head

/datum/gear/boater
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat
	cost = 1
	slot = slot_head

/datum/gear/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowler
	cost = 1
	slot = slot_head

/datum/gear/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez
	cost = 1
	slot = slot_head

/datum/gear/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that
	cost = 1
	slot = slot_head

// Wig by Earthcrusher, blame him.
/datum/gear/philosopher_wig
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig
	cost = 1
	slot = slot_head

/datum/gear/ushanka
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka
	cost = 1
	slot = slot_head

// This was sprited and coded specifically for Zhan-Khazan characters. Before you
// decide that it's 'not even Taj themed' maybe you should read the wiki, gamer. ~ Z
/datum/gear/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	cost = 1
	slot = slot_head
	whitelisted = "Tajara"

// Eyes

/datum/gear/eyepatch
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	cost = 1
	slot = slot_glasses

/datum/gear/green_glasses
	display_name = "Glasses, green"
	path = /obj/item/clothing/glasses/gglasses
	cost = 1
	slot = slot_glasses

/datum/gear/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster
	cost = 1
	slot = slot_glasses

/datum/gear/prescription
	display_name = "Glasses, prescription"
	path = /obj/item/clothing/glasses/regular
	cost = 1
	slot = slot_glasses

/datum/gear/monocle
	display_name = "Monocle"
	path = /obj/item/clothing/glasses/monocle
	cost = 1
	slot = slot_glasses

/datum/gear/scanning_goggles
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners
	cost = 1
	slot = slot_glasses

/datum/gear/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science
	cost = 1
	slot = slot_glasses

/datum/gear/security
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	cost = 1
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/thugshades
	display_name = "Sunglasses, Fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	cost = 1
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective","Internal Affairs Agent","Quartermaster","Head of Personnel","Captain")

/datum/gear/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 2
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective","Internal Affairs Agent","Quartermaster","Head of Personnel","Captain")

// Mask

/datum/gear/sterilemask
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	slot = slot_wear_mask
	cost = 2

// Uniform slot

/datum/gear/blazer_blue
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	cost = 1

/datum/gear/cheongsam
	display_name = "cheongsam, white"
	path = /obj/item/clothing/under/cheongsam
	slot = slot_w_uniform
	cost = 1

/datum/gear/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt
	slot = slot_w_uniform
	cost = 1

/datum/gear/blackjumpskirt
	display_name = "jumpskirt, black"
	path = /obj/item/clothing/under/blackjumpskirt
	slot = slot_w_uniform
	cost = 1

/datum/gear/blackfjumpsuit
	display_name = "jumpsuit, female-black"
	path = /obj/item/clothing/under/color/blackf
	slot = slot_w_uniform
	cost = 1
/datum/gear/blackfjumpsuit
	display_name = "jumpsuit, rainbow"
	path = /obj/item/clothing/under/rainbow
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt_blue
	display_name = "plaid skirt, blue"
	path = /obj/item/clothing/under/dress/plaid_blue
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt_purple
	display_name = "plaid skirt, purple"
	path = /obj/item/clothing/under/dress/plaid_purple
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt_red
	display_name = "plaid skirt, red"
	path = /obj/item/clothing/under/dress/plaid_red
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt_black
	display_name = "skirt, black"
	path = /obj/item/clothing/under/blackskirt
	slot = slot_w_uniform
	cost = 1

/datum/gear/amishsuit
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit
	slot = slot_w_uniform
	cost = 1

/datum/gear/blacksuit
	display_name = "suit, black"
	path = /obj/item/clothing/under/suit_jacket
	slot = slot_w_uniform
	cost = 1

/datum/gear/shinyblacksuit
	display_name = "suit, shiny-black"
	path = /obj/item/clothing/under/lawyer/black
	slot = slot_w_uniform
	cost = 1

/datum/gear/bluesuit
	display_name = "suit, blue"
	path = /obj/item/clothing/under/lawyer/blue
	slot = slot_w_uniform
	cost = 1

/datum/gear/burgundysuit
	display_name = "suit, burgundy"
	path = /obj/item/clothing/under/suit_jacket/burgundy
	slot = slot_w_uniform
	cost = 1

/datum/gear/checkeredsuit
	display_name = "suit, checkered"
	path = /obj/item/clothing/under/suit_jacket/checkered
	slot = slot_w_uniform
	cost = 1

/datum/gear/charcoalsuit
	display_name = "suit, charcoal"
	path = /obj/item/clothing/under/suit_jacket/charcoal
	slot = slot_w_uniform
	cost = 1

/datum/gear/execsuit
	display_name = "suit, executive"
	path = /obj/item/clothing/under/suit_jacket/really_black
	slot = slot_w_uniform
	cost = 1

/datum/gear/femaleexecsuit
	display_name = "suit, female-executive"
	path = /obj/item/clothing/under/suit_jacket/female
	slot = slot_w_uniform
	cost = 1

/datum/gear/gentlesuit
	display_name = "suit, gentlemen"
	path = /obj/item/clothing/under/gentlesuit
	slot = slot_w_uniform
	cost = 1

/datum/gear/navysuit
	display_name = "suit, navy"
	path = /obj/item/clothing/under/suit_jacket/navy
	slot = slot_w_uniform
	cost = 1

/datum/gear/redsuit
	display_name = "suit, red"
	path = /obj/item/clothing/under/suit_jacket/red
	slot = slot_w_uniform
	cost = 1

/datum/gear/redlawyer
	display_name = "suit, lawyer-red"
	path = /obj/item/clothing/under/lawyer/red
	slot = slot_w_uniform
	cost = 1

/datum/gear/oldmansuit
	display_name = "suit, old-man"
	path = /obj/item/clothing/under/lawyer/oldman
	slot = slot_w_uniform
	cost = 1

/datum/gear/purplesuit
	display_name = "suit, purple"
	path = /obj/item/clothing/under/lawyer/purpsuit
	slot = slot_w_uniform
	cost = 1

/datum/gear/tansuit
	display_name = "suit, tan"
	path = /obj/item/clothing/under/suit_jacket/tan
	slot = slot_w_uniform
	cost = 1

/datum/gear/whitesuit
	display_name = "suit, white"
	path = /obj/item/clothing/under/scratch
	slot = slot_w_uniform
	cost = 1

/datum/gear/whitebluesuit
	display_name = "suit, white-blue"
	path = /obj/item/clothing/under/lawyer/bluesuit
	slot = slot_w_uniform
	cost = 1

/datum/gear/sundress
	display_name = "sundress"
	path = /obj/item/clothing/under/sundress
	slot = slot_w_uniform
	cost = 1

/datum/gear/sundress_white
	display_name = "sundress, white"
	path = /obj/item/clothing/under/sundress_white
	slot = slot_w_uniform
	cost = 1

/datum/gear/uniform_captain
	display_name = "uniform, captain's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Captain")

/datum/gear/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Head of Personnel")

/datum/gear/navysecsuit
	display_name = "uniform, navyblue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Security Officer","Head of Security","Warden")

// Attachments

/datum/gear/armband_cargo
	display_name = "armband, cargo"
	path = /obj/item/clothing/accessory/armband/cargo
	slot = slot_tie
	cost = 1

/datum/gear/armband_emt
	display_name = "armband, EMT"
	path = /obj/item/clothing/accessory/armband/medgreen
	slot = slot_tie
	cost = 1

/datum/gear/armband_engineering
	display_name = "armband, engineering"
	path = /obj/item/clothing/accessory/armband/engine
	slot = slot_tie
	cost = 1

/datum/gear/armband_hydroponics
	display_name = "armband, hydroponics"
	path = /obj/item/clothing/accessory/armband/hydro
	slot = slot_tie
	cost = 1

/datum/gear/armband_medical
	display_name = "armband, medical"
	path = /obj/item/clothing/accessory/armband/med
	slot = slot_tie
	cost = 1

/datum/gear/armband
	display_name = "armband, red"
	path = /obj/item/clothing/accessory/armband
	slot = slot_tie
	cost = 1

/datum/gear/armband_science
	display_name = "armband, science"
	path = /obj/item/clothing/accessory/armband/science
	slot = slot_tie
	cost = 1

/datum/gear/armpit
	display_name = "holster, armpit"
	path = /obj/item/clothing/accessory/holster/armpit
	slot = slot_tie
	cost = 1
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/hip
	display_name = "holster, hip"
	path = /obj/item/clothing/accessory/holster/hip
	slot = slot_tie
	cost = 1
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security", "Detective")

/datum/gear/waist
	display_name = "holster, waist"
	path = /obj/item/clothing/accessory/holster/waist
	slot = slot_tie
	cost = 1
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security", "Detective")

/datum/gear/tie_blue
	display_name = "tie, blue"
	path = /obj/item/clothing/accessory/blue
	slot = slot_tie
	cost = 1

/datum/gear/tie_red
	display_name = "tie, red"
	path = /obj/item/clothing/accessory/red
	slot = slot_tie
	cost = 1

/datum/gear/tie_horrible
	display_name = "tie, socially disgraceful"
	path = /obj/item/clothing/accessory/horrible
	slot = slot_tie
	cost = 1

/datum/gear/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	slot = slot_tie
	cost = 1
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	slot = slot_tie
	cost = 1
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	slot = slot_tie
	cost = 2

// Suit slot

/datum/gear/apron
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1
	slot = slot_wear_suit

/datum/gear/bomber
	display_name = "bomber jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber
	cost = 2
	slot = slot_wear_suit

/datum/gear/leather_jacket
	display_name = "leather jacket, black"
	path = /obj/item/clothing/suit/storage/leather_jacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/leather_jacket_nt
	display_name = "leather jacket, NanoTrasen, black"
	path = /obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	cost = 2
	slot = slot_wear_suit

/datum/gear/brown_jacket
	display_name = "leather jacket, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/brown_jacket_nt
	display_name = "leather jacket, NanoTrasen, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	cost = 2
	slot = slot_wear_suit

/datum/gear/hazard_vest
	display_name = "hazard vest"
	path = /obj/item/clothing/suit/storage/hazardvest
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie
	display_name = "hoodie, grey"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/black
	display_name = "hoodie, black"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/black
	cost = 2

/datum/gear/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	slot = slot_wear_suit
	whitelisted = "Unathi"

/datum/gear/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	cost = 2
	slot = slot_wear_suit

/datum/gear/bluelabcoat
	display_name = "labcoat, blue"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue
	cost = 2
	slot = slot_wear_suit

/datum/gear/greenlabcoat
	display_name = "labcoat, green"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/green
	cost = 2
	slot = slot_wear_suit

/datum/gear/orangelabcoat
	display_name = "labcoat, orange"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/orange
	cost = 2
	slot = slot_wear_suit

/datum/gear/purplelabcoat
	display_name = "labcoat, purple"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/purple
	cost = 2
	slot = slot_wear_suit

/datum/gear/redlabcoat
	display_name = "labcoat, red"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/red
	cost = 2
	slot = slot_wear_suit

/datum/gear/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	slot = slot_wear_suit

/datum/gear/bponcho
	display_name = "poncho, blue"
	path = /obj/item/clothing/suit/poncho/blue
	cost = 1
	slot = slot_wear_suit

/datum/gear/gponcho
	display_name = "poncho, green"
	path = /obj/item/clothing/suit/poncho/green
	cost = 1
	slot = slot_wear_suit

/datum/gear/pponcho
	display_name = "poncho, purple"
	path = /obj/item/clothing/suit/poncho/purple
	cost = 1
	slot = slot_wear_suit

/datum/gear/rponcho
	display_name = "poncho, red"
	path = /obj/item/clothing/suit/poncho/red
	cost = 1
	slot = slot_wear_suit

/datum/gear/poncho
	display_name = "poncho, tan"
	path = /obj/item/clothing/suit/poncho
	cost = 1
	slot = slot_wear_suit

/datum/gear/unathi_robe
	display_name = "roughspun robe (Unathi)"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1
	slot = slot_wear_suit
//	whitelisted = "Unathi" // You don't have a monopoly on a robe!

/datum/gear/blue_lawyer_jacket
	display_name = "suit jacket, blue"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/purple_lawyer_jacket
	display_name = "suit jacket, purple"
	path = /obj/item/clothing/suit/storage/lawyer/purpjacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/suit/suspenders
	cost = 1
	slot = slot_wear_suit

/datum/gear/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/suit/wcoat
	cost = 1
	slot = slot_wear_suit

/datum/gear/zhan_furs
	display_name = "Zhan-Khazan furs (Tajaran)"
	path = /obj/item/clothing/suit/tajaran/furs
	cost = 1
	slot = slot_wear_suit
	whitelisted = "Tajara" // You do have a monopoly on a fur suit tho

// Gloves

/datum/gear/black_gloves
	display_name = "gloves, black"
	path = /obj/item/clothing/gloves/black
	cost = 2
	slot = slot_gloves

/datum/gear/blue_gloves
	display_name = "gloves, blue"
	path = /obj/item/clothing/gloves/blue
	cost = 2
	slot = slot_gloves

/datum/gear/brown_gloves
	display_name = "gloves, brown"
	path = /obj/item/clothing/gloves/brown
	cost = 2
	slot = slot_gloves

/datum/gear/light_brown_gloves
	display_name = "gloves, light-brown"
	path = /obj/item/clothing/gloves/light_brown
	cost = 2
	slot = slot_gloves

/datum/gear/green_gloves
	display_name = "gloves, green"
	path = /obj/item/clothing/gloves/green
	cost = 2
	slot = slot_gloves

/datum/gear/grey_gloves
	display_name = "gloves, grey"
	path = /obj/item/clothing/gloves/grey
	cost = 2
	slot = slot_gloves

/datum/gear/latex_gloves
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/latex
	cost = 2
	slot = slot_gloves


/datum/gear/orange_gloves
	display_name = "gloves, orange"
	path = /obj/item/clothing/gloves/orange
	cost = 2
	slot = slot_gloves

/datum/gear/purple_gloves
	display_name = "gloves, purple"
	path = /obj/item/clothing/gloves/purple
	cost = 2
	slot = slot_gloves

/datum/gear/rainbow_gloves
	display_name = "gloves, rainbow"
	path = /obj/item/clothing/gloves/rainbow
	cost = 2
	slot = slot_gloves

/datum/gear/red_gloves
	display_name = "gloves, red"
	path = /obj/item/clothing/gloves/red
	cost = 2
	slot = slot_gloves

/datum/gear/white_gloves
	display_name = "gloves, white"
	path = /obj/item/clothing/gloves/white
	cost = 2
	slot = slot_gloves

// Shoelocker

/datum/gear/jackboots
	display_name = "jackboots"
	path = /obj/item/clothing/shoes/jackboots
	cost = 1
	slot = slot_shoes

/datum/gear/toeless_jackboots
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/jackboots/unathi
	cost = 1
	slot = slot_shoes

/datum/gear/workboots
	display_name = "workboots"
	path = /obj/item/clothing/shoes/workboots
	cost = 1
	slot = slot_shoes

/datum/gear/sandal
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	cost = 1
	slot = slot_shoes

/datum/gear/black_shoes
	display_name = "shoes, black"
	path = /obj/item/clothing/shoes/black
	cost = 1
	slot = slot_shoes

/datum/gear/blue_shoes
	display_name = "shoes, blue"
	path = /obj/item/clothing/shoes/blue
	cost = 1
	slot = slot_shoes

/datum/gear/brown_shoes
	display_name = "shoes, brown"
	path = /obj/item/clothing/shoes/brown
	cost = 1
	slot = slot_shoes

/datum/gear/laceyshoes
	display_name = "shoes, classy"
	path = /obj/item/clothing/shoes/laceup
	cost = 1
	slot = slot_shoes

/datum/gear/dress_shoes
	display_name = "shoes, dress"
	path = /obj/item/clothing/shoes/laceup
	cost = 1
	slot = slot_shoes

/datum/gear/green_shoes
	display_name = "shoes, green"
	path = /obj/item/clothing/shoes/green
	cost = 1
	slot = slot_shoes

/datum/gear/leather
	display_name = "shoes, leather"
	path = /obj/item/clothing/shoes/leather
	cost = 1
	slot = slot_shoes

/datum/gear/orange_shoes
	display_name = "shoes, orange"
	path = /obj/item/clothing/shoes/orange
	cost = 1
	slot = slot_shoes

/datum/gear/purple_shoes
	display_name = "shoes, purple"
	path = /obj/item/clothing/shoes/purple
	cost = 1
	slot = slot_shoes

/datum/gear/rainbow_shoes
	display_name = "shoes, rainbow"
	path = /obj/item/clothing/shoes/rainbow
	cost = 1
	slot = slot_shoes

/datum/gear/red_shoes
	display_name = "shoes, red"
	path = /obj/item/clothing/shoes/red
	cost = 1
	slot = slot_shoes

/datum/gear/white_shoes
	display_name = "shoes, white"
	path = /obj/item/clothing/shoes/white
	cost = 1
	slot = slot_shoes

/datum/gear/yellow_shoes
	display_name = "shoes, yellow"
	path = /obj/item/clothing/shoes/yellow
	cost = 1
	slot = slot_shoes

// "Useful" items - I'm guessing things that might be used at work?

/datum/gear/briefcase
	display_name = "briefcase"
	path = /obj/item/weapon/storage/briefcase
	sort_category = "utility"
	cost = 2

/datum/gear/clipboard
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard
	sort_category = "utility"
	cost = 1

/datum/gear/folder_blue
	display_name = "folder, blue"
	path = /obj/item/weapon/folder/blue
	sort_category = "utility"
	cost = 1

/datum/gear/folder_grey
	display_name = "folder, grey"
	path = /obj/item/weapon/folder
	sort_category = "utility"
	cost = 1

/datum/gear/folder_red
	display_name = "folder, red"
	path = /obj/item/weapon/folder/red
	sort_category = "utility"
	cost = 1

/datum/gear/folder_white
	display_name = "folder, white"
	path = /obj/item/weapon/folder/white
	sort_category = "utility"
	cost = 1

/datum/gear/folder_yellow
	display_name = "folder, yellow"
	path = /obj/item/weapon/folder/yellow
	sort_category = "utility"
	cost = 1

/datum/gear/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard
	sort_category = "utility"
	cost = 2

// The rest of the trash.

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/weapon/material/ashtray/plastic
	sort_category = "misc"
	cost = 1

/datum/gear/cane
	display_name = "cane"
	path = /obj/item/weapon/cane
	sort_category = "misc"
	cost = 1

/datum/gear/dice
	display_name = "d20"
	path = /obj/item/weapon/dice/d20
	sort_category = "misc"
	cost = 1

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/weapon/deck
	sort_category = "misc"
	cost = 1

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask
	sort_category = "misc"
	cost = 1

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask
	sort_category = "misc"
	cost = 1
/datum/gear/blipstick
	display_name = "lipstick, black"
	path = /obj/item/weapon/lipstick/black
	sort_category = "misc"
	cost = 1

/datum/gear/jlipstick
	display_name = "lipstick, jade"
	path = /obj/item/weapon/lipstick/jade
	sort_category = "misc"
	cost = 1

/datum/gear/plipstick
	display_name = "lipstick, purple"
	path = /obj/item/weapon/lipstick/purple
	sort_category = "misc"
	cost = 1

/datum/gear/rlipstick
	display_name = "lipstick, red"
	path = /obj/item/weapon/lipstick
	sort_category = "misc"
	cost = 1

/datum/gear/smokingpipe
	display_name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe
	sort_category = "misc"
	cost = 1

/datum/gear/cornpipe
	display_name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe
	sort_category = "misc"
	cost = 1

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/weapon/storage/box/matches
	sort_category = "misc"
	cost = 1

/datum/gear/comb
	display_name = "purple comb"
	path = /obj/item/weapon/haircomb
	sort_category = "misc"
	cost = 1

/datum/gear/zippo
	display_name = "zippo"
	path = /obj/item/weapon/flame/lighter/zippo
	sort_category = "misc"
	cost = 1

/*/datum/gear/combitool
	display_name = "combi-tool"
	path = /obj/item/weapon/combitool
	cost = 3*/

// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.
/datum/gear/earmuffs
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	cost = 1
	sort_category = "ears"

/datum/gear/skrell_chain
	display_name = "skrell headtail-wear, female, chain"
	path = /obj/item/clothing/ears/skrell/chain
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_plate
	display_name = "skrell headtail-wear, male, bands"
	path = /obj/item/clothing/ears/skrell/band
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_cloth_male
	display_name = "skrell headtail-wear, male, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_male
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_cloth_female
	display_name = "skrell headtail-wear, female, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_female
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"
