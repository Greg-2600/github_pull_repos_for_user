# GitHub-Pull
For a given username, pull down all their repositories and store them in ~/projects/

Usage:
./githubPull.sh gregbakerstl


To keep a users projects synced with the repo, you can move into that users directory and paste:


`for repo in $(ls); do; echo $repo; cd $repo; git fetch; git pull; cd -; pwd; done;`
