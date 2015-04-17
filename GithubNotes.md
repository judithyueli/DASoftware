# Github notes
============
This note features Github commands required to solve problems like:

## To start
### How can I *clone* a copy of DASoftware from remote server to my local directory?
- Go to local directory
- `git clone <remote url>`
Now you should have a *local master* branch

### How can I create a *branch* of DASoftware? This is useful for a team project, as the changes to the master need to be reviewed by all of the team members before *merge* happens.
- `git branch <branch name>

### How can I *commit* or take a snapshot of my files so that I can track the changes?
- swith to the branch you want to sync with the master. That is, your HEAD is pointing to the branch now.

`git checkout <branch name>

- Stage all changes you want to sync to master (or be added to your local history). If you only want to commit a change in a specific file, then don't stage the file yet.

`git add <file name>`

if you want to include removal as a change use

`git add --all`	

- Show staged files, unstaged files, untracked files. You can also find out which branch you are on and whether your branch is behind the *remote master*.

` git status `

-　Commit changes or take a snapshot. 

`git commit -m'message'`

## Track changes locally
### If I have a *local master* (suppose it is up to dated with your *remote master*) and a *local branch*, how can I sync with *local master* from my *local branch*?? (Assume that you don't have any uncommitted changes or unstaged changes)

- Always switch to the branch and check the status (git will reset your working directory to be the same as the last commit of this branch)

`git checkout <branch name>`
`git status`

- If your status shows *fast-forward*, that means you are ahead of *master*

- merge *current* into *master* 3-way merge current, master and common ancestor
` git checkout master`
` git merge current `

- occasionally you want to merge *master* to your *current* to get updated changes

`git checkout current'
`git merge master`

## Sync changes from local to remote
## *pull* changes from *remote* to *local* master branch

` git pull <remote> --merge `

## *push* changes from *local* to *remote master*

` git push --merge `
#### Reference:
1. git-scm.com [link](http://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)

2. git in quora [link](http://www.quora.com/How-do-you-explain-basics-of-Git-in-simple-words)

<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>