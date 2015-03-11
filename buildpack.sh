#!/bin/sh

NAME=$(awk -F\" '/^const Name/ { print $2 }' main.go)
VERSION=$(awk -F\" '/^const Version/ { print $2 }' main.go)

OSARCH=$1

if [[ "$OSARCH" == "" ]]; then
	echo "[Error] Missing os/arch pair!"
	echo "Usage: buildpack.sh <os/arch>"
	echo "Example: buildpack.sh linux/amd64"
	exit 1
fi

echo "Building for '${OSARCH}'..."
gox -osarch="$OSARCH" -output="build/{{.Dir}}_${VERSION}_{{.OS}}_{{.Arch}}/${NAME}"

echo

cd build
for f in *; do
	if [[ -d $f ]]; then
		echo "Packing '$f'..."
		tar -zcvf $f.tar.gz $f
	fi
done
