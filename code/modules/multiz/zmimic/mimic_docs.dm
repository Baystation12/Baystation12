/*
Types (also see terminology section):
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
	- TURF_IS_MIMICKING(turf or any)
		- value: bool - if the passed turf is z-mimic enabled

	- movable/get_above_oo()
		- return: list of movables
		- get a list of every openspace mimic that's copying this atom for things like animate()

	Changing state:
	- turf/enable_zmimic(extra_flags = 0)
		- return: bool - FALSE if this turf was already mimicking, TRUE otherwise
		- Enables z-mimic for this turf, potentially adding extra z_flags.
		- This will automatically queue the turf for update.

	- turf/disable_zmimic()
		- return: bool - FALSE if this turf was not mimicking, TRUE otherwise
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

	- atom/movable/z_flags
		- bitfield
			- ZMM_IGNORE: Do not copy this atom. Atoms with INVISIBILITY_ABSTRACT are automatically not copied.
			- ZMM_MANGLE_PLANES: Scan this atom's overlays and monkeypatch explicit plane sets. Fixes emissive overlays shining through floors, but expensive -- use only if necessary.

Implementation details:
	Z-Mimic makes some assumptions. While it may continue to work if these are violated, don't be surprised if it behaves strangely, renders things in the incorrect order, or outright breaks.

	Assumptions:
	- Z-Stacks will not be taller than OPENTURF_MAX_DEPTH.
		- If violated: Warning emitted on boot, layering may break for items near the bottom of the z-stack.
	- Atoms will render correctly if copied to another plane.
	- Atoms will layer correctly if copied to the same plane as other arbitrary in-world atoms.
	- Atoms without ZMM_MANGLE_PLANES do not have any overlays that have explicit plane sets.
		- If violated: Atoms on the below floor may be partially visible on the current floor.
	- Z-Stacks are 1:1 across the entire x/y plane.
		- If violated: Z-turfs may form nonsensical connections.
	- Z-Stacks are contiguous and linear -- get_step(UP) corresponds to moving up a z-level (within a z-stack) in all cases.
		- If violated: layering becomes nonsensical.
	- Z-Stacks will not be changed (note: adding new Z-stacks is OK) after an openturf has been initialized on that z-stack.
		- If violated: Z-Turfs may act as if they are still connected even though they are not.
	- /turf/space is never above another turf type in the Z-Stack.
	- Turfs that are setting ZM_MIMIC_OVERWRITE do not care about their appearance.
		- If violated: Appearance of turf is lost.
	- Multiturf movable atoms are symmetric, and centered on their visual center.
		- If violated: Multitile atoms may not render in cases where they should.
	- SHADOWER_DARKENING_FACTOR and SHADOWER_DARKENING_COLOR represent the same shade of grey.
		- If violated: unlit and lit z-turfs may look inconsistent with each other.
	- Lighting will mimic correctly without being associated with a plane.
		- If violated: depending on implementation, lighting may be inverted, or not render at all.
		- This can usually be addressed by changing /atom/movable/openspace/multiplier/proc/copy_lighting().

	Known Limitations:
	- Multiturf movable atoms are not rendered if they are not centered on a z-turf, but overlap one.
	- vis_contents is ignored -- mimics will not copy it.

	Terminology (of varying obscurity):
	- Z-Stack
		- A set of z-connected turfs with the same x/y coordinates.
	- Z-Depth
		- How many Z-levels this atom is *from the top of a Z-Stack* (absolute layering), regardless of z-turf presence
	- Shadower / Multiplier
		- An abstract object used to darken lower levels, copy lighting, and host Z-AO overlays.
	- Mimic / Openspace Object
		- An abstract object that holds appearances of atoms and proxies clicks.
	- Turf Proxy / Turf Object
		- An abstract object that holds Z-Copy turf appearances for non-OVERWRITE turfs.
	- Turf Mimic
		- An abstract object that holds appearances of non-OVERWRITE z-turfs below this z-turf.
	- Foreign Turf
		- A turf below this z-turf that is contributing to our appearance.
	- Mimic Underlay
		- A turf appearance holder specifically for fake space below a z-turf at the bottom of a z-stack.
*/
