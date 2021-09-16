/***********
* Augments *
***********/

/datum/uplink_item/item/augment
	category = /datum/uplink_category/augments

/datum/uplink_item/item/augment/aug_internal_air_system
	name = "Internal Air System CBM (chest, active)"
	desc = "This flexible air sack housed in your torso slowly fills with safe air as you breathe, and can be used as a low-capacity internals source if nothing else is available. \
	It will automatically filter out the safest air for your species. It has been configured to be undetectable on body scanners. \
	NOTE: This augment is incompatible with synthetic biologies."
	item_cost = 24
	path = /obj/item/device/augment_implanter/internal_air_system

/datum/uplink_item/item/augment/aug_adaptive_binoculars
	name = "Adaptive Binoculars CBM (head)"
	desc = "A pair of ultrathin lenses can be deployed or retracted at will from your eye sockets. They have powerful zoom capabilities, allowing you to see into the distance. \
	They have been configured to be undetectable on body scanners."
	item_cost = 30
	path = /obj/item/device/augment_implanter/adaptive_binoculars

/datum/uplink_item/item/augment/aug_iatric_monitor
	name = "Iatric Monitor CBM (head)"
	desc = "A small computer system attached to the brain stem that monitors your life signs. It has been configured to be undetectable on body scanners. \
	It can be activated to gain a simple readout of your current physical state that can be understood regardless of your medical skill. \
	NOTE: This augment is incompatible with synthetic biologies."
	item_cost = 20
	path = /obj/item/device/augment_implanter/iatric_monitor

/datum/uplink_item/item/augment/aug_wrist_blade
	name = "Wrist Blade CBM (arm)"
	desc = "This concealed housing is mounted inside your lower arm, and can be activated to extend a vicious, lightweight blade. Useful for assassinations or self-defense. \
	Developed especially for concealment, its presence will not be revealed by body scanners."
	item_cost = 32 // Identical to an energy sword - much less damage, but it has its own benefits, so consider it a sidegrade
	path = /obj/item/device/augment_implanter/wrist_blade

/datum/uplink_item/item/augment/aug_popout_shotgun
	name = "Pop-out Shotgun CBM (arm)"
	desc = "Replacing a hefty part of your forearm, this mechanism can be controlled with a flicking motion to reveal a long 12-gauge barrel that can fit a single shell. \
	The ultimate trump card when you're out of options. It comes pre-loaded with a single buckshot shell. \
	Due to its bulk, it is impossible to conceal from body scanners, and will be discovered by anyone feeling your bones - install with caution!"
	item_cost = 60
	path = /obj/item/device/augment_implanter/popout_shotgun
