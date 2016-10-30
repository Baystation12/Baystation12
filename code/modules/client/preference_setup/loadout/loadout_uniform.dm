// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

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

/datum/gear/uniform/suit  //amish
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/black
	display_name = "suit, black"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suit/shinyblack
	display_name = "suit, shiny-black"
	path = /obj/item/clothing/under/lawyer/black

/datum/gear/uniform/suit/blue
	display_name = "suit, blue"
	path = /obj/item/clothing/under/lawyer/blue

/datum/gear/uniform/suit/burgundy
	display_name = "suit, burgundy"
	path = /obj/item/clothing/under/suit_jacket/burgundy

/datum/gear/uniform/suit/checkered
	display_name = "suit, checkered"
	path = /obj/item/clothing/under/suit_jacket/checkered

/datum/gear/uniform/suit/charcoal
	display_name = "suit, charcoal"
	path = /obj/item/clothing/under/suit_jacket/charcoal

/datum/gear/uniform/suit/exec
	display_name = "suit, executive"
	path = /obj/item/clothing/under/suit_jacket/really_black

/datum/gear/uniform/suit/femaleexec
	display_name = "suit, female-executive"
	path = /obj/item/clothing/under/suit_jacket/female

/datum/gear/uniform/suit/gentle
	display_name = "suit, gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/uniform/suit/navy
	display_name = "suit, navy"
	path = /obj/item/clothing/under/suit_jacket/navy

/datum/gear/uniform/suit/red
	display_name = "suit, red"
	path = /obj/item/clothing/under/suit_jacket/red

/datum/gear/uniform/suit/redlawyer
	display_name = "suit, lawyer-red"
	path = /obj/item/clothing/under/lawyer/red

/datum/gear/uniform/suit/oldman
	display_name = "suit, old-man"
	path = /obj/item/clothing/under/lawyer/oldman

/datum/gear/uniform/suit/purple
	display_name = "suit, purple"
	path = /obj/item/clothing/under/lawyer/purpsuit

/datum/gear/uniform/suit/tan
	display_name = "suit, tan"
	path = /obj/item/clothing/under/suit_jacket/tan

/datum/gear/uniform/suit/white
	display_name = "suit, white"
	path = /obj/item/clothing/under/scratch

/datum/gear/uniform/suit/whiteblue
	display_name = "suit, white-blue"
	path = /obj/item/clothing/under/lawyer/bluesuit

/datum/gear/uniform/scrubs
	display_name = "scrubs, black"
	path = /obj/item/clothing/under/rank/medical/black
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/uniform/scrubs/blue
	display_name = "scrubs, blue"
	path = /obj/item/clothing/under/rank/medical/blue

/datum/gear/uniform/scrubs/purple
	display_name = "scrubs, purple"
	path = /obj/item/clothing/under/rank/medical/purple

/datum/gear/uniform/scrubs/green
	display_name = "scrubs, green"
	path = /obj/item/clothing/under/rank/medical/green

/datum/gear/uniform/scrubs/navyblue
	display_name = "scrubs, navy blue"
	path = /obj/item/clothing/under/rank/medical/navyblue

/datum/gear/uniform/sundress
	display_name = "sundress"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/white
	display_name = "sundress, white"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/uniform/dress_fire
	display_name = "flame dress"
	path = /obj/item/clothing/under/dress/dress_fire

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


//EROS START

/datum/gear/uniform/eros/harness
	display_name = "gear harness"
	path = /obj/item/clothing/under/harness

/datum/gear/uniform/eros/loose_dress
	display_name = "Loose Dress"
	path = /obj/item/clothing/under/loose_dress

/datum/gear/uniform/cheongsam
	display_name = "cheongsam selection"
	description = "Traditional silk garment embroidered with floral designs."

/datum/gear/uniform/cheongsam/New()
	..()
	var/list/cheongasms = list()
	for(var/cheongasm in typesof(/obj/item/clothing/under/cheongsam))
		var/obj/item/clothing/under/cheongsam/cheongasm_type = cheongasm
		cheongasms[initial(cheongasm_type.name)] = cheongasm_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cheongasms))

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
	display_name = "Worn Hazard suit"
	path = /obj/item/clothing/under/worn_hazard
	allowed_roles = list("Chief Engineer","Station Engineer")

//EROS FINISH
