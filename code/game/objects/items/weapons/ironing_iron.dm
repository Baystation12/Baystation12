/obj/item/ironingiron
	name = "iron"
	desc = "An ironing iron for ironing your iro- err... clothes."
	icon = 'icons/obj/ironing.dmi'
	icon_state = "iron"
	item_state = "ironingiron"
	w_class = ITEM_SIZE_NORMAL
	throwforce = 10
	throw_speed = 2
	throw_range = 10
	force = 8.0
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")

	var/enabled = 0

/obj/item/ironingiron/attack_self(var/mob/user)
	enabled = !enabled
	to_chat(user, "<span class='notice'>You turn \the [src.name] [enabled ? "on" : "off"].</span>")
	..()