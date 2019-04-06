/*
	Mail from home
	Sends a mail crate with a letter and a gift
*/

/datum/event/mail
	var/list/possible_gifts = list(
		/obj/item/device/flashlight/lamp/lava,
		/obj/item/weapon/storage/fancy/crayons,
		/obj/item/instrument/guitar,
		/obj/item/toy/torchmodel,
		/obj/item/clothing/accessory/locket,
		/obj/item/device/binoculars,
		/obj/item/device/camera,
		/obj/item/clothing/accessory/bowtie/ugly
	)

	var/list/rare_gifts = list(
		/obj/item/toy/bosunwhistle,
		/obj/item/toy/cultsword,
		/obj/item/weapon/bikehorn/airhorn,
		/obj/item/weapon/gun/projectile/revolver/capgun,
		/obj/item/weapon/grenade/fake,
		/obj/item/weapon/storage/backpack/clown,
		/obj/item/organ/external/head,
		/obj/item/clothing/glasses/night
	)

/datum/event/mail/announce()
	command_announcement.Announce("A batch of mail adressed to the crew has arrived and will arrive on the next supply shuttle.", pick("Major Bill's Shipping", "Flefingbridge Transport", "SolX Freight", "QuiCo. Mailing Services"), zlevels = affecting_z)

/datum/event/mail/start()
	// Create a crate for all the gifts
	var/obj/structure/closet/crate/gift_crate = new()
	gift_crate.name = "mail crate"

	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		// woohoo, mail time
		if(prob(20))
			var/obj/item/documents/letter = new()
			letter.name = "letter to [CR.get_name()]"
			letter.desc = "A letter from home."
			letter.description_antag = "It's a letter from someone back home. This one is adressed to [CR.get_name()]."
			letter.icon_state = "paper_words"

			var/gift_path = pick(possible_gifts)
			// 0.1% chance to get a rare gift (effectively a 0.0002% chance when the event happens)
			if(rand(1,1000) == 1)
				gift_path = pick(rare_gifts)

			var/obj/item/gift = new gift_path()

			// Wrap it all up in a parcel
			var/obj/item/smallDelivery/parcel = new /obj/item/smallDelivery()
			parcel.name = "normal-sized parcel (to [CR.get_name()])"
			parcel.icon_state = "deliverycrate3"
			letter.forceMove(parcel)
			gift.forceMove(parcel)

			parcel.forceMove(gift_crate)

	// Add the crate to the supply shuttle if possible
	if(!SSsupply.addAtom(gift_crate))
		log_debug("Failed to add mail crate to the supply shuttle!")
		qdel(gift_crate)
