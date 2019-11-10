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

/obj/item/weapon_attachment/br55_stock_cheekrest
	name = "BR55 cheekrest"
	desc = "More comfortable to shoot with."
	icon_state = "BR55-Cheekrest"
	weapon_slot = "upper stock"

/obj/item/weapon_attachment/vertical_grip
	name = "vertical grip"
	desc = "A vertical grip which reduces horizontal sway when firing."
	icon_state = "vertical-grip-obj"
	weapon_slot = "underbarrel rail"

/obj/item/weapon_attachment/br55_upper
	name = "BR55 carry handle"
	desc = "Carry handle for a BR55."
	icon_state = "BR55-CarryHandle"
	weapon_slot = "upper rail"

/obj/item/weapon_attachment/br55_upper/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.attachment_slots += "sight"

/obj/item/weapon_attachment/br55_upper/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.attachment_slots -= "sight"

/obj/item/weapon_attachment/br55_bottom
	name = "BR55 hand guard"
	desc = "Metal plate that stops the user from holding too close to the barrel."
	icon_state = "BR55-Bottom"
	weapon_slot = "underbarrel rail"