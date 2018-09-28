
/*Slayer outfits have a few restrictions to ensure that multiple species can be used.
A slayer outfit will have to have a corresponding type for any species that is involved in a slayer gamemode
The name of the outfit will need to be "[job name] [species name]"
 */

/decl/hierarchy/outfit/job/slayer
	name = "Neutral Team Slayer outfit"

	flags = 0// Stops backpack from spawning on char's back.

	uniform = /obj/item/clothing/under/utility//	/obj/item/clothing/under/unsc/odst
	back = /obj/item/weapon/gun/projectile/ma5b_ar
	belt = /obj/item/weapon/grenade/frag/m9_hedp
	gloves = /obj/item/clothing/gloves/thick/combat
	shoes = /obj/item/clothing/shoes/marine
	mask = /obj/item/clothing/mask/gas/syndicate
	l_pocket = /obj/item/ammo_magazine/m762_ap
	r_pocket = /obj/item/weapon/tank/emergency/oxygen
	suit_store = /obj/item/weapon/gun/projectile/m6d_magnum

/decl/hierarchy/outfit/job/slayer/neutral_spartan
	name = "Spartan Slayer Spartan"
	uniform = null
	suit = /obj/item/clothing/suit/armor/special/spartan
	head = /obj/item/clothing/head/helmet/spartan

/decl/hierarchy/outfit/job/slayer/red_spartan
	name = "Red Team Spartan Spartan" //Doubled "Spartan" is due to the jobname being "Red Team Spartan" and the species being "Spartan"
	uniform = null
	suit = /obj/item/clothing/suit/armor/special/spartan/red
	head = /obj/item/clothing/head/helmet/spartan/red

/decl/hierarchy/outfit/job/slayer/blue_spartan
	name = "Blue Team Spartan Spartan"
	uniform = null
	suit = /obj/item/clothing/suit/armor/special/spartan/blue
	head = /obj/item/clothing/head/helmet/spartan/blue

/decl/hierarchy/outfit/sangheili_slayer
	name = "Elites Sangheili"

	uniform = /obj/item/clothing/under/covenant/sangheili
	l_ear = /obj/item/device/radio/headset/covenant
	suit = /obj/item/clothing/suit/armor/special/combatharness/minor
	suit_store = /obj/item/weapon/gun/energy/plasmarifle
	back = /obj/item/weapon/gun/energy/plasmarifle
	belt = /obj/item/weapon/gun/energy/plasmapistol
	shoes = /obj/item/clothing/shoes/sangheili/minor
	head = /obj/item/clothing/head/helmet/sangheili/minor

/decl/hierarchy/outfit/job/slayer/spartan_slayer_covenant
	name = "Spartans Spartan"
	uniform = null
	suit = /obj/item/clothing/suit/armor/special/spartan/slayer
	head = /obj/item/clothing/head/helmet/spartan/slayer