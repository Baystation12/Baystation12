
/* some yanme wings made as jetpacks because making them anything else is too much fucking work */

#define YANMEE_FLIGHT_TICKS 80

/obj/item/flight_item/yanmee
	name = "\improper Yanme'e Wings (Minor)"
	desc = "They go flap, you go up."

	flight_ticks_max = YANMEE_FLIGHT_TICKS
	canremove = FALSE
	flight_sound = 'code/modules/halo/sounds/yanmee_flying.ogg'
	action_button_name = "Toggle Flight"
	var/obj/item/weapon/weapon_stored			//ion want them yanme to lose their back slot
	var/hidden = FALSE

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

/obj/item/flight_item/yanmee/verb/hide_wings()
	set name = "Hide Wings"
	set category = "Object"
	set src in usr

	if(usr.stat == 0)
		if(hidden)
			hidden = FALSE
			to_chat(usr, "<span class='notice'>You open your wings.</span>")
		else
			hidden = TRUE
			to_chat(usr, "<span class='notice'>You close your wings.</span>")
		update_icon(usr)
	else
		to_chat(usr, "<span class='warning'>You can'd do that in this state.</span>")


/obj/item/flight_item/yanmee/update_icon(var/mob/living/user)
	if(active)
		icon_state = "[initial(icon_state)]-active"
		item_state = "[initial(item_state)]-active"
	else
		if(hidden)
			icon_state = initial(icon_state)
			item_state = "ywings_hidden"
		else
			icon_state = initial(icon_state)
			item_state = initial(item_state)
	user.update_inv_back(1)

/obj/item/flight_item/yanmee/attackby(obj/item/weapon/W, mob/living/carbon/human/user)
	. = ..()
	if(weapon_stored)
		to_chat(user, "<span class='warning'>There is already something attached here!</span>")
		return

	if(istype(W, /obj/item/weapon/gun) || istype(W, /obj/item/weapon/melee)) //for now just weapons, basically a bigger holster
		if(istype(W, /obj/item/weapon/gun))
			if(W.w_class > ITEM_SIZE_NORMAL || istype(W, /obj/item/weapon/gun/projectile/turret))
				to_chat(user, "<span class='warning'>[W] won't fit on [src]!</span>")
				return

			if(istype(user))
				user.stop_aiming(no_message=1)

		if(istype(W, /obj/item/weapon/melee))
			if(W.w_class > ITEM_SIZE_SMALL)
				to_chat(user, "<span class='warning'>[W] won't fit on [src]!</span>")
				return

		weapon_stored = W
		user.drop_from_inventory(weapon_stored)
		weapon_stored.loc = src
		weapon_stored.add_fingerprint(user)
		user.visible_message("<span class='notice'>[user] attaches \the [weapon_stored].</span>", "<span class='notice'>You attach \the [weapon_stored].</span>")
	else
		to_chat(user, "<span class='warning'>[W] won't fit on [src]!</span>")

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