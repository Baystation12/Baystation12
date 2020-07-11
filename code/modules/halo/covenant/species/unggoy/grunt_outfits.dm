
/decl/hierarchy/outfit/unggoy
	name = "Unggoy (Minor)"

	l_ear = /obj/item/device/radio/headset/covenant
	glasses = /obj/item/clothing/glasses/hud/tactical/covenant
	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness
	back = /obj/item/weapon/tank/methane/unggoy_internal
	uniform = /obj/item/clothing/under/unggoy_internal
	belt = /obj/item/weapon/gun/energy/plasmapistol
	mask = /obj/item/clothing/mask/rebreather
	r_pocket = /obj/item/weapon/grenade/plasma
	//
	gloves = /obj/item/clothing/gloves/thick/grunt_gloves
	shoes = /obj/item/clothing/shoes/grunt_boots
	//
	id_type = /obj/item/weapon/card/id/grunt_minor
	id_slot = slot_wear_id

/decl/hierarchy/outfit/unggoy/post_equip(mob/living/carbon/human/H)
	. = ..()
	H.internal = H.back

/decl/hierarchy/outfit/unggoy_thrall
	name = "Unggoy Thrall"
	l_ear = null
	uniform = /obj/item/clothing/under/unggoy_thrall
	back = /obj/item/weapon/tank/methane
	suit = null
	mask = /obj/item/clothing/mask/rebreather/small
	l_pocket = null
	r_pocket = null

/decl/hierarchy/outfit/unggoy_thrall/ramclan
	name = "Ram Clan Unggoy Thrall"
	l_ear = /obj/item/device/radio/headset/brute_ramclan
	back = /obj/item/weapon/tank/methane/blue

/decl/hierarchy/outfit/unggoy_thrall/boulderclan
	name = "Boulder Clan Unggoy Thrall"
	l_ear = /obj/item/device/radio/headset/brute_boulderclan
	back = /obj/item/weapon/tank/methane/red

/decl/hierarchy/outfit/unggoy/major
	name = "Unggoy (Major)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/major
	back = /obj/item/weapon/tank/methane/unggoy_internal/red
	//
	id_type = /obj/item/weapon/card/id/grunt_major

/decl/hierarchy/outfit/unggoy/heavy
	name = "Unggoy (Heavy)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/heavy
	mask = /obj/item/clothing/mask/rebreather/unggoy_heavy
	back = /obj/item/weapon/tank/methane/unggoy_internal/green
	//
	id_type = /obj/item/weapon/card/id/grunt_heavy

/decl/hierarchy/outfit/unggoy/ultra
	name = "Unggoy (Ultra)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/ultra
	mask = /obj/item/clothing/mask/rebreather/unggoy_ultra
	back = /obj/item/weapon/tank/methane/unggoy_internal/blue
	//
	id_type = /obj/item/weapon/card/id/grunt_ultra

/decl/hierarchy/outfit/unggoy/specops
	name = "Unggoy (Spec-Ops)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/specops
	mask = /obj/item/clothing/mask/rebreather/unggoy_spec_ops
	back = /obj/item/weapon/tank/methane/unggoy_internal/blue
	//
	id_type = /obj/item/weapon/card/id/grunt_specops

/decl/hierarchy/outfit/unggoy/deacon
	name = "Unggoy (Deacon)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/deacon
	mask = /obj/item/clothing/mask/rebreather/unggoy_deacon
	l_hand = /obj/item/language_learner/unggoy_to_common
	back = /obj/item/weapon/tank/methane/unggoy_internal/blue
	//
	id_type = /obj/item/weapon/card/id/grunt_deacon

/decl/hierarchy/outfit/unggoy/honour_guard
	name = "Unggoy (Honour Guard)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/honour_guard
	mask = /obj/item/clothing/mask/rebreather/unggoy_honour_guard
	back = /obj/item/weapon/tank/methane/unggoy_internal/red
	//
	id_type = /obj/item/weapon/card/id/grunt_honour_guard
