/obj/item/device/personal_shield/legion
	name = "shield device"
	shield_power_cost = 0
	shield_type = /obj/aura/personal_shield/device/legion


/obj/aura/personal_shield/device/legion
	name = "shield device"
	effect_icon = 'packs/event_legion_find/icons/legion_shield.dmi'


/obj/aura/personal_shield/device/legion/aura_check_weapon(obj/item/weapon, mob/attacker, click_params)
	user.visible_message(
		SPAN_WARNING("\The [user]'s [name] flashes before \the [attacker] can hit them!")
	)
	new /obj/temporary(get_turf(src), 2 SECONDS, effect_icon, "shield_impact")
	playsound(user, 'sound/effects/basscannon.ogg', 35, TRUE)
	return AURA_FALSE | AURA_CANCEL
