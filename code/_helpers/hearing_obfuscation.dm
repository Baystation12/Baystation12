// debug segment types
#define DEBUG_SEGMENT_TYPE_KEEP "keep"
#define DEBUG_SEGMENT_TYPE_FAMILIAR "fam"
#define DEBUG_SEGMENT_TYPE_LIPREAD "lip"
#define DEBUG_SEGMENT_TYPE_SUBSTITUTED "sub"
#define DEBUG_SEGMENT_TYPE_GAP "gap"
#define DEBUG_SEGMENT_TYPE_DROPWORD "dropword"
#define DEBUG_SEGMENT_TYPE_BURST "burst"

// dropped sounds become this
#define DROPPED_SOUND_REPLACEMENT ""

// sound unit_classes, roughly in order of frequency (like Hz frequency)
#define SOUND_CLASS_NONE 0
#define SOUND_CLASS_FRICATIVE 1
#define SOUND_CLASS_STOP 2
#define SOUND_CLASS_LIQUID 3
#define SOUND_CLASS_NASAL 4
#define SOUND_CLASS_VOWEL 5

// balancing knobs
#define HEARING_SHOUT_SEVERITY_MODIFIER 0.55
#define HEARING_FAMILIAR_WORD_SEVERITY_MODIFIER 0.35
#define HEARING_LIPREAD_SOUND_SEVERITY_MODIFIER 0.25
#define HEARING_DROPOUT_BURST_MIN_SEVERITY 0.5
#define HEARING_GLOBAL_SEVERITY_MODIFIER 1.1
#define HEARING_VOWEL_MISHEAR_RATE 0.35
#define HEARING_VOWEL_MISHEAR_MIN_SEVERITY 0.15
#define HEARING_SYLLABLE_DROP_RATE 0.6
#define HEARING_SYLLABLE_DROP_START_MIN_SEVERITY 0.12
#define HEARING_BURST_START_RATE 0.22

#define HEARING_RAMP(S, START) ((S) <= (START) ? 0 : (((S) - (START)) / (1 - (START))) ** 0.7)

#define HEARING_ROLL(KEY) (text2num(copytext(md5(KEY), 1, 7), 16) / 16777216)


GLOBAL_LIST_AS(sound_class_severity_thresholds, list(0.05, 0.12, 0.30, 0.35, 0.65))


GLOBAL_ALIST_AS(sound_classes, alist(
	"sh" = SOUND_CLASS_FRICATIVE, "th" = SOUND_CLASS_FRICATIVE, "ph" = SOUND_CLASS_FRICATIVE,
	"ch" = SOUND_CLASS_FRICATIVE, "s" = SOUND_CLASS_FRICATIVE, "f" = SOUND_CLASS_FRICATIVE,
	"h" = SOUND_CLASS_FRICATIVE, "z" = SOUND_CLASS_FRICATIVE, "x" = SOUND_CLASS_FRICATIVE,
	"v" = SOUND_CLASS_FRICATIVE, "j" = SOUND_CLASS_FRICATIVE,
	"ck" = SOUND_CLASS_STOP, "p" = SOUND_CLASS_STOP, "t" = SOUND_CLASS_STOP,
	"k" = SOUND_CLASS_STOP, "c" = SOUND_CLASS_STOP, "q" = SOUND_CLASS_STOP,
	"b" = SOUND_CLASS_STOP, "d" = SOUND_CLASS_STOP, "g" = SOUND_CLASS_STOP,
	"l" = SOUND_CLASS_LIQUID, "r" = SOUND_CLASS_LIQUID, "w" = SOUND_CLASS_LIQUID,
	"y" = SOUND_CLASS_LIQUID,
	"ng" = SOUND_CLASS_NASAL, "m" = SOUND_CLASS_NASAL, "n" = SOUND_CLASS_NASAL,
	"oo" = SOUND_CLASS_VOWEL, "ee" = SOUND_CLASS_VOWEL, "a" = SOUND_CLASS_VOWEL,
	"e" = SOUND_CLASS_VOWEL, "idx" = SOUND_CLASS_VOWEL, "o" = SOUND_CLASS_VOWEL,
	"u" = SOUND_CLASS_VOWEL
))


GLOBAL_ALIST_INIT(confusable_sounds)
	confusable_sounds = alist()
	var/list/groups = list(
		list("s", "f", "th", "sh", "h"),
		list("z", "v"),
		list("ch", "sh", "j"),
		list("p", "t", "k"),
		list("c", "t"),
		list("ck", "t"),
		list("b", "d", "g"),
		list("m", "n"),
		list("ng", "n"),
		list("l", "r", "w"),
		list("a", "e", "u"),
		list("idx", "e"),
		list("o", "u"),
		list("oo", "u"),
		list("ee", "idx")
	)
	for (var/list/group as anything in groups)
		for (var/unit in group)
			if (!confusable_sounds[unit])
				confusable_sounds[unit] = group - unit


GLOBAL_ALIST_AS(lipreadable_sounds, alist(
	"p" = TRUE, "b" = TRUE, "m" = TRUE, "f" = TRUE, "v" = TRUE, "ph" = TRUE,
	"w" = TRUE, "th" = TRUE, "o" = TRUE, "oo" = TRUE, "u" = TRUE
))


GLOBAL_ALIST_AS(common_function_words, alist(
	"a" = TRUE, "an" = TRUE, "the" = TRUE, "to" = TRUE, "of" = TRUE, "in" = TRUE,
	"on" = TRUE, "at" = TRUE, "is" = TRUE, "are" = TRUE, "was" = TRUE, "it" = TRUE,
	"and" = TRUE, "or" = TRUE, "for" = TRUE, "be" = TRUE, "by" = TRUE, "as" = TRUE,
	"so" = TRUE, "if" = TRUE, "we" = TRUE, "idx" = TRUE, "me" = TRUE, "my" = TRUE,
	"you" = TRUE, "your" = TRUE, "he" = TRUE, "she" = TRUE, "they" = TRUE, "its" = TRUE,
	"that" = TRUE, "this" = TRUE, "do" = TRUE, "did" = TRUE, "has" = TRUE, "have" = TRUE,
	"can" = TRUE, "will" = TRUE, "just" = TRUE, "there" = TRUE
))

/**
 * Obfuscates the provided `message` according to the hearing `severity` + other properties.
 *
 * @param message The message to obfuscate
 * @param severity 0-1 severity, where 0 is perfect hearing and 1 is profound loss
 * @param line_of_sight If the listener can see the speaker's face
 * @param familiar List of words to reduce obfuscation on
 * @param seed Seed to obfuscate the message with
 * @param segments Optional list to place debug information in about how a message was obfuscated
 *
 * @return The obfuscated message
 */
/proc/obfuscate_hearing(message, severity = 0.5, line_of_sight = FALSE, list/familiar, seed = 0, list/segments)
	// 1st group: HTML shit
	// 2nd group: words with an HTML apostrophe
	var/static/regex/token_regex = regex(@"(<[^>]*>|&(?!#39;)#?[A-Za-z0-9]+;)|((?:[A-Za-z']|&#39;)+)|[^A-Za-z'<&]+|[<&]", "g")
	var/static/regex/shout_regex = regex(@"!\s*(<[^>]*>\s*)*$")
	var/static/regex/spaces_regex = regex(@"[ \t]{2,}", "g")
	var/static/regex/punctuation_regex = regex(@"\s+([,!?;:]|\.(?!\.))", "g")

	severity = clamp(severity, 0, 1)
	var/alist/familiar_set = alist()
	for (var/word in familiar)
		familiar_set[lowertext(word)] = TRUE
	var/base = "[seed]|[copytext(md5(message), 1, 9)]"
	var/shouted = shout_regex.Find(message) || hearing_is_caps(message)
	var/lipread_chance = line_of_sight ? 0.6 : 1

	var/alist/confusable = GLOB.confusable_sounds
	var/alist/lipreadable = GLOB.lipreadable_sounds
	var/list/class_start = GLOB.sound_class_severity_thresholds

	var/list/segment_tokens = list()
	var/list/segment_debug_types = list()
	var/list/segment_source_tokens = list()
	var/burst = 0
	var/last_was_burst = FALSE
	var/w = 0

	token_regex.next = 1
	while (token_regex.Find(message))
		var/token = token_regex.match
		var/key = lowertext(token)

		if (!token_regex.group[2] || key == uppertext(token))
			segment_tokens += token
			segment_debug_types += DEBUG_SEGMENT_TYPE_KEEP
			segment_source_tokens += null
			continue
		++w

		var/is_familiar = familiar_set[key] \
			|| (copytext(key, -2) == "'s" && familiar_set[copytext(key, 1, -2)]) \
			|| (copytext(key, -6) == "&#39;s" && familiar_set[copytext(key, 1, -6)])
		var/s = severity
		if (shouted || hearing_is_caps(token))
			s *= HEARING_SHOUT_SEVERITY_MODIFIER
		if (is_familiar)
			s *= HEARING_FAMILIAR_WORD_SEVERITY_MODIFIER

		if (!is_familiar)
			// burst starting
			if (!burst && HEARING_ROLL("[base]|[w]|burst") < HEARING_BURST_START_RATE * HEARING_RAMP(s, 0.3) * lipread_chance)
				burst = 1 + floor(HEARING_ROLL("[base]|[w]|len") * (1 + 2 * s))
			// mid-burst
			if (burst)
				--burst
				hearing_add_burst(segment_tokens, segment_debug_types, segment_source_tokens, token, last_was_burst)
				last_was_burst = TRUE
				continue

			// function words
			if (GLOB.common_function_words[key] && HEARING_ROLL("[base]|[w]|fn") < 0.85 * HEARING_RAMP(s, 0.1))
				segment_tokens += ""
				segment_debug_types += DEBUG_SEGMENT_TYPE_DROPWORD
				segment_source_tokens += token
				continue

		// split into words into sound unit_tokens
		var/list/unit_lowercases = list()
		var/list/unit_classes = list()
		var/list/unit_tokens = hearing_split_units(token, key, unit_lowercases, unit_classes)
		var/unit_count = length(unit_tokens)

		// associate sound unit_tokens with unit_syllable_indices
		var/list/unit_syllable_indices = hearing_group_units(unit_count, unit_lowercases, unit_classes)
		var/syllable_count = unit_count ? unit_syllable_indices[unit_count] + 1 : 0

		// long-word syllable dropout
		var/drop_syllable = -1
		if (!is_familiar && syllable_count >= 3 && HEARING_ROLL("[base]|[w]|syl") < HEARING_SYLLABLE_DROP_RATE * HEARING_RAMP(s, HEARING_SYLLABLE_DROP_START_MIN_SEVERITY))
			drop_syllable = 1 + floor(HEARING_ROLL("[base]|[w]|sylpick") * (syllable_count - 2))

		var/list/word_tokens = list()
		var/list/word_debug_types = list()
		var/list/word_source_tokens = list()
		var/sounds = 0
		var/lost = 0
		var/heard_kind = is_familiar ? DEBUG_SEGMENT_TYPE_FAMILIAR : DEBUG_SEGMENT_TYPE_KEEP

		var/idx = 0
		// go through the sound unit_tokens and actually do the obfuscating part
		for (idx in 1 to unit_count)
			var/unit = unit_tokens[idx]
			var/class = unit_classes[idx]
			if (!class)
				word_tokens += unit
				word_debug_types += DEBUG_SEGMENT_TYPE_KEEP
				word_source_tokens += null
				continue
			++sounds
			var/lower = unit_lowercases[idx]

			if (unit_syllable_indices[idx] == drop_syllable)
				++lost
				word_tokens += DROPPED_SOUND_REPLACEMENT
				word_debug_types += DEBUG_SEGMENT_TYPE_GAP
				word_source_tokens += unit
				continue

			var/p = HEARING_RAMP(s, class_start[class])
			if (class != SOUND_CLASS_VOWEL)
				// give special preference to nuking final consonants
				if (idx == unit_count)
					p += 0.15 * s

				// squish clusters
				var/prev_class = idx > 1 ? unit_classes[idx - 1] : SOUND_CLASS_NONE
				var/next_class = idx < unit_count ? unit_classes[idx + 1] : SOUND_CLASS_NONE
				if ((prev_class && prev_class != SOUND_CLASS_VOWEL) || (next_class && next_class != SOUND_CLASS_VOWEL))
					p += 0.1 * s

			p = min(p * HEARING_GLOBAL_SEVERITY_MODIFIER, 0.97)
			var/lipread = line_of_sight && lipreadable[lower]
			var/p_seen = lipread ? p * HEARING_LIPREAD_SOUND_SEVERITY_MODIFIER : p

			var/r = HEARING_ROLL("[base]|[w]|[idx]|u")
			if (r >= p)
				// vowel blur...
				if (class == SOUND_CLASS_VOWEL && !is_familiar && !lipread && HEARING_ROLL("[base]|[w]|[idx]|blur") < HEARING_VOWEL_MISHEAR_RATE * HEARING_RAMP(s, HEARING_VOWEL_MISHEAR_MIN_SEVERITY))
					var/list/blur_options = confusable[lower]
					if (blur_options)
						word_tokens += hearing_match_case(blur_options[1 + floor(HEARING_ROLL("[base]|[w]|[idx]|balt") * length(blur_options))], unit)
						word_debug_types += DEBUG_SEGMENT_TYPE_SUBSTITUTED
						word_source_tokens += unit
						continue
				word_tokens += unit
				word_debug_types += heard_kind
				word_source_tokens += null
				continue
			if (r >= p_seen)
				word_tokens += unit
				word_debug_types += DEBUG_SEGMENT_TYPE_LIPREAD
				word_source_tokens += null
				continue

			++lost
			var/list/options = confusable[lower]

			if (options && HEARING_ROLL("[base]|[w]|[idx]|sub") < 0.6 - 0.35 * s)
				// mild loss mishearing
				word_tokens += hearing_match_case(options[1 + floor(HEARING_ROLL("[base]|[w]|[idx]|alt") * length(options))], unit)
				word_debug_types += DEBUG_SEGMENT_TYPE_SUBSTITUTED
				word_source_tokens += unit
			else
				// major loss mishearing
				word_tokens += DROPPED_SOUND_REPLACEMENT
				word_debug_types += DEBUG_SEGMENT_TYPE_GAP
				word_source_tokens += unit

		if (!is_familiar && sounds && lost / sounds > HEARING_DROPOUT_BURST_MIN_SEVERITY)
			hearing_add_burst(segment_tokens, segment_debug_types, segment_source_tokens, token, last_was_burst)
			last_was_burst = TRUE
			continue
		segment_tokens += word_tokens
		segment_debug_types += word_debug_types
		segment_source_tokens += word_source_tokens
		last_was_burst = FALSE

	if (segments)
		for (var/index in 1 to length(segment_tokens))
			segments += list(alist("t" = segment_tokens[index], "k" = segment_debug_types[index], "src" = segment_source_tokens[index]))

	var/text = jointext(segment_tokens, "")
	text = spaces_regex.Replace(text, " ")
	text = punctuation_regex.Replace(text, "$1")
	text = trimtext(text)
	return text || "..."


/proc/hearing_split_units(token, key, list/lowers_out, list/classes_out)
	var/alist/unit_class = GLOB.sound_classes

	// split into words into sound unit_tokens
	var/list/unit_tokens = list()
	var/token_length = length(token)
	var/idx = 1
	while (idx <= token_length)
		var/size = 1
		if (idx < token_length && unit_class[copytext(key, idx, idx + 2)])
			size = 2
		var/lower = copytext(key, idx, idx + size)
		unit_tokens += copytext(token, idx, idx + size)
		lowers_out += lower
		classes_out += unit_class[lower] || SOUND_CLASS_NONE
		idx += size
	return unit_tokens

/proc/hearing_group_units(unit_count, list/unit_lowercases, list/unit_classes)
	var/list/unit_syllable_indices[unit_count]
	var/syllable = -1
	var/prev_vowel = FALSE
	var/idx = 1
	for (idx in 1 to unit_count)
		var/is_vowel = unit_classes[idx] == SOUND_CLASS_VOWEL
		if (is_vowel && !prev_vowel)
			++syllable
		prev_vowel = is_vowel
		unit_syllable_indices[idx] = max(syllable, 0)

	// trailing e is common enough that we need to specialcase it to prevent it from being too many unit_syllable_indices
	if (syllable > 0 && unit_lowercases[unit_count] == "e" && unit_count > 1 && unit_classes[unit_count - 1] != SOUND_CLASS_VOWEL)
		unit_syllable_indices[unit_count] = syllable - 1

	return unit_syllable_indices

/// Appends a "..." burst segment
/proc/hearing_add_burst(list/segment_tokens, list/segment_debug_types, list/segment_source_tokens, src_text, last_was_burst)
	if (last_was_burst)
		var/static/regex/whitespace_regex = regex(@"^\s+$")
		var/count = length(segment_tokens)
		while (count && segment_debug_types[count] == DEBUG_SEGMENT_TYPE_KEEP && whitespace_regex.Find(segment_tokens[count]))
			--count

		// only drop the whitespace if there's a burst to merge into (thanks HTML for making special cases)
		if (count && segment_debug_types[count] == DEBUG_SEGMENT_TYPE_BURST)
			LIST_RESIZE(segment_tokens, count)
			LIST_RESIZE(segment_debug_types, count)
			LIST_RESIZE(segment_source_tokens, count)
			segment_source_tokens[count] += " [src_text]"
			return
	segment_tokens += "..."
	segment_debug_types += DEBUG_SEGMENT_TYPE_BURST
	segment_source_tokens += src_text


/// Tries to match uppercase to lowercase
/proc/hearing_match_case(alt, orig)
	if (length(orig) > 1 && orig == uppertext(orig))
		return uppertext(alt)
	var/first = orig[1]
	if (first != lowertext(first))
		return uppertext(alt[1]) + copytext(alt, 2)
	return alt


/// Determines if a word counts as being in all-caps for text
/proc/hearing_is_caps(text)
	var/letters = 0
	for (var/idx in 1 to length(text))
		var/char = text2ascii(text, idx)
		if (char >= 97 && char <= 122) // a-z
			return FALSE
		if (char >= 65 && char <= 90) // A-Z
			++letters
	return letters >= 2


#undef DEBUG_SEGMENT_TYPE_KEEP
#undef DEBUG_SEGMENT_TYPE_FAMILIAR
#undef DEBUG_SEGMENT_TYPE_LIPREAD
#undef DEBUG_SEGMENT_TYPE_SUBSTITUTED
#undef DEBUG_SEGMENT_TYPE_GAP
#undef DEBUG_SEGMENT_TYPE_DROPWORD
#undef DEBUG_SEGMENT_TYPE_BURST
#undef DROPPED_SOUND_REPLACEMENT
#undef SOUND_CLASS_NONE
#undef SOUND_CLASS_FRICATIVE
#undef SOUND_CLASS_STOP
#undef SOUND_CLASS_LIQUID
#undef SOUND_CLASS_NASAL
#undef SOUND_CLASS_VOWEL
#undef HEARING_SHOUT_SEVERITY_MODIFIER
#undef HEARING_FAMILIAR_WORD_SEVERITY_MODIFIER
#undef HEARING_LIPREAD_SOUND_SEVERITY_MODIFIER
#undef HEARING_DROPOUT_BURST_MIN_SEVERITY
#undef HEARING_GLOBAL_SEVERITY_MODIFIER
#undef HEARING_VOWEL_MISHEAR_RATE
#undef HEARING_VOWEL_MISHEAR_MIN_SEVERITY
#undef HEARING_SYLLABLE_DROP_RATE
#undef HEARING_SYLLABLE_DROP_START_MIN_SEVERITY
#undef HEARING_BURST_START_RATE
#undef HEARING_RAMP
#undef HEARING_ROLL
