/decl/emote/visible
	key ="tail"
	emote_message_3p = "USER виляет своим хвостом."
	message_type = VISIBLE_MESSAGE

/decl/emote/visible/scratch
	key = "scratch"
	check_restraints = TRUE
	emote_message_3p = "USER почёсывается."

/decl/emote/visible/drool
	key ="drool"
	emote_message_3p = "USER пускает слюни."
	conscious = 0

/decl/emote/visible/nod
	key ="nod"
	emote_message_3p = "USER кивает."

/decl/emote/visible/sway
	key ="sway"
	emote_message_3p = "USER шатается."

/decl/emote/visible/sulk
	key ="sulk"
	emote_message_3p = "USER грустно садится..."

/decl/emote/visible/dance
	key ="dance"
	check_restraints = TRUE
	emote_message_3p = "USER танцует!"

/decl/emote/visible/roll
	key ="roll"
	check_restraints = TRUE
	emote_message_3p = "USER катается."

/decl/emote/visible/shake
	key ="shake"
	emote_message_3p = "USER трясет головой."

/decl/emote/visible/jump
	key ="jump"
	emote_message_3p = "USER прыгает!"

/decl/emote/visible/hiss
	key ="hiss_"
	emote_message_3p = "USER мягко шипит..."
	emote_message_3p_target = "USER мягко шипит на TARGET..."

/decl/emote/visible/shiver
	key ="shiver"
	emote_message_3p = "USER дрожит."
	conscious = 0

/decl/emote/visible/collapse
	key ="collapse"
	emote_message_3p = "USER падает!"

/decl/emote/visible/collapse/do_extra(var/mob/user)
	if(istype(user))
		user.Paralyse(2)

/decl/emote/visible/flash
	key = "flash"
	emote_message_3p = "Индикаторы на дисплее USER быстро мигают."

/decl/emote/visible/blink
	key = "blink"
	emote_message_3p = "USER моргает."

/decl/emote/visible/airguitar
	key = "airguitar"
	check_restraints = TRUE
	emote_message_3p = "USER бренчит в воздухе и мотает головой, как шимпанзе на сафари."

/decl/emote/visible/blink_r
	key = "blink_r"
	emote_message_3p = "USER быстро моргает!"

/decl/emote/visible/bow
	key = "bow"
	emote_message_3p_target = "USER делает поклон TARGET."
	emote_message_3p = "USER делает поклон."

/decl/emote/visible/salute
	key = "salute"
	emote_message_3p_target = "USER выполняет воинское приветствие TARGET."
	emote_message_3p = "USER выполняет воинское приветствие."
	check_restraints = TRUE

/decl/emote/visible/flap
	key = "flap"
	check_restraints = TRUE
	emote_message_3p = "USER машет крыльями."

/decl/emote/visible/aflap
	key = "aflap"
	check_restraints = TRUE
	emote_message_3p = "USER агрессивно машет крыльями!"

/decl/emote/visible/eyebrow
	key = "eyebrow"
	emote_message_3p = "USER приподнимает бровь."

/decl/emote/visible/twitch
	key = "twitch"
	emote_message_3p = "USER дергается."
	conscious = 0

/decl/emote/visible/twitch_v
	key = "twitch_v"
	emote_message_3p = "USER сильно дергается!"
	conscious = 0

/decl/emote/visible/faint
	key = "faint"
	emote_message_3p = "USER падает в обморок!"

/decl/emote/visible/faint/do_extra(var/mob/user)
	if(istype(user) && user.sleeping <= 0)
		user.sleeping += 10

/decl/emote/visible/frown
	key = "frown"
	emote_message_3p = "USER хмурится."

/decl/emote/visible/blush
	key = "blush"
	emote_message_3p = "USER краснеет..."

/decl/emote/visible/wave
	key = "wave"
	emote_message_3p = "USER машет."
	emote_message_3p_target = "USER машет TARGET."
	check_restraints = TRUE

/decl/emote/visible/glare
	key = "glare"
	emote_message_3p = "USER недовольно смотрит на TARGET."
	emote_message_3p = "USER недовольно смотрит."

/decl/emote/visible/stare
	key = "stare"
	emote_message_3p = "USER пялится на TARGET."
	emote_message_3p = "USER пялится."

/decl/emote/visible/look
	key = "look"
	emote_message_3p = "USER смотрит на TARGET."
	emote_message_3p = "USER смотрит."

/decl/emote/visible/point
	key = "point"
	check_restraints = TRUE
	emote_message_3p = "USER показывает пальцем."
	emote_message_3p_target = "USER показывает пальцем на TARGET."

/decl/emote/visible/raise
	key = "raise"
	check_restraints = TRUE
	emote_message_3p = "USER поднимает руку."

/decl/emote/visible/grin
	key = "grin"
	emote_message_3p = "USER скалится в улыбке."

/decl/emote/visible/shrug
	key = "shrug"
	emote_message_3p = "USER пожимает плечами."

/decl/emote/visible/smile
	key = "smile"
	emote_message_3p = "USER улыбается."
	emote_message_3p_target = "USER улыбается TARGET."

/decl/emote/visible/pale
	key = "pale"
	emote_message_3p = "USER на секунду бледнеет..."

/decl/emote/visible/tremble
	key = "tremble"
	emote_message_3p = "USER трепещет в страхе!"

/decl/emote/visible/wink
	key = "wink"
	emote_message_3p = "USER подмигивает."
	emote_message_3p_target = "USER подмигивает TARGET."

/decl/emote/visible/hug
	key = "hug"
	check_restraints = TRUE
	emote_message_3p_target = "USER обнимает TARGET!"
	emote_message_3p = "USER обнимает USER_SELF!"
	check_range = 1

/decl/emote/visible/dap
	key = "dap"
	check_restraints = TRUE
	emote_message_3p_target = "USER gives daps to TARGET."
	emote_message_3p = "USER sadly can't find anybody to give daps to, and daps USER_SELF."

/decl/emote/visible/bounce
	key = "bounce"
	emote_message_3p = "USER прыгает на месте!"

/decl/emote/visible/jiggle
	key = "jiggle"
	emote_message_3p = "USER покачивается..."

/decl/emote/visible/lightup
	key = "light"
	emote_message_3p = "USER загорается на некоторое время, затем прекращая светиться."

/decl/emote/visible/vibrate
	key = "vibrate"
	emote_message_3p = "USER вибрирует!"

/decl/emote/visible/deathgasp_robot
	key = "deathgasp"
	emote_message_3p = "USER shudders violently for a moment, then becomes motionless, USER_THEIR eyes slowly darkening."

/decl/emote/visible/handshake
	key = "handshake"
	check_restraints = TRUE
	emote_message_3p_target = "USER shakes hands with TARGET."
	emote_message_3p = "USER shakes hands with USER_SELF."
	check_range = 1

/decl/emote/visible/handshake/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(target && !user.Adjacent(target))
		return "USER holds out USER_THEIR hand out to TARGET."
	return ..()

/decl/emote/visible/signal
	key = "signal"
	emote_message_3p_target = "USER сигнализирует рукой TARGET."
	emote_message_3p = "USER подаёт сигналы рукой."
	check_restraints = TRUE

/decl/emote/visible/signal/check_user(atom/user)
	return ismob(user)

/decl/emote/visible/signal/get_emote_message_3p(var/mob/user, var/atom/target, var/extra_params)
	if(istype(user) && !(user.r_hand && user.l_hand))
		var/t1 = round(text2num(extra_params))
		if(isnum(t1) && t1 <= 5)
			return "USER raises [t1] finger\s."
	return .. ()

/decl/emote/visible/afold
	key = "afold"
	check_restraints = TRUE
	emote_message_3p = "USER folds USER_THEIR arms."

/decl/emote/visible/alook
	key = "alook"
	emote_message_3p = "USER отводит взгляд."

/decl/emote/visible/hbow
	key = "hbow"
	emote_message_3p = "USER bows USER_THEIR head."

/decl/emote/visible/hip
	key = "hip"
	check_restraints = TRUE
	emote_message_3p = "USER puts USER_THEIR hands on USER_THEIR hips."

/decl/emote/visible/holdup
	key = "holdup"
	check_restraints = TRUE
	emote_message_3p = "USER holds up USER_THEIR palms."

/decl/emote/visible/hshrug
	key = "hshrug"
	emote_message_3p = "USER слегка пожимает плечами."

/decl/emote/visible/crub
	key = "crub"
	check_restraints = TRUE
	emote_message_3p = "USER rubs USER_THEIR chin."

/decl/emote/visible/eroll
	key = "eroll"
	emote_message_3p = "USER rolls USER_THEIR eyes."
	emote_message_3p_target = "USER rolls USER_THEIR eyes at TARGET."

/decl/emote/visible/erub
	key = "erub"
	check_restraints = TRUE
	emote_message_3p = "USER rubs USER_THEIR eyes."

/decl/emote/visible/fslap
	key = "fslap"
	check_restraints = TRUE
	emote_message_3p = "USER slaps USER_THEIR forehead."

/decl/emote/visible/ftap
	key = "ftap"
	emote_message_3p = "USER taps USER_THEIR foot."

/decl/emote/visible/hrub
	key = "hrub"
	check_restraints = TRUE
	emote_message_3p = "USER rubs USER_THEIR hands together."

/decl/emote/visible/hspread
	key = "hspread"
	check_restraints = TRUE
	emote_message_3p = "USER spreads USER_THEIR hands."

/decl/emote/visible/pocket
	key = "pocket"
	check_restraints = TRUE
	emote_message_3p = "USER shoves USER_THEIR hands in USER_THEIR pockets."

/decl/emote/visible/rsalute
	key = "rsalute"
	check_restraints = TRUE
	emote_message_3p = "USER отвечает на воинское приветствие."

/decl/emote/visible/rshoulder
	key = "rshoulder"
	emote_message_3p = "USER rolls USER_THEIR shoulders."

/decl/emote/visible/squint
	key = "squint"
	emote_message_3p = "USER прищуривается."
	emote_message_3p_target = "USER прищуривается на TARGET."

/decl/emote/visible/tfist
	key = "tfist"
	emote_message_3p = "USER tightens USER_THEIR hands into fists."

/decl/emote/visible/tilt
	key = "tilt"
	emote_message_3p = "USER tilts USER_THEIR head."

/decl/emote/visible/salute
	emote_sound = 'sound/effects/salute.ogg'

/decl/emote/visible/rsalute
	emote_sound = 'sound/effects/salute.ogg'

/decl/emote/visible/adjust
	key = "adjust"
	check_restraints = TRUE
	emote_message_3p = "USER поправляет одежду."
	emote_message_3p_target = "USER поправляет одежду TARGET."
