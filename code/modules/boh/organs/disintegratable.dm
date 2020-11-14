/* Ported from UristMcStation, all credit to Irrationalist.
 *	disintegratable.dm - modules/urist/modules/organs
 *
 * 	can_disintegrate and drop_organ are used in _external.dm in modules/organs/external
 *
 *
 * 	can_disintegrate is defined in this file returns 1 by default
 *
 * 	Currently used mainly to nerf disintegration of certain essential player organs like;
 *		* Neural lace					(modules/organs/internal/stack.dm)
 *		* MMI holders for FBPs			(modules/organs/internal/species/fbp.dm)
 *		* Synthetic brains for IPCs		(modules/organs/internal/species/ipc.dm)
 *
 *
 *  drop_organ is defined in this and by default removes the organ from owner and onto location of owner
 *
 *	Currently used mainly to fix a mind-transfer issue related to mmi_holders
 *
 * 	Created in 2019-05-25 by Irra
 *	Edited	in 2019-06-13 by Irra 	- Added 'drop_organ'
 */

/obj/item/organ/proc/drop_organ(var/mob/living/carbon/human/past_owner = null, var/obj/item/organ/external/parent = null)
	if (past_owner)
		owner = past_owner

	// Null safe-check
	if (!owner)
		return

	// If parent hadn't been provided, try to find the one anyways
	if (!parent)
		parent = owner.get_organ(parent_organ)
	if(istype(parent))
		parent.internal_organs -= src

	removed()

// Special override for MMI holder organ objects
/obj/item/organ/internal/mmi_holder/drop_organ()
	..()
	// This line has to be always be run before the function below. Otherwise, you risk working with null references.
	var/turf/T = get_turf(src)
	var/obj/item/device/mmi/M = transfer_and_delete()
	M.forceMove(T)

/obj/item/organ/proc/can_disintegrate()
	return 1

#define ESSENTIAL_ORGAN_DISINTEGRATABLE 0

/obj/item/organ/internal/posibrain/can_disintegrate()
	return ESSENTIAL_ORGAN_DISINTEGRATABLE

/obj/item/organ/internal/mmi_holder/can_disintegrate()
	return ESSENTIAL_ORGAN_DISINTEGRATABLE

/obj/item/organ/internal/stack/can_disintegrate()
	return ESSENTIAL_ORGAN_DISINTEGRATABLE

#undef ESSENTIAL_ORGAN_DISINTEGRATABLE