// A simple datum that just holds many lists of lines for mobs to pick from.
// This is its own datum in order to be able to have different types of mobs be able to use the same lines if desired,
// even when inheritence wouldn't be able to do so.

// Also note this also contains emotes, despite its name.
// and now sounds because its probably better that way.

/mob/living
	var/datum/say_list/say_list = null
	var/say_list_type = /datum/say_list	// Type to give us on initialization. Default has empty lists, so the mob will be silent.

/mob/living/Initialize()
	if (say_list_type)
		say_list = new say_list_type(src)
	return ..()

/mob/living/Destroy()
	QDEL_NULL(say_list)
	return ..()


/datum/say_list
	var/list/speak = list()				// Things the mob might say if it talks while idle.
	var/list/emote_hear = list()		// Hearable emotes it might perform
	var/list/emote_see = list()			// Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps

	var/list/say_understood = list()	// When accepting an order.
	var/list/say_cannot = list()		// When they cannot comply.
	var/list/say_maybe_target = list()	// When they briefly see something.
	var/list/say_got_target = list()	// When a target is first assigned.
	var/list/say_threaten = list()		// When threatening someone.
	var/list/say_stand_down = list()	// When the threatened thing goes away.
	var/list/say_escalate = list()		// When the threatened thing doesn't go away.

	var/threaten_sound = null			// Sound file played when the mob's AI calls threaten_target() for the first time.
	var/stand_down_sound = null			// Sound file played when the mob's AI loses sight of the threatened target.







// Subtypes.

// This one's pretty dumb, but pirates are dumb anyways and it makes for a good test.
/datum/say_list/pirate
	speak = list("Yarr!")

	say_understood = list("Alright, matey.")
	say_cannot = list("No, matey.")
	say_maybe_target = list("Eh?")
	say_got_target = list("Yarrrr!")
	say_threaten = list("You best leave, this booty is mine.", "No plank to walk on, just walk away.")
	say_stand_down = list("Good.")
	say_escalate = list("Yarr! The booty is mine!")

// Mercs!
/datum/say_list/merc
	speak = list("When are we gonna get out of this chicken-shit outfit?",
				"Wish I had better equipment...",
				"I knew I should have been a line chef...",
				"Fuckin' helmet keeps fogging up.",
				"Anyone else smell that?")
	emote_see = list("sniffs", "coughs", "taps his foot", "looks around", "checks his equipment")

	say_understood = list("Understood!", "Affirmative!")
	say_cannot = list("Negative!")
	say_maybe_target = list("Who's there?")
	say_got_target = list("Engaging!")
	say_threaten = list("Get out of here!", "Hey! Private Property!")
	say_stand_down = list("Good.")
	say_escalate = list("Your funeral!", "Bring it!")

	threaten_sound = 'sound/weapons/TargetOn.ogg'
	stand_down_sound = 'sound/weapons/TargetOff.ogg'

/datum/say_list/crab
	emote_hear = list("clicks")
	emote_see = list("clacks")

/datum/say_list/spider
	emote_hear = list("chitters")

/datum/say_list/hivebot
	speak = list(
		"Resuming task: Protect area.",
		"No threats found.",
		"Error: No targets found."
		)
	emote_hear = list("hums ominously", "whirrs softly", "grinds a gear")
	emote_see = list("looks around the area", "turns from side to side")
	say_understood = list("Affirmative.", "Positive.")
	say_cannot = list("Denied.", "Negative.")
	say_maybe_target = list("Possible threat detected.  Investigating.", "Motion detected.", "Investigating.")
	say_got_target = list("Threat detected.", "New task: Remove threat.", "Threat removal engaged.", "Engaging target.")

/datum/say_list/lizard
	emote_hear = list("hisses")

/datum/say_list/crab
	emote_hear = list("clicks")
	emote_see = list("clacks")

/datum/say_list/parrot


	speak = list("Hi","Hello!","Cracker?")
	emote_hear = list("squawks","bawks")
	emote_see = list("flutters its wings")

/* For Meatbag */
/datum/say_list/parrot/heist
 speak = list("Yaaar!","Squaaak!","Fight me Matey!","BAWWWWK Vox trying to eat me!")
