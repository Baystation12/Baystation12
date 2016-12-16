// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/cheongsam
	display_name = "cheongsam, white"
	path = /obj/item/clothing/under/cheongsam

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/jumpskirt
	display_name = "jumpskirt, black"
	path = /obj/item/clothing/under/blackjumpskirt

/datum/gear/uniform/shortjumpskirt
    display_name = "jumpskirt color selection"
    path = /obj/item/clothing/under/shortjumpskirt
    flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/jumpsuit
	display_name = "generic jumpsuits"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/under/color)

/datum/gear/uniform/roboticist_skirt
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Roboticist")

/datum/gear/uniform/suit
	display_name = "suit selection"
	path = /obj/item/clothing/under/lawyer/bluesuit

/datum/gear/uniform/suit/New()
	..()
	var/suits = list()
	suits["amish suit"] = /obj/item/clothing/under/sl_suit
	suits["black suit"] = /obj/item/clothing/under/suit_jacket
	suits["blue suit"] = /obj/item/clothing/under/lawyer/blue
	suits["burgundy suit"] = /obj/item/clothing/under/suit_jacket/burgundy
	suits["charcoal suit"] = /obj/item/clothing/under/suit_jacket/charcoal
	suits["checkered suit"] = /obj/item/clothing/under/suit_jacket/checkered
	suits["executive suit"] = /obj/item/clothing/under/suit_jacket/really_black
	suits["female executive suit"] = /obj/item/clothing/under/suit_jacket/female
	suits["gentleman suit"] = /obj/item/clothing/under/gentlesuit
	suits["navy suit"] = /obj/item/clothing/under/suit_jacket/navy
	suits["old man suit"] = /obj/item/clothing/under/lawyer/oldman
	suits["purple suit"] = /obj/item/clothing/under/lawyer/purpsuit
	suits["red suit"] = /obj/item/clothing/under/suit_jacket/red
	suits["red lawyer suit"] = /obj/item/clothing/under/lawyer/red
	suits["shiny black suit"] = /obj/item/clothing/under/lawyer/black
	suits["tan suit"] = /obj/item/clothing/under/suit_jacket/tan
	suits["white suit"] = /obj/item/clothing/under/scratch
	suits["white-blue suit"] = /obj/item/clothing/under/lawyer/bluesuit
	suits["formal outfit"] = /obj/item/clothing/under/rank/internalaffairs/plain
	gear_tweaks += new/datum/gear_tweak/path(suits)

/datum/gear/uniform/scrubs
	display_name = "medical scrubs"
	path = /obj/item/clothing/under/rank/medical/black
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/uniform/scrubs/New()
	..()
	var/scrubcolor = list()
	scrubcolor["black scrubs"] = /obj/item/clothing/under/rank/medical/black
	scrubcolor["blue scrubs"] = /obj/item/clothing/under/rank/medical/blue
	scrubcolor["green scrubs"] = /obj/item/clothing/under/rank/medical/green
	scrubcolor["navy blue scrubs"] = /obj/item/clothing/under/rank/medical/navyblue
	scrubcolor["purple scrubs"] = /obj/item/clothing/under/rank/medical/purple
	gear_tweaks += new/datum/gear_tweak/path(scrubcolor)

/datum/gear/uniform/dress
	display_name = "dress selection"
	path = /obj/item/clothing/under/dress

/datum/gear/uniform/dress/New()
	..()
	var/dresses = list()
	dresses["flame dress"] = /obj/item/clothing/under/dress/dress_fire
	dresses["green dress"] = /obj/item/clothing/under/dress/dress_green
	dresses["orange dress"] = /obj/item/clothing/under/dress/dress_orange
	dresses["pink dress"] = /obj/item/clothing/under/dress/dress_pink
	dresses["purple dress"] = /obj/item/clothing/under/dress/dress_purple
	dresses["sundress"] = /obj/item/clothing/under/sundress
	dresses["white sundress"] = /obj/item/clothing/under/sundress_white
	gear_tweaks += new/datum/gear_tweak/path(dresses)

/datum/gear/uniform/uniform_captain
	display_name = "uniform, captain's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Captain")

/datum/gear/uniform/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/navysecsuit
	display_name = "uniform, navyblue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/skirt
	display_name = "skirt selection"
	path = /obj/item/clothing/under/skirt

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(skirts))

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorts))

/datum/gear/uniform/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool

/datum/gear/uniform/turtleneck
	display_name = "sweater"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater
	flags = GEAR_HAS_COLOR_SELECTION

//EROS START

/datum/gear/uniform/eros/harness
	display_name = "gear harness"
	path = /obj/item/clothing/under/harness

/datum/gear/uniform/eros/loose_dress
	display_name = "Loose Dress"
	path = /obj/item/clothing/under/loose_dress

/datum/gear/uniform/cheongsam
	display_name = "cheongsam, red"
	path = /obj/item/clothing/under/cheongsam/red

/datum/gear/uniform/cheongsam
	display_name = "cheongsam, blue"
	path = /obj/item/clothing/under/cheongsam/blue

/datum/gear/uniform/cheongsam
	display_name = "cheongsam, black"
	path = /obj/item/clothing/under/cheongsam/black

/datum/gear/uniform/croptop
	display_name = "croptop, NT"
	path = /obj/item/clothing/under/croptop

/datum/gear/uniform/croptop/grey
	display_name = "croptop, grey"
	path = /obj/item/clothing/under/croptop/grey

/datum/gear/uniform/croptop/red
	display_name = "croptop, red"
	path = /obj/item/clothing/under/croptop/red

/datum/gear/uniform/cuttop
	display_name = "cut top, grey"
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/red
	display_name = "cut top, red"
	path = /obj/item/clothing/under/cuttop/red

/datum/gear/uniform/colonist1
	display_name= "colonist clothes"
	path = /obj/item/clothing/under/colonist

/datum/gear/uniform/colonist2
	display_name= "colonist clothes, alt"
	path = /obj/item/clothing/under/colonist/colonist2

/datum/gear/uniform/colonist3
	display_name= "colonist clothes, alt 2"
	path = /obj/item/clothing/under/colonist/colonist3

/datum/gear/uniform/tenpenny
	display_name= "red fancy suit"
	path = /obj/item/clothing/under/tenpenny

/datum/gear/uniform/springm
	display_name= "springwear clothes"
	path = /obj/item/clothing/under/springm

/datum/gear/uniform/relaxedwearm
	display_name= "relaxedwear"
	path = /obj/item/clothing/under/relaxedwearm

/datum/gear/uniform/springf
	display_name= "springwear dress"
	path = /obj/item/clothing/under/springf

/datum/gear/uniform/wasteland
	display_name= "wasteland fatigues"
	path = /obj/item/clothing/under/wasteland

/datum/gear/uniform/cowboy_dark
	display_name= "black cowboy outfit"
	path = /obj/item/clothing/under/cowboy_dark

/datum/gear/uniform/cowboy
	display_name= "brown cowboy outfit"
	path = /obj/item/clothing/under/cowboy

/datum/gear/uniform/seifuku
	display_name= "delinquent schoolgirl uniform"
	path = /obj/item/clothing/under/seifuku

/datum/gear/uniform/polkaskirt
	display_name= "polkadot skirt"
	path = /obj/item/clothing/under/polkaskirt

/datum/gear/uniform/victoria
	display_name= "victorian suit"
	path = /obj/item/clothing/under/victoria

/datum/gear/uniform/girlwinter
	display_name= "winter girls clothes"
	path = /obj/item/clothing/under/girlwinter

/datum/gear/uniform/shortplaindress
	display_name = "plain dress"
	path = /obj/item/clothing/under/dress/white3
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/longdress
	display_name = "long dress"
	path = /obj/item/clothing/under/dress/white2
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/longwidedress
	display_name = "long wide dress"
	path = /obj/item/clothing/under/dress/white4
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/maid
	path = /obj/item/clothing/under/dress/maid
	display_name = "maid uniform"

/datum/gear/uniform/janimaid
	path = /obj/item/clothing/under/dress/janimaid
	display_name = "maid uniform, alt"

/datum/gear/uniform/whitewedding
	display_name= "white wedding dress"
	path = /obj/item/clothing/under/dress/white

/datum/gear/uniform/hoodiejeans
	display_name= "casual hoodie and jeans"
	path = /obj/item/clothing/under/hoodiejeans

/datum/gear/uniform/hoodieskirt
	display_name= "casual hoodie and skirt"
	path = /obj/item/clothing/under/hoodieskirt

/datum/gear/uniform/job_skirt/ce
	display_name = "skirt, ce"
	path = /obj/item/clothing/under/rank/engineer/chief_engineer/skirt
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/job_skirt/atmos
	display_name = "skirt, atmos"
	path = /obj/item/clothing/under/rank/engineer/atmospheric_technician/skirt
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/uniform/job_skirt/eng
	display_name = "skirt, engineer"
	path = /obj/item/clothing/under/rank/engineer/skirt
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/uniform/job_skirt/roboticist
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/uniform/job_skirt/cmo
	display_name = "skirt, cmo"
	path = /obj/item/clothing/under/rank/medical/chief_medical_officer/skirt
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/job_skirt/chem
	display_name = "skirt, chemist"
	path = /obj/item/clothing/under/rank/medical/chemist/skirt
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/uniform/job_skirt/viro
	display_name = "skirt, virologist"
	path = /obj/item/clothing/under/rank/medical/virologist/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/uniform/job_skirt/med
	display_name = "skirt, medical"
	path = /obj/item/clothing/under/rank/medical/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")

/datum/gear/uniform/job_skirt/sci
	display_name = "skirt, scientist"
	path = /obj/item/clothing/under/rank/scientist/skirt
	allowed_roles = list("Research Director","Scientist", "Xenobiologist")

/datum/gear/uniform/job_skirt/cargo
	display_name = "skirt, cargo"
	path = /obj/item/clothing/under/rank/cargotech/skirt
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/job_skirt/qm
	display_name = "skirt, QM"
	path = /obj/item/clothing/under/rank/cargo/skirt
	allowed_roles = list("Quartermaster")

	allowed_roles = list("Head of Security", "Warden")

/datum/gear/uniform/job_skirt/security
	display_name = "skirt, security"
	path = /obj/item/clothing/under/rank/security/skirt
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_skirt/security/warden
	display_name = "skirt, warden"
	path = /obj/item/clothing/under/rank/security/warden/skirt

/datum/gear/uniform/job_skirt/security/head_of_security
	display_name = "skirt, hos"
	path = /obj/item/clothing/under/rank/security/head_of_security/skirt
	allowed_roles = list("Head of Security")

/datum/gear/uniform/jeans_qm
	display_name = "jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jean
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_cargo
	display_name = "jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jean
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/keyholesweater
	display_name= "keyhole sweater"
	path = /obj/item/clothing/under/keyholesweater

/datum/gear/uniform/pinstripe
	display_name= "pinstriped suit"
	path =/obj/item/clothing/under/pinstripe

/datum/gear/uniform/reddress
	display_name = "red dress with belt"
	path = /obj/item/clothing/under/dress/darkred

/datum/gear/uniform/worn_hazard
	display_name = "worn hazard suit"
	path = /obj/item/clothing/under/worn_hazard
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/uniform/skatercolor
	display_name = "skater skirt, colorable"
	path = /obj/item/clothing/under/skateskirt
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/workman
	display_name = "workman outfit"
	path = /obj/item/clothing/under/serviceoveralls

//EROS FINISH
