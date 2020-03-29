/obj/item/weapon/card/id/exonet
	var/user_id													// The user's ID this card belongs to. This is typically their access_record UID, which is their cortical stack ID.
	var/ennid													// The exonet network ID this card is linked to.
	var/broken = FALSE											// Whether or not this card has been broken.
	var/datum/computer_file/data/access_record/access_record 	// A cached link to the access_record belonging to this card. Do not save this.

/obj/item/weapon/card/id/exonet/GetAccess()
	if(broken)
		return
	if(!access_record)
		refresh_access_record()
	return access

/obj/item/weapon/card/id/exonet/proc/refresh_access_record()
	var/datum/exonet/network = GLOB.exonets[ennid]
	if(!network)
		// This card is totally lost.
		access = null
		broken = TRUE
		return
	for(var/obj/machinery/exonet/mainframe/mainframe in network.mainframes)
		for(var/datum/computer_file/data/access_record/ar in mainframe.stored_files)
			if(ar.user_id != user_id)
				continue // Mismatch user file.
			// We have a match!
			access_record = ar
			access = ar.get_access()
			return
	// No record was found. This card is no longer good.
	access = null
	broken = TRUE
