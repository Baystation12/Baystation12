/datum/craft_recipe/salvage
	category = "Salvage"
	time = 150
	icon_state = "gun"

/datum/craft_recipe/salvage/salvage_sawblade
	name = "Salvage sawblade"
	desc = "Disassemble a circular saw to get a sawblade which can be used for other purposes."
	result = /obj/item/ammo_casing/sawblade
	steps = list(
	list(CRAFT_OBJECT, /obj/item/weapon/tool/saw/circular),
	list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, "time" = 150),
	)

/datum/craft_recipe/salvage/salvage_sawblade_adv
	name = "Salvage diamond sawblade"
	desc = "Disassemble an advanced circular saw to get a diamond sawblade which can be used for other purposes."
	result = /obj/item/ammo_casing/sawblade/diamond
	steps = list(
	list(CRAFT_OBJECT, /obj/item/weapon/tool/saw/advanced_circular),
	list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, "time" = 300),
	)