/datum/map_template/ruin/exoplanet/marooned
	name = "Marooned"
	id = "awaysite_marooned"
	description = "crashed dropship with marooned Magnitka officer"
	suffixes = list("marooned/marooned.dmm")
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	apc_test_exempt_areas = list(
		/area/map_template/marooned = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/item/clothing/under/magintka_uniform
	name = "officer uniform"
	desc = "A dark uniform coat worn by Magnitka fleet officers."
	icon_state = "magnitka_officer"
	icon = 'maps/random_ruins/exoplanet_ruins/marooned/marooned_icons.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/random_ruins/exoplanet_ruins/marooned/marooned_icons.dmi')

/obj/item/clothing/accessory/medal/silver/marooned_medal
	name = "silver medal"
	desc = "An silver round medal of marooned officer. It has inscription \"For Distinguished Service\" in lower part. On medal's plank it's engraved \"H. Warda\""
	icon_state = "marooned_medal"
	icon = 'maps/random_ruins/exoplanet_ruins/marooned/marooned_icons.dmi'

/obj/effect/landmark/corpse/marooned_officer
	name = "Horazy Warda"
	corpse_outfits = list(/decl/hierarchy/outfit/marooned_officer)
	spawn_flags = ~CORPSE_SPAWNER_RANDOM_NAME

/decl/hierarchy/outfit/marooned_officer
	name = "Dead Magnitka's fleet officer"
	uniform = /obj/item/clothing/under/magintka_uniform
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick
	head = /obj/item/clothing/head/beret
	l_pocket = /obj/item/material/knife/folding/combat/switchblade

/obj/item/gun/projectile/revolver/medium/marooned
	name = "worn-out revolver"

/obj/item/gun/projectile/revolver/medium/marooned/Initialize()
	. = ..()
	consume_next_projectile()
	handle_post_fire()

/area/map_template/marooned
	name = "\improper Crashed Dropship"
	icon_state = "A"

/obj/item/paper/marooned
	name = "diary page"
	language = LANGUAGE_HUMAN_RUSSIAN
/obj/item/paper/marooned/note01
	info = "Horacy Warda, Captain First Rank of Magnitka Defence Forces, Special Observation Flotilia. I have been betrayed by my crew and illegally marooned.<br>Main conspirators were Lieutenant Igor Pytlak, Lieutenant Hans Kovac and Captain Third Rank Dragomir Mladic.<br>If you find this, please make sure those dogs face justice."
/obj/item/paper/marooned/note02
	info = "Day 3. I've done the best I could to fix up the hole in my side, but I am not optimistic.<br>The dullness of this place is impossible. I think I forgot the word for 'pencil' yesterday. Will start writing this log to keep myself occupied. Just need to figure out what I can write without getting court-martialed when I get home."
/obj/item/paper/marooned/note03
	info = "Day 4. Saw some animals outside. Look pretty ferocious, and probably not edible. I'll stick to MREs for now.<br>I guess I'll start with how I ended up here. We were on a special mission far away from Magnitka, checking something for the Academy of Sciences, anomalous readings of some sort. The professor looked pretty excited, but I didn't really understand the technical details. We got few scientists embedded in our crew, a civilian hull paintjob and 'alternative' transponder codes. Business as usual."
/obj/item/paper/marooned/note04
	info = "Day 5.<br>We got to the destination without much trouble. A planetoid, in an uncharted sector of space. Scientists locked down the readings they were looking for, and we sent a team down. They returned with some sort of obelisk, etched with symbols I've never seen before, maybe 3 meters tall. Should've ditched that thing out of airlock there and then."
/obj/item/paper/marooned/note05
	info = "Day 8. Made a running wave antenna and jury rigged some amplification for the radio. Hope someone will hear the signal.<br>That obelisk was trouble. People on guard duty in cargo hold kept complaining about headaches and hearing things. Some didn't. They were nice enough to offer to take the shifts of those who complained. Now that I think about it, that's when they started acting weird."
/obj/item/paper/marooned/note06
	info = "Day 14. I've been feverish for some time now, and the wound doesn't look good. So where was I?<br>A week later, we were in the orbit of this planet, replenishing some raw materials from the surface. Mladic came to my quarters, and started talking nonsense. Something about how we have to go back to the planet we found obelisk at, that it 'told' them to do that. I ordered him to snap out of it, and he pulled a stungun on me. That was a mutiny, so according to Directive 714 I pulled my service weapon and shot him right there."
/obj/item/paper/marooned/note07
	info = "Day 15. Still nothing on radio. I only listening to it 3 hours per day now, to save power. Speaking of radio, back then too...<br>No one responded on radio, and when I went to find someone to sort out this mess, I found an even bigger one. There was fighting in the hallways, crew turning on each other, stabbing and shooting. Mess hall was covered in drawings made with blood. It was sick. I knew what caused it, I had to space the damn thing."
/obj/item/paper/marooned/note08
	info = "Day 18. I think. Life support is failing, I am running out of power. I think at this point I just am writing this to avoid thinking about what's to come.<br>I failed. I rallied some of the sane crewmen, and we made a break for the cargo hold, but we were too badly outnumbered. I holed up in the dropship, but the bastards just locked the hatch and overrode controls to send me planetside. And they didn't go for a soft descent. Wrecked dropship hard, barely left the inner hull intact. Some debris pierced my side."
/obj/item/paper/marooned/note09
	info = "Day ???. I'm not getting better. I can barely move now, and even if I try to eat something, I just puke it out. Guess this is it. I am not going to lie here and puke to death, I'm an officer dammit. I'd write something profound, if I could. Damn that obelisk. Glory to Magnitka."

/obj/machinery/computer/dummy
	construct_state = null
