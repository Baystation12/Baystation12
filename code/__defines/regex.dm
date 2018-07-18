// Global REGEX datums for regular use without recompiling
// Stolen from Aurora.

// The lazy URL finder. Lazy in that it matches the bare minimum
// Replicates BYOND's own URL parser in functionality.
GLOBAL_DATUM_INIT(url_find_lazy, /regex, new("((https?|byond):\\/\\/\[^\\s\]*)", "g"))

// Global list for mark-up REGEX tag collection.
GLOBAL_LIST_INIT(markup_tags, list("/" = list("<i>", "</i>"),
						"*" = list("<b>", "</b>"),
						"~" = list("<strike>", "</strike>"),
						"_" = list("<u>", "</u>")))

// Global list for mark-up REGEX datums.
GLOBAL_LIST_INIT(markup_regex, list("/" = new /regex("((\\W|^)\\/)(\[^\\/\]*)(\\/(\\W|$))", "g"),
						"*" = new /regex("((\\W|^)\\*)(\[^\\*\]*)(\\*(\\W|$))", "g"),
						"~" = new /regex("((\\W|^)\\~)(\[^\\~\]*)(\\~(\\W|$))", "g"),
						"_" = new /regex("((\\W|^)\\_)(\[^\\_\]*)(\\_(\\W|$))", "g")))
