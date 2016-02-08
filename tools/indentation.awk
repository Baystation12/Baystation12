#! /usr/bin/awk -f

# Finds incorrect indentation of absolute path definitions in DM code
# For example, the following fails on the indicated line:

#/datum/path/foo
#	x = "foo"
# /datum/path/bar // FAIL
#	x = "bar"

{
	if ( comma != 1 ) { # No comma/'list('/etc at the end of the previous line
		if ( $0 ~ /^[\t ]+\/[^/*]/ ) { # Current line's first non-whitespace character is a slash, followed by something that is not another slash or an asterisk
			print FILENAME, ":", $0
			fail = 1
		}
	}

	if ($0 ~ /,[\t ]*\\?\r?$/ || # comma at EOL
	    $0 ~ /list[\t ]*\([\t ]*\\?\r?$/ || # start of a list()
	    $0 ~ /pick[\t ]*\([\t ]*\\?\r?$/ ) { # start of a pick()
		comma = 1
	} else {
		comma = 0
	}
}

END {
	if ( fail ) {
		exit 1
	}
}
