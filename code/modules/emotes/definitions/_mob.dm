/mob/var/list/default_emotes = list()
/mob/var/list/usable_emotes = list()

/mob/proc/update_emotes(skip_sort)
	usable_emotes.Cut()
	for(var/emote in default_emotes)
		var/singleton/emote/emote_datum = GET_SINGLETON(emote)
		if (emote_datum.check_user(src))
			usable_emotes[emote_datum.key] = emote_datum
	if (!skip_sort)
		usable_emotes = sortAssoc(usable_emotes)

/mob/Initialize()
	. = ..()
	update_emotes()

// Specific defines follow.
/mob/living/carbon/alien/default_emotes = list(
	/singleton/emote/visible,
	/singleton/emote/visible/scratch,
	/singleton/emote/visible/drool,
	/singleton/emote/visible/nod,
	/singleton/emote/visible/sway,
	/singleton/emote/visible/sulk,
	/singleton/emote/visible/twitch,
	/singleton/emote/visible/dance,
	/singleton/emote/visible/roll,
	/singleton/emote/visible/shake,
	/singleton/emote/visible/jump,
	/singleton/emote/visible/shiver,
	/singleton/emote/visible/collapse,
	/singleton/emote/audible/hiss,
	/singleton/emote/audible,
	/singleton/emote/audible/deathgasp_alien,
	/singleton/emote/audible/whimper,
	/singleton/emote/audible/gasp,
	/singleton/emote/audible/scretch,
	/singleton/emote/audible/choke,
	/singleton/emote/audible/moan,
	/singleton/emote/audible/gnarl
)

/mob/living/carbon/alien/diona/default_emotes = list(
	/singleton/emote/visible,
	/singleton/emote/visible/scratch,
	/singleton/emote/visible/drool,
	/singleton/emote/visible/nod,
	/singleton/emote/visible/sway,
	/singleton/emote/visible/sulk,
	/singleton/emote/visible/twitch,
	/singleton/emote/visible/dance,
	/singleton/emote/visible/roll,
	/singleton/emote/visible/shake,
	/singleton/emote/visible/jump,
	/singleton/emote/visible/shiver,
	/singleton/emote/visible/collapse,
	/singleton/emote/audible/hiss,
	/singleton/emote/audible,
	/singleton/emote/audible/scretch,
	/singleton/emote/audible/choke,
	/singleton/emote/audible/gnarl,
	/singleton/emote/audible/bug_hiss,
	/singleton/emote/audible/bug_chitter,
	/singleton/emote/audible/chirp
)

/mob/living/carbon/brain/can_emote()
	return (istype(container, /obj/item/device/mmi) && ..())

/mob/living/carbon/brain/default_emotes = list(
	/singleton/emote/audible/alarm,
	/singleton/emote/audible/alert,
	/singleton/emote/audible/notice,
	/singleton/emote/audible/whistle,
	/singleton/emote/audible/synth,
	/singleton/emote/audible/boop,
	/singleton/emote/visible/blink,
	/singleton/emote/visible/flash
)

/mob/living/carbon/human/default_emotes = list(
	/singleton/emote/visible/blink,
	/singleton/emote/audible/synth,
	/singleton/emote/audible/synth/ping,
	/singleton/emote/audible/synth/buzz,
	/singleton/emote/audible/synth/confirm,
	/singleton/emote/audible/synth/deny,
	/singleton/emote/visible/nod,
	/singleton/emote/visible/shake,
	/singleton/emote/visible/shiver,
	/singleton/emote/visible/collapse,
	/singleton/emote/audible/gasp,
	/singleton/emote/audible/sneeze,
	/singleton/emote/audible/sniff,
	/singleton/emote/audible/snore,
	/singleton/emote/audible/whimper,
	/singleton/emote/audible/yawn,
	/singleton/emote/audible/clap,
	/singleton/emote/audible/chuckle,
	/singleton/emote/audible/cough,
	/singleton/emote/audible/cry,
	/singleton/emote/audible/sigh,
	/singleton/emote/audible/slowclap,
	/singleton/emote/audible/laugh,
	/singleton/emote/audible/mumble,
	/singleton/emote/audible/grumble,
	/singleton/emote/audible/groan,
	/singleton/emote/audible/moan,
	/singleton/emote/audible/grunt,
	/singleton/emote/audible/slap,
	/singleton/emote/human,
	/singleton/emote/human/deathgasp,
	/singleton/emote/audible/giggle,
	/singleton/emote/audible/scream,
	/singleton/emote/visible/airguitar,
	/singleton/emote/visible/blink_r,
	/singleton/emote/visible/bow,
	/singleton/emote/visible/salute,
	/singleton/emote/visible/flap,
	/singleton/emote/visible/aflap,
	/singleton/emote/visible/drool,
	/singleton/emote/visible/eyebrow,
	/singleton/emote/visible/twitch,
	/singleton/emote/visible/twitch_v,
	/singleton/emote/visible/faint,
	/singleton/emote/visible/frown,
	/singleton/emote/visible/blush,
	/singleton/emote/visible/wave,
	/singleton/emote/visible/glare,
	/singleton/emote/visible/stare,
	/singleton/emote/visible/look,
	/singleton/emote/visible/point,
	/singleton/emote/visible/raise,
	/singleton/emote/visible/grin,
	/singleton/emote/visible/shrug,
	/singleton/emote/visible/smile,
	/singleton/emote/visible/pale,
	/singleton/emote/visible/tremble,
	/singleton/emote/visible/wink,
	/singleton/emote/visible/hug,
	/singleton/emote/visible/dap,
	/singleton/emote/visible/signal,
	/singleton/emote/visible/handshake,
	/singleton/emote/visible/afold,
	/singleton/emote/visible/alook,
	/singleton/emote/visible/eroll,
	/singleton/emote/visible/hbow,
	/singleton/emote/visible/hip,
	/singleton/emote/visible/holdup,
	/singleton/emote/visible/hshrug,
	/singleton/emote/visible/crub,
	/singleton/emote/visible/erub,
	/singleton/emote/visible/fslap,
	/singleton/emote/visible/ftap,
	/singleton/emote/visible/hrub,
	/singleton/emote/visible/hspread,
	/singleton/emote/visible/pocket,
	/singleton/emote/visible/rsalute,
	/singleton/emote/visible/rshoulder,
	/singleton/emote/visible/squint,
	/singleton/emote/visible/tfist,
	/singleton/emote/visible/tilt,
	/singleton/emote/visible/atten,
)

/mob/living/silicon/robot/default_emotes = list(
	/singleton/emote/audible/clap,
	/singleton/emote/visible/bow,
	/singleton/emote/visible/salute,
	/singleton/emote/visible/rsalute,
	/singleton/emote/visible/flap,
	/singleton/emote/visible/aflap,
	/singleton/emote/visible/twitch,
	/singleton/emote/visible/twitch_v,
	/singleton/emote/visible/nod,
	/singleton/emote/visible/shake,
	/singleton/emote/visible/glare,
	/singleton/emote/visible/look,
	/singleton/emote/visible/stare,
	/singleton/emote/visible/deathgasp_robot,
	/singleton/emote/audible/synth,
	/singleton/emote/audible/synth/ping,
	/singleton/emote/audible/synth/buzz,
	/singleton/emote/audible/synth/confirm,
	/singleton/emote/audible/synth/deny,
	/singleton/emote/audible/synth/security,
	/singleton/emote/audible/synth/security/halt
)

/mob/living/carbon/slime/default_emotes = list(
	/singleton/emote/audible/moan,
	/singleton/emote/visible/twitch,
	/singleton/emote/visible/sway,
	/singleton/emote/visible/shiver,
	/singleton/emote/visible/bounce,
	/singleton/emote/visible/jiggle,
	/singleton/emote/visible/lightup,
	/singleton/emote/visible/vibrate,
	/singleton/emote/slime,
	/singleton/emote/slime/pout,
	/singleton/emote/slime/sad,
	/singleton/emote/slime/angry,
	/singleton/emote/slime/frown,
	/singleton/emote/slime/smile
)
