#!/usr/bin/env bash
set -e

if [ "$1" == 'ReRun' ]; then
  set -x
else
  $0 ReRun 2>&1 | tee log
  exit 0
fi

(
	mkdir lib p1 p2
	git init lib
	git init p1
	git init p2
)

(
	cd lib
	touch readme
	git add readme
	git commit -m "Initial lib"
	git checkout -b temp #To push to lib later we must not have working copy on master branch.
)

(
	cd p1
	touch p1
	git add p1
	git commit -m "Initial"
	git subrepo clone ../lib lib -b master
	touch foo
	git add foo
	git commit -m "PostClone"
)

(
	cd p2
	touch p2
	git add p2
	git commit -m "Initial"
	git subrepo clone ../lib lib -b master
)

(
	# Subrepo is modified in parallel by two projects.
	cd p1
	echo "p1 initial add to subrepo" >> lib/readme
	git add lib/readme
	git commit -m "p1 initial add to subrepo"
	touch bar
	git add bar
	git commit -m "PostModify"
)

(
	cd p2
	echo "p2 initial add to subrepo" >> lib/readme
	git add lib/readme
	git commit -m "p2 initial add to subrepo"
)

(
	# Both push/pull their subrepo modifications upstream,
	#  which will not auto-merge, thus requiring a hand merge.
	cd p1
	git subrepo push --all
)

(
	cd p2
	git subrepo pull -v --all
	#git mergetool
	#git commit
	#git subrepo pull -v lib --continue
)
