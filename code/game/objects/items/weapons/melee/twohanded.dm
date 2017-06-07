#define GAINS_SHARP_ON_ACTIVE 1//Chainsaws I guess. Also eswords.
#define GAINS_EDGE_ON_ACTIVE 1
#define PARRY_REQUIRES_ACTIVE 1 //For energy weapons that need to be active to parry.
#define SPARKS_ON_PARRY 1 //For energy weapons that need to be active to parry.

/obj/item/weapon/twohanded //Base type, never spawn this.
	icon_state = "DONGS"
	var/wielded = 0
	var/force_wielded = 0
	var/unwielded_force_divisor = 0.25
	var/parry_chance = 15
	var/parry_sound = 'sound/weapons/punchmiss.ogg'
	var/active = 0 //So we don't have to use copy-paste procs with one more argument.

/obj/item/weapon/twohanded/update_twohanding() //Lets us know if the weapon is being held in both hands
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
		name = "[initial(name)] (wielded)"
	else
		wielded = 0
		force = initial(force)
		name = "[initial(name)]"
	update_icon()
	..()

/obj/item/weapon/twohanded/New()
	..()
	update_icon()

//Allow a small chance of parrying melee attacks when wielded
/obj/item/weapon/twohanded/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) \
&& prob(parry_chance) && PARRY_REQUIRES_ACTIVE <= active) // Last two conditions apply mostly to energy weapons. \
		                                                              <= means you can have a weapon that does not need to be active to parry.
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		if(SPARKS_ON_PARRY)
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, user.loc)
			spark_system.start()
		playsound(user.loc, parry_sound, 50, 1)
		return 1
	return 0

/obj/item/weapon/twohanded/update_icon()
	icon_state = "[initial(icon)][wielded]"
	item_state_slots[slot_l_hand_str] = icon_state

/*
 * Togglable weapons.
 */

/obj/item/weapon/twohanded/toggled/ //Exists to hold variables. Do not spawn this.

	var/active_force = 0 //Declared here for any weird mechanical weapons in the near future.
	var/activation_sound = null
	var/deactivation_sound = null
	var/passive_sound = null //For weird energy chainsaws or whatever the fuck
	var/active_throwforce

/*
 * Activation handling.
 */
/obj/item/weapon/twohanded/toggled/proc/activate(mob/living/user)

	if(active)
		return
	active = 1
	force = active_force
	throwforce = active_throwforce
	if(GAINS_SHARP_ON_ACTIVE)
		sharp = 1
	if(GAINS_EDGE_ON_ACTIVE)
		edge = 1
	slot_flags |= SLOT_DENYPOCKET
	playsound(user, activation_sound, 50, 1)

obj/item/weapon/twohanded/toggled/proc/deactivate(mob/living/user)
	anchored = 0
	if(!active)
		return
	playsound(user, deactivation_sound, 50, 1)
	active = 0
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	slot_flags = initial(slot_flags)



/obj/item/weapon/twohanded/toggled/attack_self(mob/living/user as mob)

	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts \himself with \the [src].</span>","<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			user.take_organ_damage(5,5)
			deactivate(user)
	else
		activate(user)
	update_icon()
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()
	add_fingerprint(user)


/obj/item/weapon/twohanded/get_storage_cost()
	if(active)
		return ITEM_SIZE_NO_CONTAINER
	return ..()

////////////Energy weapons!/////////////

//Double saber
/obj/item/weapon/twohanded/toggled/energy/dualsaber
	icon_state = "dualsaber0"
	name = "double-bladed energy sword"
	desc = "Handle with care."
	force = 3
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	unwielded_force_divisor = 0.52
	sharp = 0
	edge = 0
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	w_class = ITEM_SIZE_SMALL
	parry_chance = 70
	flags = GAINS_SHARP_ON_ACTIVE | GAINS_EDGE_ON_ACTIVE | PARRY_REQUIRES_ACTIVE | SPARKS_ON_PARRY | NOBLOODY
	active = 0
	active_force = 50
	active_throwforce = 40
	var/blade_color = "red"
	activation_sound = 'sound/weapons/saberon.ogg'
	deactivation_sound = 'sound/weapons/saberoff.ogg'

/obj/item/weapon/twohanded/toggled/energy/dualsaber/New()
	..()
	blade_color = pick("red","blue","green","purple","rainbow")

/obj/item/weapon/twohanded/toggled/energy/dualsaber/update_icon()
	//icon_state = "dualsaber[wielded]" //Wielded states do not exist yet.
	if(active)
		icon_state = "dualsaber[blade_color]"
	if(!active)
		icon_state = initial(icon_state)
