/obj/item/weapon/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	sharp = 0
	edge = 0
	armor_penetration = 50
	atom_flags = ATOM_FLAG_NO_BLOOD
	var/attack_verb_on
	var/active_state
	var/active_sound = 'sound/weapons/saberon.ogg'
	var/deactivate_sound = 'sound/weapons/saberoff.ogg'
	var/lighthue

/obj/item/weapon/melee/energy/proc/activate(mob/living/user)
	anchored = 1
	if(active)
		return
	active = 1

	if(active_state)
		icon_state = active_state

	if(attack_verb_on)
		attack_verb = attack_verb_on

	if(lighthue)
		set_light(5, 1, lighthue)

	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	slot_flags |= SLOT_DENYPOCKET
	playsound(user, active_sound, 50, 1)
	to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

/obj/item/weapon/melee/energy/proc/deactivate(mob/living/user)
	anchored = 0
	if(!active)
		return
	icon_state = initial(icon_state)
	if(lighthue)
		set_light(0)
	playsound(user, deactivate_sound, 50, 1)
	active = 0
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	slot_flags = initial(slot_flags)
	attack_verb = initial(attack_verb)
	to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")

/obj/item/weapon/melee/energy/attack_self(mob/living/user as mob)
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
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
	active_state = "axe1"
	active_force = 60
	active_throwforce = 35
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	attack_verb = list("strikes", "chops", "slices", "rends", "dices", "cuts", "cleaves")
	sharp = 1
	edge = 1
	lighthue = COLOR_CYAN


/obj/item/weapon/melee/energy/sword
	name = "DO NOT SPAWN ME I AM A PLACEHOLDER"
	var/parrysound = 'sound/weapons/saberon.ogg'

/obj/item/weapon/melee/energy/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, parrysound, 50, 1)
		return 1
	return 0

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"
	active_state = "cutlass1"
	lighthue = COLOR_RED

/obj/item/weapon/melee/energy/sword/bogsword
	name = "alien sword"
	desc = "A strange, strange energy sword."
	icon_state = "sword0"
	active_state = "bog_sword"

/obj/item/weapon/melee/energy/sword/HF
	name = "\improper H.F. sword"
	desc = "An easily maintained high-tech sword. While high-frequency blades were initially created for use in the kitchen, this technology was rapidly adapted for cutting people as well. \
	The weapon has been applied a non-stick coating, so all the gore just slides <i>right</i> off!"
	description_antag = "A powerful melee weapon. Light enough to block with, and contains an ID locking mechanism. It will be nearly useless when used against you."
	icon_state = "hfrequency0"
	active_state = "hfrequency1"
	force = 5
	active_force = 40
	armor_penetration = 60
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MAGNET = 5, TECH_ILLEGAL = 5, TECH_COMBAT = 4, TECH_MATERIAL = 5)
	attack_verb = list("strikes", "beats", "smacks", "hits", "whacks")
	var/owner //the real_name of our original owner. Emagging and/or EMP will reset this.
	parrysound = 'sound/weapons/parry.ogg'
	active_sound = 'sound/weapons/HFon.ogg'
	deactivate_sound = 'sound/weapons/HFoff.ogg'


/obj/item/weapon/melee/energy/sword/HF/emp_act()
	emag_act()
/obj/item/weapon/melee/energy/sword/HF/emag_act()
	deactivate()
	audible_message("<span class = 'notice'>\the [src] buzzes oddly.</span>")
	owner = null

/obj/item/weapon/melee/energy/sword/HF/activate(mob/user)
	if(active)
		return
	if(isnull(owner))
		to_chat(user, "<span class = 'notice'>\the [src] registers you as its owner. It will not activate for anyone else.</span>")
		owner = user.real_name
	if(user.real_name != owner)
		audible_message("\the [src] beeps once, then does nothing.")
		return
	else
		..()

/obj/item/weapon/melee/energy/sword/HF/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/*
 *Energy Blade
 */

//Can't be activated or deactivated, so no reason to be a subtype of energy
/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	armor_penetration = 100
	sharp = 1
	edge = 1
	anchored = 1    // Never spawned outside of inventory, should be fine.
	throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEM_SIZE_TINY //technically it's just energy or something, I dunno
	atom_flags = ATOM_FLAG_NO_BLOOD
	attack_verb = list("strikes", "slashes", "stabs", "slices", "rends", "rends", "dices", "cuts", "cleaves")
	var/mob/living/creator
	var/datum/effect/effect/system/spark_spread/spark_system
	light_range = 1
	light_power = 5
	light_color = COLOR_GREEN

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
	QDEL_IN(src, 1)

/obj/item/weapon/melee/energy/blade/dropped()
	..()
	QDEL_IN(src, 1)

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
		QDEL_IN(src, 1)
/*
 * Energy Sword
 */
/obj/item/weapon/melee/energy/sword/saber
	name = "energy sword"
	desc = "A blade comprised of entangled photons in a crystalline structure. The first of its kind, these photon crystal\
	implements were swiftly adopted for the use in medicine. Famous for its ease of concealment,\"energy\" blades have been considered contraband since the year 2086."
	icon_state = "sword0"
	active_force = 30
	active_throwforce = 20
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	sharp = 1
	edge = 1
	attack_verb_on = list("strikes", "slashes", "stabs", "slices", "rends", "dices", "cuts", "cleaves")
	var/blade_color

/obj/item/weapon/melee/energy/sword/saber/activate(mob/living/user)
	..()
	if(blade_color)
		icon_state = "sword[blade_color]"

/obj/item/weapon/melee/energy/sword/saber/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/weapon/melee/energy/sword/saber/Initialize()
	. = ..()
	if(isnull(blade_color))
		var/obj/item/weapon/melee/energy/sword/saber/myproduct = pick(subtypesof(src))
		blade_color = initial(myproduct.blade_color)
		lighthue = initial(myproduct.lighthue)

/obj/item/weapon/melee/energy/sword/saber/green
	blade_color = "green"
	lighthue = COLOR_GREEN //Todo: Light colors.

/obj/item/weapon/melee/energy/sword/saber/red
	blade_color = "red"
	lighthue = COLOR_RED_LIGHT

/obj/item/weapon/melee/energy/sword/saber/blue
	blade_color = "blue"
	lighthue = COLOR_BLUE_LIGHT

/obj/item/weapon/melee/energy/sword/saber/purple
	blade_color = "purple"
	lighthue = COLOR_PURPLE //Todo: Light colors.