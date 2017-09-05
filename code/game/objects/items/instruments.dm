/obj/item/instrument
	icon = 'icons/obj/items.dmi'
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	force = 0

/obj/item/instrument/guitar
	name = "guitar"
	desc = "An antique musical instrument made of wood, originating from Earth.	It has six metal strings of different girth and tension. When moved, they vibrate and the waves resonate in the guitar's open body, producing sounds. Obtained notes can be altered by pressing the strings to the neck, affecting the vibration's frequency."
	icon = 'icons/obj/items.dmi'
	icon_state = "guitar"

/obj/item/instrument/guitar/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'><b>\The [user]</b> strums [src]!</span>","<span class='notice'>You strum [src]!</span>")
