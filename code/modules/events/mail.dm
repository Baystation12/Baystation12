/*
	Mail from home
	Sends a mail crate on the supply shuttle with letters and a gifts to random crew members
*/

/datum/event/mail
	// This event is actually intended to end when the mail has been spawned on the shuttle, but have a "timeout" just in case
	endWhen = 3000

	var/list/possible_gifts = list(
		/obj/item/device/flashlight/lamp/lava,
		/obj/item/storage/fancy/crayons,
		/obj/item/device/synthesized_instrument/guitar,
		/obj/item/toy/torchmodel,
		/obj/item/clothing/accessory/locket,
		/obj/item/device/binoculars,
		/obj/item/device/camera,
		/obj/item/clothing/accessory/bowtie/ugly
	)

	var/list/rare_gifts = list(
		/obj/item/toy/bosunwhistle,
		/obj/item/toy/cultsword,
		/obj/item/bikehorn/airhorn,
		/obj/item/gun/projectile/revolver/capgun,
		/obj/item/grenade/fake,
		/obj/item/storage/backpack/clown,
		/obj/item/organ/external/head,
		/obj/item/clothing/glasses/night
	)

	var/list/to_receive = list()

/datum/event/mail/setup()
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		if(prob(25))
			to_receive.Add(CR.get_name())

	// Nobody got any mail :(
	if(!to_receive.len)
		log_debug("Nobody got any mail. Aborting event.")
		kill(TRUE)

/datum/event/mail/announce()
	command_announcement.Announce("A batch of mail addressed to the crew of \the [location_name()] has arrived at the sorting office and will arrive on the next available supply shuttle.", pick("Major Bill's Shipping", "Flefingbridge Transport", "SolX Freight", "QuiCo. Mailing Services"), zlevels = affecting_z)

/datum/event/mail/tick()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle

	// No shuttle on the map
	if(isnull(shuttle))
		kill()
		return

	// Make sure the shuttle is idle at the away site
	if(!shuttle.at_station() && shuttle.moving_status == SHUTTLE_IDLE)
		if(spawn_mail())
			kill()

/datum/event/mail/proc/spawn_mail()
	// Create a crate for all the gifts
	var/obj/structure/closet/crate/gift_crate = new()
	gift_crate.SetName("mail crate")

	for(var/name in to_receive)
		var/obj/item/documents/letter = new()
		letter.SetName("letter to [name]")
		letter.desc = "A letter from home."
		letter.description_antag = "It's a letter from someone back home. This one is addressed to [name]."
		letter.icon_state = "paper_words"

		var/gift_path = pick(possible_gifts)
		// 15% chance to get a rare gift
		if(prob(15))
			gift_path = pick(rare_gifts)

		var/obj/item/gift = new gift_path()

		// Wrap it all up in a parcel
		var/obj/item/smallDelivery/parcel = new /obj/item/smallDelivery()
		parcel.SetName("normal-sized parcel (to [name])")
		letter.forceMove(parcel)
		gift.forceMove(parcel)

		parcel.forceMove(gift_crate)

	// Add the crate to the supply shuttle if possible
	if(!SSsupply.addAtom(gift_crate))
		log_debug("Failed to add mail crate to the supply shuttle!")
		qdel(gift_crate)
		return FALSE

	return TRUE
