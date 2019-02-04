//This file is for attachments that require none or very little extra code.
/obj/item/weapon_attachment/ma5_stock_cheekrest
	name = "MA5 stock cheekrest"
	desc = "It's comfortable. That's about it."
	icon_state = "MA5-Shotgun"
	weapon_slot = "upper stock"

/obj/item/weapon_attachment/ma5_stock_butt
	name = "MA5 basic stock butt"
	desc = "A butt for an ma5 stock. It's comfortable, but not much else."
	icon_state = "MA5-Butt-Basic"
	weapon_slot = "stock"

/obj/item/weapon_attachment/ma5_stock_butt/extended
	name = "MA5 extended stock butt"
	desc = "A butt for an ma5 stock. It's been extended."
	icon_state = "MA5-Butt-Extended"
	weapon_slot = "stock"

/obj/item/weapon_attachment/ma5_grip
	name = "MA5 underbarrel grip"
	desc = "An underbarrel grip."
	icon_state = "MA5-Grip-Compact"
	weapon_slot = "underbarrel rail"

/obj/item/weapon_attachment/ma5_upper
	name = "MA5 basic upper"
	desc = "An upper part of an MA5B."
	icon_state = "MA5-Top-Basic"
	weapon_slot = "upper rail"

/obj/item/weapon_attachment/ma5_upper_railed
	name = "MA5 railed upper"
	desc = "An upper part of an MA5B. Has a rail to allow for scope attachment"
	icon_state = "MA5-Top-Rails"
	weapon_slot = "upper rail"

/obj/item/weapon_attachment/ma5_upper_railed/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.attachment_slots += "sight"

/obj/item/weapon_attachment/ma5_upper_railed/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.attachment_slots -= "sight"
