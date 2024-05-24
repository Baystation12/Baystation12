/datum/gear/uniform/pmc //Some of that is duplicate of standart Torch uniforms selection. But who cares.
	display_name = "PMC uniform selection"
	allowed_roles = list(/datum/job/detective, /datum/job/officer, /datum/job/hos)
	path = /obj/item/clothing/under

/datum/gear/uniform/pmc/New()
	..()
	var/pmc = list()
	pmc["SAARE utility uniform"]= /obj/item/clothing/under/saare
	pmc["SAARE combat uniform"]= /obj/item/clothing/under/rank/security/saarecombat
	pmc["PCRC utility uniform"]	= /obj/item/clothing/under/pcrc
	pmc["PCRC formal uniform"]	= /obj/item/clothing/under/pcrcsuit
	pmc["SCP utility uniform"]	= /obj/item/clothing/under/scp_uniform
	pmc["ZPCI utility uniform"]	= /obj/item/clothing/under/zpci_uniform
	gear_tweaks += new/datum/gear_tweak/path(pmc)

/datum/gear/tactical/colorable_camo
	display_name = "camo uniform - colorable"
	path = /obj/item/clothing/under/gray_camo
	slot = slot_w_uniform
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/sierra_scg
	display_name = "SCG uniform selection"
	allowed_branches = list(/datum/mil_branch/contractor)
	allowed_factions = list(FACTION_EXPEDITIONARY, FACTION_CORPORATE)
	path = /obj/item/clothing/under

/datum/gear/uniform/sierra_scg/New()
	..()
	var/scg = list()
	scg += /obj/item/clothing/under/scg_expeditonary
	scg += /obj/item/clothing/under/scg_expeditonary/officer
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(scg)

/datum/gear/uniform/avalon
	display_name = "avalon outfit selection"
	path = /obj/item/clothing/under/avalon

/datum/gear/uniform/avalon/New()
	..()
	var/avalon = list()
	avalon["avalon skirt"] = /obj/item/clothing/under/avalon
	avalon["avalon noble suit"] = /obj/item/clothing/under/avalon/noble
	gear_tweaks += new/datum/gear_tweak/path(avalon)

/datum/gear/uniform/sport
	display_name = "sportive outfit selection"
	path = /obj/item/clothing/under/sport

/datum/gear/uniform/sport/New()
	..()
	var/sport = list()
	sport["faln trousers"] = /obj/item/clothing/under/sport
	sport["olympic clothes"] = /obj/item/clothing/under/sport/olympic
	gear_tweaks += new/datum/gear_tweak/path(sport)

/datum/gear/uniform/maid
	display_name = "maid dress"
	path = /obj/item/clothing/under/maid

/datum/gear/uniform/mafia
	display_name = "mafia outfit selection"
	path = /obj/item/clothing/under/mafia

/datum/gear/uniform/mafia/New()
	..()
	var/mafia = list()
	mafia["mafia outfit"] = /obj/item/clothing/under/mafia
	mafia["mafia vest"] = /obj/item/clothing/under/mafia/vest
	mafia["white mafia outfit"] = /obj/item/clothing/under/mafia/white
	gear_tweaks += new/datum/gear_tweak/path(mafia)

/datum/gear/uniform/blackservice
	display_name = "service uniform selection"
	path = /obj/item/clothing/under/service

/datum/gear/uniform/blackservice/New()
	..()
	var/service = list()
	service["dark service uniform"] = /obj/item/clothing/under/service
	service["brown service uniform"] = /obj/item/clothing/under/service/brown
	service["fleet service uniform"] = /obj/item/clothing/under/service/milsim
	service["white service uniform"] = /obj/item/clothing/under/service/white
	service["white female service uniform"] = /obj/item/clothing/under/service/female
	gear_tweaks += new/datum/gear_tweak/path(service)

/datum/gear/uniform/cuttop
	display_name = "cuttop uniform selection (female)"
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/New()
	..()
	var/cuttop = list()
	cuttop["cuttop uniform"] = /obj/item/clothing/under/cuttop
	cuttop["red cuttop uniform"] = /obj/item/clothing/under/cuttop/red
	gear_tweaks += new/datum/gear_tweak/path(cuttop)

/datum/gear/uniform/checkered
	display_name = "checkered shirt selection"
	path = /obj/item/clothing/under/checkered

/datum/gear/uniform/checkered/New()
	..()
	var/checkered = list()
	checkered["pinstripe"] = /obj/item/clothing/under/checkered
	checkered["red checkered shirt"] = /obj/item/clothing/under/checkered/red
	gear_tweaks += new/datum/gear_tweak/path(checkered)

/datum/gear/uniform/gotsis
	display_name = "gotsis dress selection"
	path = /obj/item/clothing/under/dress

/datum/gear/uniform/gotsis/New()
	..()
	var/gdress = list()
	gdress["red gotsis dress"] = /obj/item/clothing/under/dress/gotsis_red
	gdress["orange gotsis dress"] = /obj/item/clothing/under/dress/gotsis_orange
	gear_tweaks += new/datum/gear_tweak/path(gdress)

/datum/gear/uniform/victdress
	display_name = "victorian dress selection"
	path = /obj/item/clothing/under/dress/victorian

/datum/gear/uniform/victdress/New()
	..()
	var/dress = list()
	dress["black victorian dress"] = /obj/item/clothing/under/dress/victorian
	dress["red victorian dresst"] = /obj/item/clothing/under/dress/victorian/red
	gear_tweaks += new/datum/gear_tweak/path(dress)

/datum/gear/uniform/victsuit
	display_name = "victorian suit selection"
	path = /obj/item/clothing/under/formal/victorian

/datum/gear/uniform/victsuit/New()
	..()
	var/victsuit = list()
	victsuit["victorian suit"] = /obj/item/clothing/under/formal/victorian
	victsuit["red and black victorian suit"] = /obj/item/clothing/under/formal/victorian/black_red
	victsuit["red victorian suit"] = /obj/item/clothing/under/formal/victorian/red
	victsuit["dark victorian suit"] = /obj/item/clothing/under/formal/victorian/twilight
	gear_tweaks += new/datum/gear_tweak/path(victsuit)

/datum/gear/uniform/formal
	display_name = "formal uniform selection"
	path = /obj/item/clothing/under/formal

/datum/gear/uniform/formal/New()
	..()
	var/formal = list()
	formal["white black"] = /obj/item/clothing/under/formal
	formal["formal vest"] = /obj/item/clothing/under/formal/vest
	formal["classic suit"] = /obj/item/clothing/under/formal/classic_suit
	formal["black and white with style"] = /obj/item/clothing/under/formal/chain_with_shirt
	formal["aristo uniform"] = /obj/item/clothing/under/formal/aristo
	formal["callum vest"] = /obj/item/clothing/under/formal/callum
	formal["charcoal vest"] = /obj/item/clothing/under/formal/hm_suit
	formal["red 'n black suit"] = /obj/item/clothing/under/formal/red_n_black
	formal["rubywhite uniform"] = /obj/item/clothing/under/formal/rubywhite
	gear_tweaks += new/datum/gear_tweak/path(formal)

/datum/gear/uniform/informal
	display_name = "informal uniform selection"
	path = /obj/item/clothing/under/informal

/datum/gear/uniform/informal/New()
	..()
	var/informal = list()
	informal["harper uniform"] = /obj/item/clothing/under/informal
	informal["vice uniform"] = /obj/item/clothing/under/informal/vice
	informal["lify suit"] = /obj/item/clothing/under/informal/lify
	informal["denim vest"] = /obj/item/clothing/under/informal/denimvest
	informal["rhumba outfit"] = /obj/item/clothing/under/informal/cuban_suit
	gear_tweaks += new/datum/gear_tweak/path(informal)

//Aurora stuff
/datum/gear/uniform/black_skirtsuit
	display_name = "black skirtsuit"
	path = /obj/item/clothing/under/suit_jacket/nt_skirtsuit

/datum/gear/uniform/red_swept_dress
	display_name = "red swept dress"
	path = /obj/item/clothing/under/dress/red_swept_dress

/datum/gear/uniform/colorable_dress
	display_name = "colorable dress selection"
	path = /obj/item/clothing/under/dress/colorable
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/colorable_dress/New()
	..()
	var/dresses = list()
	dresses["strapless midi dress"] = /obj/item/clothing/under/dress/colorable
	dresses["sleeveless A-line dress"] = /obj/item/clothing/under/dress/colorable/sleeveless
	dresses["longsleeve A-line dress"] = /obj/item/clothing/under/dress/colorable/longsleeve
	dresses["evening gown"] = /obj/item/clothing/under/dress/colorable/evening_gown
	dresses["tea-length dress"] = /obj/item/clothing/under/dress/colorable/tea_dress
	dresses["open-shoulder dress"] = /obj/item/clothing/under/dress/colorable/open_shoulder
	dresses["asymmetric dress"] = /obj/item/clothing/under/dress/colorable/asymmetric
	gear_tweaks += new/datum/gear_tweak/path(dresses)

/datum/gear/uniform/avalon_dress
	display_name = "avalon noble dress selection"
	path = /obj/item/clothing/under/dominia/dress

/datum/gear/uniform/avalon_dress/New()
	..()
	var/dresses = list()
	dresses["Avalon noble greatdress"] = /obj/item/clothing/under/dominia/dress
	dresses["Avalon noble dress"] = /obj/item/clothing/under/dominia/dress/noble
	dresses["Portenas noble dress"] = /obj/item/clothing/under/dominia/dress/noble/strelitz
	dresses["West Vujaran noble dress"] = /obj/item/clothing/under/dominia/dress/noble/volvalaad
	dresses["East Vujaran noble dress"] = /obj/item/clothing/under/dominia/dress/noble/kazhkz
	dresses["Kvoblau noble dress"] = /obj/item/clothing/under/dominia/dress/noble/caladius
	dresses["Nova-Yorvik noble dress"] = /obj/item/clothing/under/dominia/dress/noble/zhao
	dresses["black Avalon noble dress"] = /obj/item/clothing/under/dominia/dress/noble/black
	dresses["black Portenas noble dress"] = /obj/item/clothing/under/dominia/dress/noble/black/strelitz
	dresses["black West Vujaran noble dress"] = /obj/item/clothing/under/dominia/dress/noble/black/volvalaad
	dresses["black East Vujaran noble dress"] = /obj/item/clothing/under/dominia/dress/noble/black/kazhkz
	dresses["black Kvoblau noble dress"] = /obj/item/clothing/under/dominia/dress/noble/black/caladius
	dresses["black Nova-Yorvik noble dress"] = /obj/item/clothing/under/dominia/dress/noble/black/zhao
	gear_tweaks += new/datum/gear_tweak/path(dresses)
