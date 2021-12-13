
/* some yanme wings made as jetpacks because making them anything else is too much fucking work */

#define YANMEE_FLIGHT_TICKS 80

/obj/item/flight_item/yanmee
	name = "\improper Yanme'e Wings (Minor)"
	desc = "They go flap, you go up."

	flight_ticks_max = YANMEE_FLIGHT_TICKS
	canremove = FALSE
	flight_sound = FALSE
	var/obj/item/weapon/weapon_stored			//ion want them yanme to lose their back slot
	action_button_name = "Toggle Flight"

	icon = 'code/modules/halo/clothing/yanmee_wings.dmi'
	icon_state = "ywings_minor_item"
	item_state = "ywings_minor"
	item_icons = list(
		slot_back_str = 'code/modules/halo/clothing/yanmee_wings.dmi',
		)

	takeoff_msg = "\'s wings start flapping."
	land_msg = "\'s wings stop flapping, bringing them to the ground."

/obj/item/flight_item/yanmee/examine(mob/user, distance)
	. = ..()
	if(weapon_stored)
		to_chat(user, "<span class='notice'>It has a [weapon_stored] attached!</span>")

/obj/item/flight_item/yanmee/attackby(obj/item/weapon/W, mob/living/carbon/human/user)
	. = ..()
	if(weapon_stored)
		to_chat(user, "<span class='warning'>There is already something attached here!</span>")
		return

	if(!istype(W, /obj/item/weapon/gun) || !istype(W, /obj/item/weapon/melee) || istype(W, /obj/item/weapon/gun/projectile/turret))
		to_chat(user, "<span class='warning'>You can't attach this here!</span>")
		return

	if(istype(user))
		user.stop_aiming(no_message=1)

	weapon_stored = W
	user.drop_from_inventory(weapon_stored)
	weapon_stored.loc = src
	weapon_stored.add_fingerprint(user)
	user.visible_message("<span class='notice'>[user] attaches \the [weapon_stored].</span>", "<span class='notice'>You attach \the [weapon_stored].</span>")

/obj/item/flight_item/yanmee/attack_hand(mob/living/carbon/human/user)
	. = ..()

	if(!weapon_stored)
		return

	if(istype(user.get_active_hand(),/obj) && istype(user.get_inactive_hand(),/obj))
		to_chat(user, "<span class='warning'>You need an empty hand to deattach \the [weapon_stored]!</span>")
	else
		if(user.a_intent == I_HURT)
			usr.visible_message(
				"<span class='danger'>[user] deattach \the [weapon_stored], ready to shoot!</span>",
				"<span class='warning'>You deattach \the [weapon_stored], ready to shoot!</span>"
				)
		else
			user.visible_message(
				"<span class='notice'>[user] deattach \the [weapon_stored], pointing it at the ground.</span>",
				"<span class='notice'>You deattach \the [weapon_stored], pointing it at the ground.</span>"
				)
		user.put_in_hands(weapon_stored)
		weapon_stored.add_fingerprint(user)
		weapon_stored = FALSE

/obj/item/flight_item/yanmee/major
	name = "\improper Yanme'e Wings (Major)"
	icon_state = "ywings_major_item"
	item_state = "ywings_major"

/obj/item/flight_item/yanmee/ultra
	name = "\improper Yanme'e Wings (Ultra)"
	icon_state = "ywings_ultra_item"
	item_state = "ywings_ultra"

/obj/item/flight_item/yanmee/leader
	name = "\improper Yanme'e Wings (Leader)"
	icon_state = "ywings_leader_item"
	item_state = "ywings_leader"

#undef YANMEE_FLIGHT_TICKS