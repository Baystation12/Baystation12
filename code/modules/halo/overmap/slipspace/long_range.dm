
/obj/machinery/slipspace_engine/covenant/longrange
	name = "\improper Long Range Slipspace Traversal Drive"
	desc = "A device for thrusting the ship into the slipspace dimension to travel to distant star systems."
	slipspace_target_status = 2

/obj/machinery/slipspace_engine/covenant/longrange/user_slipspace_to_nullspace(var/mob/user)
	if(alert(user, "This will take your ship out of the system, this is most likely a one way trip. Are you sure?","Are you sure?","Proceed","Cancel") == "Cancel")
		return

	var/obj/effect/overmap/om_obj = map_sectors["[z]"]

	. = ..(user)

	if(ticker.mode)
		ticker.mode.handle_slipspace_jump(om_obj)
