#define XENO_PLANT_FRUITGROW_DELAY 1 MINUTE
#define XENO_PLANT_SMOKE_DELAY 30 SECONDS

/obj/structure/xeno_plant
	name = "\improper Xeno Plant"
	desc = "A plant of unknown origin."
	icon = 'code/modules/halo/misc/xeno_plant.dmi'
	anchored = 0
	density = 1

	var/list/reagents_can_spawn = list(\
	/datum/reagent/toxin/hair_remover,/datum/reagent/hyperzine,/datum/reagent/bicaridine,\
	/datum/reagent/space_drugs,/datum/reagent/dermaline,/datum/reagent/dylovene,/datum/reagent/dexalin,\
	/datum/reagent/dexalinp,/datum/reagent/oxycodone,/datum/reagent/toxin/carpotoxin,/datum/reagent/lexorin,\
	/datum/reagent/impedrezene,/datum/reagent/mindbreaker)
	var/datum/reagents/internal_container
	var/next_fruit_at = 0
	var/next_smoke_at = 0

/obj/structure/xeno_plant/New()
	. = ..()
	icon_state = "weird_plant[pick("1","2","3")]"
	internal_container = new/datum/reagents(20,src)
	GLOB.processing_objects += src

/obj/structure/xeno_plant/Destroy()
	GLOB.processing_objects -= src
	. = ..()

/obj/structure/xeno_plant/attack_hand(var/mob/living/carbon/human/M)
	if(world.time < next_fruit_at)
		to_chat(M,"<span class = 'notice'>[src] hasn't grown any more fruit yet.</span>")
		return
	var/obj/item/weapon/reagent_containers/food/snacks/grown/g = new(loc,pick(plant_controller.seeds))
	g.reagents.add_reagent(pick(reagents_can_spawn),40)
	if(g.nutriment_amt == 0)
		g.nutriment_amt = 1
	if(g.bitesize == 0)
		g.bitesize = 1
	visible_message("<span class = 'notice'>[M] picks one of the fruits off of [src]</span>")
	next_fruit_at = world.time + XENO_PLANT_FRUITGROW_DELAY

/obj/structure/xeno_plant/process()
	if(world.time > next_smoke_at)
		next_smoke_at = world.time + XENO_PLANT_SMOKE_DELAY
		internal_container.add_reagent(pick(reagents_can_spawn),5)
		internal_container.add_reagent(/datum/reagent/potassium,5)
		internal_container.add_reagent(/datum/reagent/sugar,5)
		internal_container.add_reagent(/datum/reagent/phosphorus,5)