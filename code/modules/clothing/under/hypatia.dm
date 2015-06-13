/obj/item/clothing/under/pencilskirt
	name = "pencilskirt"
	desc = "A black pencil skirt."
	icon_state = "newskirt"
	item_state = "newskirt"
	item_color = "newskirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/rank/magistrate
	name = "magistrate's uniform"
	desc = "An expensive gray suit with black dress shirt and tie, perfect for upholding the law."
	icon_state = "vice"
	item_state = "gy_suit"
	item_color = "vice"

/obj/item/clothing/under/sapphiredress
	name = "Sapphire Dress"
	desc = "A full length blue dress."
	icon_state = "sapphiredress"
	item_state = "sapphiredress"
	item_color = "sapphiredress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/ssapphiredress
	name = "Blue Dress"
	desc = "A short blue dress."
	icon_state = "ssapphiredress"
	item_state = "ssapphiredress"
	item_color = "ssapphiredress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/waitress
	name = "Waitress Uniform"
	desc = "A waitress uniform. Please tip generously."
	icon_state = "waitress"
	item_state = "waitress"
	item_color = "waitress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/maid
	name = "Maid Uniform"
	desc = "I didn't know we were in Japan."
	icon_state = "maid"
	item_state = "maid"
	item_color = "maid"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

//Nanotrasen Military Uniforms
/obj/item/clothing/under/mil/marine
	name = "Marine's uniform"
	desc = "It's a short sleeved Nanotrasen Marine uniform."
	icon_state = "marineuniform"
	item_state = "bl_suit"
	item_color = "marineuniform"

/obj/item/clothing/under/mil/marine/long
	name = "Marine's uniform"
	desc = "It's a long sleeved Nanotrasen Marine uniform."
	item_color = "marineuniforml"

/obj/item/clothing/under/mil/marine/dress
	name = "NT Navy uniform"
	desc = "It's a Nanotrasen Marine dress uniform."
	item_color = "marinedress"

/obj/item/clothing/under/mil/marine/sergeant
	name = "Marine Sergeant's uniform"
	desc = "A short sleeved Nanotrasen Marine uniform, with the rank insignia of a Sergeant."
	icon_state = "marineuniformsergeant"
	item_color = "marineuniformsergeant"

/obj/item/clothing/under/mil/marine/officer
	name = "Marine Officer's uniform"
	desc = "A long sleeved Nanotrasen Marine uniform for Officers."
	icon_state = "marineuniformsergeant"
	item_color = "marineofficer"

/obj/item/clothing/under/mil/navy/
	name = "Navy Rating's uniform"
	desc = "It's the standard enlisted uniform of the Nanotrasen Navy."
	icon_state = "navyofficer1"
	item_state = "bl_suit"
	item_color = "navyenlisted"

/obj/item/clothing/under/mil/navy/jofficer
	name = "Navy Junior Officer's uniform"
	desc = "It's a long sleeved Nanotrasen Navy uniform, worn by junior officers."
	icon_state = "navyofficer1"
	item_color = "navyjofficer"

/obj/item/clothing/under/mil/navy/sofficer
	name = "NT Navy Senior Officer's uniform"
	desc = "A long sleeved Nanotrasen Navy uniform for senior officers."
	icon_state = "navyofficer2"
	item_color = "navysofficer"

/obj/item/clothing/under/mil/navy/fofficer
	name = "NT Navy Flag Officer uniform"
	desc = "A long sleeved Nanotrasen Navy uniform, with the rank insignia of a Flag Officer."
	icon_state =  "navyofficer2"
	item_color = "navyfofficer"

/obj/item/weapon/storage/belt/security/marine
	name = "Marine combat belt"
	desc = "Can hold gear like grenades and ammunition."
	icon_state = "marinebelt"
	item_state = "marinebelt"
	storage_slots = 9
	max_w_class = 3
	max_combined_w_class = 21

/obj/item/weapon/storage/backpack/marine
	name = "Marine rucksack"
	desc = "It's a pack for combat, with inbuilt radio"
	icon_state = "marine"
	item_state = "marine"

//Marine Armour

/obj/item/clothing/head/helmet/tactical/marine
	name = "Marine helmet"
	desc = "A combat helmet used by NT Marines."
	icon_state = "marine-helmet"
	item_state = "marine-helmet"

/obj/item/clothing/suit/armor/tactical/marineheavy
	name = "Marine heavy armor"
	desc = "NT Marine heavy armor, provides the best protection at the cost of mobility."
	icon_state = "marine-armor-heavy"
	item_state = "marine-armor-heavy"
	armor = list(melee = 70, bullet = 70, laser = 70, energy = 50, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/marinemed
	name = "Marine medium armor"
	desc = "NT Marine medium armor ."
	icon_state = "marine-armor-med"
	item_state = "marine-armor-med"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/marinelight
	name = "Marine light armor"
	desc = "NT Marine light armor, generally worn in non-combat zones."
	icon_state = "marine-armor-light"
	item_state = "marine-armor-light"

//Obsedai
/obj/item/clothing/under/obsedai
	name = "Obsedai webbing"
	desc = "A webbing harness used by Obsedai to store things. It is far too large to be worn by other species."
	species_restricted = list("Obsedai")
	icon_state = "obsedai"
	item_state = "obsedai"
	item_color = "obsedai"

//Made this a seperate file for ease of updating.