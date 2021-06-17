/obj/item/gun/energy/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself."
	icon = 'icons/obj/guns/staff.dmi'
	item_icons = null
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'sound/weapons/emitter.ogg'
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	max_shots = 5
	projectile_type = /obj/item/projectile/change
	origin_tech = null
	self_recharge = 1
	charge_meter = 0
	var/required_antag_type = MODE_WIZARD

/obj/item/gun/energy/staff/special_check(var/mob/user)
	if(required_antag_type)
		var/datum/antagonist/antag = get_antag_data(required_antag_type)
		if(user.mind && !antag.is_antagonist(user.mind))
			to_chat(usr, "<span class='warning'>You focus your mind on \the [src], but nothing happens!</span>")
			return 0

	return ..()

/obj/item/gun/energy/staff/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	max_shots = 5
	recharge_time = 5 SECONDS
	projectile_type = /obj/item/projectile/animate

/obj/item/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "focus"
	item_state = "focus"
	projectile_type = /obj/item/projectile/forcebolt
