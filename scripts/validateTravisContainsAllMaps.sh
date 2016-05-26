#! /bin/bash 

cd "$(dirname "${BASH_SOURCE[0]}")"
cd ../

fail=0

for k in maps/*; do
	map=${k#maps/}
	if [[ -e maps/$map/$map.dm ]] && ! grep "MAP_PATH=$map" .travis.yml > /dev/null; then
		# $map is a valid map key, but travis isn't testing it!
		fail=$((fail + 1))
		echo "Map key '$map' is present in the repository, but is not listed in .travis.yml!"
	fi
done

exit $fail
