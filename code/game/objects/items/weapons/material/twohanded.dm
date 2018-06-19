/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
/obj/item/weapon/material/twohanded
	w_class = ITEM_SIZE_HUGE
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_force_divisor = 0.25
	var/wielded_parry_chance = 15

/obj/item/weapon/material/twohanded/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
	else
		wielded = 0
		force = force_unwielded
	update_icon()
	..()

/obj/item/weapon/material/twohanded/update_force()
	..()
	base_name = name
	force_unwielded = round(force*unwielded_force_divisor)
	force_wielded = force
	force = force_unwielded
//	log_debug("[src] has unwielded force [force_unwielded], wielded force [force_wielded] and throwforce [throwforce] when made from default material [material.name]")


/obj/item/weapon/material/twohanded/New()
	..()
	update_icon()

/obj/item/weapon/material/twohanded/get_parry_chance()
	return wielded ? wielded_parry_chance : base_parry_chance

/obj/item/weapon/material/twohanded/update_icon()
	icon_state = "[base_icon][wielded]"
	item_state_slots[slot_l_hand_str] = icon_state
	item_state_slots[slot_r_hand_str] = icon_state

/*
 * Fireaxe
 */
/obj/item/weapon/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"

	force_divisor = 0.6
	unwielded_force_divisor = 0.3
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	force_wielded = 30
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0

/obj/item/weapon/material/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/vine))
			var/obj/effect/vine/P = A
			P.die_off()

//spears, bay edition
/obj/item/weapon/material/twohanded/spear
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 10
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	applies_material_colour = 0

	// 12/19 with hardness 60 (steel) or 10/16 with hardness 50 (glass)
	force_divisor = 0.33
	unwielded_force_divisor = 0.20
	thrown_force_divisor = 1.5 // 20 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 0
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = "glass"

/obj/item/weapon/material/twohanded/spear/shatter(var/consumed)
	if(!consumed)
		new /obj/item/weapon/material/wirerod(get_turf(src)) //give back the wired rod
	..()
