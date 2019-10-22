//NASA Voidsuit
/obj/item/clothing/head/helmet/space/void
	name = "void helmet"
	desc = "A high-tech dark red space suit helmet. Used for AI satellite maintenance."
	icon_state = "void"

	heat_protection = HEAD
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_MINOR
		)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = VOIDSUIT_MAX_PRESSURE
	min_pressure_protection = 0
	siemens_coefficient = 0.4

	//Species-specific stuff.
	species_restricted = list(SPECIES_HUMAN, SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_helmet_unathi.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi',
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/obj_head_unathi.dmi',
		SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_head_skrell.dmi',
		)

	light_overlay = "helmet_light"

/obj/item/clothing/suit/space/void
	name = "voidsuit"
	icon_state = "void"
	w_class = ITEM_SIZE_HUGE//bulky item
	desc = "A high-tech dark red space suit. Used for AI satellite maintenance."
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_MINOR
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = VOIDSUIT_MAX_PRESSURE
	siemens_coefficient = 0.4

	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_suit_skrell.dmi',
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/obj_suit_unathi.dmi',
		SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_suit_skrell.dmi',
		)

	//Breach thresholds, should ideally be inherited by most (if not all) voidsuits.
	//With 0.2 resiliance, will reach 10 breach damage after 3 laser carbine blasts or 8 smg hits.
	breach_threshold = 15
	can_breach = 1

	//Inbuilt devices.
	var/obj/item/clothing/shoes/magboots/boots = null // Deployable boots, if any.
	var/obj/item/clothing/head/helmet/helmet = null   // Deployable helmet, if any.
	var/obj/item/weapon/tank/tank = null              // Deployable tank, if any.

	action_button_name = "Toggle Helmet"
	var/helmet_deploy_sound = 'sound/items/helmet_close.ogg'
	var/helmet_retract_sound = 'sound/items/helmet_open.ogg'

#define VOIDSUIT_INIT_EQUIPMENT(equipment_var, expected_path) \
if(ispath(##equipment_var, ##expected_path )){\
	##equipment_var = new equipment_var (src);\
}\
else if(##equipment_var) {\
	CRASH("[log_info_line(src)] has an invalid [#equipment_var] type: [log_info_line(##equipment_var)]");\
}

/obj/item/clothing/suit/space/void/Initialize()
	. = ..()
	VOIDSUIT_INIT_EQUIPMENT(boots,  /obj/item/clothing/shoes/magboots)
	VOIDSUIT_INIT_EQUIPMENT(helmet, /obj/item/clothing/head/helmet)
	VOIDSUIT_INIT_EQUIPMENT(tank,   /obj/item/weapon/tank)

#undef VOIDSUIT_INIT_EQUIPMENT

/obj/item/clothing/suit/space/void/Destroy()
	. = ..()
	QDEL_NULL(boots)
	QDEL_NULL(helmet)
	QDEL_NULL(tank)

/obj/item/clothing/suit/space/void/examine(user,distance)
	. = ..()
	var/list/part_list = new
	for(var/obj/item/I in list(helmet,boots,tank))
		part_list += "\a [I]"
	to_chat(user, "\The [src] has [english_list(part_list)] installed.")
	if(tank && distance <= 1)
		to_chat(user, "<span class='notice'>The wrist-mounted pressure gauge reads [max(round(tank.air_contents.return_pressure()),0)] kPa remaining in \the [tank].</span>")

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

	if(boots)
		if (H.equip_to_slot_if_possible(boots, slot_shoes))
			boots.canremove = 0

	if(helmet)
		if(H.head)
			to_chat(M, "You are unable to deploy your suit's helmet as \the [H.head] is in the way.")
		else if (H.equip_to_slot_if_possible(helmet, slot_head))
			to_chat(M, "Your suit's helmet deploys with a hiss.")
			playsound(loc, helmet_deploy_sound, 30)
			helmet.canremove = 0

	if(tank)
		if(H.s_store) //In case someone finds a way.
			to_chat(M, "Alarmingly, the valve on your suit's installed tank fails to engage.")
		else if (H.equip_to_slot_if_possible(tank, slot_s_store))
			to_chat(M, "The valve on your suit's installed tank safely engages.")
			tank.canremove = 0


/obj/item/clothing/suit/space/void/dropped()
	..()

	var/mob/living/carbon/human/H

	if(helmet)
		helmet.canremove = 1
		H = helmet.loc
		if(istype(H))
			if(helmet && H.head == helmet)
				H.drop_from_inventory(helmet, src)

	if(boots)
		boots.canremove = 1
		H = boots.loc
		if(istype(H))
			if(boots && H.shoes == boots)
				H.drop_from_inventory(boots, src)

	if(tank)
		tank.canremove = 1
		tank.forceMove(src)

/obj/item/clothing/suit/space/void/verb/toggle_helmet()

	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(!helmet)
		to_chat(usr, "There is no helmet installed.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.incapacitated()) return
	if(H.wear_suit != src) return

	if(H.head == helmet)
		to_chat(H, "<span class='notice'>You retract your suit helmet.</span>")
		helmet.canremove = 1
		playsound(loc, helmet_retract_sound, 30)
		H.drop_from_inventory(helmet, src)
	else
		if(H.head)
			to_chat(H, "<span class='danger'>You cannot deploy your helmet while wearing \the [H.head].</span>")
			return
		if(H.equip_to_slot_if_possible(helmet, slot_head))
			helmet.pickup(H)
			helmet.canremove = 0
			playsound(loc, helmet_deploy_sound, 30)
			to_chat(H, "<span class='info'>You deploy your suit helmet, sealing you off from the world.</span>")
	helmet.update_light(H)

/obj/item/clothing/suit/space/void/verb/eject_tank()

	set name = "Eject Voidsuit Tank"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(!tank)
		to_chat(usr, "There is no tank inserted.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.incapacitated()) return
	var/slot = H.get_inventory_slot(src)
	if(slot != slot_wear_suit && slot != slot_l_hand && slot != slot_r_hand) return// let them eject those tanks when they're in hand or stuff for ease of use


	to_chat(H, "<span class='info'>You press the emergency release, ejecting \the [tank] from your suit.</span>")
	tank.canremove = 1
	H.drop_from_inventory(tank, src)
	H.put_in_hands(tank)
	src.tank = null
	playsound(loc, 'sound/effects/spray3.ogg', 50)

/obj/item/clothing/suit/space/void/attackby(obj/item/W as obj, mob/user as mob)

	if(!istype(user,/mob/living)) return

	if(istype(W,/obj/item/clothing/accessory) || istype(W, /obj/item/weapon/hand_labeler))
		return ..()

	if(istype(W,/obj/item/weapon/screwdriver))
		if(user.get_inventory_slot(src) == slot_wear_suit)//maybe I should make this into a proc?
			to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
			return

		if(helmet || boots || tank)
			var/choice = input("What component would you like to remove?") as null|anything in list(helmet,boots,tank)
			if(!choice) return

			playsound(loc, 'sound/items/Screwdriver.ogg', 50)
			if(choice == tank)	//No, a switch doesn't work here. Sorry. ~Techhead
				to_chat(user, "You pop \the [tank] out of \the [src]'s storage compartment.")
				user.put_in_hands(tank)
				src.tank = null
			else if(choice == helmet)
				to_chat(user, "You detatch \the [helmet] from \the [src]'s helmet mount.")
				user.put_in_hands(helmet)
				src.helmet = null
			else if(choice == boots)
				to_chat(user, "You detatch \the [boots] from \the [src]'s boot mounts.")
				user.put_in_hands(boots)
				src.boots = null
		else
			to_chat(user, "\The [src] does not have anything installed.")
		return
	else if(istype(W,/obj/item/clothing/head/helmet/space))
		if(user.get_inventory_slot(src) == slot_wear_suit)
			to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
			return
		if(helmet)
			to_chat(user, "\The [src] already has a helmet installed.")
		else
			if(!user.unEquip(W, src))
				return
			to_chat(user, "You attach \the [W] to \the [src]'s helmet mount.")
			src.helmet = W
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		return
	else if(istype(W,/obj/item/clothing/shoes/magboots))
		if(user.get_inventory_slot(src) == slot_wear_suit)
			to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
			return
		if(boots)
			to_chat(user, "\The [src] already has magboots installed.")
		else
			if(!user.unEquip(W, src))
				return
			to_chat(user, "You attach \the [W] to \the [src]'s boot mounts.")
			boots = W
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		return
	else if(istype(W,/obj/item/weapon/tank))
		if(user.get_inventory_slot(src) == slot_wear_suit)
			to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
			return
		if(tank)
			to_chat(user, "\The [src] already has an airtank installed.")
		else
			if(!user.unEquip(W, src))
				return
			to_chat(user, "You insert \the [W] into \the [src]'s storage compartment.")
			tank = W
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		return

	..()

/obj/item/clothing/suit/space/void/attack_self() //sole purpose of existence is to toggle the helmet
	toggle_helmet()

/obj/item/clothing/suit/space/void/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(tank && slot == slot_back)
		ret.overlays += tank.get_mob_overlay(user_mob, slot_back_str)
	return ret