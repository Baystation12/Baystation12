/decl/hierarchy/outfit/job/captain/fallout
	name = OUTFIT_JOB_NAME("Overseer")
	head = null
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/gold

/decl/hierarchy/outfit/job/hop/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/silver



//--------------------------
//Security
//--------------------------
/decl/hierarchy/outfit/job/security/hos/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/security/head

/decl/hierarchy/outfit/job/security/detective/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/security/detective

/decl/hierarchy/outfit/job/security/officer/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/security



//--------------------------
//Medical
//--------------------------
/decl/hierarchy/outfit/job/medical/cmo/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/medical/head

/decl/hierarchy/outfit/job/medical/doctor/fallout
	uniform = /obj/item/clothing/under/fallout
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/fallout/medical

/decl/hierarchy/outfit/job/medical/doctor/virologist/fallout
	uniform = /obj/item/clothing/under/fallout
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/fallout/medical

/decl/hierarchy/outfit/job/medical/chemist/fallout
	uniform = /obj/item/clothing/under/fallout
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/fallout/medical/chemist

/decl/hierarchy/outfit/job/medical/psychiatrist/fallout
	uniform = /obj/item/clothing/under/fallout
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/fallout/medical/psychiatrist



//--------------------------
//Science
//--------------------------
/decl/hierarchy/outfit/job/science/rd/fallout
	uniform = /obj/item/clothing/under/fallout
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/fallout/science/head

/decl/hierarchy/outfit/job/science/scientist/fallout
	uniform = /obj/item/clothing/under/fallout
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/fallout/science

/decl/hierarchy/outfit/job/science/roboticist/fallout
	uniform = /obj/item/clothing/under/fallout
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/fallout/science/roboticist



//--------------------------
//Engineering
//--------------------------
/decl/hierarchy/outfit/job/engineering/chief_engineer/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/engineering/head

/decl/hierarchy/outfit/job/engineering/engineer/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/engineering

/decl/hierarchy/outfit/job/engineering/atmos/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/engineering



//--------------------------
//Civilian
//--------------------------
/decl/hierarchy/outfit/job/service/bartender/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/civilian/bartender

/decl/hierarchy/outfit/job/service/chef/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/civilian/chef

/decl/hierarchy/outfit/job/service/gardener/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/civilian/botanist

/decl/hierarchy/outfit/job/cargo/qm/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/cargo/head

/decl/hierarchy/outfit/job/cargo/cargo_tech/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/cargo

/decl/hierarchy/outfit/job/cargo/mining/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/cargo/mining

/decl/hierarchy/outfit/job/service/janitor/fallout
	uniform = /obj/item/clothing/under/fallout
	id_type = /obj/item/weapon/card/id/fallout/civilian/janitor

//--------------------------
//Settler
//--------------------------
/decl/hierarchy/outfit/settler
	hierarchy_type = /decl/hierarchy/outfit/settler
	name = "Sunset Settler"
	uniform = /obj/item/clothing/under/fallout/settler
	shoes = /obj/item/clothing/shoes/leather

/decl/hierarchy/outfit/settler/settler
	uniform = /obj/item/clothing/under/fallout/settler

/decl/hierarchy/outfit/settler/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(33))
		if(!l_pocket) // equip if not predefined to equip
			l_pocket = /obj/item/device/radio/settler
	var/money = rand(1,4)
	switch(money) //give them some money to play with
		if(1)
			backpack_contents.Add(/obj/item/weapon/spacecash/bundle/c200 = 1)
		if(2)
			backpack_contents.Add(/obj/item/weapon/spacecash/bundle/c200 = 1)
			backpack_contents.Add(/obj/item/weapon/spacecash/bundle/c100 = 1)
		if(3)
			backpack_contents.Add(/obj/item/weapon/spacecash/bundle/c500 = 1)
		if(4)
			backpack_contents.Add(/obj/item/weapon/spacecash/bundle/c1000 = 1)

/decl/hierarchy/outfit/settler/sheriff
	name = "Sunset Sheriff"
	uniform = /obj/item/clothing/under/fallout/sheriff
	suit = /obj/item/clothing/suit/armor/vest
	back = /obj/item/weapon/storage/backpack/satchel
	belt = /obj/item/weapon/storage/belt/security
	gloves = /obj/item/clothing/gloves/thick
	head = /obj/item/clothing/head/cowboy_hat
	suit_store = /obj/item/weapon/gun/projectile/revolver
	l_pocket = /obj/item/device/radio/settler/sheriff
	r_pocket = /obj/item/weapon/key/sheriff
	backpack_contents = list(/obj/item/weapon/handcuffs = 2, /obj/item/weapon/key/police = 1)

/decl/hierarchy/outfit/settler/sheriff/deputy
	name = "Sunset Sheriff's deputy"
	uniform = /obj/item/clothing/under/fallout/cowboyb
	r_pocket = /obj/item/weapon/key/police

/decl/hierarchy/outfit/settler/wastedoc
	name = "Frontier Doctor"
	back = /obj/item/weapon/storage/backpack/satchel
	belt = /obj/item/weapon/storage/belt/medical
	gloves = /obj/item/clothing/gloves/latex/nitrile
	belt = /obj/item/device/healthanalyzer
	r_pocket = /obj/item/weapon/key/clinic
	backpack_contents = list(/datum/gear/accessory/stethoscope = 1, /obj/item/device/flashlight/pen = 1)

/decl/hierarchy/outfit/settler/wastedoc/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/fallout/doctorf
	else
		uniform = /obj/item/clothing/under/fallout/doctorm

/decl/hierarchy/outfit/settler/manager
	name = "Sunset Hotel Manager"
	uniform = /obj/item/clothing/under/fallout/benny
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/weapon/storage/backpack/satchel
	r_pocket = /obj/item/weapon/key/hotel

/decl/hierarchy/outfit/settler/maid
	name = "Sunset Hotel Maid"
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/weapon/storage/backpack/satchel
	r_pocket = /obj/item/weapon/key/hotel

/decl/hierarchy/outfit/settler/maid/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/blackskirt
	else
		uniform = /obj/item/clothing/under/suit_jacket/charcoal

/decl/hierarchy/outfit/settler/solareng
	name = "Solar Field Engineer"
	uniform = /obj/item/clothing/under/fallout/cowboyg
	suit = /obj/item/clothing/suit/storage/fallout/duster
	belt = /obj/item/weapon/storage/belt/utility/full
	glasses = /obj/item/clothing/glasses/welding
	gloves = /obj/item/clothing/gloves/insulated
	back = /obj/item/weapon/storage/backpack/satchel_eng
	r_pocket = /obj/item/weapon/key/solar
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/engi

/decl/hierarchy/outfit/settler/merchant
	name = "Merchant"
	uniform = /obj/item/clothing/under/fallout/caravaneer
	suit = /obj/item/clothing/suit/armor/fallout/armorkit
	suit_store = /obj/item/weapon/gun/projectile/revolver
	id_type = /obj/item/weapon/card/id/merchant
	r_pocket = /obj/item/weapon/key/merchant
/*
	uniform = null
	suit = null
	back = null
	belt = null
	gloves = null
	shoes = null
	head = null
	mask = null
	l_ear = null
	r_ear = null
	glasses = null
	id = null
	l_pocket = null
	r_pocket = null
	suit_store = null
	r_hand = null
	l_hand = null
	*/