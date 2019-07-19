
/mob/living/simple_animal/npc/colonist/surgeon
	name = "NPC Surgeon"
	npc_job_title = "NPC Surgeon"
	//desc = "A human from one of Earth's diverse cultures. This NPC does surgery for cash."

	jumpsuits = list()
	glasses = list(/obj/item/clothing/glasses/hud/health)
	glasses_chance = 100
	suits = list(/obj/item/clothing/suit/surgicalapron)
	suit_chance = 100
	gloves = list(/obj/item/clothing/gloves/latex)
	glove_chance = 100
	suits = list(/obj/item/clothing/suit/surgicalapron)
	suit_chance = 100
	masks = list(/obj/item/clothing/mask/surgical)
	mask_chance = 100
	hats = list(\
		/obj/item/clothing/head/surgery/black,\
		/obj/item/clothing/head/surgery/blue,\
		/obj/item/clothing/head/surgery/green,\
		/obj/item/clothing/head/surgery/navyblue,\
		/obj/item/clothing/head/surgery/purple)
	hat_chance = 0

/mob/living/simple_animal/npc/colonist/surgeon/equip_gear()

	//override this so our suit and hat match

	jumpsuits = list(\
		/obj/item/clothing/under/rank/medical/black,\
		/obj/item/clothing/under/rank/medical/blue,\
		/obj/item/clothing/under/rank/medical/green,\
		/obj/item/clothing/under/rank/medical/navyblue,\
		/obj/item/clothing/under/rank/medical/purple)
	var/index = rand(1,5)
	//
	var/newtype = hats[index]
	var/new_item = new newtype(src)
	sprite_equip(new_item,slot_head_str)
	//
	newtype = jumpsuits[index]
	new_item = new newtype(src)
	sprite_equip(new_item,slot_w_uniform_str)

	jumpsuits = list()

	. = ..()

/mob/living/simple_animal/npc/colonist/doctor
	name = "NPC Doctor"
	npc_job_title = "NPC Doctor"
	//desc = "A human from one of Earth's diverse cultures. This NPC does surgery for cash."

	jumpsuits = list(\
		/obj/item/clothing/under/rank/medical/virologist,\
		/obj/item/clothing/under/rank/medical/chemist,\
		/obj/item/clothing/under/rank/medical/geneticist,\
		/obj/item/clothing/under/rank/medical)
	shoes = list(/obj/item/clothing/shoes/white)
	glasses = list(/obj/item/clothing/glasses/hud/health)
	glasses_chance = 100
	suits = list(\
		/obj/item/clothing/suit/storage/toggle/labcoat/blue,\
		/obj/item/clothing/suit/storage/toggle/labcoat/chemist,\
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,\
		/obj/item/clothing/suit/storage/toggle/labcoat/genetics,\
		/obj/item/clothing/suit/storage/toggle/labcoat/virologist,\
		/obj/item/clothing/suit/storage/toggle/labcoat)
	suit_chance = 100
	gloves = list(/obj/item/clothing/gloves/latex)
	glove_chance = 33
	hats = list()

/mob/living/simple_animal/npc/colonist/nurse
	name = "NPC Nurse"
	npc_job_title = "NPC Nurse"
	//desc = "A human from one of Earth's diverse cultures. This NPC does basic first aid for free."

	//these nurse outfits are terrible
	//jumpsuits = list(/obj/item/clothing/under/rank/nurse, /obj/item/clothing/under/rank/nursesuit)
	jumpsuits = list(\
		/obj/item/clothing/under/rank/medical/black,\
		/obj/item/clothing/under/rank/medical/blue,\
		/obj/item/clothing/under/rank/medical/green,\
		/obj/item/clothing/under/rank/medical/navyblue,\
		/obj/item/clothing/under/rank/medical/purple)
	glasses = list(/obj/item/clothing/glasses/regular,/obj/item/clothing/glasses/regular/hipster)
	glasses_chance = 33
	gloves = list(/obj/item/clothing/gloves/latex)
	glove_chance = 25
	suits = list()
	hats = list(/obj/item/clothing/head/nursehat)
	hat_chance = 100

/mob/living/simple_animal/npc/colonist/nurse/paramedic
	name = "NPC Paramedic"
	npc_job_title = "NPC Paramedic"
	jumpsuits = list(/obj/item/clothing/under/rank/medical)
	hats = list()
	glasses = list(/obj/item/clothing/glasses/hud/health)
	glasses_chance = 50

/mob/living/simple_animal/npc/colonist/organlegger
	name = "NPC Organlegger"
	npc_job_title = "NPC Organlegger"
	desc = "A human from one of Earth's diverse cultures. This NPC buys and sells organs for cash."
	trade_categories_by_name =  list("organs")
	interact_screen = 2
	starting_trade_items = 10

	jumpsuits = list(\
		/obj/item/clothing/under/sterile,\
		/obj/item/clothing/under/rank/medical,\
		/obj/item/clothing/under/rank/medical/black,\
		/obj/item/clothing/under/rank/medical/blue,\
		/obj/item/clothing/under/rank/medical/green,\
		/obj/item/clothing/under/rank/medical/navyblue,\
		/obj/item/clothing/under/rank/medical/purple)
	shoes = list(\
		/obj/item/clothing/shoes/dress,\
		/obj/item/clothing/shoes/dress/white,\
		/obj/item/clothing/shoes/workboots,\
		/obj/item/clothing/shoes/sandal,\
		/obj/item/clothing/shoes/slippers)
	glasses = list(\
		/obj/item/clothing/glasses/hud/health,\
		/obj/item/clothing/glasses/threedglasses,\
		/obj/item/clothing/glasses/science,\
		/obj/item/clothing/glasses/eyepatch,\
		/obj/item/clothing/glasses/monocle,\
		/obj/item/clothing/glasses/regular/hipster)
	glasses_chance = 50
	suits = list(\
		/obj/item/clothing/suit/storage/det_trench,\
		/obj/item/clothing/suit/storage/det_trench/grey,\
		/obj/item/clothing/suit/storage/hazardvest/white,\
		/obj/item/clothing/suit/storage/hooded/hoodie,\
		/obj/item/clothing/suit/storage/toggle/labcoat,\
		/obj/item/clothing/suit/storage/toggle/labcoat/blue,\
		/obj/item/clothing/suit/storage/toggle/labcoat/mad,\
		/obj/item/clothing/suit/apron,\
		/obj/item/clothing/suit/surgicalapron,\
		/obj/item/clothing/suit/apron/overalls)
	suit_chance = 90
	gloves = list(/obj/item/clothing/gloves/latex, /obj/item/clothing/gloves/rainbow)
	glove_chance = 75
	hats = list(\
		/obj/item/clothing/head/boaterhat,\
		/obj/item/clothing/head/feathertrilby,\
		/obj/item/clothing/head/fedora,\
		/obj/item/clothing/head/bandana)
	hat_chance = 33
	masks = list(\
		/obj/item/clothing/mask/gas,\
		/obj/item/clothing/mask/fakemoustache,\
		/obj/item/clothing/mask/breath/medical,\
		/obj/item/clothing/mask/innie/shemagh,\
		/obj/item/clothing/mask/surgical)
	mask_chance = 50

	wander = 0
