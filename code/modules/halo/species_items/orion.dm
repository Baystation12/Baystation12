
/mob/living/carbon/human/Orion/New(var/new_loc)
	. = ..(new_loc,"Orion")

/obj/item/organ/internal/heart/spartan/theta
	name = "Augmented Heart"
	desc = "This augmented heart has been inlaced with nanites which allow it to incur substanstially more damage then a normal heart can."

/obj/item/organ/internal/liver/spartan/theta
	//Equivalent to Spartan Liver
	name = "Augmented liver"
	desc = "This augmented liver is enhanced with nanites which allow the implantee to ingest double the normal amount of toxins any other human can, as well as toughen it's outer layers significantly."

/obj/item/organ/internal/eyes/occipital_reversal/theta
	name = "Augmented Eyeballs"
	desc = "These Augmented eyeballs are enhanced with nanites which automatically provide in built flash protection, as well as toughen the organ a significant amount."
	max_damage = 60

/obj/item/organ/internal/lungs/theta
	name = "Augmented Lungs"
	desc = "These augmented lungs have been enhanced with nanites which allow for tougher membranes as well as the implantee needing half of a normal person's air pressure to survive."
	min_breath_pressure = 8
	max_damage = 90
	min_bruised_damage = 35
	min_broken_damage = 60

/obj/item/clothing/under/psysuit/theta
	name = "Orion Undersuit"
	desc = "A prototype thick, layered grey undersuit lined with power cables and flexible nano composite plates."
	species_restricted = list("Orion")

/obj/item/clothing/head/helmet/innie/urfdefector
	name = "H34D Dome Protector"
	desc = "A X-52 prototype Helmet made from flexible high grade metals meant to intimidate the wearer's foes and for use by an Orion Project subject. Any common soldier should fear the person who is seen wearing this helmet."
	armor = list(melee = 60,bullet = 35,laser = 25,energy = 25,bomb = 35,bio = 100,rad = 25)
	armor_thickness = 20
	icon = 'code/modules/halo/clothing/inniearmor.dmi'
	icon_override = 'code/modules/halo/clothing/inniearmor.dmi'
	icon_state = "defectorhelm"
	item_state = "defectorhelm"
	species_restricted = list("Orion")

/obj/item/clothing/suit/storage/innie/urfdefector
	name = "I25B Heavy Chest Rig"
	desc = "A X-52 prototype heavily armored suit of flexible nano composite materials. It is intended to be worn by a subject of project Orion. Any common soldier should fear the person who wears this armor."
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic)
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 60, bio = 100, rad = 25)
	species_restricted = list("Orion")
	icon = 'code/modules/halo/clothing/inniearmor.dmi'
	icon_override = 'code/modules/halo/clothing/inniearmor.dmi'
	icon_state = "defectorarmour"
	item_state = "defectorarmour"
	flags_inv = 0

/obj/item/clothing/gloves/marine/orion
	desc = "A prototype pair of synthetic gloves and arm pads reinforced with armor plating. Meant to be worn by a subject of the Project Orion Program."
	name = "Orion Arm Guards"
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 35, bio = 0, rad = 0)
	species_restricted = list("Orion")

/obj/item/clothing/shoes/marine/orion
	name = "Orion Boots"
	desc = "These boots have been inlaced with armor plates to provide far better protection then your normal set of boots. Meant to be worn by a subject of the Project Orion Program."
	armor = list(melee = 40, bullet = 40, laser = 5, energy = 20, bomb = 50, bio = 0, rad = 0)
	species_restricted = list("Orion")

/obj/item/weapon/gun/projectile/automatic/z8/orion
	name = "M98 All Purpose Carbine"
	desc = "This weapon was produced and funded by the UNSC for the Orion Project subjects operational use. Designed with high accuracy and easy maneuverability in combat situations, it was quickly discontinued because of it's high price range and extravagant material costs to create. It is highly versatile being capable of utilizing any and all 7.62 magazines found in the field. If attachments can be found, this carbine is capable of using them. It can be fired one handed with an accuracy penalty."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MA9"
	item_state = "ma5b"
	caliber = "a762"
	one_hand_penalty = -1
	w_class = ITEM_SIZE_LARGE
	wielded_item_state = "ma5b"
	fire_sound = 'code/modules/halo/sounds/MA3firefix.ogg'
	reload_sound = 'code/modules/halo/sounds/MA3reload.ogg'
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 5, TECH_ILLEGAL = 4)
	ammo_type = /obj/item/ammo_casing/a762
	magazine_type = /obj/item/ammo_magazine/m762_ap
	allowed_magazines = list(/obj/item/ammo_magazine/c762, /obj/item/ammo_magazine/m762_ap, /obj/item/ammo_magazine/c762, /obj/item/ammo_magazine/m762_ap/MA5B/TTR)
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

	firemodes = list(
		list(mode_name="Semiauto",       burst=1,    fire_delay=0,    move_delay=null, use_launcher=null, one_hand_penalty=4, burst_accuracy=(1), dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=5,    use_launcher=null, one_hand_penalty=5, burst_accuracy=list(0,0,-1), dispersion=list(0.0, 0.6, 0.8))
		)

	attachment_slots = list("sight","stock","barrel")
	//This is Here because the MA5B spawns with a stock.
	attachments_on_spawn = null

/obj/item/weapon/gun/projectile/automatic/z8/theta/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "MA9"
	else
		icon_state = "MA9_unloaded"