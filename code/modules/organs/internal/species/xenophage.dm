/obj/item/organ/internal/brain/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

//XENOMORPH ORGANS
/obj/item/organ/internal/xeno
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."
	var/associated_power = /mob/living/carbon/human/proc/resin

/obj/item/organ/internal/xeno/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	. = ..()
	if(ishuman(owner) && associated_power)
		owner.verbs |= associated_power

/obj/item/organ/internal/xeno/removed(var/mob/living/user)
	. = ..()
	if(ishuman(owner) && associated_power && !(associated_power in owner.species.inherent_verbs))
		owner.verbs -= associated_power

/obj/item/organ/internal/xeno/eggsac
	name = "egg sac"
	parent_organ = BP_GROIN
	icon_state = "xgibmid1"
	organ_tag = BP_EGG
	associated_power = /mob/living/carbon/human/proc/lay_egg

/obj/item/organ/internal/xeno/plasmavessel
	name = "plasma vessel"
	parent_organ = BP_CHEST
	icon_state = "xgibdown1"
	organ_tag = BP_PLASMA
	var/stored_plasma = 0
	var/max_plasma = 500

/obj/item/organ/internal/xeno/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500
	associated_power = /mob/living/carbon/human/proc/neurotoxin

/obj/item/organ/internal/xeno/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/obj/item/organ/internal/xeno/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/obj/item/organ/internal/xeno/acidgland
	name = "acid gland"
	parent_organ = BP_HEAD
	icon_state = "xgibtorso"
	organ_tag = BP_ACID
	associated_power = /mob/living/carbon/human/proc/corrosive_acid

/obj/item/organ/internal/xeno/hivenode
	name = "hive node"
	parent_organ = BP_CHEST
	icon_state = "xgibmid2"
	organ_tag = BP_HIVE

/obj/item/organ/internal/xeno/resinspinner
	name = "resin spinner"
	parent_organ = BP_HEAD
	icon_state = "xgibmid2"
	organ_tag = BP_RESIN
	associated_power = /mob/living/carbon/human/proc/resin

/obj/item/organ/internal/eyes/xeno/update_colour()
	if(!owner)
		return
	owner.r_eyes = 153
	owner.g_eyes = 0
	owner.b_eyes = 153
	..()

/obj/item/organ/internal/xeno/hivenode/removed(var/mob/living/user)
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		to_chat(H, "<span class='alium'>You feel your connection to the hivemind fray and fade away...</span>")
		H.remove_language("Hivemind")
		if(H.mind && H.species.get_bodytype(H) != "Xenophage")
			GLOB.xenomorphs.remove_antagonist(H.mind)
	..(user)

/obj/item/organ/internal/xeno/hivenode/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	if(!..()) return 0

	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.add_language("Hivemind")
		if(H.mind && H.species.get_bodytype(H) != "Xenophage")
			to_chat(H, "<span class='alium'>You feel a sense of pressure as a vast intelligence meshes with your thoughts...</span>")
			GLOB.xenomorphs.add_antagonist_mind(H.mind,1, GLOB.xenomorphs.faction_role_text, GLOB.xenomorphs.faction_welcome)

	return 1