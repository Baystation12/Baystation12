/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	req_access = list(access_captain)
	closet_appearance = /decl/closet_appearance/secure_closet/command

/obj/structure/closet/secure_closet/captains/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/command, /obj/item/storage/backpack/satchel/com)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/com, 50),
		/obj/item/clothing/suit/captunic,
		/obj/item/clothing/suit/captunic/capjacket,
		/obj/item/clothing/head/caphat/cap,
		/obj/item/clothing/under/rank/captain,
		/obj/item/clothing/suit/armor/vest/nt,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/shoes/brown,
		/obj/item/device/radio/headset/heads/captain,
		/obj/item/clothing/gloves/captain,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/suit/armor/captain,
		/obj/item/melee/telebaton,
		/obj/item/clothing/under/dress/dress_cap,
		/obj/item/clothing/head/caphat/formal,
		/obj/item/clothing/under/captainformal,
	)

/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	closet_appearance = /decl/closet_appearance/secure_closet/command/hop
	req_access = list(access_hop)

/obj/structure/closet/secure_closet/hop/WillContain()
	return list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/armor/vest/nt,
		/obj/item/clothing/head/helmet,
		/obj/item/device/radio/headset/heads/hop,
		/obj/item/storage/box/ids = 2,
		/obj/item/device/flash
	)

/obj/structure/closet/secure_closet/hop2
	name = "head of personnel's attire"
	req_access = list(access_hop)
	closet_appearance = /decl/closet_appearance/secure_closet/command/hop

/obj/structure/closet/secure_closet/hop2/WillContain()
	return list(
		/obj/item/clothing/under/rank/head_of_personnel,
		/obj/item/clothing/under/dress/dress_hop,
		/obj/item/clothing/under/dress/dress_hr,
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/oldman,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/head_of_personnel_whimsy,
		/obj/item/clothing/head/caphat/hop
	)

/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	req_access = list(access_hos)
	closet_appearance = /decl/closet_appearance/secure_closet/security/hos

/obj/structure/closet/secure_closet/hos/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/security, /obj/item/storage/backpack/satchel/sec)),
		/obj/item/clothing/head/HoS,
		/obj/item/clothing/head/helmet/nt,
		/obj/item/clothing/suit/armor/vest/nt,
		/obj/item/clothing/suit/storage/vest/nt/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/suit/armor/hos/jensen,
		/obj/item/clothing/suit/armor/hos,
		/obj/item/clothing/head/HoS/dermal,
		/obj/item/device/radio/headset/heads/hos,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/shield/riot,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/holster/security,
		/obj/item/device/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/accessory/storage/holster/waist,
		/obj/item/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/device/holowarrant
	)

/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	req_access = list(access_armory)
	closet_appearance = /decl/closet_appearance/secure_closet/security/warden

/obj/structure/closet/secure_closet/warden/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/security, /obj/item/storage/backpack/satchel/sec)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/sec, 50),
		/obj/item/clothing/head/helmet/nt,
		/obj/item/clothing/suit/armor/vest/nt,
		/obj/item/clothing/suit/storage/vest/nt/warden,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/suit/armor/vest/warden,
		/obj/item/clothing/head/warden,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/teargas,
		/obj/item/storage/belt/holster/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/storage/box/holobadge,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/device/holowarrant
	)

/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security

/obj/structure/closet/secure_closet/security/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/security, /obj/item/storage/backpack/satchel/sec)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/sec, 50),
		/obj/item/clothing/suit/armor/vest/nt,
		/obj/item/clothing/head/helmet,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/storage/belt/holster/security,
		/obj/item/device/flash,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/grenade/chem_grenade/teargas,
		/obj/item/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/gun/energy/taser,
		/obj/item/device/holowarrant,
	)

/obj/structure/closet/secure_closet/security/cargo/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
		/obj/item/clothing/accessory/armband/cargo,
		/obj/item/device/encryptionkey/headset_cargo
	))

/obj/structure/closet/secure_closet/security/engine/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
			/obj/item/clothing/accessory/armband/engine,
			/obj/item/device/encryptionkey/headset_eng
		))

/obj/structure/closet/secure_closet/security/science/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(/obj/item/device/encryptionkey/headset_sci))

/obj/structure/closet/secure_closet/security/med/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
			/obj/item/clothing/accessory/armband/medgreen,
			/obj/item/device/encryptionkey/headset_med
		))

/obj/structure/closet/secure_closet/detective
	name = "detective's cabinet"
	req_access = list(access_forensics_lockers)
	closet_appearance = /decl/closet_appearance/cabinet/secure

/obj/structure/closet/secure_closet/detective/WillContain()
	return list(
		/obj/item/clothing/under/det,
		/obj/item/clothing/under/det/grey,
		/obj/item/clothing/under/det/black,
		/obj/item/clothing/suit/storage/det_trench,
		/obj/item/clothing/suit/storage/det_trench/grey,
		/obj/item/clothing/suit/storage/forensics/blue,
		/obj/item/clothing/suit/storage/forensics/red,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/head/det,
		/obj/item/clothing/head/det/grey,
		/obj/item/clothing/shoes/laceup,
		/obj/item/storage/box/evidence,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/clothing/suit/armor/vest/detective,
		/obj/item/taperoll/police,
		/obj/item/gun/projectile/pistol/sec/detective,
		/obj/item/clothing/accessory/storage/holster/armpit,
		/obj/item/reagent_containers/food/drinks/flask/detflask,
		/obj/item/storage/briefcase/crimekit,
		/obj/item/device/holowarrant
	)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/injection/WillContain()
	return list(/obj/item/reagent_containers/syringe/ld50_syringe/choral = 2)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	anchored = TRUE
	var/id = null

/obj/structure/closet/secure_closet/brig/WillContain()
	return list(
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/shoes/orange
	)

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_lawyer)

/obj/structure/closet/secure_closet/courtroom/WillContain()
	return list(
		/obj/item/clothing/shoes/brown,
		/obj/item/paper/Court = 3,
		/obj/item/pen ,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/head/powdered_wig ,
		/obj/item/storage/briefcase,
	)

/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	closet_appearance = /decl/closet_appearance/wall

	//too small to put a man in
	large = 0

/obj/structure/closet/secure_closet/lawyer
	name = "internal affairs secure closet"
	req_access = list(access_lawyer)

/obj/structure/closet/secure_closet/lawyer/WillContain()
	return list(
		/obj/item/device/flash = 2,
		/obj/item/device/camera = 2,
		/obj/item/device/camera_film = 2,
		/obj/item/device/taperecorder = 2,
		/obj/item/storage/secure/briefcase = 2,
	)
