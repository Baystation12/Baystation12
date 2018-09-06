// sprite stolen from vgstation

/obj/item/weapon/material/bell
	name = "bell"
	desc = "A bell to ring to get people's attention. Don't break it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "bell"
	force_divisor = 0.8
	thrown_force_divisor = 0.3
	hitsound = 'sound/items/oneding.ogg'
	default_material = MATERIAL_SILVER

/obj/item/weapon/material/bell/attack_hand(mob/user as mob)
	if (user.a_intent == I_GRAB)
		return ..()
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'>\The [user] hammers \the [src]!</span>")
		playsound(user.loc, 'sound/items/manydings.ogg', 60)
	else
		user.visible_message("<span class='notice'>\The [user] rings \the [src].</span>")
		playsound(user.loc, 'sound/items/oneding.ogg', 20)

/obj/item/weapon/material/bell/apply_hit_effect()
	. = ..()
	shatter()