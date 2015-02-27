//NASA Voidsuit
/obj/item/clothing/head/helmet/space/void
	name = "void helmet"
	desc = "A high-tech dark red space suit helmet. Used for AI satellite maintenance."
	icon_state = "void"
	item_state = "void"

	heat_protection = HEAD
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

	//Species-specific stuff.
	species_restricted = list("exclude","Unathi","Tajara","Skrell","Diona","Vox", "Xenomorph", "Xenomorph Drone", "Xenomorph Hunter", "Xenomorph Sentinel", "Xenomorph Queen")
	sprite_sheets_refit = list(
		"Unathi" = 'icons/mob/species/unathi/helmet.dmi',
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi',
		"Skrell" = 'icons/mob/species/skrell/helmet.dmi',
		)
	sprite_sheets_obj = list(
		"Unathi" = 'icons/obj/clothing/species/unathi/hats.dmi',
		"Tajara" = 'icons/obj/clothing/species/tajaran/hats.dmi',
		"Skrell" = 'icons/obj/clothing/species/skrell/hats.dmi',
		)

	light_overlay = "helmet_light"

/obj/item/clothing/suit/space/void
	name = "voidsuit"
	icon_state = "void"
	item_state = "void"
	desc = "A high-tech dark red space suit. Used for AI satellite maintenance."
	slowdown = 1
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

	species_restricted = list("exclude","Unathi","Tajara","Diona","Vox", "Xenomorph", "Xenomorph Drone", "Xenomorph Hunter", "Xenomorph Sentinel", "Xenomorph Queen")
	sprite_sheets_refit = list(
		"Unathi" = 'icons/mob/species/unathi/suit.dmi',
		"Tajara" = 'icons/mob/species/tajaran/suit.dmi',
		"Skrell" = 'icons/mob/species/skrell/suit.dmi',
		)
	sprite_sheets_obj = list(
		"Unathi" = 'icons/obj/clothing/species/unathi/suits.dmi',
		"Tajara" = 'icons/obj/clothing/species/tajaran/suits.dmi',
		"Skrell" = 'icons/obj/clothing/species/skrell/suits.dmi',
		)

	//Breach thresholds, should ideally be inherited by most (if not all) voidsuits.
	//With 0.2 resiliance, will reach 10 breach damage after 3 laser carbine blasts or 8 smg hits.
	breach_threshold = 18
	can_breach = 1

	//Inbuilt devices.
	var/obj/item/clothing/shoes/magboots/boots = null // Deployable boots, if any.
	var/obj/item/clothing/head/helmet/helmet = null   // Deployable helmet, if any.

/obj/item/clothing/suit/space/void/refit_for_species(var/target_species)
	..()
	if(istype(helmet))
		helmet.refit_for_species(target_species)
	if(istype(boots))
		boots.refit_for_species(target_species)

/obj/item/clothing/suit/space/void/equipped(mob/M)
	..()

	var/mob/living/carbon/human/H = M

	if(!istype(H)) return

	if(H.wear_suit != src)
		return

	if(helmet)
		if(H.head)
			M << "You are unable to deploy your suit's helmet as \the [H.head] is in the way."
		else if (H.equip_to_slot_if_possible(helmet, slot_head))
			M << "Your suit's helmet deploys with a hiss."
			helmet.canremove = 0

	if(boots)
		if(H.shoes)
			M << "You are unable to deploy your suit's magboots as \the [H.shoes] are in the way."
		else if (H.equip_to_slot_if_possible(boots, slot_shoes))
			M << "Your suit's boots deploy with a hiss."
			boots.canremove = 0

/obj/item/clothing/suit/space/void/dropped()
	..()

	var/mob/living/carbon/human/H

	if(helmet)
		H = helmet.loc
		if(istype(H))
			if(helmet && H.head == helmet)
				helmet.canremove = 1
				H.drop_from_inventory(helmet)
				helmet.loc = src

	if(boots)
		H = boots.loc
		if(istype(H))
			if(boots && H.shoes == boots)
				boots.canremove = 1
				H.drop_from_inventory(boots)
				boots.loc = src

/obj/item/clothing/suit/space/void/verb/toggle_helmet()

	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(!helmet)
		usr << "There is no helmet installed."
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.stat) return
	if(H.wear_suit != src) return

	if(H.head == helmet)
		H << "\blue You retract your suit helmet."
		helmet.canremove = 1
		H.drop_from_inventory(helmet)
		helmet.loc = src
	else
		if(H.head)
			H << "<span class='danger'>You cannot deploy your helmet while wearing another helmet.</span>"
			return
		if(H.equip_to_slot_if_possible(helmet, slot_head))
			helmet.pickup(H)
			helmet.canremove = 0
			H << "<font color='blue'><b>You deploy your suit helmet, sealing you off from the world.</b></font>"
	helmet.update_light(H)

/obj/item/clothing/suit/space/void/attackby(obj/item/W as obj, mob/user as mob)

	if(!istype(user,/mob/living)) return

	if(istype(src.loc,/mob/living))
		user << "<span class='danger'>How do you propose to modify a hardsuit while it is being worn?</span>"
		return

	if(istype(W,/obj/item/weapon/screwdriver))
		if(helmet)
			user << "You detatch \the [helmet] from \the [src]'s helmet mount."
			helmet.loc = get_turf(src)
			src.helmet = null
		else if (boots)
			user << "You detatch \the [boots] from \the [src]'s boot mounts."
			boots.loc = get_turf(src)
			src.boots = null
		else
			user << "\The [src] does not have anything installed."
		return
	else if(istype(W,/obj/item/clothing/head/helmet/space))
		if(helmet)
			user << "\The [src] already has a helmet installed."
		else
			user << "You attach \the [W] to \the [src]'s helmet mount."
			user.drop_item()
			W.loc = src
			src.helmet = W
		return
	else if(istype(W,/obj/item/clothing/shoes/magboots))
		if(boots)
			user << "\The [src] already has magboots installed."
		else
			user << "You attach \the [W] to \the [src]'s boot mounts."
			user.drop_item()
			W.loc = src
			boots = W
		return

	..()