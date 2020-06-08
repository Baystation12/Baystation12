
// Power cell to be used in the spartan hardsuits
/obj/item/weapon/cell/infinite/microfusion_cell
	name = "microfusion cell"
	desc = "The microfusion cell is the most vital component to the Mjolnir system, as it provides power to all components of the armor, providing near unlimited power."
	icon = 'code/modules/halo/unsc/items.dmi'
	icon_state = "cell"
	origin_tech =  null
	maxcharge = 3000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)

//Hardsuit items

//To make custom/additional hardsuits, just copy one of the childs of /obj/item/weapon/rig/spartan and edit
//their chest, head, glove and shoes types to the appropriate path.
/obj/item/weapon/rig/spartan
	name = "powered assault armor"
	icon = 'code/modules/halo/unsc/items.dmi'
	desc = "A technologically advanced combat exoskeleton system designed to vastly improve the strength, speed, agility, reflexes and durability of a Spartan supersoldier."
	//suit_type = "Spartan" //Display is disabled, therefore redundant
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 55, bomb = 40, bio = 25, rad = 25) //Same values as the chest armor. Shouldn't have any impact on gameplay however.
	emp_protection = 0 //Will change this value to 100 if it prove to be a burden.
	online_slowdown = 0 //Default = 6
	offline_slowdown = 0 //Default = 10
	hides_uniform = 0

	initial_modules = list(
	/obj/item/rig_module/maneuvering_jets,\
	/obj/item/rig_module/ai_container)

	air_type = /obj/item/weapon/tank/oxygen
	cell_type = /obj/item/weapon/cell/infinite/microfusion_cell

/obj/item/weapon/rig/spartan/mjolnir_mk4
	name = "Mark IV MJOLNIR Powered Assault Armor"
	icon_state = "mjolnir"
	desc = "A Mark IV MJOLNIR Powered Assault Armor. The first version of the MJOLNIR Powered Assault Armor series."
	chest_type = /obj/item/clothing/suit/armor/special/spartan
	helm_type = /obj/item/clothing/head/helmet/spartan
	boot_type = /obj/item/clothing/shoes/magboots/spartan
	glove_type = /obj/item/clothing/gloves/spartan

/obj/item/weapon/rig/spartan/mjolnir_mk5
	name = "Mark V Mjolnir Powered Assault Armor"
	desc = "The Mjolnir Mark V is the first major upgrade of the system and introduced two revolutionary technologies for battlefield purposes: energy shielding reverse-engineered from Covenant technology, providing the user added protection against plasma weapons, and the ability to link a soldier and an artificial intelligence together to provide the soldier instant intel in the field, along with other functions."
	icon_state = "mjolnir"

	chest_type = /obj/item/clothing/suit/armor/special/spartan/mkv
	helm_type = /obj/item/clothing/head/helmet/spartan/mkv
	boot_type = /obj/item/clothing/shoes/magboots/spartan
	glove_type = /obj/item/clothing/gloves/spartan

/obj/item/weapon/rig/spartan/mjolnir_mk5_gungir
	name = "Mark V GUNGIR-class Mjolnir Powered Assault Armor "
	desc = "The Mark V GUNGIR-class MJOLNIR is the first major upgrade of the system and introduced two revolutionary technologies for battlefield purposes: energy shielding reverse-engineered from Covenant technology, providing the user added protection against plasma weapons, and the ability to link a soldier and an artificial intelligence together to provide the soldier instant intel in the field, along with other functions."
	icon_state = "mjolnir"

	chest_type = /obj/item/clothing/suit/armor/special/spartan/mkv_gungnir
	helm_type = /obj/item/clothing/head/helmet/spartan/mkv_gungnir
	boot_type = /obj/item/clothing/shoes/magboots/spartan
	glove_type = /obj/item/clothing/gloves/spartan

//Disabled due to missing gear in the code)
/*
/obj/item/weapon/rig/spartan/mjolnir_mk5_commando
	name = "Mark V Mjolnir Powered Assault Armor"
	desc = "The Mjolnir Mark V is the first major upgrade of the system and introduced two revolutionary technologies for battlefield purposes: energy shielding reverse-engineered from Covenant technology, providing the user added protection against plasma weapons, and the ability to link a soldier and an artificial intelligence together to provide the soldier instant intel in the field, along with other functions."
	icon_state = "mjolnir"

	chest_type = /obj/item/clothing/suit/armor/special/spartan/mkv
	helm_type = /obj/item/clothing/head/helmet/spartan/mkv_commando
	boot_type = /obj/item/clothing/shoes/magboots/spartan
	glove_type = /obj/item/clothing/gloves/spartan
*/

//Disabled due to missing gear in the code)
/*
/obj/item/weapon/rig/spartan/mjolnir_mk5_airassault
	name = "Mark V AIR ASSAULT-class Mjolnir Powered Assault Armor"
	desc = "The AIR ASSAULT-class MJOLNIR Mark V was designed to offer key advantages during airborne deployment scenarios. It has specialized optics that can provide real-time satellite imagery and enemy signature allocation."
	icon_state = "mjolnir"

	chest_type = /obj/item/clothing/suit/armor/special/spartan/mkv
	helm_type = /obj/item/clothing/head/helmet/spartan/mkv_airassault
	boot_type = /obj/item/clothing/shoes/magboots/spartan
	glove_type = /obj/item/clothing/gloves/spartan
*/

//Disabled due to missing gear in the code)
/*
/obj/item/weapon/rig/spartan/mjolnir_mk5_nobleteam
	name = "Mark V Mjolnir Powered Assault Armor Noble Team"
	desc = "The GEN1 MJOLNIR Mark V Air Assault was designed to offer key advantages during airborne deployment scenarios. It has specialized optics that can provide real-time satellite imagery and enemy signature allocation."
	icon_state = "mjolnir"

	chest_type = /obj/item/clothing/suit/armor/special/spartan/mkv
	helm_type = /obj/item/clothing/head/helmet/spartan/mkv_noblesix
	boot_type = /obj/item/clothing/shoes/magboots/spartan
	glove_type = /obj/item/clothing/gloves/spartan
*/
