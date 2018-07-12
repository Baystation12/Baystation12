#define ODST_OVERRIDE 'code/modules/halo/clothing/odst.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/odst_items.dmi'

/obj/item/clothing/under/unsc/odst_jumpsuit
	name = "ODST jumpsuit"
	desc = "standard issue ODST jumpsuits, padded to provide a slight edge."
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	item_state = "Jumpsuit"
	icon_state = "Jumpsuit"
	worn_state = "ODST Jumpsuit"
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/head/helmet/odst
	name = "ODST Helmet"
	desc = "Standard issue short-EVA capable helmet issued to ODST forces"
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	item_state = "Odst Helmet"
	icon_state = "Helmet"
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 60, bullet = 35, laser = 25,energy = 25, bomb = 25, bio = 0, rad = 5)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/clothing/suit/armor/odst
	name = "ODST Armour"
	desc = "Lightweight, durable armour issued to Orbital Drop Shock Troopers for increased survivability in the field."
	icon = ITEM_INHAND
	icon_state = "Odst Armour"
	icon_override = ODST_OVERRIDE
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 45, laser = 55, energy = 45, bomb = 45, bio = 30, rad = 25)
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)
	armor_thickness = 20
	allowed = list(/obj/item/weapon/tank)
	var/obj/item/weapon/tank/tank = null              // Deployable tank, if any.

/obj/item/clothing/suit/space/void/equipped(mob/M)
	..()

	var/mob/living/carbon/human/H = M

	if(!istype(H)) return

	if(H.wear_suit != src)
		return

	if(tank)
		if(H.s_store) //In case someone finds a way.
			to_chat(M, "Alarmingly, the valve on your suit's installed tank fails to engage.")
		else if (H.equip_to_slot_if_possible(tank, slot_s_store))
			to_chat(M, "The valve on your suit's installed tank safely engages.")
			tank.canremove = 0

/obj/item/clothing/suit/armor/odst/verb/eject_tank()

	set name = "Eject Oxygen Tank"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(!tank)
		to_chat(usr, "There is no oxygen tank inserted.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.incapacitated()) return
	if(H.wear_suit != src) return

	to_chat(H, "<span class='info'>You press the release, ejecting \the [tank] from your suit.</span>")
	tank.canremove = 1
	H.drop_from_inventory(tank)
	src.tank = null

/obj/item/clothing/suit/space/void/attackby(obj/item/W as obj, mob/user as mob)

	if(!istype(user,/mob/living)) return

	if(istype(W,/obj/item/clothing/accessory) || istype(W, /obj/item/weapon/hand_labeler))
		return ..()

	if(istype(src.loc,/mob/living))
		to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		return

	if(istype(W,/obj/item/weapon/screwdriver))
		if(helmet || boots || tank)
			var/choice = input("What component would you like to remove?") as null|anything in list(helmet,boots,tank)
			if(!choice) return

			if(choice == tank)	//No, a switch doesn't work here. Sorry. ~Techhead
				to_chat(user, "You pop \the [tank] out of \the [src]'s storage compartment.")
				tank.forceMove(get_turf(src))
				src.tank = null
		else
			to_chat(user, "\The [src] does not have anything installed.")
		return
	else if(istype(W,/obj/item/weapon/tank))
		if(tank)
			to_chat(user, "\The [src] already has an airtank installed.")
		else if(istype(W,/obj/item/weapon/tank/phoron))
			to_chat(user, "\The [W] cannot be inserted into \the [src]'s storage compartment.")
		else
			to_chat(user, "You insert \the [W] into \the [src]'s storage compartment.")
			user.drop_item()
			W.forceMove(src)
			tank = W
		return

	..()


//Defines for armour subtypes//

/obj/effect/odst_armour_set
	var/obj/helmet = /obj/item/clothing/head/helmet/odst
	var/obj/armour = /obj/item/clothing/suit/armor/odst

/obj/effect/odst_armour_set/New()
	.=..()
	new helmet(src.loc)
	new armour(src.loc)

/obj/effect/odst_armour_set/Initialize()
	.=..()
	return INITIALIZE_HINT_QDEL

/obj/effect/odst_armour_set/cqb
	helmet = /obj/item/clothing/head/helmet/odst/cqb
	armour = /obj/item/clothing/suit/armor/odst/cqb

/obj/item/clothing/suit/armor/odst/cqb
	name = "ODST CQB Armour"

	icon_state = "Odst Armour CQB"

/obj/item/clothing/head/helmet/odst/cqb
	name = "ODST CQB Helmet"

	item_state = "Odst Helmet CQB"
	icon_state = "Helmet CQB"

/obj/effect/odst_armour_set/sharpshooter
	helmet = /obj/item/clothing/head/helmet/odst/sharpshooter
	armour = /obj/item/clothing/suit/armor/odst/sharpshooter

/obj/item/clothing/suit/armor/odst/sharpshooter
	name = "ODST Sharpshooter Armour"

	icon_state = "Odst Armour Sharpshooter"

/obj/item/clothing/head/helmet/odst/sharpshooter
	name = "ODST Sharpshooter Helmet"

	item_state = "Odst Helmet Sharpshooter"
	icon_state = "Helmet Sharpshooter"

/obj/effect/odst_armour_set/medic
	helmet = /obj/item/clothing/head/helmet/odst/medic
	armour = /obj/item/clothing/suit/armor/odst/medic

/obj/item/clothing/suit/armor/odst/medic
	name = "ODST Medic Armour"

	icon_state = "Odst Armour Medic"

/obj/item/clothing/head/helmet/odst/medic
	name = "ODST Medic Helmet"

	item_state = "Odst Helmet Medic"
	icon_state = "Helmet Medic"

/obj/effect/odst_armour_set/engineer
	helmet = /obj/item/clothing/head/helmet/odst/engineer
	armour = /obj/item/clothing/suit/armor/odst/engineer

/obj/item/clothing/head/helmet/odst/engineer
	name = "ODST Engineer Helmet"

	item_state = "Odst Helmet Engineer"
	icon_state = "Helmet Engineer"

/obj/item/clothing/suit/armor/odst/engineer
	name = "ODST Engineer Armour"

	icon_state = "Odst Armour Engineer"

/obj/effect/odst_armour_set/squadleader
	helmet = /obj/item/clothing/head/helmet/odst/squadleader
	armour = /obj/item/clothing/suit/armor/odst/squadleader

/obj/item/clothing/head/helmet/odst/squadleader
	name = "ODST Squad Leader Helmet"

	item_state = "Odst Helmet Squad Leader"
	icon_state = "Helmet Squad Leader"

/obj/item/clothing/suit/armor/odst/squadleader
	name = "ODST Squad Leader Armour"

	icon_state = "Odst Armor Squad Leader"

/obj/effect/random_ODST_set/New()
	.=..()
	var/obj/armour_set = pick(list(/obj/effect/odst_armour_set/medic,/obj/effect/odst_armour_set/sharpshooter,/obj/effect/odst_armour_set/cqb,/obj/effect/odst_armour_set,/obj/effect/odst_armour_set/engineer))
	new armour_set(src.loc)

/obj/effect/random_ODST_set/Initialize()
	.=..()
	return INITIALIZE_HINT_QDEL

/obj/item/clothing/accessory/storage/odst
	name = "Tactical Webbing"
	icon_state = "Tactical Webbing"

/obj/item/weapon/storage/backpack/odst/regular
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack"
	item_state = "odst_b"
	icon_state = "odst_ba"


/obj/item/weapon/storage/backpack/odst/cqb
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack CQB"
	item_state = "odst_c"
	icon_state = "odst_ca"


/obj/item/weapon/storage/backpack/odst/medic
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack Medic"
	item_state = "odst_m"
	icon_state = "odst_ma"


/obj/item/weapon/storage/backpack/odst/sharpshooter
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack Sharpshooter"
	item_state = "odst_s"
	icon_state = "odst_sa"


/obj/item/weapon/storage/backpack/odst/engineer
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack Engineer"
	item_state = "odst_e"
	icon_state = "odst_ea"


/obj/item/weapon/storage/backpack/odst/squadlead
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack Squad Leader"
	item_state = "odst_sl"
	icon_state = "odst_sla"


#undef ODST_OVERRIDE
#undef ITEM_INHAND
