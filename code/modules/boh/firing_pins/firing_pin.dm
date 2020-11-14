/obj/item/firing_pin
	name = "electronic firing pin"
	desc = "A deceptively named device, the Hephaestus Industries SAFE-LOK is a intelligent subtrate system capable of preventing most standard firearms from firing, depending on various, highly configurable, conditions."
	icon = 'icons/boh/items/firing_pin.dmi'
	icon_state = "firing_pin_base"
	var/emagged = FALSE
	var/obj/item/weapon/gun/installed_in //The gun we're installed in.
	var/pin_tag //what the pin is tagged with - use for overlays.
	var/can_overwrite = TRUE

/obj/item/firing_pin/Initialize()
	update_icon()

/obj/item/firing_pin/on_update_icon()
	overlays.Cut()
	overlays += image('icons/boh/items/firing_pin.dmi', "firing_pin_[pin_tag]")
	return

/obj/item/firing_pin/proc/authorization_check(var/mob/user) //Actual authorization check. Should ALWAYS return TRUE or FALSE depending on conditions. has_access(req_access, user.GetAccess()
	return TRUE

/obj/item/firing_pin/proc/on_auth_fail(var/mob/user) //Called when authorization fails, can be used to make any number of fun effects.
	return




