
#define SHIELD_GAUNTLET_ICON 'code/modules/halo/weapons/covenant/shield_gauntlet.dmi'
#define SHIELD_GAUNTLET_ICON_INHAND_L 'code/modules/halo/weapons/covenant/shield_gauntlet_lefthand.dmi'
#define SHIELD_GAUNTLET_ICON_INHAND_R 'code/modules/halo/weapons/covenant/shield_gauntlet_righthand.dmi'
/obj/item/clothing/gloves/shield_gauntlet
	name = "Shield Gauntlet"
	desc = "Shield Gauntlet"

	icon = SHIELD_GAUNTLET_ICON
	icon_state = "shield"

	action_button_name = "Toggle Shield Gauntlet"

	var/shield_max_charge = 600
	var/shield_current_charge = 600
	var/list/shield_colour_values = list("#ff4248","#ffa76d","#6d63ff")		//highest charge to lowest charge
	var/shield_recharge_delay = 6 SECONDS //The delay between taking damage and starting to recharge, in ticks.
	var/shield_next_charge
	var/active_slowdown_amount = 5
	var/overloaded = 0

	var/obj/item/weapon/gauntlet_shield/connected_shield

/obj/item/clothing/gloves/shield_gauntlet/examine(var/mob/user)
	. = ..()
	var/span_class = "info"
	if(shield_current_charge < shield_max_charge * 0.33)
		span_class = "danger"
	else if(shield_current_charge < shield_max_charge * 0.66)
		span_class = "warning"
	to_chat(user, "<span class='[span_class]'>It has [shield_charge_string()].</span>")

/obj/item/clothing/gloves/shield_gauntlet/proc/shield_charge_string()
	return "[shield_current_charge]/[shield_max_charge] charge \
		([100*shield_current_charge/shield_max_charge]%)"

/obj/item/clothing/gloves/shield_gauntlet/attack_self(var/mob/living/carbon/human/user)
	if(connected_shield)
		qdel(connected_shield)
		connected_shield = null

	else if(shield_next_charge)
		to_chat(user, "\icon[src] <span class='warning'>[src] has been overloaded and cannot be used for another \
			[(shield_next_charge - world.time)/10] seconds.</span>")
		return

	else if(user.gloves != src)
		to_chat(user, "\icon[src] <span class='notice'>You must be wearing [src] on your hands to activate it.</span>")

	else if(!try_activate())
		return

	to_chat(user, "\icon[src] <span class='info'>You [connected_shield ? "en" : "dis"]able [src].</span>")

/obj/item/clothing/gloves/shield_gauntlet/proc/try_activate()
	var/mob/user = src.loc
	if(istype(user))
		connected_shield = new(user, src)
		if(!user.put_in_inactive_hand(connected_shield))
			if(!user.put_in_active_hand(connected_shield))
				qdel(connected_shield)
				to_chat(user,"<span class = 'notice'>You need one hand free to use [src].</span>")
				return 0
		update_icon()
		return 1

/obj/item/clothing/gloves/shield_gauntlet/proc/overload()

	//disable the inhand shield
	deactivate()

	//reactivate as soon as our timer is up
	overloaded = 1

	//reactivate with some bonus shield charge
	shield_current_charge = shield_max_charge / 2

/obj/item/clothing/gloves/shield_gauntlet/proc/hand_dropped()
	//just annul it
	connected_shield = null
	icon_state = "shield"

/obj/item/clothing/gloves/shield_gauntlet/proc/deactivate()
	if(connected_shield)
		var/mob/user = connected_shield.loc
		if(istype(user))
			user.drop_from_inventory(connected_shield)
		else
			qdel(connected_shield)
			message_admins("WARNING: JACKAL SHIELD GAUNTLET at [user] failed to deactivate() properly")

/obj/item/clothing/gloves/shield_gauntlet/dropped(var/mob/user)
	deactivate()

/obj/item/clothing/gloves/shield_gauntlet/handle_shield(mob/user, var/damage, atom/damage_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	//which turf did the attack come in from?
	var/turf/starting
	var/obj/item/projectile/P = damage_source
	if(istype(P))
		starting = P.starting
	else
		starting = get_turf(damage_source)

	//was it from our blind spot?
	if(get_dir(src, starting) in get_allowed_attack_dirs())
		return 0

	if(drain_shield(damage))
		//did our shield absorb the shot?
		if(istype(attacker))
			user.visible_message("<span class = 'danger'>[attacker]'s attack is absorbed by the [src].</span>")
		else
			user.visible_message("<span class = 'danger'>[damage_source] is absorbed by the [src].</span>")
		return -1

	return 0

/obj/item/clothing/gloves/shield_gauntlet/proc/get_allowed_attack_dirs()
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

/obj/item/clothing/gloves/shield_gauntlet/proc/drain_shield(var/damage)
	if(damage > 0)
		if(connected_shield && shield_current_charge > 0)

			//set a delay on recharging
			if(!shield_next_charge)
				GLOB.processing_objects |= src
			shield_next_charge = world.time + shield_recharge_delay

			//subtract the damage
			shield_current_charge -= damage

			//overloaded from damage?
			if(shield_current_charge < 0)
				shield_current_charge = 0
				deactivate(1)
				visible_message("<span class = 'warning'>[src.loc]'s [src] fails, overloading the shield projector.</span>")

				//double the normal recharge time
				shield_next_charge += shield_recharge_delay
			else
				update_icon()

			return 1

		return 0

	return 1

/obj/item/clothing/gloves/shield_gauntlet/update_icon()
	if(connected_shield)
		//our gauntlets are active
		icon_state = "shield_active"

		//work out which damage indicator we are at
		var/shield_colour
		if(shield_current_charge < 1 * shield_max_charge / 3)
			shield_colour = shield_colour_values[1]
		else if(shield_current_charge < 2 * shield_max_charge / 3)
			shield_colour = shield_colour_values[2]
		else
			shield_colour = shield_colour_values[3]

		//set the inhand shield colour
		animate(connected_shield, color = shield_colour, 4 SECONDS)

		var/mob/living/user = src.loc
		if(istype(user))
			if(user.l_hand == connected_shield)
				user.update_inv_l_hand()
			else if(user.r_hand == connected_shield)
				user.update_inv_r_hand()

	else if(overloaded)
		icon_state = "shield_overloaded"
	else
		icon_state = "shield"

/obj/item/clothing/gloves/shield_gauntlet/process()
	if(shield_current_charge >= shield_max_charge)
		GLOB.processing_objects -= src
		shield_next_charge = 0
		return

	//dont start recharging until we are ready
	if(world.time > shield_next_charge)
		//always take 10 ticks to get to full
		shield_current_charge += shield_max_charge / 15

		///dont overflow
		if(shield_current_charge > shield_max_charge)
			shield_current_charge = shield_max_charge

		//automatically come back up after an overload
		if(overloaded)
			overloaded = 0
			if(!try_activate())
				update_icon()
		else
			update_icon()

		//tell our holder
		var/mob/M = src.loc
		if(istype(M))
			to_chat(M,"\icon[src] <span class='info'>[src] is now at [shield_charge_string()].</span>")



//Physical shield object define//
/obj/item/weapon/gauntlet_shield //The shield object that appears when you activate the gauntlet.
	name = "Handheld Shield"
	desc = "A shimmering shield"

	icon = SHIELD_GAUNTLET_ICON
	icon_state = "shield1"
	item_state = "shield1"

	item_icons = list(\
		slot_l_hand_str = SHIELD_GAUNTLET_ICON_INHAND_L,
		slot_r_hand_str = SHIELD_GAUNTLET_ICON_INHAND_R)

	slowdown_general = 5
	canremove = 0
	var/obj/item/clothing/gloves/shield_gauntlet/creator_gauntlet

/obj/item/weapon/gauntlet_shield/New(var/loc, var/obj/created_by)
	. = ..()
	creator_gauntlet = created_by

/obj/item/weapon/gauntlet_shield/dropped()
	creator_gauntlet.hand_dropped()



//shield subtype defines//

/obj/item/clothing/gloves/shield_gauntlet/kigyar
	name = "Kig-Yar Point Defense Gauntlet"
	desc = "A wrist-worn gauntlet that contains a directional shield generator, allowing it to provide protection from gunfire in the direction the user is facing."
	species_restricted = list("Kig-Yar")
	body_parts_covered = HANDS
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 15, bio = 0, rad = 0)