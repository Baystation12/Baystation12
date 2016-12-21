/obj/item/weapon/eros/sex
	icon = 'icons/eros/obj/adult.dmi'
	w_class = 1
	attack_verb = list("pleasured", "violated", "teased", "poked")

/obj/item/weapon/eros/sex/fleshlight
	name = "fleshlight"
	desc = "Somehow, it seems to be the perfect fit for any length. Very cool."
	icon_state = "fleshlight"
	item_state = "fleshlight"
	attack_verb = list("cuntslapped", "violated", "teased", "prodded")
	w_class = 2

/obj/item/weapon/eros/sex/fleshlight/maw
	name = "maw unahole"
	desc = "The silicone is shaped like slightly feminine unathi's maw..."
	icon_state = "unathihole"
	item_state = "unathihole"

/obj/item/weapon/eros/sex/fleshlight/onahole
	name = "onahole"
	desc = "It's a generic-looking unahole, in a pinkish that's probably supposed to be fleshy, but doesn't quite hit the mark."
	icon_state = "onahole"
	item_state = "onahole"

/obj/item/weapon/eros/sex/butt/plug
	name = "butt plug"
	desc = "That seems.. .big."
	icon_state = "plug"
	item_state = "plug"

/obj/item/weapon/eros/sex/butt/beads
	name = "anal beads"
	desc = "They have a ring on the end, for safety."
	icon_state = "beads"
	item_state = "beads"


/obj/item/weapon/eros/sex/bulletvibe
	name = "bullet vibrator"
	desc = "A discreet, versatile vibrator, and don't you let its size fool you. Still one of the most popular vibes on the market."
	icon_state = "bulletvibe"
	item_state = "bulletvibe"
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 30) // Same as a welder, fun fact. -A
	attack_verb = list("pleasured", "vibrated", "teased", "poked")


/obj/item/weapon/eros/sex/dildos
	w_class = 2
	attack_verb = list("fucked", "probed", "violated", "teased", "prodded")

/obj/item/weapon/eros/sex/dildos/attack_self(mob/user as mob)
	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> teases \himself with the [src]!</span>","<span class='notice'>You tease yourself with the [src]!</span>")
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> fucks \himself with the [src]!</span>","<span class='warning'>You fuck yourself with the [src]!</span>")
	else if (user.a_intent == I_GRAB)
		user.visible_message("<span class='warning'><b>\The [user]</b> violates \himself with the [src]!</span>","<span class='warning'>You violate yourself with the [src]!</span>")
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> prods \himself with the [src].</span>","<span class='notice'>You prod yourself with the [src].</span>")


/obj/item/weapon/eros/sex/dildos/bigblackdick
	name = "big black dick"
	desc = "Bigger. Blacker. For when the real thing just doesn't cut it."
	icon_state = "bigblackdick"
	item_state = "bigblackdick"

/obj/item/weapon/eros/sex/dildos/metal_dildo
	name = "metal dildo"
	desc = "That metal is unyielding and unforgiving."
	icon_state = "metal_dildo"
	item_state = "metal_dildo"
	matter = list(DEFAULT_WALL_MATERIAL = 300) //HARD AS SOLID STEEL -A

/obj/item/weapon/eros/sex/dildos/canine
	name = "canine dildo"
	desc = "It has a bulbous knot."
	icon_state = "canine"
	item_state = "canine"

/obj/item/weapon/eros/sex/dildos/floppydick
	name = "floppy dick"
	desc = "The silicone on this toy is particularly soft and, well, kind of flaccid."
	icon_state = "floppydick"
	item_state = "floppydick"
	w_class = 1

/obj/item/weapon/eros/sex/dildos/purpledong
	name = "purple dildo"
	desc = "It's a playful shade of purple."
	icon_state = "purple-dong"
	item_state = "purple-dong"

/obj/item/weapon/eros/sex/dildos/blue
	name = "blue dildo"
	desc = "This blue one has a nice, tapered tip."
	icon_state = "blue"
	item_state = "blue"

/obj/item/weapon/eros/sex/dildos/uglyhorse
	name = "equine dildo"
	desc = "Oh, god."
	icon_state = "uglyhorse"
	item_state = "uglyhorse"

/obj/item/weapon/eros/sex/dildos/knotted
	name = "knotted dildo"
	desc = "It's big, pink and knotted."
	icon_state = "knotted"
	item_state = "knotted"