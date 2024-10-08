set -e

tmp=$(mktemp -d)
trap 'chmod -R +w "$tmp" && rm -fr "$tmp"' EXIT

HOME=$tmp/.home
export TMPDIR="$tmp/.tmp"
mkdir "$HOME" "$TMPDIR"
cd "$tmp"

phases="
    ${prePhases[*]:-}
    unpackPhase
    patchPhase
    ${preConfigurePhases[*]:-}
    configurePhase
" genericBuild

depsFile=$(realpath "${1:-@defaultDepsFile@}")
tmpFile="$tmp"/deps.nix
echo -e "# This file was automatically generated by passthru.fetch-deps.\n# Please dont edit it manually, your changes might get overwritten!\n" > "$tmpFile"
@nugetToNix@/bin/nuget-to-nix "$NUGET_PACKAGES" >> "$tmpFile"
mv "$tmpFile" "$depsFile"
echo "Succesfully wrote lockfile to $depsFile"
