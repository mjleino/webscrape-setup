#!/bin/bash
#
# sets up a nice webscraping environment
# based on http://blog.nodejitsu.com/jsdom-jquery-in-5-lines-on-nodejs
#
# dependencies: npm
#
# usage: ./scrape-setup.sh [WHERE]

command -v npm >/dev/null 2>&1 || { 
	echo >&2 "npm is required, https://npmjs.org/" 
	exit 1
}

[ $# -gt 0 ] && {
	mkdir -p $1 >& /dev/null || {
		echo >&2 "$1 is not a directory"
		exit 2
	}
	cd $1
}

npm install jsdom request
curl -O http://code.jquery.com/jquery.min.js
cat >example.js <<EXAMPLESCRIPT
var request = require('request'),
    jsdom = require('jsdom');
request({ uri: "http://viiksipojat.fi" }, function (error, response, body) {
  if (error && response.statusCode !== 200) {
    console.log('Oops, error.')
  }
  jsdom.env({
    html: body,
    scripts: ["jquery.min.js"],
    done: function (err, window) {
// --------------
// THE BEEF
var $ = window.jQuery;
console.log($('body').html());
// --------------
    }
  });
});
EXAMPLESCRIPT

echo your beautiful webscraping environment is ready at $(pwd)
echo next step: node example.js