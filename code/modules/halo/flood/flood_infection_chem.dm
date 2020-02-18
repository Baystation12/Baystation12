#define FLOOD_INFECTION_MESSAGE_PROB 10
#define FLOOD_INFECTION_MESSAGES_LOW list(\
"Your skin becomes cold to the touch...",\
"A spasm runs through your body...",\
"Visions of a unified purpose invade your thoughts..."\
)
#define FLOOD_INFECTION_MESSAGES_MEDIUM list(\
"Something wriggles underneath your skin...",\
"Your mind goes blank for a moment, replaced only by visions of an endless void...",\
"You feel your mind slipping..."\
)
#define FLOOD_INFECTION_MESSAGES_HIGH list(\
"A chorus of voices speaks in riddles...",\
"You feel something digging into your spinal column...",\
"You hear the voices of long-dead friends..."\
)

//Infection toxin chemical

/datum/reagent/floodinfectiontoxin
	name = "Unknown Biological Contaminant"
	description = "A substance with no known classification."
	reagent_state = LIQUID
	color = "#00BFFF"
	metabolism = 0
	overdose = 27 //Time (60 seconds gas exposure) / 2 (2 seconds between life ticks) * 0.9 (Chemicals lost due to metabolism).
	scannable = 0
	flags = AFFECTS_DEAD

/datum/reagent/floodinfectiontoxin/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)
	if(!prob(FLOOD_INFECTION_MESSAGE_PROB))
		return
	var/percent_to_overdose = (volume / overdose) * 100
	var/message = ""
	if(percent_to_overdose <= 100)
		message = pick(FLOOD_INFECTION_MESSAGES_HIGH)
	if(percent_to_overdose < 50)
		message = pick(FLOOD_INFECTION_MESSAGES_MEDIUM)
	if(percent_to_overdose < 25)
		message = pick(FLOOD_INFECTION_MESSAGES_LOW)
	to_chat(H,"<span class = 'warning'>[message]</span>")

/datum/reagent/floodinfectiontoxin/overdose(var/mob/living/carbon/human/H)
	holder.remove_reagent("Unknown Biological Contaminant",volume)
	if(locate(/obj/effect/dead_infestor) in H.contents)
		return
	to_chat(H,"<span class = 'danger'>Your flesh writhes and twists against your own control...</span>")
	var/mob/living/simple_animal/hostile/flood/spawned_flood = new
	spawned_flood.do_infect(H)
	qdel(spawned_flood)

//Items for testing.
/obj/item/weapon/reagent_containers/glass/bottle/floodtox
	name = "Bottled Unknown Biological Contaminant"
	desc = "A bottle of some unknown biological material, composed of spores floating in a dark-green tinted liquid. A label states: Organism critical mass threshold: 27u."

	New()
		. = ..()
		reagents.add_reagent(/datum/reagent/floodinfectiontoxin,60)