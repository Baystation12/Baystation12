
/decl/hierarchy/outfit/job/ks7_colonist
	name = "KS7 Colonist"

	head = null
	uniform = null
	l_ear = /obj/item/device/radio/headset
	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	shoes = /obj/item/clothing/shoes/brown
	r_pocket = /obj/item/ammo_magazine/m127_saphe
	l_pocket = /obj/item/weapon/storage/wallet/random
	pda_slot = null

/decl/hierarchy/outfit/job/ks7_colonist/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "New Pompeii Resident/Worker"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/ks7_colonist/equip_base(mob/living/carbon/human/H)
	var/random_uniform = pick(/obj/item/clothing/under/serviceoveralls,\
		/obj/item/clothing/under/frontier,\
		/obj/item/clothing/under/overalls,\
		/obj/item/clothing/under/focal,\
		/obj/item/clothing/under/grayson,\
		/obj/item/clothing/under/hazard,\
		/obj/item/clothing/under/aether)
	H.equip_to_slot_or_del(new random_uniform(H),slot_w_uniform)

	. = ..()

/decl/hierarchy/outfit/job/ks7_mayor
	name = "KS7 Mayor"
	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	l_ear = /obj/item/device/radio/headset/police
	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	shoes = /obj/item/clothing/shoes/brown
	r_pocket = /obj/item/ammo_magazine/m127_saphe
	l_pocket = /obj/item/weapon/storage/wallet/random
	pda_slot = null

	l_hand = /obj/item/weapon/card/id/building_key/mayor_master

/decl/hierarchy/outfit/job/ks7_mayor/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "New Pompeii Mayor"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/ks7_colonist/aerodrome
	name = "KS7 Aerodrome Technician"
	l_hand = /obj/item/weapon/card/id/building_key/aerodrome

/decl/hierarchy/outfit/job/ks7_colonist/biodome_worker
	name = "KS7 Biodome Worker"
	l_hand = /obj/item/weapon/card/id/building_key/biodome

/decl/hierarchy/outfit/job/ks7_colonist/casino_owner
	name = "KS7 Casino Owner"
	l_hand = /obj/item/weapon/card/id/building_key/casino_backroom

/decl/hierarchy/outfit/job/ks7_colonist/hospital_worker
	name = "KS7 Hospital Worker"
	l_hand = /obj/item/weapon/card/id/building_key/hospital

/decl/hierarchy/outfit/job/ks7_colonist/pharmacist
	name = "KS7 Pharmacist"
	l_hand = /obj/item/weapon/card/id/building_key/pharmacy

/decl/hierarchy/outfit/job/ks7_colonist/colonist_marshall
	name = "KS7 Colonist Marshall"
	l_hand = /obj/item/weapon/card/id/building_key/police_station
	l_ear = /obj/item/device/radio/headset/police

/decl/hierarchy/outfit/job/ks7_colonist/bartender
	name = "KS7 Bartender"
	l_hand = /obj/item/weapon/card/id/building_key/bar

/decl/hierarchy/outfit/job/ks7_colonist/chef
	name = "KS7 Chef"
	l_hand = /obj/item/weapon/card/id/building_key/kitchen

/decl/hierarchy/outfit/job/ks7_colonist/librarian_museum
	name = "KS7 Librarian / Museum Worker"
	l_hand = /obj/item/weapon/card/id/building_key/museum_library

/decl/hierarchy/outfit/job/ks7_colonist/innie
	name = "KS7 Reformed Insurrectionist Cell"

	l_ear = /obj/item/device/radio/headset/insurrection

/decl/hierarchy/outfit/job/ks7_unsc
	name = "First Contact UNSC Crewman"

	head = null
	uniform = /obj/item/clothing/under/unsc/red
	l_ear = /obj/item/device/radio/headset/unsc
	shoes = /obj/item/clothing/shoes/brown
	l_pocket = /obj/item/weapon/storage/wallet/random
	pda_slot = null

/decl/hierarchy/outfit/fc_unggoy
	name = "Unggoy (First Contact Minor)"

	l_ear = /obj/item/device/radio/headset/covenant
	glasses = /obj/item/clothing/glasses/hud/tactical/covenant
	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/first_contact
	back = /obj/item/weapon/tank/methane/unggoy_internal
	uniform = /obj/item/clothing/under/unggoy_internal
	mask = /obj/item/clothing/mask/rebreather
	//
	id_type = /obj/item/weapon/card/id/grunt_minor