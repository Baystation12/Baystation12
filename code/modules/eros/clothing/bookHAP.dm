/obj/item/weapon/rig/ert/assetprotection/book_hap
	name = "heavy asset advanced protection suit control module"
	desc = "A heavier, more modified version of a common asset protection hardsuit. Has blood red highlights. Built like a tank and could go toe to toe with one too."
	suit_type = "heavy asset advanced protection"
	icon_state = "asset_protection_rig"
	armor = list(melee = 65, bullet = 55, laser = 55,energy = 45, bomb = 45, bio = 100, rad = 100)
	cell_type = /obj/item/weapon/cell/hyper

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/healthscanner
		)
