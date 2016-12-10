// Definitions for shield modes. Names, descriptions and power usage multipliers can be changed here.
// Do not change the mode_flag variables without a good reason!

/datum/shield_mode
	var/mode_name			// User-friendly name of this mode.
	var/mode_desc			// A short description of what the mode does.
	var/mode_flag			// Mode bitflag. See defines file.
	var/multiplier			// Energy usage multiplier. Each enabled mode multiplies upkeep power usage by this number. Values between 1-2 are good balance-wise. Hacked modes can go up to 3-4
	var/hacked_only = 0		// Set to 1 to allow usage of this shield mode only on hacked generators.

/datum/shield_mode/hyperkinetic
	mode_name = "Hyperkinetic Projectiles"
	mode_desc = "This mode blocks various fast moving physical objects, such as bullets, blunt weapons, meteors and other."
	mode_flag = MODEFLAG_HYPERKINETIC
	multiplier = 1.2

/datum/shield_mode/photonic
	mode_name = "Photonic Dispersion"
	mode_desc = "This mode blocks majority of light. This includes beam weaponry and most of the visible light spectrum."
	mode_flag = MODEFLAG_PHOTONIC
	multiplier = 1.3

/datum/shield_mode/humanoids
	mode_name = "Humanoid Lifeforms"
	mode_desc = "This mode blocks various humanoid lifeforms. Does not affect fully synthetic humanoids."
	mode_flag = MODEFLAG_HUMANOIDS
	multiplier = 1.5

/datum/shield_mode/silicon
	mode_name = "Silicon Lifeforms"
	mode_desc = "This mode blocks various silicon based lifeforms."
	mode_flag = MODEFLAG_ANORGANIC
	multiplier = 1.5

/datum/shield_mode/mobs
	mode_name = "Unknown Lifeforms"
	mode_desc = "This mode blocks various other non-humanoid and non-silicon lifeforms. Typical uses include blocking carps."
	mode_flag = MODEFLAG_NONHUMANS
	multiplier = 1.5

/datum/shield_mode/atmosphere
	mode_name = "Atmospheric Containment"
	mode_desc = "This mode blocks air flow and acts as atmosphere containment."
	mode_flag = MODEFLAG_ATMOSPHERIC
	multiplier = 1.3

/datum/shield_mode/hull
	mode_name = "Hull Shielding"
	mode_desc = "This mode recalibrates the field to cover surface of the installation instead of projecting a bubble shaped field."
	mode_flag = MODEFLAG_HULL
	multiplier = 1

/datum/shield_mode/adaptive
	mode_name = "Adaptive Field Harmonics"
	mode_desc = "This mode modulates the shield harmonic frequencies, allowing the field to adapt to various damage types."
	mode_flag = MODEFLAG_MODULATE
	multiplier = 2

/datum/shield_mode/bypass
	mode_name = "Diffuser Bypass"
	mode_desc = "This mode disables the built-in safeties which allows the generator to counter effect of various shield diffusers. This tends to create a very large strain on the generator. Does not work with enabled safety protocols."
	mode_flag = MODEFLAG_BYPASS
	multiplier = 3
	hacked_only = 1

/datum/shield_mode/overcharge
	mode_name = "Field Overcharge"
	mode_desc = "This mode polarises the field, causing damage on contact. Does not work with enabled safety protocols."
	mode_flag = MODEFLAG_OVERCHARGE
	multiplier = 3
	hacked_only = 1

/datum/shield_mode/multiz
	mode_name = "Multi-Dimensional Field Warp"
	mode_desc = "Recalibrates the field projection array to increase the vertical height of the field, allowing it's usage on multi-deck stations or ships."
	mode_flag = MODEFLAG_MULTIZ
	multiplier = 1