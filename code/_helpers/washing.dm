/proc/wash_mob(var/mob/living/washing)

	if(!istype(washing))
		return

	var/mob/living/L = washing

	if(L.on_fire)
		L.visible_message("<span class='danger'>A cloud of steam rises up as the water hits \the [L]!</span>")
		L.ExtinguishMob()

	L.fire_stacks = -20 //Douse ourselves with water to avoid fire more easily

	if(!iscarbon(washing))
		washing.clean_blood()
		return

	var/mob/living/carbon/M = washing
	if(M.r_hand)
		M.r_hand.clean_blood()
	if(M.l_hand)
		M.l_hand.clean_blood()
	if(M.back && M.back.clean_blood())
		M.update_inv_back(0)

	//flush away reagents on the skin
	if(M.touching)
		var/remove_amount = M.touching.maximum_volume * M.reagent_permeability() //take off your suit first
		M.touching.remove_any(remove_amount)

	if(!ishuman(M))
		if(M.wear_mask && M.wear_mask.clean_blood())
			M.update_inv_wear_mask(0)
		M.clean_blood()
		return

	var/mob/living/carbon/human/H = M
	var/washgloves = 1
	var/washshoes = 1
	var/washmask = 1
	var/washears = 1
	var/washglasses = 1

	if(H.wear_suit)
		washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
		washshoes = !(H.wear_suit.flags_inv & HIDESHOES)

	if(H.head)
		washmask = !(H.head.flags_inv & HIDEMASK)
		washglasses = !(H.head.flags_inv & HIDEEYES)
		washears = !(H.head.flags_inv & HIDEEARS)

	if(H.wear_mask)
		if (washears)
			washears = !(H.wear_mask.flags_inv & HIDEEARS)
		if (washglasses)
			washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

	if(H.head)
		if(H.head.clean_blood())
			H.update_inv_head(0)
	if(H.wear_suit)
		if(H.wear_suit.clean_blood())
			H.update_inv_wear_suit(0)
	else if(H.w_uniform)
		if(H.w_uniform.clean_blood())
			H.update_inv_w_uniform(0)
	if(H.gloves && washgloves)
		if(H.gloves.clean_blood())
			H.update_inv_gloves(0)
	if(H.shoes && washshoes)
		if(H.shoes.clean_blood())
			H.update_inv_shoes(0)
	if(H.wear_mask && washmask)
		if(H.wear_mask.clean_blood())
			H.update_inv_wear_mask(0)
	if(H.glasses && washglasses)
		if(H.glasses.clean_blood())
			H.update_inv_glasses(0)
	if(H.l_ear && washears)
		if(H.l_ear.clean_blood())
			H.update_inv_ears(0)
	if(H.r_ear && washears)
		if(H.r_ear.clean_blood())
			H.update_inv_ears(0)
	if(H.belt)
		if(H.belt.clean_blood())
			H.update_inv_belt(0)
	H.clean_blood(washshoes)