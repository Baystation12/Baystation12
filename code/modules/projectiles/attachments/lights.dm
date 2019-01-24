
/obj/item/weapon_attachment/light
	name = "flashlight attachment"
	desc = "An attachment designed to provide light."

	var/on = 0
	var/intensity = 4
	var/activation_sound = 'sound/effects/flashlight.ogg'

/obj/item/weapon_attachment/light/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.verbs += /obj/item/weapon/gun/proc/toggle_attachment_light

/obj/item/weapon_attachment/light/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.verbs -= /obj/item/weapon/gun/proc/toggle_attachment_light

/obj/item/weapon_attachment/light/ma5_flashlight
	name = "flashlight attachment"
	icon_state = "MA5-Grip-Basic-FlashlightOff"