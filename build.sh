# Concatenate all coffee files in ./lib, compile, and save to lib/rsc.js.
find . -name "*.coffee" -print0 | xargs -0 cat | coffee --compile --stdio > dist/rsc.js

# minify javascript
uglify -s dist/rsc.js -o dist/rsc.min.js > /dev/null

# compile sass
sassc stylesheets/application.scss dist/rsc.css

# minify sass
sassc -t compressed dist/rsc.css dist/rsc.min.css

mkdir -p dist/images
cp images/* dist/images/
