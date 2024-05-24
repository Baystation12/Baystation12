/singleton/emote/audible
	key = "burp"
	emote_message_3p = "USER burps."
	message_type = AUDIBLE_MESSAGE
	var/list/emote_sound

/singleton/emote/audible/do_extra(atom/user)
	if(!emote_sound)
		return
	if (ismob(user))
		var/mob/M = user
		if (world.time < M.next_audible_emote_time)
			M.next_audible_emote_time = world.time + M.audible_emote_cooldown
			return
		M.next_audible_emote_time = world.time + M.audible_emote_cooldown
	var/playable = emote_sound
	if (islist(emote_sound))
		playable = pick(emote_sound)
	playsound(user.loc, playable, 50, 0)

/singleton/emote/audible/deathgasp_alien
	key = "deathgasp"
	emote_message_3p = "USER lets out a waning guttural screech, green blood bubbling from its maw."

/singleton/emote/audible/whimper
	key ="whimper"
	emote_message_3p = "USER whimpers."

/singleton/emote/audible/gasp
	key ="gasp"
	emote_message_3p = "USER gasps."
	conscious = 0

/singleton/emote/audible/scretch
	key ="scretch"
	emote_message_3p = "USER scretches."

/singleton/emote/audible/choke
	key ="choke"
	emote_message_3p = "USER chokes."
	conscious = 0

/singleton/emote/audible/gnarl
	key ="gnarl"
	emote_message_3p = "USER gnarls and shows its teeth.."

/singleton/emote/audible/chirp
	key ="chirp"
	emote_message_3p = "USER chirps!"
	emote_sound = 'sound/misc/nymphchirp.ogg'

/singleton/emote/audible/multichirp
	key ="mchirp"
	emote_message_3p = "USER chirps a chorus of notes!"
	emote_sound = 'sound/misc/multichirp.ogg'

/singleton/emote/audible/alarm
	key = "alarm"
	emote_message_1p = "You sound an alarm."
	emote_message_3p = "USER sounds an alarm."

/singleton/emote/audible/alert
	key = "alert"
	emote_message_1p = "You let out a distressed noise."
	emote_message_3p = "USER lets out a distressed noise."

/singleton/emote/audible/notice
	key = "notice"
	emote_message_1p = "You play a loud tone."
	emote_message_3p = "USER plays a loud tone."

/singleton/emote/audible/whistle
	key = "whistle"
	emote_message_1p = "You whistle."
	emote_message_3p = "USER whistles."

/singleton/emote/audible/boop
	key = "boop"
	emote_message_1p = "You boop."
	emote_message_3p = "USER boops."

/singleton/emote/audible/sneeze
	key = "sneeze"
	emote_message_3p = "USER sneezes."

/singleton/emote/audible/sniff
	key = "sniff"
	emote_message_3p = "USER sniffs."

/singleton/emote/audible/snore
	key = "snore"
	emote_message_3p = "USER snores."
	conscious = 0

/singleton/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "USER whimpers."

/singleton/emote/audible/yawn
	key = "yawn"
	emote_message_3p = "USER yawns."

/singleton/emote/audible/clap
	key = "clap"
	emote_message_3p = "USER claps."

/singleton/emote/audible/chuckle
	key = "chuckle"
	emote_message_3p = "USER chuckles."

/singleton/emote/audible/cough
	key = "cough"
	emote_message_3p = "USER coughs!"
	conscious = 0

/singleton/emote/audible/cry
	key = "cry"
	emote_message_3p = "USER cries."

/singleton/emote/audible/sigh
	key = "sigh"
	emote_message_3p = "USER sighs."

/singleton/emote/audible/slowclap
	key = "slowclap"
	emote_message_3p_target = "USER slowly claps at TARGET."
	emote_message_3p = "USER slowly claps."

/singleton/emote/audible/laugh
	key = "laugh"
	emote_message_3p_target = "USER laughs at TARGET."
	emote_message_3p = "USER laughs."

/singleton/emote/audible/mumble
	key = "mumble"
	emote_message_3p = "USER mumbles!"

/singleton/emote/audible/grumble
	key = "grumble"
	emote_message_3p = "USER grumbles!"

/singleton/emote/audible/groan
	key = "groan"
	emote_message_3p = "USER groans!"
	conscious = 0

/singleton/emote/audible/moan
	key = "moan"
	emote_message_3p = "USER moans!"
	conscious = 0

/singleton/emote/audible/giggle
	key = "giggle"
	emote_message_3p = "USER giggles."

/singleton/emote/audible/scream
	key = "scream"
	emote_message_3p = "USER screams!"

/singleton/emote/audible/grunt
	key = "grunt"
	emote_message_3p = "USER grunts."

/singleton/emote/audible/slap
	key = "slap"
	emote_message_1p_target = "You slap TARGET across the face!"
	emote_message_1p = "You slap yourself across the face!"
	emote_message_3p_target = "USER slaps TARGET across the face!"
	emote_message_3p = "USER slaps USER_SELF across the face!"
	emote_sound = 'sound/effects/snap.ogg'
	check_restraints = TRUE
	check_range = 1

/singleton/emote/audible/bug_hiss
	key ="hiss"
	emote_message_3p_target = "USER hisses at TARGET."
	emote_message_3p = "USER hisses."
	emote_sound = 'sound/voice/BugHiss.ogg'

/singleton/emote/audible/bug_buzz
	key ="buzz"
	emote_message_3p = "USER buzzes its wings."
	emote_sound = 'sound/voice/BugBuzz.ogg'

/singleton/emote/audible/bug_chitter
	key ="chitter"
	emote_message_3p = "USER chitters."
	emote_sound = 'sound/voice/Bug.ogg'

/singleton/emote/audible/roar
	key = "roar"
	emote_message_3p = "USER roars!"

/singleton/emote/audible/bellow
	key = "bellow"
	emote_message_3p = "USER bellows!"

/singleton/emote/audible/howl
	key = "howl"
	emote_message_3p = "USER howls!"

/singleton/emote/audible/wheeze
	key = "wheeze"
	emote_message_3p = "USER wheezes."

/singleton/emote/audible/hiss
	key ="hiss_"
	emote_message_3p_target = "USER hisses softly at TARGET."
	emote_message_3p = "USER hisses softly."

/singleton/emote/audible/lizard_bellow
	key = "bellow"
	emote_message_3p_target = "USER bellows deeply at TARGET!"
	emote_message_3p = "USER bellows!"
	emote_sound = 'sound/voice/LizardBellow.ogg'

/singleton/emote/audible/lizard_squeal
	key = "squeal"
	emote_message_3p = "USER squeals."
	emote_sound = 'sound/voice/LizardSqueal.ogg'
