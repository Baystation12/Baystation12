/obj/item/weapon/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_icon
	var/lighting_color
	var/active_attack_verb
	var/inactive_attack_verb = list()
	sharp = 0
	edge = 0
	armor_penetration = 50
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD

/obj/item/weapon/melee/energy/can_embed()
	return FALSE

/obj/item/weapon/melee/energy/Initialize()
	. = ..()
	if(active)
		active = FALSE
		activate()
	else
		active = TRUE
		deactivate()

/obj/item/weapon/melee/energy/on_update_icon()
	. = ..()
	if(active)
		icon_state = active_icon
	else
		icon_state = initial(icon_state)

/obj/item/weapon/melee/energy/proc/activate(mob/living/user)
	if(active)
		return
	active = TRUE
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	slot_flags |= SLOT_DENYPOCKET
	attack_verb = active_attack_verb
	update_icon()
	if(user)
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
	set_light(0.8, 1, 2, 4, lighting_color)

/obj/item/weapon/melee/energy/proc/deactivate(mob/living/user)
	if(!active)
		return
	active = FALSE
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	slot_flags = initial(slot_flags)
	attack_verb = inactive_attack_verb
	update_icon()
	if(user)
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
	set_light(0)

/obj/item/weapon/melee/energy/attack_self(mob/living/user as mob)
	if(active)
		if((MUTATION_CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts \himself with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/weapon/melee/energy/get_storage_cost()
	if(active)
		return ITEM_SIZE_NO_CONTAINER
	return ..()

/*
 * Energy Axe
 */
/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	active_icon = "axe1"
	lighting_color = COLOR_SABER_AXE
	active_force = 60
	active_throwforce = 35
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	active_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	inactive_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1
	melee_accuracy_bonus = 15

/obj/item/weapon/melee/energy/axe/deactivate(mob/living/user)
	. = ..()
	to_chat(user, "<span class='notice'>\The [src] is de-energised. It's just a regular axe now.</span>")

/*
 * Energy Sword
 */
/obj/item/weapon/melee/energy/sword
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	active_force = 30
	active_throwforce = 20
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	origin_tech = list(TECH_MAGNET = 3, TECH_ESOTERIC = 4)
	sharp = 1
	edge = 1
	base_parry_chance = 50
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	var/blade_color

/obj/item/weapon/melee/energy/sword/Initialize()
	if(!blade_color)
		blade_color = pick("red","blue","green","purple")

	active_icon = "sword[blade_color]"
	var/color_hex = list("red" = COLOR_SABER_RED,  "blue" = COLOR_SABER_BLUE, "green" = COLOR_SABER_GREEN, "purple" = COLOR_SABER_PURPLE)
	lighting_color = color_hex[blade_color]

	. = ..()

/obj/item/weapon/melee/energy/sword/green
	blade_color = "green"

/obj/item/weapon/melee/energy/sword/red
	blade_color = "red"

/obj/item/weapon/melee/energy/sword/blue
	blade_color = "blue"

/obj/item/weapon/melee/energy/sword/purple
	blade_color = "purple"

/obj/item/weapon/melee/energy/sword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/weapon/melee/energy/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(.)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/weapon/melee/energy/sword/get_parry_chance(mob/user)
	return active ? ..() : 0

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"
	active_icon = "cutlass1"
	lighting_color = COLOR_SABER_CUTLASS

/*
 *Energy Blade
 */

/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	active_icon = "blade"	//It's all energy, so it should always be visible.
	lighting_color = COLOR_SABER_GREEN
	active_force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	active = 1
	armor_penetration = 100
	sharp = 1
	edge = 1
	anchored = 1    // Never spawned outside of inventory, should be fine.
	active_throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEM_SIZE_TINY //technically it's just energy or something, I dunno
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	var/mob/living/creator
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/item/weapon/melee/energy/blade/New()
	..()
	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/weapon/melee/energy/blade/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/melee/energy/blade/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/melee/energy/blade/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/weapon/melee/energy/blade/attack_self(mob/user as mob)
	user.drop_from_inventory(src)

/obj/item/weapon/melee/energy/blade/dropped()
	..()
	QDEL_IN(src, 0)

/obj/item/weapon/melee/energy/blade/Process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 0)

/obj/item/weapon/melee/energy/machete
	name = "energy machete"
	desc = "A machete handle that extends out into a long, purple machete blade. It appears to be Skrellian in origin."
	icon_state = "machete_skrell_x"
	active_icon = "machete_skrell"
	active_force = 16		//In line with standard machetes at time of creation.
	active_throwforce = 17.25
	lighting_color = COLOR_SABER_SKRELL
	force = 3
	throwforce = 1
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MAGNET = 3)
	active_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
