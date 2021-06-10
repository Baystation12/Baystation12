/obj/item/organ/internal/augment/active/simple/popout_shotgun
	name = "pop-out shotgun"
	desc = "A galvanized steel mechanism that replaces most of the flesh below the elbow. Using the arm's natural range of motion as a hinge, it can be flicked open to reveal a 12-gauge shotgun with room for a single shell."
	action_button_name = "Deploy shotgun"
	icon_state = "circuit"
	allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)
	holding_type = /obj/item/gun/projectile/shotgun/popout
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_ESOTERIC = 4)
	deploy_sound = 'sound/weapons/guns/interaction/rifle_boltback.ogg'
	retract_sound = 'sound/weapons/guns/interaction/rifle_boltforward.ogg'
	discoverable = TRUE

/obj/item/gun/projectile/shotgun/popout
	name = "pop-out shotgun"
	desc = "A specialized 12-gauge shotgun concealed in the forearm. A deadly surprise."
	icon = 'icons/obj/augment.dmi'
	icon_state = "circuit"
	item_state = "coilgun"
	max_shells = 1
	w_class = ITEM_SIZE_HUGE
	force = 5
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	caliber = CALIBER_SHOTGUN
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	handle_casings = EJECT_CASINGS
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'
	has_safety = FALSE // No brakes on this train baby
	unacidable = TRUE

/obj/item/gun/projectile/shotgun/popout/check_accidents(mob/living/user, message, skill_path, fail_chance, no_more_fail, factor)
	// The pop-out shotgun is a very unique type of gun and doesn't function like a normal one. We do this to prevent people blowing themselves away if they're not weapons-trained
	return FALSE
