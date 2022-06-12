/mob
	var/list/default_emotes = list()
	var/list/usable_emotes = list()

/mob/proc/update_emotes(var/skip_sort)
	usable_emotes.Cut()
	for(var/emote in default_emotes)
		var/decl/emote/emote_datum = decls_repository.get_decl(emote)
		if(emote_datum.check_user(src))
			usable_emotes[emote_datum.key] = emote_datum
	if(!skip_sort)
		usable_emotes = sortAssoc(usable_emotes)

/mob/Initialize()
	. = ..()
	update_emotes()

// Specific defines follow.
/mob/living/carbon/alien
	default_emotes = list(
		/decl/emote/visible,
		/decl/emote/visible/scratch,
		/decl/emote/visible/drool,
		/decl/emote/visible/nod,
		/decl/emote/visible/sway,
		/decl/emote/visible/sulk,
		/decl/emote/visible/twitch,
		/decl/emote/visible/dance,
		/decl/emote/visible/roll,
		/decl/emote/visible/shake,
		/decl/emote/visible/jump,
		/decl/emote/visible/shiver,
		/decl/emote/visible/collapse,
		/decl/emote/audible/hiss,
		/decl/emote/audible,
		/decl/emote/audible/deathgasp_alien,
		/decl/emote/audible/whimper,
		/decl/emote/audible/gasp,
		/decl/emote/audible/choke,
		/decl/emote/audible/moan,
		/decl/emote/audible/gnarl
		)

/mob/living/carbon/alien/diona
	default_emotes = list(
		/decl/emote/visible,
		/decl/emote/visible/scratch,
		/decl/emote/visible/drool,
		/decl/emote/visible/nod,
		/decl/emote/visible/sway,
		/decl/emote/visible/sulk,
		/decl/emote/visible/twitch,
		/decl/emote/visible/dance,
		/decl/emote/visible/roll,
		/decl/emote/visible/shake,
		/decl/emote/visible/jump,
		/decl/emote/visible/shiver,
		/decl/emote/visible/collapse,
		/decl/emote/audible/hiss,
		/decl/emote/audible,
		/decl/emote/visible/scratch,
		/decl/emote/audible/choke,
		/decl/emote/audible/gnarl,
		/decl/emote/audible/bug_hiss,
		/decl/emote/audible/bug_chitter,
		/decl/emote/audible/chirp
		)

/mob/living/carbon/brain/can_emote()
	return (istype(container, /obj/item/device/mmi) && ..())

/mob/living/carbon/brain
	default_emotes = list(
		/decl/emote/audible/alarm,
		/decl/emote/audible/alert,
		/decl/emote/audible/notice,
		/decl/emote/audible/whistle,
		/decl/emote/audible/synth,
		/decl/emote/audible/boop,
		/decl/emote/visible/blink,
		/decl/emote/visible/flash
		)

/mob/living/carbon/human
	default_emotes = list(
		/decl/emote/visible/adjust,
		/decl/emote/visible/blink,
		/decl/emote/visible/scratch,
		/decl/emote/audible/synth,
		/decl/emote/audible/synth/ping,
		/decl/emote/audible/synth/buzz,
		/decl/emote/audible/synth/confirm,
		/decl/emote/audible/synth/deny,
		/decl/emote/visible/nod,
		/decl/emote/visible/shake,
		/decl/emote/visible/shiver,
		/decl/emote/visible/collapse,
		/decl/emote/visible/salute,
		/decl/emote/audible/gasp,
		/decl/emote/audible/sneeze,
		/decl/emote/audible/sniff,
		/decl/emote/audible/snore,
		/decl/emote/audible/whimper,
		/decl/emote/audible/whistle,
		/decl/emote/audible/yawn,
		/decl/emote/audible/clap,
		/decl/emote/audible/chuckle,
		/decl/emote/audible/cough,
		/decl/emote/audible/choke,
		/decl/emote/audible/cry,
		/decl/emote/audible/sigh,
		/decl/emote/audible/laugh,
		/decl/emote/audible/mumble,
		/decl/emote/audible/grumble,
		/decl/emote/audible/groan,
		/decl/emote/audible/moan,
		/decl/emote/audible/grunt,
		/decl/emote/audible/slap,
		/decl/emote/human,
		/decl/emote/human/deathgasp,
		/decl/emote/audible/giggle,
		/decl/emote/audible/scream,
		/decl/emote/visible/airguitar,
		/decl/emote/visible/blink_r,
		/decl/emote/visible/bow,
		/decl/emote/visible/flap,
		/decl/emote/visible/aflap,
		/decl/emote/visible/drool,
		/decl/emote/visible/eyebrow,
		/decl/emote/visible/twitch,
		/decl/emote/visible/twitch_v,
		/decl/emote/visible/faint,
		/decl/emote/visible/frown,
		/decl/emote/visible/blush,
		/decl/emote/visible/wave,
		/decl/emote/visible/glare,
		/decl/emote/visible/stare,
		/decl/emote/visible/look,
		/decl/emote/visible/point,
		/decl/emote/visible/raise,
		/decl/emote/visible/grin,
		/decl/emote/visible/shrug,
		/decl/emote/visible/smile,
		/decl/emote/visible/pale,
		/decl/emote/visible/tremble,
		/decl/emote/visible/wink,
		/decl/emote/visible/hug,
		/decl/emote/visible/dap,
		/decl/emote/visible/signal,
		/decl/emote/visible/handshake,
		/decl/emote/visible/afold,
		/decl/emote/visible/alook,
		/decl/emote/visible/eroll,
		/decl/emote/visible/hbow,
		/decl/emote/visible/hip,
		/decl/emote/visible/holdup,
		/decl/emote/visible/hshrug,
		/decl/emote/visible/crub,
		/decl/emote/visible/erub,
		/decl/emote/visible/fslap,
		/decl/emote/visible/ftap,
		/decl/emote/visible/hrub,
		/decl/emote/visible/hspread,
		/decl/emote/visible/pocket,
		/decl/emote/visible/rsalute,
		/decl/emote/visible/rshoulder,
		/decl/emote/visible/squint,
		/decl/emote/visible/tfist,
		/decl/emote/visible/tilt,
//[INF],
		/decl/emote/audible/finger_snap,
//[/INF],
	)

/mob/living/silicon/robot
	default_emotes = list(
		/decl/emote/audible/clap,
		/decl/emote/visible/bow,
		/decl/emote/visible/twitch,
		/decl/emote/visible/twitch_v,
		/decl/emote/visible/nod,
		/decl/emote/visible/shake,
		/decl/emote/visible/glare,
		/decl/emote/visible/look,
		/decl/emote/visible/stare,
		/decl/emote/visible/deathgasp_robot,
		/decl/emote/audible/synth,
		/decl/emote/audible/synth/ping,
		/decl/emote/audible/synth/buzz,
		/decl/emote/audible/synth/confirm,
		/decl/emote/audible/synth/deny,
		/decl/emote/audible/synth/security,
		/decl/emote/audible/synth/security/halt
		)

/mob/living/carbon/slime
	default_emotes = list(
		/decl/emote/audible/moan,
		/decl/emote/visible/twitch,
		/decl/emote/visible/sway,
		/decl/emote/visible/shiver,
		/decl/emote/visible/bounce,
		/decl/emote/visible/jiggle,
		/decl/emote/visible/lightup,
		/decl/emote/visible/vibrate,
		/decl/emote/slime,
		/decl/emote/slime/pout,
		/decl/emote/slime/sad,
		/decl/emote/slime/angry,
		/decl/emote/slime/frown,
		/decl/emote/slime/smile
		)

/mob/living/silicon/pai
	default_emotes = list(
		/decl/emote/audible/synth,
		/decl/emote/audible/synth/ping,
		/decl/emote/audible/synth/buzz,
		/decl/emote/audible/synth/confirm,
		/decl/emote/audible/synth/deny
		)
