
//I guess this goes here//
//Generalised Holster Verb, to expand it's usage from accessory holsters//

/mob/living/carbon/human/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(user.stat) return

	var/obj/item/weapon/gun/W = user.get_active_hand()
	var/list/locations_to_check = list(user.back,user.s_store,user.belt) //Assoc. List to allow for equip_to_slot_if_possible to work
	var/obj/item/clothing/accessory/holster/acc_holster = null //Let's search for an actual holster first.
	if (istype(user.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/S = user.w_uniform
		if (S.accessories.len)
			acc_holster = locate() in S.accessories

	if(!isnull(acc_holster))
		if(!acc_holster.holstered && !isnull(W))
			acc_holster.holster(W, user)
		else
			acc_holster.unholster(user)
		return

	if(!isnull(W)) //We'll let the auto-equip system deal with holstering.
		if(istype(W))
			if(user.equip_to_appropriate_slot(W))
				user.visible_message("<span class = 'notice'>[user] holsters \the [W].</span>")
		else
			to_chat(user,"<span class = 'warning'>You need an empty hand to unholster a weapon!</span>")
		return

	for(var/location in locations_to_check)
		var/obj/item/weapon/gun/gun_to_drop = location
		if(istype(gun_to_drop))
			user.drop_from_inventory(gun_to_drop)
			if(user.put_in_hands(gun_to_drop))
				if(user.a_intent == I_HURT)
					visible_message("<span class = 'danger'>[user] draws \the [gun_to_drop], ready to shoot!</span>","<span class = 'warning'>You draw \the [gun_to_drop], ready to shoot!</span>")
				else
					visible_message("<span class = 'warning'>[user] draws \the [gun_to_drop], pointing it at the ground.</span>","<span class = 'notice'>You draw \the [gun_to_drop], pointing it at the ground.</span>")
				break
