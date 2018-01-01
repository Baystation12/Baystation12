/obj/item/device/personal_shield
	name = "personal shield"
	desc = "Truely a life-saver: this device protects its user from being hit by objects moving very, very fast, though only for a few shots."
	icon = 'icons/obj/device.dmi'
	icon_state = "batterer"
	var/uses = 5
	var/obj/aura/personal_shield/device/shield

/obj/item/device/personal_shield/attack_self(var/mob/living/user)
	if(shield)
		qdel(shield)
	else if(uses)
		shield = new(user,src)

/obj/item/device/personal_shield/Move()
	QDEL_NULL(shield)
	return ..()

/obj/item/device/personal_shield/forceMove()
	QDEL_NULL(shield)
	return ..()

/obj/item/device/personal_shield/proc/take_charge()
	if(!--uses)
		QDEL_NULL(shield)
		to_chat(loc,"<span class='danger'>\The [src] begins to spark as it breaks!</span>")
		icon_state = "battererburnt"
		return