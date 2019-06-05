#!/bin/bash

user="gregbakerstl"
user="$1"
mainURL="https://github.com/$user?tab=repositories"
me=$(whoami)
pwd="/home/$me/projects/$user"


getRepoList() {
# for a given github user name, screen scrape all of their repo names
	curl --silent "$mainURL"|    # pull down webpage
		grep -A1 "codeRepo"| # get the line after the string
		grep "</a>"|         # look for closing tags
		sed 's/<\/a>//g';    # removing closing tag from string
}


generateCloneLinks() {
# tokenize the repo names into a URI target
	while read repo; do 
		cloneLink="https://github.com/$user/$repo.git" # build the clone variable
		echo $cloneLink 			       # return the result
	done
}


cloneRepos() {
# clone repositories to the right place
	mkdir -p $pwd # make the correct directories
	cd $pwd       # move into it
	while read cloneLinks; do
		git clone "$cloneLinks" 2>/dev/null # download the repo and send errors to bit bucket
	done
}


pullRepos() {
# update repos that are already present
	while read repo; do
		cd "$pwd/$repo/" # move to the repo
		git pull         # pull the deltas
	done
}


main () {
# flow control
	repoList=$(getRepoList) # instantiate list of repos for user
	echo $repoList|tr " " "\n"|generateCloneLinks|cloneRepos # do initial clone
	echo $repoList|tr " " "\n"|pullRepos                     # update existing repos
}
