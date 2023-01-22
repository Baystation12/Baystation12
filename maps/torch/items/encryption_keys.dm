/obj/item/device/encryptionkey/heads/torchexec
	name = "executive encryption key"
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1, "Exploration" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/science
	name = "science radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Science" = 1, "Exploration" = 1)

/obj/item/device/encryptionkey/headset_torchrd
	name = "chief science officer radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Science" = 1, "Command" = 1, "Exploration" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/headset_torchcorp
	name = "corporate radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Service" = 1)

/obj/item/device/encryptionkey/headset_research_guard
	name = "research_guard's encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Science" = 1)

/obj/item/device/encryptionkey/headset_modsci
	name = "medical science encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Science" = 1, "Medical" = 1)

/obj/item/device/encryptionkey/headset_torchcl
	name = "corporate liaison radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Service" = 1, "Command" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/headset_deckofficer
	name = "deck chief's encryption key"
	icon_state = "qm_cypherkey"
	channels = list("Supply" = 1, "Command" = 1, "Exploration" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/bridgeofficer
	name = "bridge officer's encryption key"
	icon_state = "com_cypherkey"
	channels = list("Command" = 1, "Engineering" = 1, "Exploration" = 1, "Supply" = 1, "Service" = 1, "Science" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/heads/ai_integrated
	name = "ai integrated encryption key"
	desc = "Integrated encryption key."
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1, "Exploration" = 1, "AI Private" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/exploration
	name = "exploration radio encryption key"
	icon_state = "srv_cypherkey"
	channels = list("Exploration" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/headset_expedition_medic
	name = "exploration medic's encryption key"
	icon_state = "srv_cypherkey"
	channels = list("Exploration" = 1, "Hailing" = 1, "Medical" = 1)

/obj/item/device/encryptionkey/headset_expedition_engineer
	name = "exploration engineer's encryption key"
	icon_state = "srv_cypherkey"
	channels = list("Exploration" = 1, "Hailing" = 1, "Engineering" = 1)

/obj/item/device/encryptionkey/headset_pilot
	name = "pilot radio encryption key"
	icon_state = "srv_cypherkey"
	channels = list("Exploration" = 1, "Supply" = 1, "Science" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/headset_mining
	name = "prospector radio encryption key"
	icon_state = "srv_cypherkey"
	channels = list("Supply" = 1, "Exploration" = 1)

/obj/item/storage/box/encryptionkey/exploration
	name = "box of spare exploration radio keys"
	desc = "A box full of exploration department radio keys."
	startswith = list(/obj/item/screwdriver, /obj/item/device/encryptionkey/exploration = 5)

/obj/item/device/encryptionkey/pathfinder
	name = "pathfinder's encryption key"
	icon_state = "com_cypherkey"
	channels = list("Exploration" = 1, "Command" = 1, "Science" = 1, "Hailing" = 1)

/obj/item/storage/box/radiokeys
	name = "box of radio encryption keys"
	desc = "A box full of assorted encryption keys."
	startswith = list(/obj/item/device/encryptionkey/headset_sec = 5,
					  /obj/item/device/encryptionkey/headset_med = 5,
					  /obj/item/device/encryptionkey/headset_cargo = 5,
					  /obj/item/device/encryptionkey/headset_sci = 5)

/obj/item/storage/box/radiokeys/Initialize()
	. = ..()
	make_exact_fit()

/obj/item/device/encryptionkey/heads/sea
	name = "senior enlisted advisor's encryption key"
	icon_state = "com_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1, "Exploration" = 1, "Hailing" = 1)


///////////Boxes with radiokeys/////////// //by proxima


/obj/item/storage/box/encryptionkey/command
	name = "box of spare command radio keys"
	desc = "A box full of command department radio keys."
	startswith = list(/obj/item/screwdriver, /obj/item/device/encryptionkey/headset_com = 5)

/obj/item/storage/box/encryptionkey/security
	name = "box of spare security radio keys"
	desc = "A box full of security department radio keys."
	startswith = list(/obj/item/screwdriver, /obj/item/device/encryptionkey/headset_sec = 5)

/obj/item/storage/box/encryptionkey/engineering
	name = "box of spare engineering radio keys"
	desc = "A box full of engineering department radio keys."
	startswith = list(/obj/item/screwdriver, /obj/item/device/encryptionkey/headset_eng = 5)

/obj/item/storage/box/encryptionkey/science
	name = "box of spare science radio keys"
	desc = "A box full of science department radio keys."
	startswith = list(/obj/item/screwdriver, /obj/item/device/encryptionkey/headset_sci = 5)

/obj/item/storage/box/encryptionkey/medical
	name = "box of spare medical radio keys"
	desc = "A box full of medical department radio keys."
	startswith = list(/obj/item/screwdriver, /obj/item/device/encryptionkey/headset_med = 5)

/obj/item/storage/box/encryptionkey/supply
	name = "box of spare supply radio keys"
	desc = "A box full of supply department radio keys."
	startswith = list(/obj/item/screwdriver, /obj/item/device/encryptionkey/headset_cargo = 5)

/obj/item/storage/box/encryptionkey/service
	name = "box of spare service radio keys"
	desc = "A box full of service department radio keys."
	startswith = list(/obj/item/screwdriver, /obj/item/device/encryptionkey/headset_service = 5)
