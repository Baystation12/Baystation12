/datum/equip_node_group
	var/datum/equip_node/list/nodes = list()
	var/obj/item/clothing/contains

	var/plane
	var/list/layers = list()

/datum/equip_node
	var/datum/equip_node/back
	var/datum/equip_node/next
	var/obj/item/organ/external/body_part
	var/datum/equip_node_group/group

/datum/equip_node_group/proc/equip(var/mob/living/carbon/human/H)

/datum/equip_node_group/proc/unequip(var/mob/living/carbon/human/H)

/datum/equip_node_group/proc/limbs_overlap(var/mob/living/carbon/human/H)

/datum/equip_node/proc/layer_overlaps(var/datum/equip_node/nodeB)
	var/datum/equip_node/nodeA = src
	var/planeA = nodeA.group.plane
	var/planeB = nodeB.group.plane
	var/list/layersA = nodeA.group.layers
	var/list/layersB = nodeB.group.layers

	return(!((planeA != planeB) || (layersA & layersB)))

/datum/equip_node/proc/give_greater(var/datum/equip_node/nodeB)
	var/datum/equip_node/nodeA = src
	if(layer_overlaps(nodeB))
		return
	if(!nodeB)
		return src
	var/planeA = nodeA.group.plane
	var/planeB = nodeB.group.plane

	if(planeA < planeB)
		return nodeB
	if(planeB < planeA)
		return nodeA

	var/list/layersA = nodeA.group.layers
	var/list/layersB = nodeB.group.layers

	if(layersA[1] < layersB[1])
		return nodeB
	if(layersB[1] < layersA[1])
		return nodeA
