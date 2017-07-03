#define GAINS_SHARP_ON_ACTIVE 0x1//Chainsaws I guess. Also eswords.
#define GAINS_EDGE_ON_ACTIVE 0x2
#define PARRY_REQUIRES_ACTIVE 0x4//For energy weapons that need to be active to parry.

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

//SPARKING
obj/item/weapon/twohanded/proc/attempt_spark(var/mob/user)
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, user.loc)
	spark_system.start()
	playsound(user.loc, parry_sound, 50, 1)

//Allow a small chance of parrying melee attacks when wielded
/obj/item/weapon/twohanded/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(wielded && default_parry_check(user, attacker, damage_source) && prob(parry_chance) && (flags & PARRY_REQUIRES_ACTIVE) <= active)
		var/obj/item/weapon/twohanded/toggled/energy/S
		if(istype(S))
			if(S.active)
				attempt_spark()
			else
				return 0 //Just in case.
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, parry_sound, 50, 1)
		return 1
	return 0

/obj/item/weapon/twohanded/update_icon()
	icon_state = "[initial(icon_state)][wielded]"
	item_state_slots[slot_l_hand_str] = icon_state

/*
 * Togglable weapons.
 */

/obj/item/weapon/twohanded/toggled //Exists to hold variables. Do not spawn this.

	var/active_force = 0
	var/activation_sound = null
	var/deactivation_sound = null
	var/passive_sound = null
	var/active_throwforce

/*
 * Activation handling.
 */
/obj/item/weapon/twohanded/toggled/proc/activate(mob/living/user)

	if(active)
		return
	force = active_force
	throwforce = active_throwforce
	if(flags & GAINS_SHARP_ON_ACTIVE)
		sharp = 1
	if(flags & GAINS_EDGE_ON_ACTIVE)
		edge = 1
	slot_flags |= SLOT_DENYPOCKET
	playsound(user, activation_sound, 50, 1)


obj/item/weapon/twohanded/toggled/proc/deactivate(mob/living/user)
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
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		update_icon()
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)

/obj/item/weapon/twohanded/toggled/get_storage_cost()
	if(active)
		return ITEM_SIZE_NO_CONTAINER
	return ..()

/obj/item/weapon/twohanded/toggled/dropped(var/mob/user) // Protects us from potential incredible stupidity (IE the hypothetical "dropping a lightsaber on the death star" situation.)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

obj/item/weapon/twohanded/toggled/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(parry_chance) && (flags & PARRY_REQUIRES_ACTIVE) <= active)
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, parry_sound, 50, 1)
		return 1
	return 0

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
	flags = GAINS_SHARP_ON_ACTIVE | GAINS_EDGE_ON_ACTIVE | PARRY_REQUIRES_ACTIVE | NOBLOODY
	active = 0
	active_force = 50
	active_throwforce = 40
	var/blade_color = "#00AFEA"
	activation_sound = 'sound/weapons/saberon.ogg'
	deactivation_sound = 'sound/weapons/saberoff.ogg'
	var/overlay_control = 0



/obj/item/weapon/twohanded/toggled/energy/dualsaber/New()
	..()

	update_icon()
/obj/item/weapon/twohanded/toggled/energy/dualsaber/proc/manage_overlay()
	var/image/LH = image('icons/mob/items/lefthand.dmi', icon_state = "dualsaber_overlay[wielded]")
	var/image/RH = image('icons/mob/items/righthand.dmi', icon_state = "dualsaber_overlay[wielded]")
	var/image/LB = image('icons/obj/weapons.dmi', "dualsaber overlay[wielded]") //LB, as in Lightblade.
	var/mob/user
	if(overlay_control == 0) //So we only run specific stages just once.
		usr.overlays += LH
		usr.overlays += RH
		src.overlays += LB
		overlay_control = 1

	if(overlay_control == 1 || !(active))
		LH.alpha = 0
		RH.alpha = 0
		LB.alpha = 0
		overlay_control = 2

	if(active)
		LB.alpha = 255

		if(user.get_equipped_item(slot_l_hand) == src)
			LH.alpha = 255
		if(user.get_equipped_item(slot_r_hand) == src)
			RH.alpha = 255

	LH.icon_state = "dualsaber_overlay[wielded]"
	RH.icon_state = "dualsaber_overlay[wielded]"

	LH.color = blade_color
	RH.color = blade_color
	LB.color = blade_color
	if(overlay_control == 3)
		usr.overlays -= LH
		usr.overlays -= RH
		src.overlays -= LB
		overlay_control = 0

/obj/item/weapon/twohanded/toggled/energy/dualsaber/equipped(var/mob/user, var/slot)
	update_icon()


/obj/item/weapon/twohanded/toggled/energy/dualsaber/update_icon()
	icon_state = "dualsaber[wielded]"
	manage_overlay()

obj/item/weapon/twohanded/toggled/energy/dualsaber/dropped()
	..()
	overlay_control = 3
	manage_overlay()
	overlay_control = 0
/* In Construction
obj/item/weapon/twohanded/toggled/energy/dualsaber/verb/choose_blade_color
	set category = "Object"
	set name = "Set Lightblade Color"
	set src in usr


	//Choose between predefs and a color wheel
	var/list/colors = list("Black", "Navy", "Green", "Teal", "Dark Grey", "Maroon", \
	"Purple", "Olive", "Brown Orange", "Dark Orange", "Gray-40", "Sedona", "Dark Brown",\
	 "Blue", "Deep Sky-blue", "Lime", "Cyan", "Red", "Pink", "Orange", "Yellow", "Gray",\
	  "Red Gray", "Brown", "Green Gray", " Blue Gray", "Sun", "Purple Gray", "Light Blue", \
	  "Light Red", "Beige", "Pale Green Gray", "Pale Red Gray", "Pale Purple Gray", "Pale Blue Gray",\
	   "Luminol", "Silver", "Gray-80", "Off-White", "NT-Red") //We have a lot of predefined grays. TODO: Add LONG FUCKING IF-CHAIN for all these values to their associated color macros.
	if(
		input(usr, "Pick a new color", "Lightlade Color", blade_color) as color|null
*/
#undef GAINS_SHARP_ON_ACTIVE
#undef GAINS_EDGE_ON_ACTIVE
#undef PARRY_REQUIRES_ACTIVE