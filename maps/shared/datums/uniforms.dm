/decl/hierarchy/outfit/job/dreyfus/magistrate
	name = OUTFIT_JOB_NAME("Magistrate")
	l_ear = /obj/item/device/radio/headset/heads/captain
	uniform = /obj/item/clothing/under/rank/magistrate
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/weapon/card/id/dreyfus/gold
	pda_type = /obj/item/device/pda/captain
	gloves = /obj/item/clothing/gloves/white
	head = /obj/item/clothing/head/crown//FIT FOR A FUCKING KING
	suit = /obj/item/clothing/suit/robes

/decl/hierarchy/outfit/job/dreyfus/adjoint
	name = OUTFIT_JOB_NAME("Directeur Adjoint")
	l_ear = /obj/item/device/radio/headset/heads/hop
	uniform = /obj/item/clothing/under/rank/internalaffairs/plain/nt
	suit = /obj/item/clothing/suit/storage/toggle/internalaffairs
	shoes = /obj/item/clothing/shoes/dress
	l_hand = /obj/item/weapon/storage/briefcase
	id_type = /obj/item/weapon/card/id/dreyfus/hop
	pda_type = /obj/item/device/pda/heads/hop

/decl/hierarchy/outfit/job/dreyfus/employe
	name = OUTFIT_JOB_NAME("Employe Administratif")
	l_ear = /obj/item/device/radio/headset/headset_com
	uniform = /obj/item/clothing/under/rank/internalaffairs/plain/nt
	shoes = /obj/item/clothing/shoes/black
	l_hand = /obj/item/weapon/storage/briefcase
	id_type = /obj/item/weapon/card/id/dreyfus/civilian/employe
	pda_type = /obj/item/device/pda/lawyer

/decl/hierarchy/outfit/job/dreyfus/inge
	hierarchy_type = /decl/hierarchy/outfit/job/engineering
	belt = /obj/item/weapon/storage/belt/utility/full
	l_ear = /obj/item/device/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/workboots
	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one = /obj/item/weapon/storage/backpack/satchel_eng
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/engi
	id_type = /obj/item/weapon/card/id/dreyfus/engineer
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/dreyfus/inge/inge
	name = OUTFIT_JOB_NAME("Ingenieur")
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/hazard
	r_pocket = /obj/item/device/t_scanner
	id_type = /obj/item/weapon/card/id/engineering
	pda_type = /obj/item/device/pda/engineering

/decl/hierarchy/outfit/job/dreyfus/ouvrier
	name = OUTFIT_JOB_NAME("Ouvrier")
	uniform = /obj/item/clothing/under/overalls
	id_type = /obj/item/weapon/card/id/dreyfus/cargo/ouvrier
	pda_type = /obj/item/device/pda/cargo
	l_ear = /obj/item/device/radio/headset/headset_cargo

/decl/hierarchy/outfit/job/science/superviseur
	name = OUTFIT_JOB_NAME("Superviseur")
	l_ear = /obj/item/device/radio/headset/heads/rd
	r_ear = /obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/research_director
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/science/head
	pda_type = /obj/item/device/pda/heads/rd

/decl/hierarchy/outfit/job/security/peacekeeper
	name = OUTFIT_JOB_NAME("Peacekeeper")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/syndicate/soldier
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/storage/vest/opvest
	belt = /obj/item/weapon/melee/classic_baton//So they at least start off with some kind of weapon to defend themselves.
	r_pocket = /obj/item/weapon/handcuffs
	id_type = /obj/item/weapon/card/id/dreyfus/sec
	pda_type = /obj/item/device/pda/security
	pda_slot = slot_l_store //So they don't lose their PDA.

/decl/hierarchy/outfit/job/security/head_peacekeeper
	name = OUTFIT_JOB_NAME("Head Peacekeeper")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/head_of_security/corp
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/hos//He doesn't have a locker anymore.
	id_type = /obj/item/weapon/card/id/dreyfus/hos
	pda_type = /obj/item/device/pda/heads/hos

/decl/hierarchy/outfit/job/cargo_kid
	name = OUTFIT_JOB_NAME("Cargo Kid")
	uniform = /obj/item/clothing/under/child_jumpsuit
	shoes = /obj/item/clothing/shoes/child_shoes
	id = /obj/item/weapon/card/id/dreyfus/cargo

/decl/hierarchy/outfit/job/cadet
	name = OUTFIT_JOB_NAME("Cadet")
	uniform = /obj/item/clothing/under/child_jumpsuit
	shoes = /obj/item/clothing/shoes/child_shoes
	id = /obj/item/weapon/card/id/dreyfus/sec

/decl/hierarchy/outfit/job/medassist
	name = OUTFIT_JOB_NAME("Medical Assistant")
	uniform = /obj/item/clothing/under/child_jumpsuit
	shoes = /obj/item/clothing/shoes/child_shoes
	id = /obj/item/weapon/card/id/medical

/decl/hierarchy/outfit/job/jr_upkeep
	name = OUTFIT_JOB_NAME("Junior Upkeeper")
	uniform = /obj/item/clothing/under/child_jumpsuit
	shoes = /obj/item/clothing/shoes/child_shoes
	id = /obj/item/weapon/card/id/dreyfus/engineer

//church outfits
/decl/hierarchy/outfit/job/arbiter
	name = OUTFIT_JOB_NAME("Arbiter")
	head = /obj/item/clothing/head/helmet/arbiter
	uniform = /obj/item/clothing/under/rank/arbiter
	shoes = /obj/item/clothing/shoes/jackboots/arbiter
	l_ear = /obj/item/device/radio/headset/inquision
	r_pocket = /obj/item/device/arbiter_scanner
	suit = /obj/item/clothing/suit/storage/vest/arbiter
	gloves = /obj/item/clothing/gloves/arbiter
	id_type = /obj/item/weapon/card/id/arbiter
	pda_type = /obj/item/device/pda/lawyer
	belt = /obj/item/weapon/melee/baton/loaded//So they at least start off with some kind of weapon to defend themselves.
	pda_slot = slot_l_store //So they don't lose their PDA.


/decl/hierarchy/outfit/job/supreme_arbiter
	name = OUTFIT_JOB_NAME("Supreme Arbiter")
	head = /obj/item/clothing/head/helmet/arbiter/supreme
	uniform = /obj/item/clothing/under/rank/arbiter
	shoes = /obj/item/clothing/shoes/jackboots/arbiter
	l_ear = /obj/item/device/radio/headset/inquision
	r_pocket = /obj/item/device/arbiter_scanner
	suit = /obj/item/clothing/suit/storage/vest/cowl
	gloves = /obj/item/clothing/gloves/arbiter
	id_type = /obj/item/weapon/card/id/arbiter
	pda_type = /obj/item/device/pda/lawyer

/decl/hierarchy/outfit/job/medical/doctor/undertaker
	name = OUTFIT_JOB_NAME("Undertaker")
	uniform = /obj/item/clothing/under/rank/undertaker
	suit = /obj/item/clothing/suit/undertaker
	shoes = /obj/item/clothing/shoes/undertaker
	gloves = /obj/item/clothing/gloves/undertaker
	mask = /obj/item/clothing/mask/gas/undertaker
	l_hand = null
	r_pocket = /obj/item/device/flashlight/pen
	id_type = /obj/item/weapon/card/id/medical

//Raider outfit.
/decl/hierarchy/outfit/shipraiders
	name = "Raiders"
	head = /obj/item/clothing/head/helmet/siege
	uniform = /obj/item/clothing/under/ert/raider
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/device/radio/headset/raider
	r_pocket = /obj/item/weapon/card/emag
	//belt = /obj/item/weapon/gun/projectile/pistol
	suit = /obj/item/clothing/suit/storage/vest/opvest
	//mask = /obj/item/clothing/mask/gas
	gloves = /obj/item/clothing/gloves/thick/swat/combat
	//back = /obj/item/weapon/gun/projectile/shotgun/pump/boltaction/shitty/bayonet
	flags = OUTFIT_NO_BACKPACK|OUTFIT_NO_SURVIVAL_GEAR