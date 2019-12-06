/spell/targeted/equip_item/burning_hand
	name = "Burning Hand"
	desc = "Bathes your hand in fire, giving you all the perks and disadvantages that brings."
	feedback = "BH"
	school = "conjuration"
	invocation = "Horila Kiha!"
	invocation_type = SpI_SHOUT
	spell_flags = INCLUDEUSER
	range = -1
	duration = 0
	max_targets = 1
	equipped_summons = list("active hand" = /obj/item/weapon/flame/hands)
	delete_old = 0

	hud_state = "gen_burnhand"

/obj/item/weapon/flame/hands
	name = "Burning Hand"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "grabbed+1"
	force = 10
	damtype = BURN
	simulated = 0
	var/burn_power = 0
	var/burn_timer
	var/obj/item/organ/external/hand/connected

/obj/item/weapon/flame/hands/pickup(var/mob/user)
	burn_power = 0
	burn_timer = world.time + 10 SECONDS
	START_PROCESSING(SSobj,src)


/obj/item/weapon/flame/hands/Process()
	if(world.time < burn_timer)
		return
	burn_timer = world.time + 5 SECONDS
	burn_power++
	force += 2
	if(!istype(src.loc, /mob/living/carbon/human))
		qdel(src)
		return
	var/mob/living/carbon/human/user = src.loc
	var/obj/item/organ/external/hand
	if(src == user.l_hand)
		hand = user.get_organ(BP_L_HAND)
	else
		hand = user.get_organ(BP_R_HAND)
	hand.take_external_damage(burn=2 * burn_power)
	if(burn_power > 5)
		user.fire_stacks += 15
		user.IgniteMob()
		user.visible_message("<span class='danger'>\The [user] bursts into flames!</span>")
		user.drop_from_inventory(src)
	else
		if(burn_power == 5)
			to_chat(user, "<span class='danger'>You begin to lose control of \the [src]'s flames as they rapidly move up your arm...</span>")
		else
			to_chat(user, "<span class='warning'>You feel \the [src] grow hotter and hotter!</span>")

/obj/item/weapon/flame/hands/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/weapon/flame/hands/dropped()
	..()
	qdel(src)