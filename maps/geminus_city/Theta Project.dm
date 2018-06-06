/obj/item/clothing/shoes/swat/theta
	name = "Theta Boots"
	desc = "These boots have been inlaced with armor plates to provide far better protection then your normal set of boots. Meant to be worn by the subject of the Project Theta Program."
	armor = list("melee" = 20, "bullet" = 20, "laser" = 30, "energy" = 25, "bomb" = 50, "bio" = 0, "rad" = 0)
	armor_thickness = 5

/obj/item/clothing/gloves/guards/theta
	desc = "A prototype pair of synthetic gloves and arm pads reinforced with armor plating. Meant to be worn by the subject of the Project Theta Program."
	name = "Theta Arm Guards"
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 10, "bomb" = 20, "bio" = 0, "rad" = 0)
	armor_thickness = 5

/obj/item/clothing/under/psysuit/theta
	name = "Theta Undersuit"
	desc = "A prototype thick, layered grey undersuit lined with power cables and flexible nano composite plates. This might be the only piece of equipment which is actually better made then what the spartan program has."
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10, "energy" = 10, "bomb" = 10, "bio" = 0, "rad" = 0)
	armor_thickness = 10

/obj/item/clothing/suit/space/void/swat/theta
	name = "Theta Armor"
	desc = "A prototype heavily armored suit of flexible nano composite materials. It is intended to be worn by the subject of project Theta. Any common soldier should fear the person who wears this armor."
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic)
	armor = list("melee" = 65, "bullet" = 65, "laser" = 55, "energy" = 45, "bomb" = 60, "bio" = 0, "rad" = 0)
	armor_thickness = 50
	flags_inv = 29
	slowdown_general = -1
	breach_threshold = 100
	flags_inv = HIDESHOES

/obj/item/clothing/suit/space/void/swat/theta/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0

/obj/item/clothing/suit/space/void/swat/theta/handle_shield(mob/user, atom/damage_source = null, var/damage, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(istype(damage_source, /obj/item/projectile/bullet))
		var/obj/item/projectile/P = damage_source

		var/reflectchance = 35 - round(damage/3)
		if(!(def_zone)) //Should cause the chest to reflect bullets,to punish people aiming center mass.
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text] off of the Theta Armor's metal plates!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)

			return PROJECTILE_CONTINUE // complete projectile permutation

/obj/item/clothing/head/helmet/space/deathsquad/theta
	name = "Theta Helmet"
	desc = "A prototype Helmet made from flexible high grade metals meant to mimic the spartan armor and for use by the Theta Project subject. Any common soldier should fear the person who is seen wearing this helmet."
	armor = list("melee" = 70, "bullet" = 65, "laser" = 45, "energy" = 30, "bomb" = 50, "bio" = 0, "rad" = 0)
	armor_thickness = 40

/obj/item/clothing/head/helmet/space/deathsquad/theta/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0

/obj/item/clothing/head/helmet/space/deathsquad/theta/handle_shield (mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = BP_HEAD, var/attack_text = "the attack")

	if(istype(damage_source, /obj/item/projectile/bullet))
		var/obj/item/projectile/P = damage_source

		var/reflectchance = 20 - round(damage/3)
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text] off of the Theta Helmet's metal plates!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)

			return PROJECTILE_CONTINUE // complete projectile permutation

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

//Testing out New Gun for Theta Project, may not end up using this.
/obj/item/weapon/gun/projectile/automatic/z8/theta
	name = "MA3 All Purpose Carbine"
	desc = "This weapon was designed and funded by anti-UNSC factions as their reaction to the standard MA5B assault rifle. Designed with high accuracy and easy maneuverability in combat situations, it was quickly discontinued because of it's high price range. It is highly versatile being capable of utilizing any and all 7.62 magazines found in the field. If attachments can be found, this carbine is capable of using them. It can be fired one handed with an accuracy penalty."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MA3"
	item_state = "ma5b"
	caliber = "a762"
	burst_delay = 0.5
	wielded_item_state = "ma5b"
	fire_sound = 'code/modules/halo/sounds/MA3firefix.ogg'
	reload_sound = 'code/modules/halo/sounds/MA3reload.ogg'
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5, TECH_ILLEGAL = 4)
	ammo_type = /obj/item/ammo_casing/a762
	magazine_type = /obj/item/ammo_magazine/m762_ap
	allowed_magazines = list(/obj/item/ammo_magazine/box/a762, /obj/item/ammo_magazine/c762, /obj/item/ammo_magazine/m762_ap, /obj/item/ammo_magazine/c762)
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

	firemodes = list(
		list(mode_name="Semiauto",       burst=1,    fire_delay=0,    move_delay=null, use_launcher=null, one_hand_penalty=4, burst_accuracy=(1), dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=5,    use_launcher=null, one_hand_penalty=5, burst_accuracy=list(0,0,-1), dispersion=list(0.0, 0.6, 0.8))
		)

	attachment_slots = list("sight","stock","barrel")

/obj/item/weapon/gun/projectile/automatic/z8/theta/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "MA3"
	else
		icon_state = "MA3_unloaded"