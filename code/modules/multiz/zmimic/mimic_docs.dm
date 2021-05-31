/*
Types:
	openspace/multiplier -> shadows the below level, also copies lighting
	openspace/mimic -> copies below movables
	openspace/turf_proxy -> holds the appearance of the below turf for non-OVERWRITE Z-turfs
	openspace/turf_mimic -> copies openspace/turf_proxy objects

Public API:
	Notifying Z-Mimic of icon updates:
	- UPDATE_OO_IF_PRESENT
		- valid on movables only
		- if this movable is being copied, update the copies
		- cheap (if this movable is not being mimiced, this is a null check)

	- atom/update_above()
		- similar to UPDATE_OO_IF_PRESENT, but for both turfs and movables
		- less cheap (pretty much just proc-call overhead)

	Checking state:
	- TURF_IS_MIMICING(turf or any)
		- value: bool - if the passed turf is z-mimic enabled

	- movable/get_above_oo()
		- return: list of movables
		- get a list of every openspace mimic that's copying this atom for things like animate()

	Changing state:
	- turf/enable_zmimic(extra_flags = 0)
		- return: bool - FALSE if this turf was already mimicing, TRUE otherwise
		- Enables z-mimic for this turf, potentially adding extra z_flags.
		- This will automatically queue the turf for update.

	- turf/disable_zmimic()
		- return: bool - FALSE if this turf was not mimicing, TRUE otherwise
		- Disables z-mimic for this turf.
		- This will clean up associated mimic objects, but they may hang around for a few additional seconds.

	Vars:
	- turf/z_flags
		- bitfield
			- ZM_MIMIC_BELOW: copy below atoms
			- ZM_MIMIC_OVERWRITE: z-mimic can overwrite this turf's appearance
			- ZM_ALLOW_LIGHTING: lighting should pass through this turf
			- ZM_ALLOW_ATMOS: air should pass through this turf
			- ZM_MIMIC_NO_AO: normal turf AO should be skipped, only do openspace AO (if your turf is not solid, you probably want this)
			- ZM_NO_OCCLUDE: don't block clicking on below atoms if not OVERWRITE

	- movable/no_z_overlay
		- bool
		- Set this to TRUE if you want Z-Mimic to ignore this atom. Atoms with INVISIBLITY_ABSTRACT are automatically ignored; other invisibility values are inherited.
*/
