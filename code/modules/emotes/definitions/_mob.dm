/mob
	var/list/default_emotes = list()
	var/list/usable_emotes = list()
	var/last_used_audible_emote //lol

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
		/decl/emote/visible/hiss,
		/decl/emote/visible/shiver,
		/decl/emote/visible/collapse,
		/decl/emote/audible,
		/decl/emote/audible/deathgasp_alien,
		/decl/emote/audible/whimper,
		/decl/emote/audible/gasp,
		/decl/emote/audible/scretch,
		/decl/emote/audible/choke,
		/decl/emote/audible/moan,
		/decl/emote/audible/gnarl,
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
		/decl/emote/visible/blink,
		/decl/emote/audible/synth,
		/decl/emote/audible/synth/ping,
		/decl/emote/audible/synth/buzz,
		/decl/emote/audible/synth/confirm,
		/decl/emote/audible/synth/deny,
		/decl/emote/visible/nod,
		/decl/emote/visible/shake,
		/decl/emote/visible/shiver,
		/decl/emote/visible/collapse,
		/decl/emote/audible/gasp,
		/decl/emote/audible/sneeze,
		/decl/emote/audible/sniff,
		/decl/emote/audible/snore,
		/decl/emote/audible/whimper,
		/decl/emote/audible/yawn,
		/decl/emote/audible/clap,
		/decl/emote/audible/chuckle,
		/decl/emote/audible/cough,
		/decl/emote/audible/cry,
		/decl/emote/audible/sigh,
		/decl/emote/audible/laugh,
		/decl/emote/audible/mumble,
		/decl/emote/audible/grumble,
		/decl/emote/audible/groan,
		/decl/emote/audible/moan,
		/decl/emote/audible/grunt,
		/decl/emote/audible/painscream,
		/decl/emote/human,
		/decl/emote/human/deathgasp,
		/decl/emote/audible/giggle,
		/decl/emote/audible/scream,
		/decl/emote/visible/airguitar,
		/decl/emote/visible/blink_r,
		/decl/emote/visible/bow,
		/decl/emote/visible/salute,
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
		/decl/emote/audible/species_sound/alert1,
		/decl/emote/audible/species_sound/alert2,
		/decl/emote/audible/species_sound/alert3,
		/decl/emote/audible/species_sound/alert4,
		/decl/emote/audible/species_sound/berserk1,
		/decl/emote/audible/species_sound/berserk2,
		/decl/emote/audible/species_sound/berserk3,
		/decl/emote/audible/species_sound/berserk4,
		/decl/emote/audible/species_sound/charge1,
		/decl/emote/audible/species_sound/charge2,
		/decl/emote/audible/species_sound/charge3,
		/decl/emote/audible/species_sound/charge4,
		/decl/emote/audible/species_sound/curse1,
		/decl/emote/audible/species_sound/curse2,
		/decl/emote/audible/species_sound/curse3,
		/decl/emote/audible/species_sound/curse4,
		/decl/emote/audible/species_sound/gloat1,
		/decl/emote/audible/species_sound/gloat2,
		/decl/emote/audible/species_sound/gloat3,
		/decl/emote/audible/species_sound/gloat4,
		/decl/emote/audible/species_sound/medic1,
		/decl/emote/audible/species_sound/oorah1,
		/decl/emote/audible/species_sound/oorah2,
		/decl/emote/audible/species_sound/oorah3,
		/decl/emote/audible/species_sound/oorah4,
		/decl/emote/audible/species_sound/taunt1,
		/decl/emote/audible/species_sound/taunt2,
		/decl/emote/audible/species_sound/taunt3,
		/decl/emote/audible/species_sound/taunt4,
		/decl/emote/audible/species_sound/femalert1,
		/decl/emote/audible/species_sound/femberserk1,
		/decl/emote/audible/species_sound/femcurse1,
		/decl/emote/audible/species_sound/femgloat1,
		/decl/emote/audible/species_sound/femmedic1,
		/decl/emote/audible/species_sound/femoorah1,
		/decl/emote/audible/species_sound/femtaunt1,
		/decl/emote/audible/species_sound/wort,
		/decl/emote/audible/species_sound/need_weapon,
		/decl/emote/audible/species_sound/aim,
		/decl/emote/audible/species_sound/nipple,
		/decl/emote/audible/species_sound/boo,
		/decl/emote/audible/species_sound/berserk,
		/decl/emote/audible/species_sound/forerunner,
		/decl/emote/audible/species_sound/covenant,
		/decl/emote/audible/species_sound/taunt,
		/decl/emote/audible/species_sound/warcry,
		/decl/emote/audible/species_sound/panic,
		/decl/emote/audible/species_sound/chitter
	)

/mob/living/silicon/robot
	default_emotes = list(
		/decl/emote/audible/clap,
		/decl/emote/visible/bow,
		/decl/emote/visible/salute,
		/decl/emote/visible/flap,
		/decl/emote/visible/aflap,
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
		/decl/emote/audible/synth/chirrup1,
		/decl/emote/audible/synth/chirrup2,
		/decl/emote/audible/synth/chirrup3,
		/decl/emote/audible/synth/chirrup4,
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
