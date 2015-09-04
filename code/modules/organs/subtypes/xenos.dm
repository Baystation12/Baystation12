//XENOMORPH ORGANS
/obj/item/organ/xenos
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/xenos/eggsac
	name = "egg sac"
	parent_organ = "groin"
	icon_state = "xgibmid1"
	organ_tag = "egg sac"

/obj/item/organ/xenos/plasmavessel
	name = "plasma vessel"
	parent_organ = "chest"
	icon_state = "xgibdown1"
	organ_tag = "plasma vessel"
	var/stored_plasma = 0
	var/max_plasma = 500

/obj/item/organ/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/obj/item/organ/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/obj/item/organ/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/obj/item/organ/xenos/acidgland
	name = "acid gland"
	parent_organ = "head"
	icon_state = "xgibtorso"
	organ_tag = "acid gland"

/obj/item/organ/xenos/resinspinner
	name = "resin spinner"
	parent_organ = "head"
	icon_state = "xgibmid2"
	organ_tag = "resin spinner"

/obj/item/organ/xenos/hivenode
	name = "hive node"
	parent_organ = "chest"
	icon_state = "xgibmid2"
	organ_tag = "hive node"

/obj/item/organ/xenos/hivenode/removed(var/mob/living/user)
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H << "<span class='alium'>You feel your connection to the hivemind fray and fade away...</span>"
		H.remove_language("Hivemind")
		if(H.mind && H.species.get_bodytype() != "Xenomorph")
			xenomorphs.remove_antagonist(H.mind)
	..(user)

/obj/item/organ/xenos/hivenode/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)
	..(target, affected)
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.add_language("Hivemind")
		if(H.mind)
			H << "<span class='alium'>You feel a sense of pressure as a vast intelligence meshes with your thoughts...</span>"
			if(H.species.get_bodytype() != "Xenomorph" && xenomorphs.add_antagonist_mind(H.mind,1))
				H << "Your will is ripped away as your humanity merges with the xenomorph hive. You are now a thrall to the queen and her brood. \
				Obey their instructions without question. Serve the hive.</span>"