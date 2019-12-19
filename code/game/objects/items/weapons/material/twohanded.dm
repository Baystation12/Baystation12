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
	slot_flags = SLOT_BACK
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_force_divisor = 0.25
	var/wielded_parry_bonus = 15

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


/obj/item/weapon/material/twohanded/New()
	..()
	update_icon()

/obj/item/weapon/material/twohanded/get_parry_chance(mob/user)
	. = ..()
	if(wielded)
		. += wielded_parry_bonus

/obj/item/weapon/material/twohanded/on_update_icon()
	..()
	icon_state = "[base_icon][wielded]"
	item_state_slots[slot_l_hand_str] = icon_state
	item_state_slots[slot_r_hand_str] = icon_state
	item_state_slots[slot_back_str] = base_icon

/*
 * Fireaxe
 */
/obj/item/weapon/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"

	max_force = 60	//for wielded
	force_divisor = 0.6
	unwielded_force_divisor = 0.3
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	worth_multiplier = 31

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

/obj/item/weapon/material/twohanded/fireaxe/ishatchet()
	return TRUE

//spears, bay edition
/obj/item/weapon/material/twohanded/spear
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	max_force = 20	//for wielded
	applies_material_colour = 0
	force_divisor = 0.33 // 12/19 with hardness 60 (steel) or 10/16 with hardness 50 (glass)
	unwielded_force_divisor = 0.20
	thrown_force_divisor = 1.5 // 20 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 0
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = MATERIAL_GLASS
	does_spin = FALSE
	worth_multiplier = 7

/obj/item/weapon/material/twohanded/spear/shatter(var/consumed)
	if(!consumed)
		new /obj/item/stack/material/rods(get_turf(src), 1)
		new /obj/item/stack/cable_coil(get_turf(src), 3)
	..()

/obj/item/weapon/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	w_class = ITEM_SIZE_LARGE
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	default_material = MATERIAL_MAPLE
	max_force = 40	//for wielded
	force_divisor = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	attack_cooldown_modifier = 1
	melee_accuracy_bonus = -10

//Predefined materials go here.
/obj/item/weapon/material/twohanded/baseballbat/metal/New(var/newloc)
	..(newloc,MATERIAL_ALUMINIUM)

/obj/item/weapon/material/twohanded/baseballbat/uranium/New(var/newloc)
	..(newloc,MATERIAL_URANIUM)

/obj/item/weapon/material/twohanded/baseballbat/gold/New(var/newloc)
	..(newloc,MATERIAL_GOLD)

/obj/item/weapon/material/twohanded/baseballbat/platinum/New(var/newloc)
	..(newloc,MATERIAL_PLATINUM)

/obj/item/weapon/material/twohanded/baseballbat/diamond/New(var/newloc)
	..(newloc,MATERIAL_DIAMOND)