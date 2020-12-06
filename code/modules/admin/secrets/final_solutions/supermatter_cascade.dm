/datum/admin_secret_item/final_solution/supermatter_cascade
	name = "Supermatter Cascade"

/datum/admin_secret_item/final_solution/supermatter_cascade/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/choice = input(user, "You sure you want to destroy the universe and create a large explosion at your location? Misuse of this could result in removal of flags or hilarity.") in list("NO TIME TO EXPLAIN", "Cancel")
	if(choice == "NO TIME TO EXPLAIN")
		var/turf/T = get_turf(user)
		if(!T)
			return
		explosion(T, 8, 16, 24, 32, 1)
		T.ChangeTurf(/turf/unsimulated/wall/supermatter)
		SetUniversalState(/datum/universal_state/supermatter_cascade)
		message_admins("[key_name_admin(user)] has managed to destroy the universe with a supermatter cascade. Good job, [key_name_admin(user)]")
