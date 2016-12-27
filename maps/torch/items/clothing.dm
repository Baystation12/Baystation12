//Try to keep this limited. I don't want unique solgov or NT items in here, it should only be things that require the torch map datums like access.

/obj/item/weapon/rig/hazard/guard
	name = "hazard hardsuit control module"

	req_access = list(access_sec_guard)

/obj/item/clothing/head/helmet/space/rig/hazard/guard
	camera = /obj/machinery/camera/network/research

/obj/item/weapon/rig/hazard/equipped

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/mounted/taser
		)