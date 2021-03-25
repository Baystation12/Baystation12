/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 */

/*
 * Retractor
 */
/obj/item/retractor
	name = "retractor"
	desc = "Used to separate the edges of a surgical incision to get to the juicy organs inside."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 5000)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/*
 * Hemostat
 */
/obj/item/hemostat
	name = "hemostat"
	desc = "A type of forceps used to prevent an incision from bleeding, or to extract objects from the inside of the body."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	matter = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 2500)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")

/*
 * Cautery
 */
/obj/item/cautery
	name = "cautery"
	desc = "Uses chemicals to quickly cauterize incisions and other small cuts without causing further damage."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	matter = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 2500, MATERIAL_ALUMINIUM = 1000)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")

/*
 * Surgical Drill
 */
/obj/item/surgicaldrill
	name = "surgical drill"
	desc = "Effectively a very precise hand drill, used to bore holes through bone."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 10000)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 15.0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")

/*
 * Scalpel
 */
/obj/item/scalpel
	name = "scalpel"
	desc = "A tiny and extremely sharp steel cutting tool used for surgery, dissection, autopsy, and very precise cuts. The cornerstone of any surgical procedure."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 10.0
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/*
 * Researchable Scalpels
 */
/obj/item/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"

/obj/item/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0

/obj/item/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0

/obj/item/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5

/*
 * Circular Saw
 */
/obj/item/circular_saw
	name = "circular saw"
	desc = "A small and nasty-looking hand saw used to cut through bone, or in an emergency, pizza."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw3"
	hitsound = 'sound/weapons/circsawhit.ogg'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 15.0
	w_class = ITEM_SIZE_NORMAL
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MATERIAL_STEEL = 20000,MATERIAL_GLASS = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE

//misc, formerly from code/defines/weapons.dm
/obj/item/bonegel
	name = "bone gel"
	desc = "Sophisticated chemical gel used to mend fractures and broken bones before setting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = ITEM_SIZE_SMALL
	throwforce = 1.0

/obj/item/FixOVein
	name = "FixOVein"
	desc = "Derived from a Vey-Med design, this is a very precise surgical tool used to mend cut tendons and severed arteries."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	w_class = ITEM_SIZE_SMALL
	var/usage_amount = 10

/obj/item/bonesetter
	name = "bone setter"
	desc = "A large, heavy clamp for setting dislocated or fractured bones back in place."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned")
