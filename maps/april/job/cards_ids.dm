/obj/item/weapon/card/id/fallout
	name = "identification card"
	desc = "An identification card issued to personnel in Vault 12."
	icon_state = "id"
	item_state = "card-id"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/fallout/gold
	desc = "A golden identification card belonging to the Overseer."
	icon_state = "gold"
	item_state = "gold_id"
	job_access_type = /datum/job/fallout/overseer


/obj/item/weapon/card/id/fallout/silver
	desc = "A silver identification card belonging to heads of staff."
	icon_state = "silver"
	item_state = "silver_id"
	job_access_type = /datum/job/fallout/hop



//--------------------------
//Security
//--------------------------
/obj/item/weapon/card/id/fallout/security
	name = "identification card"
	desc = "A card issued to vault security staff."
	icon_state = "sec"
	job_access_type = /datum/job/fallout/officer

/obj/item/weapon/card/id/fallout/security/detective
	job_access_type = /datum/job/fallout/detective

/obj/item/weapon/card/id/fallout/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	icon_state = "secGold"
	job_access_type = /datum/job/fallout/hos



//--------------------------
//MEDICAL
//--------------------------
/obj/item/weapon/card/id/fallout/medical
	name = "identification card"
	desc = "A card issued to vault medical staff."
	icon_state = "med"
	job_access_type = /datum/job/fallout/doctor

/obj/item/weapon/card/id/fallout/medical/chemist
	job_access_type = /datum/job/fallout/chemist

/obj/item/weapon/card/id/fallout/medical/psychiatrist
	job_access_type = /datum/job/fallout/psychiatrist

/obj/item/weapon/card/id/fallout/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	icon_state = "medGold"
	job_access_type = /datum/job/fallout/cmo



//--------------------------
//SCIENCE
//--------------------------
/obj/item/weapon/card/id/fallout/science
	name = "identification card"
	desc = "A card issued to vault science staff."
	icon_state = "sci"
	job_access_type = /datum/job/fallout/scientist

/obj/item/weapon/card/id/fallout/science/roboticist
	job_access_type = /datum/job/fallout/roboticist

/obj/item/weapon/card/id/fallout/science/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	icon_state = "sciGold"
	job_access_type = /datum/job/fallout/rd



//--------------------------
//ENGINEERING
//--------------------------
/obj/item/weapon/card/id/fallout/engineering
	name = "identification card"
	desc = "A card issued to vault engineering staff."
	icon_state = "eng"
	job_access_type = /datum/job/fallout/engineer

/obj/item/weapon/card/id/fallout/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	icon_state = "engGold"
	job_access_type = /datum/job/fallout/chief_engineer



//--------------------------
//CIVILIAN
//--------------------------
/obj/item/weapon/card/id/fallout/cargo
	name = "identification card"
	desc = "A card issued to station cargo staff."
	icon_state = "cargo"
	job_access_type = /datum/job/fallout/cargo_tech

/obj/item/weapon/card/id/fallout/cargo/mining
	job_access_type = /datum/job/fallout/mining

/obj/item/weapon/card/id/fallout/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	icon_state = "cargoGold"
	job_access_type = /datum/job/fallout/qm

/obj/item/weapon/card/id/fallout/civilian
	name = "identification card"
	desc = "A card issued to station civilian staff."
	icon_state = "civ"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/fallout/civilian/bartender
	job_access_type = /datum/job/fallout/bartender

/obj/item/weapon/card/id/fallout/civilian/chef
	job_access_type = /datum/job/fallout/chef

/obj/item/weapon/card/id/fallout/civilian/botanist
	job_access_type = /datum/job/fallout/hydro

/obj/item/weapon/card/id/fallout/civilian/janitor
	job_access_type = /datum/job/fallout/janitor


//Lol might as well put settler keys here
/obj/item/weapon/key/solar
	name = "key (Solar Field)"
	key_data = "solar"

/obj/item/weapon/key/clinic
	name = "key (Sunset Clinic)"
	key_data = "clinic"

/obj/item/weapon/key/sheriff
	name = "key (Sheriff's Office)"
	key_data = "sheriff"

/obj/item/weapon/key/police
	name = "key (Sunset Dept.)"
	key_data = "police"

/obj/item/weapon/key/merchant
	name = "Key (Merchant Market)"
	key_data = "merch"

/obj/item/weapon/key/hotel
	name = "Key (Sunset Hotel)"
	key_data = "hotel"