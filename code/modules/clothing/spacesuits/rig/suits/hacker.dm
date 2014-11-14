/obj/item/weapon/storage/rig/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements."
	icon_state = "hacker_rig"

	helm_type = /obj/item/clothing/head/helmet/space/rig/mask

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack
		)

/obj/item/clothing/head/helmet/space/rig/mask
	name = "mask"
	flags = FPRINT | TABLEPASS | THICKMATERIAL