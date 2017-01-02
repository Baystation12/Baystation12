/decl/hierarchy/outfit/job/assistant
	name = OUTFIT_JOB_NAME("Assistant")

/decl/hierarchy/outfit/job/assistant/visitor
	name = OUTFIT_JOB_NAME("Visitor")
	uniform = /obj/item/clothing/under/assistantformal

/decl/hierarchy/outfit/job/assistant/resident
	name = OUTFIT_JOB_NAME("Resident")
	uniform = /obj/item/clothing/under/color/white

/decl/hierarchy/outfit/job/assistant/colonist
	name = OUTFIT_JOB_NAME("Colonist")
	uniform = /obj/item/clothing/under/colonist
	shoes = /obj/item/clothing/shoes/brown

/decl/hierarchy/outfit/job/assistant/sci
	name = OUTFIT_JOB_NAME("Research Assistant")
	uniform = /obj/item/clothing/under/sciassist
	shoes = /obj/item/clothing/shoes/white
	head = /obj/item/clothing/head/soft/mime

/decl/hierarchy/outfit/job/assistant/med
	name = OUTFIT_JOB_NAME("Medical Intern")
	uniform = /obj/item/clothing/under/medintern
	shoes = /obj/item/clothing/shoes/white
	head = /obj/item/clothing/head/soft/mime

/decl/hierarchy/outfit/job/assistant/sec
	name = OUTFIT_JOB_NAME("Security Cadet")
	uniform = /obj/item/clothing/under/seccadet
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/soft/red

/decl/hierarchy/outfit/job/assistant/eng
	name = OUTFIT_JOB_NAME("Technical Assistant")
	uniform = /obj/item/clothing/under/techassist
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/techassist

/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/device/radio/headset/headset_service
	hierarchy_type = /decl/hierarchy/outfit/job/service

/decl/hierarchy/outfit/job/service/bartender
	name = OUTFIT_JOB_NAME("Bartender")
	uniform = /obj/item/clothing/under/rank/bartender
	id_type = /obj/item/weapon/card/id/civilian/bartender
	pda_type = /obj/item/device/pda/bar

/decl/hierarchy/outfit/job/service/chef
	name = OUTFIT_JOB_NAME("Chef")
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/weapon/card/id/civilian/chef
	pda_type = /obj/item/device/pda/chef

/decl/hierarchy/outfit/job/service/gardener
	name = OUTFIT_JOB_NAME("Gardener")
	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/thick/botany
	r_pocket = /obj/item/device/analyzer/plant_analyzer
	backpack = /obj/item/weapon/storage/backpack/hydroponics
	satchel_one = /obj/item/weapon/storage/backpack/satchel_hyd
	id_type = /obj/item/weapon/card/id/civilian/botanist
	pda_type = /obj/item/device/pda/botanist
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/hyd

/decl/hierarchy/outfit/job/service/janitor
	name = OUTFIT_JOB_NAME("Janitor")
	uniform = /obj/item/clothing/under/rank/janitor
	id_type = /obj/item/weapon/card/id/civilian/janitor
	pda_type = /obj/item/device/pda/janitor

/decl/hierarchy/outfit/job/librarian
	name = OUTFIT_JOB_NAME("Librarian")
	uniform = /obj/item/clothing/under/suit_jacket/red
	l_hand = /obj/item/weapon/barcodescanner
	id_type = /obj/item/weapon/card/id/civilian/librarian
	pda_type = /obj/item/device/pda/librarian

/decl/hierarchy/outfit/job/internal_affairs_agent
	name = OUTFIT_JOB_NAME("Internal affairs agent")
	l_ear = /obj/item/device/radio/headset/ia
	uniform = /obj/item/clothing/under/rank/internalaffairs
	suit = /obj/item/clothing/suit/storage/toggle/internalaffairs
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_hand = /obj/item/weapon/storage/briefcase
	id_type = /obj/item/weapon/card/id/civilian/internal_affairs_agent
	pda_type = /obj/item/device/pda/lawyer

/decl/hierarchy/outfit/job/chaplain
	name = OUTFIT_JOB_NAME("Chaplain")
	uniform = /obj/item/clothing/under/rank/chaplain
	l_hand = /obj/item/weapon/storage/bible
	id_type = /obj/item/weapon/card/id/civilian/chaplain
	pda_type = /obj/item/device/pda/chaplain

//EROS START

/decl/hierarchy/outfit/job/entertainer
	name = OUTFIT_JOB_NAME("Entertainer")
	uniform = /obj/item/clothing/under/rank/internalaffairs
	shoes = /obj/item/clothing/shoes/chameleon
	backpack = /obj/item/weapon/storage/backpack/chameleon
	satchel_one = /obj/item/weapon/storage/backpack/chameleon/entertainer
	satchel_two = /obj/item/weapon/storage/backpack/chameleon/entertainer
	id_type = /obj/item/weapon/card/id/civilian/entertainer
	pda_type = /obj/item/device/pda
	backpack_contents = list(/obj/item/weapon/storage/box/syndie_kit/chameleon/entertainer = 1, /obj/item/clothing/suit/chameleon/entertainer = 1, /obj/item/clothing/under/chameleon/entertainer = 1)

/decl/hierarchy/outfit/job/entertainer/clown
	name = OUTFIT_JOB_NAME("Clown")
	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	mask = /obj/item/clothing/mask/gas/clown_hat
	backpack = /obj/item/weapon/storage/backpack/clown
	satchel_one = /obj/item/weapon/storage/backpack/clown
	satchel_two = /obj/item/weapon/storage/backpack/clown
	pda_type = /obj/item/device/pda/clown
	l_hand = /obj/item/weapon/bikehorn
	backpack_contents = list(/obj/item/weapon/pen/crayon/rainbow = 1, /obj/item/toy/waterflower = 1, /obj/item/weapon/reagent_containers/food/snacks/egg/rainbow  = 3)

/decl/hierarchy/outfit/job/entertainer/mime
	name = OUTFIT_JOB_NAME("Mime")
	uniform = /obj/item/clothing/under/mime
//	suit = /obj/item/clothing/suit/suspenders
	shoes = /obj/item/clothing/shoes/mime
	mask = /obj/item/clothing/mask/gas/mime
	head = /obj/item/clothing/head/beret
	backpack = /obj/item/weapon/storage/backpack
	satchel_one = /obj/item/weapon/storage/backpack/satchel_norm
	satchel_two = /obj/item/weapon/storage/backpack/satchel
	pda_type = /obj/item/device/pda/mime
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing = 1, /obj/item/weapon/pen/crayon/mime = 1, /obj/item/clothing/gloves/white = 1)

/decl/hierarchy/outfit/job/entertainer/mime/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/suspenders/mime_susp = new()
		if(uniform.can_attach_accessory(mime_susp))
			uniform.attach_accessory(null, mime_susp)
		else
			qdel(mime_susp)

/decl/hierarchy/outfit/job/entertainer/artist
	name = OUTFIT_JOB_NAME("Artist")
	uniform = /obj/item/clothing/under/color/rainbow
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/rainbow
	head = /obj/item/clothing/head/beret
	backpack = /obj/item/weapon/storage/backpack
	satchel_one = /obj/item/weapon/storage/backpack/satchel_norm
	satchel_two = /obj/item/weapon/storage/backpack/satchel
	l_hand = /obj/item/device/floor_painter
	backpack_contents = list(/obj/item/weapon/pen/multi = 1, /obj/item/weapon/storage/fancy/crayons = 2, /obj/item/device/cable_painter = 1,  /obj/item/stack/cable_coil/random = 3)

/decl/hierarchy/outfit/job/entertainer/violinist
	name = OUTFIT_JOB_NAME("Violinist")
	uniform = /obj/item/clothing/under/rank/internalaffairs
	suit = /obj/item/clothing/suit/wcoat
	shoes = /obj/item/clothing/shoes/laceup
	backpack = /obj/item/weapon/storage/backpack
	satchel_one = /obj/item/weapon/storage/backpack/satchel_norm
	satchel_two = /obj/item/weapon/storage/backpack/satchel
	l_hand = /obj/item/device/violin
	backpack_contents = list(/obj/item/device/violin/secondary = 1, /obj/item/device/violin/backup = 1, /obj/item/device/violin/emergency = 1)


//EROS FINISH