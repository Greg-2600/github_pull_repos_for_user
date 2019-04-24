#!/bin/bash

user="gregbakerstl"
user="$1"
mainURL="https://github.com/$user?tab=repositories"
pwd="/home/greg/projects/$user"


getRepoList() {
	curl --silent "$mainURL"|grep -A1 "codeRepo"|grep "</a>"|sed 's/<\/a>//g';
}


generateCloneLinks() {
	while read repo; do
		cloneLink="https://github.com/$user/$repo.git"
		echo $cloneLink
	done
}


cloneRepos() {
	mkdir -p $pwd
	cd $pwd
	while read cloneLinks; do
		git clone "$cloneLinks" 2>/dev/null
	done
}


pullRepos() {
	while read repo; do
		cd "$pwd/$repo/"
		echo $repo 
		git pull
	done
}

repoList=$(getRepoList)
echo $repoList|tr " " "\n"|generateCloneLinks|cloneRepos
echo $repoList|tr " " "\n"|pullRepos
