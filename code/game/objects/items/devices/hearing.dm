/obj/item/device/hearing
	name = "hearing device"
	desc = "It seems to be the abstract concept of a hearing device. You're not really sure what you're looking at specifically, though. Seems to be for debugging purposes."
	icon = 'icons/obj/clothing/hearing.dmi'

	slot_flags = SLOT_EARS

/obj/item/device/hearing/proc/adjust_hearing_loss(hearing_loss)
	return hearing_loss

/obj/item/device/hearing/cochlear_implant_processor
	name = "cochlear implant processor"
	desc = "Ear-mounted device that transmits audio from outside to an implant inside the cochlea. Seems to be for debugging purposes."

	icon_state = "ci_processor"
	item_state = "ci_processor"

/obj/item/device/hearing/cochlear_implant_processor/adjust_hearing_loss(hearing_loss)
	return 0.25

/obj/item/device/hearing/hearing_aid
	name = "hearing aid"
	desc = "Ear-mounted device that amplifies sounds coming into the ear. Seems to be for debugging purposes."

	icon_state = "hearing_aid"
	item_state = "hearing_aid"

/obj/item/device/hearing/hearing_aid/adjust_hearing_loss(hearing_loss)
	return hearing_loss * 0.5
