/obj/item/comms_bypass_key
	name = "Communications Jamming Bypass Key"
	desc = "\
An item used to bypass some of the communications jamming nodes present in the sector.\
Will reduce cooldown time on Long-Range Requisition Consoles."
	var/cooldown_divisor = 2

/obj/item/comms_bypass_key/examine(var/mob/user)
	. = ..()
	to_chat(user,"Somehow, you expect this would divide the remaining cooldown time by [cooldown_divisor]")