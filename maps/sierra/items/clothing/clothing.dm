//Try to keep this limited. I don't want unique solgov or NT items in here, it should only be things that require the sierra map datums like access.

/obj/item/rig/hazard/guard
	name = "hazard hardsuit control module"

/obj/item/clothing/head/helmet/space/rig/hazard/guard
	camera = /obj/machinery/camera/network/research

/obj/item/rig/hazard/guard

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/energy/taser
		)
