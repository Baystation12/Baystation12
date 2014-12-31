/**********************Marine Gear**************************/
//STANDARD MARINE CLOSET
/obj/structure/closet/secure_closet/marine
	name = "Marine's Locker"
	req_access = list()
	icon_state = "standard_locked"
	icon_closed = "standard_unlocked"
	icon_locked = "standard_locked"
	icon_opened = "squad_open"
	icon_broken = "standard_emmaged"
	icon_off = "standard_off"
	icon = 'icons/Marine/Marine_Lockers.dmi'

	New()
		sleep(2)
		new /obj/item/clothing/suit/storage/marine2(src)
		new /obj/item/weapon/storage/belt/marine(src)
		new /obj/item/clothing/head/helmet/marine2(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/clothing/shoes/marine(src)
		new /obj/item/clothing/gloves/marine(src)
		new /obj/item/clothing/under/marine2(src)
		new /obj/item/device/radio/headset/msulaco(src)
		return

//MARINE COMMAND CLOSET
/obj/structure/closet/secure_closet/marine/marine_commander
	name = "Marine Commander's Locker"
	req_access = list()
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	New()
		sleep(2)
		new /obj/item/weapon/storage/backpack/mcommander(src)
		new /obj/item/clothing/shoes/marinechief/commander(src)
		new /obj/item/clothing/gloves/marine/techofficer/commander(src)
		new /obj/item/clothing/under/marine/officer/commander(src)
		new /obj/item/clothing/suit/storage/marine/officer/commander(src)
		new /obj/item/weapon/storage/belt/marine(src)
		new /obj/item/clothing/head/beret/marine/commander(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/mcom(src)
		return





/**********************Military Police Gear**************************/
/obj/structure/closet/secure_closet/marine/military_officer
	name = "Military Police's Locker"
	req_access = list()
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	New()
		sleep(2)
		new /obj/item/clothing/shoes/marine(src)
		new /obj/item/clothing/under/marine/mp(src)
		new /obj/item/clothing/suit/armor/riot/marine(src)
		new /obj/item/clothing/head/helmet/riot(src)
		new /obj/item/weapon/storage/belt/marine(src)
		new /obj/item/weapon/storage/box/beanbags(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/mmpo(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/weapon/melee/baton(src)
		return


/obj/structure/closet/secure_closet/marine/military_officer_spare
	name = "Extra Equipment Locker"
	req_access = list()
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	New()
		sleep(2)
		new /obj/item/clothing/shoes/marine(src)
		new /obj/item/clothing/under/marine/mp(src)
		new /obj/item/clothing/suit/armor/riot/marine(src)
		new /obj/item/clothing/head/helmet/riot(src)
		new /obj/item/weapon/storage/box/beanbags(src)
		new /obj/item/weapon/storage/box/beanbags(src)
		new /obj/item/weapon/storage/box/beanbags(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/mmpo(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/weapon/shield/riot(src)
		new /obj/item/weapon/shield/riot(src)
		new /obj/item/weapon/melee/baton(src)
		return



//ALPHA EQUIPMENT CLOSET
/obj/structure/closet/secure_closet/marine/marine_alpha_equipment
	name = "Alpha Equipment Locker"
	req_access = list()
	icon_state = "squad_alpha_locked"
	icon_closed = "squad_alpha_unlocked"
	icon_locked = "squad_alpha_locked"
	icon_opened = "squad_open"
	icon_broken = "squad_alpha_emmaged"
	icon_off = "squad_alpha_off"

	New()
		sleep(2)
		new /obj/item/clothing/shoes/marine(src)
		new /obj/item/clothing/gloves/marine/alpha(src)
		new /obj/item/clothing/under/marine2(src)
		new /obj/item/clothing/suit/storage/marine2(src)
		new /obj/item/weapon/storage/belt/marine(src)
		new /obj/item/clothing/head/helmet/marine2(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/malpha(src)
		return

//BRAVO EQUIPMENT CLOSET
/obj/structure/closet/secure_closet/marine/marine_bravo_equipment
	name = "Bravo Equipment Locker"
	req_access = list()
	icon_state = "squad_bravo_locked"
	icon_closed = "squad_bravo_unlocked"
	icon_locked = "squad_bravo_locked"
	icon_opened = "squad_open"
	icon_broken = "squad_bravo_emmaged"
	icon_off = "squad_bravo_off"

	New()
		sleep(2)
		new /obj/item/clothing/shoes/marine(src)
		new /obj/item/clothing/gloves/marine/bravo(src)
		new /obj/item/clothing/under/marine2(src)
		new /obj/item/clothing/suit/storage/marine2(src)
		new /obj/item/weapon/storage/belt/marine(src)
		new /obj/item/clothing/head/helmet/marine2(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/mbravo(src)
		return

//CHARLIE EQUIPMENT CLOSET
/obj/structure/closet/secure_closet/marine/marine_charlie_equipment
	name = "Charlie Equipment Locker"
	req_access = list()
	icon_state = "squad_charlie_locked"
	icon_closed = "squad_charlie_unlocked"
	icon_locked = "squad_charlie_locked"
	icon_opened = "squad_open"
	icon_broken = "squad_charlie_emmaged"
	icon_off = "squad_charlie_off"

	New()
		sleep(2)
		new /obj/item/clothing/shoes/marine(src)
		new /obj/item/clothing/gloves/marine/charlie(src)
		new /obj/item/clothing/under/marine2(src)
		new /obj/item/clothing/suit/storage/marine2(src)
		new /obj/item/weapon/storage/belt/marine(src)
		new /obj/item/clothing/head/helmet/marine2(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/mcharlie(src)
		return

//Delta EQUIPMENT CLOSET
/obj/structure/closet/secure_closet/marine/marine_delta_equipment
	name = "Delta Equipment Locker"
	req_access = list()
	icon_state = "squad_delta_locked"
	icon_closed = "squad_delta_unlocked"
	icon_locked = "squad_delta_locked"
	icon_opened = "squad_open"
	icon_broken = "squad_delta_emmaged"
	icon_off = "squad_delta_off"

	New()
		sleep(2)
		new /obj/item/clothing/shoes/marine(src)
		new /obj/item/clothing/gloves/marine/delta(src)
		new /obj/item/clothing/under/marine2(src)
		new /obj/item/clothing/suit/storage/marine2(src)
		new /obj/item/weapon/storage/belt/marine(src)
		new /obj/item/clothing/head/helmet/marine2(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/mdelta(src)
		return



//SULACO MEDICAL CLOSET
/obj/structure/closet/secure_closet/marine/medical
	name = "Sulaco Medical Doctor's Locker"
	req_access_txt = 504
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

	New()
		sleep(2)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/medic(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_med(src)
		new /obj/item/clothing/under/rank/nursesuit (src)
		new /obj/item/clothing/head/nursehat (src)
		switch(pick("blue", "green", "purple"))
			if ("blue")
				new /obj/item/clothing/under/rank/medical/blue(src)
				new /obj/item/clothing/head/surgery/blue(src)
			if ("green")
				new /obj/item/clothing/under/rank/medical/green(src)
				new /obj/item/clothing/head/surgery/green(src)
			if ("purple")
				new /obj/item/clothing/under/rank/medical/purple(src)
				new /obj/item/clothing/head/surgery/purple(src)
		switch(pick("blue", "green", "purple"))
			if ("blue")
				new /obj/item/clothing/under/rank/medical/blue(src)
				new /obj/item/clothing/head/surgery/blue(src)
			if ("green")
				new /obj/item/clothing/under/rank/medical/green(src)
				new /obj/item/clothing/head/surgery/green(src)
			if ("purple")
				new /obj/item/clothing/under/rank/medical/purple(src)
				new /obj/item/clothing/head/surgery/purple(src)
		new /obj/item/clothing/under/rank/medical(src)
		new /obj/item/clothing/under/rank/nurse(src)
		new /obj/item/clothing/under/rank/orderly(src)
		new /obj/item/clothing/suit/storage/labcoat(src)
		new /obj/item/clothing/suit/storage/labcoat/genetics(src)
		new /obj/item/clothing/suit/storage/labcoat/chemist(src)
		new /obj/item/clothing/suit/storage/labcoat/virologist(src)
		new /obj/item/clothing/suit/storage/fr_jacket(src)
		new /obj/item/clothing/shoes/white(src)
		new /obj/item/device/radio/headset/msulaco(src)
		new /obj/item/weapon/storage/belt/medical(src)
		new /obj/item/weapon/reagent_containers/hypospray(src)
		new /obj/item/clothing/glasses/hud/health(src)
		return