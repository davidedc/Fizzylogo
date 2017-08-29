# this script takes some small comment-tags to generate
# the source of the "yielding" version.
# This is because extra "yield" code makes things more
# difficult to read and change, while the small
# comment tags are innocuous.
#
# We use the "replace" node module, see
# https://www.npmjs.com/package/replace
# we could have used sed or awk but this is more
# convenient and we use node anyways.
#
# also note that we don't ask the user to install
# "replace" globally, as it seems too much, so
# we use it "from local" with "$(npm bin)/"

mkdir -p yielding-version
rm -rf ./yielding-version/*
cp *.coffee ./yielding-version/

# before:
#
#    # yield from
#    theContext.returned = firstElement.eval theContext, @
#
# after:
#
#    theContext.returned  = yield from  firstElement.eval theContext, @
#
$(npm bin)/replace '^\s*# yield from$\n^(\s*[^=]*)=(.*)$' '$1 = yield from $2' ./yielding-version/*.coffee

# before:
#
#  #catch yields
#  evalled = (@elementAt i).eval context, @, true
#
# after:
#
#  gen = (@elementAt i).eval context, @, true; console.log "yielding" until (ret = gen.next()).done;
#  evalled = ret.value
#
$(npm bin)/replace '($\n^\s*)#catch yields$\n^\s*([^=]*) =\s*(.*)$' '$1gen = $3; console.log "yielding" until (ret = gen.next()).done;$1$2 = ret.value' ./yielding-version/*.coffee

# before:
#
#    #yield
#    #yieldMode = true
#
# after:
#
#    yield
#    yieldMode = true
#
$(npm bin)/replace '#(yield.*)' '$1' ./yielding-version/*.coffee