/obj/item/weapon/stamp
	name = "rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "stamp-qm"
	item_state = "stamp"
	flags = FPRINT | TABLEPASS
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	m_amt = 60
	item_colour = "cargo"
	pressure_resistance = 2
	attack_verb = list("stamped")

/obj/item/weapon/stamp/captain
	name = "captain's rubber stamp"
	icon_state = "stamp-cap"
	item_colour = "captain"

/obj/item/weapon/stamp/hop
	name = "head of personnel's rubber stamp"
	icon_state = "stamp-hop"
	item_colour = "hop"

/obj/item/weapon/stamp/hos
	name = "head of security's rubber stamp"
	icon_state = "stamp-hos"
	item_colour = "hosred"

/obj/item/weapon/stamp/ce
	name = "chief engineer's rubber stamp"
	icon_state = "stamp-ce"
	item_colour = "chief"

/obj/item/weapon/stamp/rd
	name = "research director's rubber stamp"
	icon_state = "stamp-rd"
	item_colour = "director"

/obj/item/weapon/stamp/cmo
	name = "chief medical officer's rubber stamp"
	icon_state = "stamp-cmo"
	item_colour = "cmo"

/obj/item/weapon/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"
	item_colour = "redcoat"

/obj/item/weapon/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"
	item_colour = "clown"

/obj/item/weapon/stamp/internalaffairs
	name = "internal affairs rubber stamp"
	icon_state = "stamp-intaff"
	item_colour = "intaff"

/obj/item/weapon/stamp/centcomm
	name = "centcomm rubber stamp"
	icon_state = "stamp-cent"
	item_colour = "centcomm"


/obj/item/weapon/stamp/attack_paw(mob/user as mob)
	return attack_hand(user)
