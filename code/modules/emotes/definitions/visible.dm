/singleton/emote/visible
	key ="tail"
	emote_message_3p = "USER waves USER_THEIR tail."
	message_type = VISIBLE_MESSAGE

/singleton/emote/visible/scratch
	key = "scratch"
	check_restraints = TRUE
	emote_message_3p = "USER scratches."

/singleton/emote/visible/drool
	key ="drool"
	emote_message_3p = "USER drools."
	conscious = 0

/singleton/emote/visible/nod
	key ="nod"
	emote_message_3p_target = "USER nods USER_THEIR head at TARGET."
	emote_message_3p = "USER nods USER_THEIR head."

/singleton/emote/visible/sway
	key ="sway"
	emote_message_3p = "USER sways around dizzily."

/singleton/emote/visible/sulk
	key ="sulk"
	emote_message_3p = "USER sulks down sadly."

/singleton/emote/visible/dance
	key ="dance"
	check_restraints = TRUE
	emote_message_3p = "USER dances around happily."

/singleton/emote/visible/roll
	key ="roll"
	check_restraints = TRUE
	emote_message_3p = "USER rolls."

/singleton/emote/visible/shake
	key ="shake"
	emote_message_3p = "USER shakes USER_THEIR head."

/singleton/emote/visible/jump
	key ="jump"
	emote_message_3p = "USER jumps!"

/singleton/emote/visible/shiver
	key ="shiver"
	emote_message_3p = "USER shivers."
	conscious = 0

/singleton/emote/visible/collapse
	key ="collapse"
	emote_message_3p = "USER collapses!"

/singleton/emote/visible/collapse/do_extra(mob/user)
	if(istype(user))
		user.Paralyse(2)

/singleton/emote/visible/flash
	key = "flash"
	emote_message_3p = "The lights on USER flash quickly."

/singleton/emote/visible/blink
	key = "blink"
	emote_message_3p = "USER blinks."

/singleton/emote/visible/airguitar
	key = "airguitar"
	check_restraints = TRUE
	emote_message_3p = "USER is strumming the air and headbanging like a safari chimp."

/singleton/emote/visible/blink_r
	key = "blink_r"
	emote_message_3p = "USER blinks rapidly."

/singleton/emote/visible/bow
	key = "bow"
	emote_message_3p_target = "USER bows to TARGET."
	emote_message_3p = "USER bows."

/singleton/emote/visible/salute
	key = "salute"
	emote_message_3p_target = "USER salutes TARGET."
	emote_message_3p = "USER salutes."
	check_restraints = TRUE

/singleton/emote/visible/flap
	key = "flap"
	check_restraints = TRUE
	emote_message_3p = "USER flaps USER_THEIR wings."

/singleton/emote/visible/aflap
	key = "aflap"
	check_restraints = TRUE
	emote_message_3p = "USER flaps USER_THEIR wings ANGRILY!"

/singleton/emote/visible/eyebrow
	key = "eyebrow"
	emote_message_3p = "USER raises an eyebrow."

/singleton/emote/visible/twitch
	key = "twitch"
	emote_message_3p = "USER twitches."
	conscious = 0

/singleton/emote/visible/twitch_v
	key = "twitch_v"
	emote_message_3p = "USER twitches violently."
	conscious = 0

/singleton/emote/visible/faint
	key = "faint"
	emote_message_3p = "USER faints."

/singleton/emote/visible/faint/do_extra(mob/user)
	if(istype(user) && user.sleeping <= 0)
		user.sleeping += 10

/singleton/emote/visible/frown
	key = "frown"
	emote_message_3p = "USER frowns."

/singleton/emote/visible/blush
	key = "blush"
	emote_message_3p = "USER blushes."

/singleton/emote/visible/wave
	key = "wave"
	emote_message_3p_target = "USER waves at TARGET."
	emote_message_3p = "USER waves."
	check_restraints = TRUE

/singleton/emote/visible/glare
	key = "glare"
	emote_message_3p_target = "USER glares at TARGET."
	emote_message_3p = "USER glares."

/singleton/emote/visible/stare
	key = "stare"
	emote_message_3p_target = "USER stares at TARGET."
	emote_message_3p = "USER stares."

/singleton/emote/visible/look
	key = "look"
	emote_message_3p_target = "USER looks at TARGET."
	emote_message_3p = "USER looks."

/singleton/emote/visible/point
	key = "point"
	check_restraints = TRUE
	emote_message_3p_target = "USER points to TARGET."
	emote_message_3p = "USER points."

/singleton/emote/visible/raise
	key = "raise"
	check_restraints = TRUE
	emote_message_3p = "USER raises a hand."

/singleton/emote/visible/grin
	key = "grin"
	emote_message_3p_target = "USER grins at TARGET."
	emote_message_3p = "USER grins."

/singleton/emote/visible/shrug
	key = "shrug"
	emote_message_3p = "USER shrugs."

/singleton/emote/visible/smile
	key = "smile"
	emote_message_3p_target = "USER smiles at TARGET."
	emote_message_3p = "USER smiles."

/singleton/emote/visible/pale
	key = "pale"
	emote_message_3p = "USER goes pale for a second."

/singleton/emote/visible/tremble
	key = "tremble"
	emote_message_3p = "USER trembles in fear!"

/singleton/emote/visible/wink
	key = "wink"
	emote_message_3p_target = "USER winks at TARGET."
	emote_message_3p = "USER winks."

/singleton/emote/visible/hug
	key = "hug"
	check_restraints = TRUE
	emote_message_3p_target = "USER hugs TARGET."
	emote_message_3p = "USER hugs USER_SELF."
	check_range = 1

/singleton/emote/visible/dap
	key = "dap"
	check_restraints = TRUE
	emote_message_3p_target = "USER gives daps to TARGET."
	emote_message_3p = "USER sadly can't find anybody to give daps to, and daps USER_SELF."

/singleton/emote/visible/bounce
	key = "bounce"
	emote_message_3p = "USER bounces in place."

/singleton/emote/visible/jiggle
	key = "jiggle"
	emote_message_3p = "USER jiggles!"

/singleton/emote/visible/lightup
	key = "light"
	emote_message_3p = "USER lights up for a bit, then stops."

/singleton/emote/visible/vibrate
	key = "vibrate"
	emote_message_3p = "USER vibrates!"

/singleton/emote/visible/deathgasp_robot
	key = "deathgasp"
	emote_message_3p = "USER shudders violently for a moment, then becomes motionless, USER_THEIR eyes slowly darkening."

/singleton/emote/visible/handshake
	key = "handshake"
	check_restraints = TRUE
	emote_message_3p_target = "USER shakes hands with TARGET."
	emote_message_3p = "USER shakes hands with USER_SELF."
	check_range = 1

/singleton/emote/visible/handshake/get_emote_message_3p(atom/user, atom/target, extra_params)
	if(target && !user.Adjacent(target))
		return "USER holds out USER_THEIR hand out to TARGET."
	return ..()

/singleton/emote/visible/signal
	key = "signal"
	emote_message_3p_target = "USER signals at TARGET."
	emote_message_3p = "USER signals."
	check_restraints = TRUE

/singleton/emote/visible/signal/check_user(atom/user)
	return ismob(user)

/singleton/emote/visible/signal/get_emote_message_3p(mob/user, atom/target, extra_params)
	if (istype(user) && user.HasFreeHand())
		var/t1 = round(text2num(extra_params))
		if(isnum(t1) && t1 <= 5)
			return "USER raises [t1] finger\s."
	return .. ()

/singleton/emote/visible/afold
	key = "afold"
	check_restraints = TRUE
	emote_message_3p = "USER folds USER_THEIR arms."

/singleton/emote/visible/alook
	key = "alook"
	emote_message_3p = "USER looks away."

/singleton/emote/visible/hbow
	key = "hbow"
	emote_message_3p = "USER bows USER_THEIR head."

/singleton/emote/visible/hip
	key = "hip"
	check_restraints = TRUE
	emote_message_3p = "USER puts USER_THEIR hands on USER_THEIR hips."

/singleton/emote/visible/holdup
	key = "holdup"
	check_restraints = TRUE
	emote_message_3p = "USER holds up USER_THEIR palms."

/singleton/emote/visible/hshrug
	key = "hshrug"
	emote_message_3p = "USER gives a half shrug."

/singleton/emote/visible/crub
	key = "crub"
	check_restraints = TRUE
	emote_message_3p = "USER rubs USER_THEIR chin."

/singleton/emote/visible/eroll
	key = "eroll"
	emote_message_3p = "USER rolls USER_THEIR eyes."
	emote_message_3p_target = "USER rolls USER_THEIR eyes at TARGET."

/singleton/emote/visible/erub
	key = "erub"
	check_restraints = TRUE
	emote_message_3p = "USER rubs USER_THEIR eyes."

/singleton/emote/visible/fslap
	key = "fslap"
	check_restraints = TRUE
	emote_message_3p = "USER slaps USER_THEIR forehead."

/singleton/emote/visible/ftap
	key = "ftap"
	emote_message_3p = "USER taps USER_THEIR foot."

/singleton/emote/visible/hrub
	key = "hrub"
	check_restraints = TRUE
	emote_message_3p = "USER rubs USER_THEIR hands together."

/singleton/emote/visible/hspread
	key = "hspread"
	check_restraints = TRUE
	emote_message_3p = "USER spreads USER_THEIR hands."

/singleton/emote/visible/pocket
	key = "pocket"
	check_restraints = TRUE
	emote_message_3p = "USER shoves USER_THEIR hands in USER_THEIR pockets."

/singleton/emote/visible/rsalute
	key = "rsalute"
	check_restraints = TRUE
	emote_message_3p = "USER returns the salute."

/singleton/emote/visible/atten
	key = "atten"
	emote_message_3p = "USER stands at attention."

/singleton/emote/visible/rshoulder
	key = "rshoulder"
	emote_message_3p = "USER rolls USER_THEIR shoulders."

/singleton/emote/visible/squint
	key = "squint"
	emote_message_3p = "USER squints."
	emote_message_3p_target = "USER squints at TARGET."

/singleton/emote/visible/tfist
	key = "tfist"
	emote_message_3p = "USER tightens USER_THEIR hands into fists."

/singleton/emote/visible/tilt
	key = "tilt"
	emote_message_3p = "USER tilts USER_THEIR head."
