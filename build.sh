# Concatenate all coffee files in ./lib, compile, and save to lib/rsc.js.
find . -name "*.coffee" -print0 | xargs -0 cat | coffee --compile --stdio > dist/rsc.js
uglify -s dist/rsc.js -o dist/rsc.min.js
