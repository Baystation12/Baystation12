
/mob/living/simple_animal/npc/colonist
	name = "colonist"
	npc_job_title = "NPC Colonist"
	desc = "A human from one of Earth's diverse cultures who decided to try a future offplanet."
	emote_hear = list("coughs","sneezes","sniffs","clears their throat","whistles tunelessly","sighs deeply","yawns","gasps loudly")
	emote_see = list("shifts from side to side.","scratches their arm.","examines their nails.","stares at at the ground aimlessly.","looks bored.","places their hands in their pockets.","stares at you with a blank expression.")
	speak = list("Have you heard the latest news from Earth?",\
		"I'd love to visit Reach one day.",\
		"Do the UNSC really care about us? I haven't see them in years!",\
		"Did you hear the Insurrection are stealing UNSC ships? they've already stolen two so far!",\
		"If you ever want to visit a frontier world, check out the Draetheus V colony.",\
		"I hope the weather improves.",\
		"I hope this war ends soon",\
		"If I were you I'd leave this place before you end up dead.",\
		"The 111 Tauri System isn't like the inner colonies or Earth, we play by other rules out here!",\
		"Who knows the UEG might bless us with less taxes and more biofoam!",\
		"Oof.",\
		"I swear I hate KS7 nothing but snow and rocks, Geminus is a way better colony!",\
		"Sometimes the UNSC can be full of madlads.",\
		"Sometimes I think the Insurrection can do good for us outer colonist!",\
		"I swear that gun smuggler has the most awful prices",\
		"Will the UEG ever let KS7 rejoin them?",\
		"I really need a drink right now.",\
		"Anyone here got a smoke?",\
		"Just great I lost my credits!",\
		"I could care less about UNSC or Insurrection, I just want to fish!",\
		"Born to fish, forced to work.",\
		"I use to be a UNSC marine like you,then I took an bullet to the knee",\
		"I can't believe they took the kids after leaving me.",\
		"I met this guy named Blackburn and we hit it off, I hope he calls me back because I have some news to tell him.",\
		"The price of these UEG taxes is insane right now.",\
		"Did you hear about the colonies going dark?",\
		"Nah, that's all just propaganda about the colonies going dark.",\
		"Theres nothing like coffee in the morning, let me tell you,that stuff brings you back from the dead.",\
		"Did you hear about that ODST that murdered those civilians on the CCV Deliverance medical ship? I heard they're still on the run hiding in Geminus",\
		"Still can't believe it's been five years since Far Isle got nuked.",\
		"Have you heard the plans for the spaceport upgrade?",\
		"You heard the plans for the spaceport upgrade?",\
		"Let me tell you, Martian made means low quality knockoffs.",\
		"Hey did you hear that rumour of those big green walking tanks?",\
		"Bleh, this sucks, why does nothing interesting ever happen to this colony?",\
		"Been seeing a lot more traffic in these parts, I wonder why?",\
		"I use to be a soldier like you, then I took a landmine to the knee.",\
		"Use to live on Far Isle, still don’t know what happened to that place... wiped from existence.",\
		"Have you seen those uh... Helljumpers? In that sleek black armor? Man I wanna be one of them some day.",\
		"Hey, did you hear they reopened recruitment for the Hellbringers? I wonder what that’s all about.",\
		"Feels good to live on a free planet!",\
		"Went hunting last week, found me one of those ice-boar things, they may smell terrible but they taste pretty good!",\
		"Have you ever been to space? Sometimes I long for my chance.",\
		"Crayons actually taste pretty nice.",\
		"I heard Earth it quite beautiful this time of year. Maybe I’ll visit it one day.",\
		"Tried my hand at the International War Photography Prize last year, came in last place.",\
		"I have relatives on Harvest. I should really go visit them because I haven't heard from them for awhile.")
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
	glasses = list(/obj/item/clothing/glasses/regular,/obj/item/clothing/glasses/regular/hipster)
	glasses_chance = 20

/mob/living/simple_animal/npc/colonist/New()
	if(!speech_triggers.len)
		var/speech_trigger_type = pick(/datum/npc_speech_trigger/colonist_unsc,\
			/datum/npc_speech_trigger/colonist_innie,\
			/datum/npc_speech_trigger/colonist_covenant,\
			null)
		if(speech_trigger_type)
			speech_triggers.Add(new speech_trigger_type())
	desc = "This is [src]. [initial(desc)]."
	. = ..()

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
	glasses = list(/obj/item/clothing/glasses/meson,/obj/item/clothing/glasses/sunglasses,/obj/item/clothing/glasses/material,/obj/item/clothing/glasses/thermal)
	glasses_chance = 33

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
