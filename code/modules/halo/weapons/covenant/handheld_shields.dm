
#define SHIELD_GAUNTLET_ICON 'code/modules/halo/weapons/covenant/shield_gauntlet.dmi'
#define SHIELD_GAUNTLET_ICON_INHAND_L 'code/modules/halo/weapons/covenant/shield_gauntlet_lefthand.dmi'
#define SHIELD_GAUNTLET_ICON_INHAND_R 'code/modules/halo/weapons/covenant/shield_gauntlet_righthand.dmi'
/obj/item/clothing/gloves/shield_gauntlet
	name = "Shield Gauntlet"
	desc = "Shield Gauntlet"

	icon = SHIELD_GAUNTLET_ICON
	icon_state = "shield_placeholder_gauntlet"
	item_state = "shield_placeholder_gauntlet"

	action_button_name = "Toggle Shield Gauntlet"

	var/obj/item/weapon/gauntlet_shield/connected_shield = /obj/item/weapon/gauntlet_shield
	var/mob/current_user

	var/shield_max_charge = 400
	var/shield_current_charge = 400
	var/list/shield_colour_values = list("300" = "#6d63ff","200" = "#ffa76d","100" = "#ff4248")//Associative list with shield-charge as key and colour value as keyvalue. Ordered highest to lowest. EG: "200" = "#6D63FF"
	var/shield_recharge_delay = 2 //The delay between taking damage and starting to recharge, in seconds.
	var/shield_next_charge
	var/limb_hit_chance = 5 //The chance to hit arms and legs even if the shield were to block the shot. Percentile.
	var/active_slowdown_amount = 5

/obj/item/clothing/gloves/shield_gauntlet/New()
	. = ..()
	connected_shield = new connected_shield (src)

/obj/item/clothing/gloves/shield_gauntlet/proc/gloves_check()
	var/mob/living/carbon/human/h = current_user
	if(istype(h))
		if(h.gloves == src)
			return 1
	return 0

/obj/item/clothing/gloves/shield_gauntlet/equipped(var/mob/user)
	current_user = user
	if(!gloves_check())
		current_user = null

/obj/item/clothing/gloves/shield_gauntlet/dropped(var/mob/user)
	if(!gloves_check())
		current_user = null

/obj/item/clothing/gloves/shield_gauntlet/proc/equip_shield()
	if(!current_user)
		return
	if(!current_user.put_in_inactive_hand(connected_shield))
		if(!current_user.put_in_active_hand(connected_shield))
			to_chat(current_user,"<span class = 'notice'>You need one hand unobstructed to use [src.name]</span>")
		else
			//activate shield and we walk slower
			slowdown_per_slot[slot_gloves] = active_slowdown_amount
	update_inhand_icons()

/obj/item/clothing/gloves/shield_gauntlet/proc/unequip_shield()
	current_user.drop_from_inventory(connected_shield)
	contents += connected_shield
	update_inhand_icons()
	slowdown_per_slot[slot_gloves] = 0

/obj/item/clothing/gloves/shield_gauntlet/proc/drain_shield(var/damage)
	var/charge_after_depletion = shield_current_charge - damage
	if(charge_after_depletion <= 0)
		to_chat(current_user,"<span class = 'danger'>Your shield gauntlet fails!</span>")
		visible_message("<span class = 'warning'>[current_user.name]'s shield gauntlet fails, overloading the shield projector.</span>")
		shield_next_charge = (world.time + (shield_recharge_delay SECONDS) * 2)
		. = 0
	if(charge_after_depletion > 0)
		shield_current_charge = charge_after_depletion
		shield_next_charge = (world.time + shield_recharge_delay SECONDS)
		. = 1

	GLOB.processing_objects += src
	update_shield()

/obj/item/clothing/gloves/shield_gauntlet/proc/try_shield_recharge()
	if(world.time > shield_next_charge)
		var/new_charge = shield_current_charge + (shield_max_charge/20)
		if(new_charge >= shield_max_charge)
			shield_current_charge = shield_max_charge
		else
			shield_current_charge = new_charge
		shield_next_charge = world.time + (shield_recharge_delay SECONDS)

/obj/item/clothing/gloves/shield_gauntlet/proc/update_shield()
	var/colourcode_animate_to
	if(shield_current_charge > 0)
		for(var/i = 1,i<=shield_colour_values.len,i++)
			var/shield_value = shield_colour_values[i]
			var/value_colour = shield_colour_values[shield_value]
			if(shield_current_charge <= text2num(shield_value))
				colourcode_animate_to = value_colour
		connected_shield.icon_state = initial(connected_shield.icon_state)
		animate(connected_shield,color = colourcode_animate_to,alpha = 255,3 SECONDS)
	else
		connected_shield.icon_state = "[initial(connected_shield.icon_state)]_depleted"
	update_inhand_icons()

/obj/item/clothing/gloves/shield_gauntlet/proc/update_inhand_icons()
	if(!current_user)
		return

	if(current_user.l_hand == connected_shield)
		current_user.update_inv_l_hand()
	if(current_user.r_hand == connected_shield)
		current_user.update_inv_r_hand()

/obj/item/clothing/gloves/shield_gauntlet/process()
	if(shield_current_charge == shield_max_charge)
		GLOB.processing_objects -= src
		return
	try_shield_recharge()
	update_shield()
	update_inhand_icons()

/obj/item/clothing/gloves/shield_gauntlet/proc/on_shield_dropped()
	contents += connected_shield //We don't want the shield just lying on the ground.

/obj/item/clothing/gloves/shield_gauntlet/proc/on_shield_equipped()
	update_shield()

/obj/item/clothing/gloves/shield_gauntlet/ui_action_click()
	if(!connected_shield.inhand_check())
		equip_shield()
	else
		unequip_shield()

//Physical shield object define//
/obj/item/weapon/gauntlet_shield //The shield object that appears when you activate the gauntlet.
	name = "Handheld Shield"
	desc = "A shimmering shield"

	icon = SHIELD_GAUNTLET_ICON
	icon_state = "shield_placeholder"
	item_state = "shield_placeholder"

	item_icons = list(slot_l_hand_str =SHIELD_GAUNTLET_ICON_INHAND_L,
	slot_r_hand_str = SHIELD_GAUNTLET_ICON_INHAND_R)

	var/obj/item/clothing/gloves/shield_gauntlet/creator_gauntlet
	canremove = 0

/obj/item/weapon/gauntlet_shield/New(var/obj/created_by)
	. = ..()
	creator_gauntlet = created_by

/obj/item/weapon/gauntlet_shield/proc/get_allowed_attack_dirs()
	var/list/allowed_attack_dirs = list()
	switch(loc.dir)
		if(NORTH)
			allowed_attack_dirs = list(SOUTH,SOUTHEAST,SOUTHWEST)
		if(SOUTH)
			allowed_attack_dirs = list(NORTH,NORTHEAST,NORTHWEST)
		if(EAST)
			allowed_attack_dirs = list(WEST,NORTHWEST,SOUTHWEST)
		if(WEST)
			allowed_attack_dirs = list(EAST,NORTHEAST,SOUTHEAST)

	return allowed_attack_dirs

/obj/item/weapon/gauntlet_shield/proc/drain_shield(var/amount)
	. = creator_gauntlet.drain_shield(amount)

/obj/item/weapon/gauntlet_shield/handle_shield(mob/user, var/damage, atom/damage_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(!drain_shield(damage))
		return 0
	var/obj/item/projectile/P = damage_source
	if(istype(P))
		if(get_dir(src,P.starting) in get_allowed_attack_dirs())
			return 0
	else
		if(get_dir(src,damage_source) in get_allowed_attack_dirs())
			return 0

	if((def_zone in list("l_hand","r_hand")) && prob(creator_gauntlet.limb_hit_chance))
		return 0
	else
		if(!isnull(attacker))
			creator_gauntlet.current_user.visible_message("<span class = 'danger'>[attacker]'s attack is deflected by the [creator_gauntlet.name].</span>")
		else
			creator_gauntlet.current_user.visible_message("<span class = 'danger'>[damage_source] is deflected by the [creator_gauntlet.name].</span>")

	return 1

/obj/item/weapon/gauntlet_shield/proc/inhand_check()
	var/mob/living/carbon/human/h = creator_gauntlet.current_user
	if(istype(h))
		if(h.l_hand  || h.r_hand == src)
			return 1
	return 0

/obj/item/weapon/gauntlet_shield/dropped()
	if(!inhand_check())
		creator_gauntlet.on_shield_dropped()

/obj/item/weapon/gauntlet_shield/equipped()
	if(inhand_check())
		creator_gauntlet.on_shield_equipped()

//shield subtype defines//

/obj/item/clothing/gloves/shield_gauntlet/kigyar
	name = "Kig-Yar Point Defense Gauntlet"
	desc = "A wrist-worn gauntlet that contains a directional shield generator, allowing it to provide protection from gunfire in the direction the user is facing."
	species_restricted = list("Kig-Yar")
