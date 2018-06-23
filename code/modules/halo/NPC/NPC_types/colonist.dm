
/mob/living/simple_animal/npc/colonist
	name = "colonist"
	desc = "A human from one of Earth's diverse cultures who decided to try a future offplanet."
	icon = 'code/modules/halo/NPC/npc.dmi'
	icon_state = "body_m_s"
	emote_hear = list("coughs","sneezes","sniffs","clears their throat","whistles tunelessly")
	emote_see = list("shifts from side to side","scratches their arm","examines their nails","stares at at the ground aimlessly","looks bored")
	speak = list("Have you heard the latest news from Earth?",\
		"I'd love to visit Reach one day.",\
		"If you ever want to visit a frontier world, check out the Draetheus V colony.",\
		"I hope the weather improves.",\
		"The price of starship fuel is insane right now.",\
		"Did you hear the rioting worsened on Far Isle yesterday?",\
		"Have you heard the plans for the spaceport upgrade?",\
		"Let me tell you, Martian made means low quality knockoffs.",\
		"I have relatives on Coral. I should really go visit them.")
	speak_chance = 5
	jumpsuits = list(\
		/obj/item/clothing/under/color/aqua,\
		/obj/item/clothing/under/color/black,\
		/obj/item/clothing/under/color/blue,\
		/obj/item/clothing/under/color/brown,\
		/obj/item/clothing/under/color/darkblue,\
		/obj/item/clothing/under/color/darkred,\
		/obj/item/clothing/under/color/green,\
		/obj/item/clothing/under/color/grey,\
		/obj/item/clothing/under/color/lightblue,\
		/obj/item/clothing/under/color/lightbrown,\
		/obj/item/clothing/under/color/lightgreen,\
		/obj/item/clothing/under/color/lightpurple,\
		/obj/item/clothing/under/color/lightred,\
		/obj/item/clothing/under/color/orange,\
		/obj/item/clothing/under/color/pink,\
		/obj/item/clothing/under/color/red,\
		/obj/item/clothing/under/color/white,\
		/obj/item/clothing/under/color/yellow,\
		/obj/item/clothing/under/color/yellowgreen\
		)
	shoes = list(\
		/obj/item/clothing/shoes/black,\
		/obj/item/clothing/shoes/brown,\
		/obj/item/clothing/shoes/white,\
		/obj/item/clothing/shoes/red,\
		/obj/item/clothing/shoes/orange,\
		/obj/item/clothing/shoes/yellow,\
		/obj/item/clothing/shoes/purple,\
		/obj/item/clothing/shoes/green,\
		/obj/item/clothing/shoes/blue\
		)
	hats = list(\
		/obj/item/clothing/head/bandana,\
		/obj/item/clothing/head/beret,\
		/obj/item/clothing/head/beret/purple,\
		/obj/item/clothing/head/beret/plaincolor,\
		/obj/item/clothing/head/cowboy_hat,\
		/obj/item/clothing/head/det,\
		/obj/item/clothing/head/det/grey,\
		/obj/item/clothing/head/flatcap,\
		/obj/item/clothing/head/ushanka,\
		/obj/item/clothing/head/utility,\
		/obj/item/clothing/head/soft,\
		/obj/item/clothing/head/soft/black,\
		/obj/item/clothing/head/soft/blue,\
		/obj/item/clothing/head/soft/green,\
		/obj/item/clothing/head/soft/grey,\
		/obj/item/clothing/head/soft/mbill,\
		/obj/item/clothing/head/soft/mime,\
		/obj/item/clothing/head/soft/orange,\
		/obj/item/clothing/head/soft/purple,\
		/obj/item/clothing/head/soft/red,\
		/obj/item/clothing/head/soft/yellow\
		)
	gloves = list(\
		/obj/item/clothing/gloves/duty,\
		/obj/item/clothing/gloves/thick\
	)
	suits = list(\
		/obj/item/clothing/suit/leathercoat,\
		/obj/item/clothing/suit/wizrobe/gentlecoat,\
		/obj/item/clothing/suit/chaplain_hoodie,\
		/obj/item/clothing/suit/apron,\
		/obj/item/clothing/suit/apron/overalls\
	)

/mob/living/simple_animal/npc/colonist/New()
	if(!speech_triggers.len)
		var/speech_trigger_type = pick(/datum/npc_speech_trigger/colonist_unsc,\
			/datum/npc_speech_trigger/colonist_innie,\
			null)
		if(speech_trigger_type)
			speech_triggers.Add(new speech_trigger_type())
	desc = "This is [src]. \He is from one of Earth's many diverse cultures that decided to try a future offplanet."
	..()

/mob/living/simple_animal/npc/colonist/labourer
	jumpsuits = list(\
		/obj/item/clothing/under/focal,\
		/obj/item/clothing/under/frontier,\
		/obj/item/clothing/under/overalls,\
		/obj/item/clothing/under/grayson\
		)
	shoes = list(\
		/obj/item/clothing/shoes/workboots\
		)
	hats = list(\
		/obj/item/clothing/head/hardhat,\
		/obj/item/clothing/head/hardhat/dblue,\
		/obj/item/clothing/head/hardhat/orange,\
		/obj/item/clothing/head/hardhat/red,\
		/obj/item/clothing/head/hardhat/white,\
		/obj/item/clothing/head/bandana,\
		/obj/item/clothing/head/orangebandana,\
		)
	hat_chance = 75
	gloves = list(\
		/obj/item/clothing/gloves/botanic_leather,\
		/obj/item/clothing/gloves/duty,\
		/obj/item/clothing/gloves/insulated\
		)
	glove_chance = 66
	suits = list(\
		/obj/item/clothing/suit/apron/overalls\
	)
	suit_chance = 5

/mob/living/simple_animal/npc/colonist/highclass
	jumpsuits = list(\
		/obj/item/clothing/under/blazer,\
		/obj/item/clothing/under/assistantformal,\
		/obj/item/clothing/under/gentlesuit,\
		/obj/item/clothing/under/librarian,\
		/obj/item/clothing/under/lawyer/bluesuit,\
		/obj/item/clothing/under/lawyer/oldman\
		)
	shoes = list(\
		/obj/item/clothing/shoes/laceup,\
		/obj/item/clothing/shoes/leather,\
		/obj/item/clothing/shoes/dress,\
		/obj/item/clothing/shoes/dress/white,\
		/obj/item/clothing/shoes/flats,\
		/obj/item/clothing/shoes/athletic\
		)
	hats = list(\
		/obj/item/clothing/head/fez,\
		/obj/item/clothing/head/bowler,\
		/obj/item/clothing/head/bowlerhat,\
		/obj/item/clothing/head/beaverhat,\
		/obj/item/clothing/head/boaterhat,\
		/obj/item/clothing/head/fedora,\
		/obj/item/clothing/head/feathertrilby,\
		/obj/item/clothing/head/that\
		)
	hat_chance = 25
	gloves = list(\
		/obj/item/clothing/gloves/white,\
		/obj/item/clothing/gloves/thick\
	)
	suits = list(\
		/obj/item/clothing/suit/leathercoat,\
		/obj/item/clothing/suit/wizrobe/gentlecoat,\
		/obj/item/clothing/suit/chaplain_hoodie\
	)
	suit_chance = 10
