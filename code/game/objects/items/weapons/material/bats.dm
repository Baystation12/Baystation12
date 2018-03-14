/obj/item/weapon/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	w_class = ITEM_SIZE_LARGE
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	parrysound = 'sound/effects/woodhit.ogg'
	default_material = "wood"
	force_divisor = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	slot_flags = SLOT_BACK


//Predefined materials go here.
/obj/item/weapon/material/twohanded/baseballbat/metal/New(var/newloc)
	..(newloc,"steel")
	parrysound = 'sound/weapons/parry.ogg'

/obj/item/weapon/material/twohanded/baseballbat/uranium/New(var/newloc)
	..(newloc,"uranium")
	parrysound = 'sound/weapons/parry.ogg'

/obj/item/weapon/material/twohanded/baseballbat/gold/New(var/newloc)
	..(newloc,"gold")
	parrysound = 'sound/weapons/parry.ogg'

/obj/item/weapon/material/twohanded/baseballbat/platinum/New(var/newloc)
	..(newloc,"platinum")
	parrysound = 'sound/weapons/parry.ogg'

/obj/item/weapon/material/twohanded/baseballbat/diamond/New(var/newloc)
	..(newloc,"diamond")
	parrysound = 'sound/weapons/parry.ogg'