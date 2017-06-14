//XENOMORPH ORGANS
/obj/item/organ/internal/xenos
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/internal/xenos/eggsac
	name = "egg sac"
	parent_organ = BP_GROIN
	icon_state = "xgibmid1"
	organ_tag = BP_EGG

/obj/item/organ/internal/xenos/plasmavessel
	name = "plasma vessel"
	parent_organ = BP_CHEST
	icon_state = "xgibdown1"
	organ_tag = BP_PLASMA
	var/stored_plasma = 0
	var/max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/obj/item/organ/internal/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/obj/item/organ/internal/xenos/acidgland
	name = "acid gland"
	parent_organ = BP_HEAD
	icon_state = "xgibtorso"
	organ_tag = BP_ACID

/obj/item/organ/internal/xenos/hivenode

	name = "hive node"
	parent_organ = BP_CHEST
	icon_state = "xgibmid2"
	organ_tag = BP_HIVE

/obj/item/organ/internal/xenos/resinspinner
	name = "resin spinner"
	parent_organ = BP_HEAD
	icon_state = "xgibmid2"
	organ_tag = BP_RESIN

/obj/item/organ/internal/eyes/xenos/update_colour()
	if(!owner)
		return
	owner.r_eyes = 153
	owner.g_eyes = 0
	owner.b_eyes = 153
	..()

/obj/item/organ/internal/xenos/hivenode/removed(var/mob/living/user)
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		to_chat(H, "<span class='alium'>You feel your connection to the hivemind fray and fade away...</span>")
		H.remove_language("Hivemind")
		if(H.mind && H.species.get_bodytype(H) != "Xenophage")
			xenomorphs.remove_antagonist(H.mind)
	..(user)

/obj/item/organ/internal/xenos/hivenode/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	if(!..()) return 0

	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.add_language("Hivemind")
		if(H.mind && H.species.get_bodytype(H) != "Xenophage")
			to_chat(H, "<span class='alium'>You feel a sense of pressure as a vast intelligence meshes with your thoughts...</span>")
			xenomorphs.add_antagonist_mind(H.mind,1, xenomorphs.faction_role_text, xenomorphs.faction_welcome)

	return 1

/obj/item/organ/external/head/unbreakable/xeno
	eye_icon = "eyes"
