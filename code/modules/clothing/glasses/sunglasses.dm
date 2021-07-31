/obj/item/clothing/glasses/sunglasses
	name = "sunglasses"
	desc = "Glasses with treated lenses to prevent glare. They provide some rudamentary protection from dazzling attacks."
	icon_state = "sun"
	item_state = "sunglasses"
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MINOR


/obj/item/clothing/glasses/sunglasses/prescription
	prescription = 5
	desc = "Glasses with treated lenses to prevent glare. They provide some rudamentary protection from dazzling attacks. These ones have eyesight-correcting lenses."


/obj/item/clothing/glasses/sunglasses/big
	name = "thick sunglasses"
	desc = "Glasses with treated lenses to prevent glare. The thick, wide lenses protect against a variety of flash attacks."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"
	flash_protection = FLASH_PROTECTION_MODERATE


/obj/item/clothing/glasses/sunglasses/big/prescription
	prescription = 5
	desc = "Glasses with treated lenses to prevent glare. The thick, wide lenses protect against a variety of flash attacks. These ones have eyesight-correcting lenses."


/obj/item/clothing/glasses/aviators_black
	name = "aviator sunglasses"
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have black frames and lenses."
	icon = 'icons/obj/clothing/aviators.dmi'
	icon_state = "black"
	item_icons = list(slot_glasses_str = 'icons/obj/clothing/aviators.dmi')
	item_state_slots = list(slot_glasses_str = "black_onmob")
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE


/obj/item/clothing/glasses/aviators_black/prescription
	prescription = 5
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have black frames and eyesight-correcting lenses."


/obj/item/clothing/glasses/aviators_silver
	name = "aviator sunglasses"
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have silver frames and chrome lenses."
	icon = 'icons/obj/clothing/aviators.dmi'
	icon_state = "silver"
	item_icons = list(slot_glasses_str = 'icons/obj/clothing/aviators.dmi')
	item_state_slots = list(slot_glasses_str = "silver_onmob")
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE


/obj/item/clothing/glasses/aviators_silver/prescription
	prescription = 5
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have silver frames and eyesight-correcting chrome lenses."


/obj/item/clothing/glasses/aviators_gold
	name = "aviator sunglasses"
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have gold frames and chrome lenses."
	icon = 'icons/obj/clothing/aviators.dmi'
	icon_state = "gold"
	item_icons = list(slot_glasses_str = 'icons/obj/clothing/aviators.dmi')
	item_state_slots = list(slot_glasses_str = "gold_onmob")
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE


/obj/item/clothing/glasses/aviators_gold/prescription
	prescription = 5
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have gold frames and eyesight-correcting chrome lenses."


/obj/item/clothing/glasses/aviators_rose
	name = "aviator sunglasses"
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have rose gold frames and goldochre chrome lenses."
	icon = 'icons/obj/clothing/aviators.dmi'
	icon_state = "rose"
	item_icons = list(slot_glasses_str = 'icons/obj/clothing/aviators.dmi')
	item_state_slots = list(slot_glasses_str = "rose_onmob")
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE


/obj/item/clothing/glasses/aviators_rose/prescription
	prescription = 5
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have rose gold frames and eyesight-correcting goldochre chrome lenses."


/obj/item/clothing/glasses/aviators_shutter
	name = "shutter shades"
	desc = "An anachronistic style of glare pr- wait a minute. These don't protect against anything."
	icon = 'icons/obj/clothing/aviators.dmi'
	icon_state = "shutter"
	item_icons = list(slot_glasses_str = 'icons/obj/clothing/aviators.dmi')
	item_state_slots = list(slot_glasses_str = "shutter_onmob")
	darkness_view = -1


/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUD sunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"
	hud = /obj/item/clothing/glasses/hud/security
	electric = TRUE
	flash_protection = FLASH_PROTECTION_MODERATE
	req_access = list(access_security)


/obj/item/clothing/glasses/sunglasses/sechud/prescription
	prescription = 5
	desc = "Sunglasses with a HUD. These ones have eyesight-correcting lenses."


/obj/item/clothing/glasses/sunglasses/sechud/goggles
	name = "HUD goggles"
	desc = "A pair of goggles with an inbuilt heads up display. The lenses provide some flash protection."
	icon_state = "goggles"


/obj/item/clothing/glasses/sunglasses/sechud/goggles/prescription
	prescription = 5
	desc = "A pair of goggles with an inbuilt heads up display. These ones have eyesight-correcting lenses."


/obj/item/clothing/glasses/sunglasses/sechud/toggle
	name = "HUD aviators"
	desc = "Modified aviator glasses that can be switched between HUD and darkened modes."
	icon_state = "sec_hud"
	off_state = "sec_flash"
	action_button_name = "Toggle Mode"
	toggleable = TRUE
	activation_sound = 'sound/effects/pop.ogg'
	var/on = TRUE
	var/hud_holder


/obj/item/clothing/glasses/sunglasses/sechud/toggle/prescription
	prescription = 5
	desc = "Modified aviator glasses that can be switched between HUD and darkened modes. These ones have eyesight-correcting lenses."


/obj/item/clothing/glasses/sunglasses/sechud/toggle/Initialize()
	. = ..()
	hud_holder = hud


/obj/item/clothing/glasses/sunglasses/sechud/toggle/Destroy()
	qdel(hud_holder)
	hud_holder = null
	hud = null
	. = ..()


/obj/item/clothing/glasses/sunglasses/sechud/toggle/attack_self(mob/user)
	if (toggleable && !user.incapacitated())
		on = !on
		if (on)
			flash_protection = FLASH_PROTECTION_NONE
			src.hud = hud_holder
			to_chat(user, "You switch \the [src] to HUD mode.")
		else
			flash_protection = initial(flash_protection)
			src.hud = null
			to_chat(user, "You toggle \the [src]'s darkened mode on.")
		update_icon()
		sound_to(user, activation_sound)
		user.update_inv_glasses()
		user.update_action_buttons()


/obj/item/clothing/glasses/sunglasses/sechud/toggle/on_update_icon()
	if (on)
		icon_state = initial(icon_state)
	else
		icon_state = off_state
