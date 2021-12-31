#include "lar_maria_areas.dm"

/obj/effect/overmap/visitable/sector/lar_maria
	name = "Lar Maria space station"
	desc = "Sensors detect an orbital station with low energy profile and sporadic life signs."
	icon_state = "object"
	known = 0

/datum/map_template/ruin/away_site/lar_maria
	name = "Lar Maria"
	id = "awaysite_lar_maria"
	description = "An orbital virus research station."
	suffixes = list("lar_maria/lar_maria-1.dmm", "lar_maria/lar_maria-2.dmm")
	spawn_cost = 2
	area_usage_test_exempted_root_areas = list(/area/lar_maria)

///////////////////////////////////crew and prisoners
/obj/effect/landmark/corpse/lar_maria
	eye_colors_per_species = list(SPECIES_HUMAN = list(COLOR_RED))//red eyes
	skin_tones_per_species = list(SPECIES_HUMAN = list(-15))
	facial_styles_per_species = list(SPECIES_HUMAN = list("Shaved"))
	genders_per_species = list(SPECIES_HUMAN = list(MALE))

/mob/living/simple_animal/hostile/lar_maria
	name = "Lar Maria hostile mob"
	desc = "You shouldn't see me!"
	icon = 'maps/away/lar_maria/lar_maria_sprites.dmi'
	unsuitable_atmos_damage = 15
	environment_smash = 1
	faction = "lar_maria"
	status_flags = CANPUSH
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 8
	can_escape = TRUE
	natural_weapon = /obj/item/natural_weapon/punch
	var/obj/effect/landmark/corpse/lar_maria/corpse = null
	var/weapon = null

	ai_holder = /datum/ai_holder/simple_animal/lar_maria
	say_list_type = /datum/say_list/lar_maria

/mob/living/simple_animal/hostile/lar_maria/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	if (weapon)
		new weapon(src.loc)
	visible_message("<span class='warning'>Small shining spores float away from dying [src]!</span>")
	qdel(src)

/mob/living/simple_animal/hostile/lar_maria/test_subject
	name = "\improper test subject"
	desc = "Sick, filthy, angry and probably crazy human in an orange robe."
	icon_state = "test_subject"
	icon_living = "test_subject"
	icon_dead = "test_subject_dead"
	maxHealth = 40
	health = 40
	harm_intent_damage = 5
	corpse = /obj/effect/landmark/corpse/lar_maria/test_subject

/obj/effect/landmark/corpse/lar_maria/test_subject
	name = "Dead test subject"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/test_subject)
	spawn_flags = CORPSE_SPAWNER_NO_RANDOMIZATION//no name, no hairs etc.

/decl/hierarchy/outfit/corpse/test_subject
	name = "Dead ZHP test subject"
	uniform = /obj/item/clothing/under/color/orange
	shoes = /obj/item/clothing/shoes/orange

/obj/effect/landmark/corpse/lar_maria/zhp_guard
	name = "dead guard"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/zhp_guard)
	skin_tones_per_species = list(SPECIES_HUMAN = list(-15))

/obj/effect/landmark/corpse/lar_maria/zhp_guard/dark
	skin_tones_per_species = list(SPECIES_HUMAN = list(-115))

/decl/hierarchy/outfit/corpse/zhp_guard
	name = "Dead ZHP guard"
	uniform = /obj/item/clothing/under/rank/virologist
	suit = /obj/item/clothing/suit/armor/pcarrier
	head = /obj/item/clothing/head/soft/lar_maria/zhp_cap
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset

/mob/living/simple_animal/hostile/lar_maria/guard//angry guards armed with batons and shotguns. Still bite
	name = "\improper security"
	desc = "Guard dressed at Zeng-Hu Pharmaceuticals uniform."
	icon_state = "guard_light"
	maxHealth = 60
	health = 60
	harm_intent_damage = 5
	natural_weapon = /obj/item/melee/baton
	weapon = /obj/item/melee/baton
	corpse = /obj/effect/landmark/corpse/lar_maria/zhp_guard

/mob/living/simple_animal/hostile/lar_maria/guard/Initialize()
	. = ..()
	var/skin_color = pick(list("light","dark"))
	icon_state = "guard_[skin_color]"
	if (skin_color == "dark")
		corpse = /obj/effect/landmark/corpse/lar_maria/zhp_guard/dark

/mob/living/simple_animal/hostile/lar_maria/guard/ranged
	weapon = /obj/item/gun/projectile/shotgun/pump
	ranged = 1
	projectiletype = /obj/item/projectile/bullet/shotgun/beanbag

/mob/living/simple_animal/hostile/lar_maria/guard/ranged/Initialize()
	. = ..()
	icon_state = "[icon_state]_ranged"

/obj/item/clothing/head/soft/lar_maria/zhp_cap
	name = "Zeng-Hu Pharmaceuticals cap"
	icon = 'maps/away/lar_maria/lar_maria_sprites.dmi'
	desc = "A green cap with Zeng-Hu Pharmaceuticals symbol on it."
	icon_state = "zhp_cap"
	item_icons = list(slot_head_str = 'maps/away/lar_maria/lar_maria_clothing_sprites.dmi')

/mob/living/simple_animal/hostile/lar_maria/virologist
	name = "\improper virologist"
	desc = "Virologist dressed at Zeng-Hu Pharmaceuticals uniform."
	icon_state = "virologist_m"
	maxHealth = 50
	health = 50
	harm_intent_damage = 5
	corpse = /obj/effect/landmark/corpse/lar_maria/virologist

/obj/effect/landmark/corpse/lar_maria/virologist
	name = "dead virologist"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/zhp_virologist)

/decl/hierarchy/outfit/corpse/zhp_virologist
	name = "Dead male ZHP virologist"
	uniform = /obj/item/clothing/under/rank/virologist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/latex/nitrile
	head = /obj/item/clothing/head/surgery
	mask = /obj/item/clothing/mask/surgical
	glasses = /obj/item/clothing/glasses/eyepatch/hud/medical

/mob/living/simple_animal/hostile/lar_maria/virologist/female
	icon_state = "virologist_f"
	weapon = /obj/item/scalpel
	corpse = /obj/effect/landmark/corpse/lar_maria/virologist_female

/obj/effect/landmark/corpse/lar_maria/virologist_female
	name = "dead virologist"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/zhp_virologist_female)
	hair_styles_per_species = list(SPECIES_HUMAN = list("Flaired Hair"))
	hair_colors_per_species = list(SPECIES_HUMAN = list("#ae7b48"))
	genders_per_species = list(SPECIES_HUMAN = list(FEMALE))

/decl/hierarchy/outfit/corpse/zhp_virologist_female
	name = "Dead female ZHP virologist"
	uniform = /obj/item/clothing/under/rank/virologist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/latex/nitrile
	mask = /obj/item/clothing/mask/surgical

////////////////////////////Notes and papers
/obj/item/paper/lar_maria/note_1
	name = "paper note"
	info = {"
			<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><b><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></b></center>
			<i>We received the latest batch of subjects this evening. Evening? Is it even evening? The schedule out here is so fucked in terms of sleep-cycles I forget to even check what time it is sometimes. I'm pretty sure it's evening anyway. Anyway, point is, we got the new guys, and thus far they seem like they fit the criteria pretty well. No family histories of diseases or the like, no current illnesses, prime physical condition, perfect subjects for our work. Tomorrow we start testing out the type 008 Serum. Hell if I know where this stuff's coming from, but it's fascinating. Injected into live subjects, it seems like it has a tendancy to not only cure them of ailments, but actually improve their bodily functions...</i>
			"}

/obj/item/paper/lar_maria/note_2
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>I can't believe it, the type 8 Serum seems to actually have a regenerative effect on the subjects. We actually cut one's arm open during the test and ten minutes later, it had clotted. Fifteen and it was healing, and within two hours it was nothing but a fading scar. This is insanity, and the worst part is, we can't even determine HOW it does it yet. All these samples of the goo and not a damn clue how it works, it's infuriating! I'm going to try some additional tests with this stuff. I've heard it's got all kinds of uses, fuel enhancer, condiment, so on and so forth, even with this minty taste, but we'll see. There's got to be some rhyme or reason to this damned stuff.</i>
			"}

/obj/item/paper/lar_maria/note_3
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>The samples of Type 8 we've got are almost out, but it seems like we're actually onto something major here. We'll need to get more sent over asap. This stuff may well be the key to immortality. We cut off one of the test subject's arms and they just put it back on and it healed in an hour or so to the point it was working fine. It's nothing short of miraculous.</i>
			"}

/obj/item/paper/lar_maria/note_4
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Tedd, don't get into the cells with the Type 8 subjects anymore, something's off about them the last couple days. They haven't been moving right, and they seem distracted nearly constantly, and not in a normal way. They also look like they're turning kinda... green? One of the other guys says it's probably just a virus or something reacting with it, but I don't know, something seems off.</i>
			"}

/obj/item/paper/lar_maria/note_5
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			This is a reminder to all facility staff, while we may be doing important work for the good of humanity here, our methods are not necessarily one hundred percent legal under SCG law, and as such you are NOT permitted, as outlined in your contract, to discuss the nature of your work, nor any other related information, with anyone not directly involved with the project without express permission of your facility director. This includes family, friends, local or galactic news outlets and bluenet chat forums.
			"}

/obj/item/paper/lar_maria/note_6
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			Due to the recent incident in the labs involving Type 8 test subject #12 and #33, all research personnel are to refrain from interacting directly with the research subjects involved in serum type 8 testing without the presence of armed guards and full Biohazard protective measures in place.
			"}

/obj/item/paper/lar_maria/note_7
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Can we get some more diversity in test subjects? I know we're mostly working off SCG undesirables, but martians and frontier colonists aren't exactly the most varied bunch. We could majorly benefit from having some Skrell test subjects, for example. Oooh, or one of those GAS things Xynergy's got a monopoly on.</i>
			"}

/obj/item/paper/lar_maria/note_8
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>On a related note, can we get some more female subjects? There's been some discussion about gender related differences in reactions to some of the chemicals we're working on. Testosterone and shit affecting chemical balances or something, I'm not sure, point is, variety.</i>
			"}

/obj/item/paper/lar_maria/note_9
	name = "paper note"
	info = "<i><font color='blue'>can we get some fresh carp sometime? Or freshish? Or frozen? I just really want carp, ok? I'm willing to pay for it if so.</font></i>"

/datum/ai_holder/simple_animal/lar_maria
	speak_chance = 50

/datum/say_list/lar_maria
	speak = list("Die!", "Fresh meat!", "Hurr!", "You said help will come!", "I did nothing!", "Eat my fist!", "One for the road!")
	emote_see = list("cries", "grins insanely", "itches fiercly", "scratches his face", "shakes his fists above his head")
	emote_hear = list("roars", "giggles", "breathes loudly", "mumbles", "yells something unintelligible")