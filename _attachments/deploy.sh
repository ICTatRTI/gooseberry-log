echo "Deploying design_docs and views to $1/gooseberry-log"
echo "Browserifying and uglifying bundle.js"
./node_modules/browserify/bin/cmd.js --verbose -t coffeeify --extension='.coffee' Router.coffee  | ./node_modules/uglifyjs/bin/uglifyjs > bundle.js
couchapp push --no-atomic $1/gooseberry-log
echo "Pushing views to $1/gooseberry-log"
cd ../../__views
./pushViews.rb $1 gooseberry-log
echo 'Executing views, takes a while on first run'
coffee executeViews.coffee $1/gooseberry-log
