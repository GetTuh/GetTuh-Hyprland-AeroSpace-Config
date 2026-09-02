#!/usr/bin/env bash
# Drop-in replacement for `qalc -t` for the launcher's math row.
#
# The shell's launcher (quickshell ii, services/LauncherSearch.qml) runs
# `qalc -t <expr>` and shows the single line it prints. qalc already converts a
# foreign amount into the local currency on its own (local_currency_conversion=1
# in ~/.config/qalculate/qalc.cfg), so `10 eur` -> `42,88 zł` needs nothing. It
# will not go the other way, and it only ever prints one conversion. This adds
# both, on one line, and passes everything else straight through untouched.
#
#   10        ->  10 zł = 2,33 €  •  10 € = 42,88 zł
#   10pln     ->  10 zł = 2,33 € = 2,51 $
#   10eur     ->  42,88 zł            (plain qalc, unchanged)
#   2+2       ->  4                   (plain qalc, unchanged)
set -uo pipefail

# Currencies to fan a local-currency amount out into.
TARGETS=(${QALC_MULTI_TARGETS:-EUR USD})
# The other side of the bare-number case: <n> LOCAL and <n> FOREIGN, both ways.
PAIR="${QALC_MULTI_PAIR:-EUR}"
SEP=" \u2022 "

expr="$*"
[[ -z "${expr//[[:space:]]/}" ]] && exit 0

# -t terse, and never block the launcher on an exchange-rate fetch.
q() { timeout 3 qalc -t "$1" 2>/dev/null | head -1; }

# Local currency, from the locale rather than hardcoded, so this keeps working
# on a machine set to something other than PLN.
LOCAL="${QALC_MULTI_LOCAL:-$(locale -k LC_MONETARY 2>/dev/null |
    sed -n 's/^int_curr_symbol="\?\([A-Z]\{3\}\).*/\1/p')}"
[[ -z "$LOCAL" ]] && LOCAL=EUR

# How qalc renders a currency ("PLN" -> "zł"). The "to X" is what stops qalc
# converting the probe into the local currency behind our back.
sym() {
    local out
    out="$(q "1 $1 to $1")"
    out="${out#1 }"
    [[ -z "$out" || "$out" == "1" ]] && out="$1"
    printf '%s' "$out"
}

raw="$(q "$expr")"
[[ -z "$raw" ]] && exit 0

# Bare number: no unit to work from, so show the pair in both directions.
if [[ "$expr" =~ ^[[:space:]]*-?[0-9]+([.,][0-9]+)?[[:space:]]*$ ]]; then
    n="${expr//,/.}"
    n="${n//[[:space:]]/}"
    there="$(q "$n $LOCAL to $PAIR")"
    back="$(q "$n $PAIR to $LOCAL")"
    if [[ -n "$there" && -n "$back" ]]; then
        # "$raw" not "$n": qalc renders the number in the locale's own format,
        # so 1234,5 stays 1234,5 instead of the dot form we feed back to qalc.
        printf '%s %s = %s%b%s %s = %s\n' \
            "$raw" "$(sym "$LOCAL")" "$there" "$SEP" "$raw" "$(sym "$PAIR")" "$back"
        exit 0
    fi
    printf '%s\n' "$raw"
    exit 0
fi

# Result already sits in the local currency: fan it out to the targets.
local_sym="$(sym "$LOCAL")"
if [[ "$raw" == *"$local_sym"* ]]; then
    out="$raw"
    shopt -s nocasematch
    for cur in "${TARGETS[@]}"; do
        [[ "$cur" == "$LOCAL" ]] && continue
        # Don't convert back into a currency the user already typed --
        # "10 eur" should not answer with "= 10 €".
        [[ "$expr" == *"$cur"* || "$expr" == *"$(sym "$cur")"* ]] && continue
        conv="$(q "($expr) to $cur")"
        [[ -n "$conv" ]] && out+=" = $conv"
    done
    shopt -u nocasematch
    printf '%s\n' "$out"
    exit 0
fi

printf '%s\n' "$raw"
