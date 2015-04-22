# Github notes
============
This note features git commands required for *version control*. 

### Establish local repository: local __master__ and working branch __iss53__
- *clone* a copy of DASoftware from remote server to my local directory?
	- Go to local directory
	- `git clone <remote url>`
Now you should have a *local master* branch

- Create a *branch* from *master* for a specific purpose. This is useful for a team project, as the changes to the master need to be reviewed by all of the team members before *merge* happens.

	- `git branch <branch name>`

Now you have 3 branches: origin/master, master and iss53(your working branch)

### Make and track changes locally at your working branch
- How can I *commit* or take a snapshot of my files so that I can track the changes?
	- 1.Swith to the branch you want to sync with the master. That is, your HEAD is pointing to the branch now.

	`git checkout <branch name>`

	- 2.Stage all changes you want to sync to master (or be added to your local history). If you only want to commit a change in a specific file, then don't stage the file yet.

		`git add <file name>`

	- 3.If you want to include removal as a change use

		`git add --all`	

	- 4.Show staged files, unstaged files, untracked files. You can also find out which branch you are on and whether your branch is behind the *remote master*.

		` git status `

	- 5.Commit changes or take a snapshot. 

		`git commit -m'message'`

	- 6.Check commit history

		`git log`

### Is your local __master__ is up to date?
- __Use with caution!!__If your local __master__ is not up to date with the remote __master__, then *pull* changes from *remote* to *local* master branch. But this will possibly overwrite your local changes in your __master__ branch. 
	` git status `

	` git pull <remote> --merge `

### Sync changes locally between __master__ and your working branch

![A graphic presentation of the merge](http://git-scm.com/book/en/v2/book/03-git-branching/images/basic-merging-1.png)

At this point your *local master* (synced from *remote master*) are at __C4__, while your *local branch* __iss53__ is at __C5__ (you created the branch from __C2__ , and then master is updated from __C2__ to __C4__)

- How can I merge changes in *local branch* __iss53__ to my *local master branch*?? (Assume that you don't have any uncommitted changes or unstaged changes)

- Option 1 - merging

	- 1.Always switch to the branch and check the status (git will reset your working directory to be the same as the last commit of this branch)

		`git checkout <branch name>`
		`git status`

	- 2.If your status shows *fast-forward*, that means you are ahead of *master*, go to step 3.

	- 3.Merge *current* into *master* 3-way merge current, master and common ancestor
		` git checkout master`

		` git merge <branch name> `

	- 4.Do not merge *master* to your *current* to get updated changes from master. If you have to do it, be very __!!cautious!!__ as this may overwrite some of the unstaged changes or untracked files.

		`git checkout <branch name>`

		`git merge master`
		
- Option 2 - rebasing
	- Rebasing vs merging: rebasing will create a linear history for the remote master making it is easier to tracks changes. In terms of the status of your branches and local, the end result is exactly the same
	- 1.Always switch to the branch and check the status (git will reset your working directory to be the same as the last commit of this branch)

		`git checkout <branch name>`
		`git status`
		
	- 2. If your status shows *fast-forward*, that means that your local branch has no new committed changes and therefore the *master* is ahead of you, so you need to move the pointer of your branch to where the master is.
		`git merge master`
	Now the master and your branch are at the same point.
	
	- 3. If you status does not show *fast-forward*, that means that your local branch has new committed changes and you need to update the master with your branch.
		`git checkout <branch>`
		`git rebase master`
	- 4. Now remote master has your changes. Next, move pointer of local master to where the remote master is
		`git checkout <master>`
		`git merge <branch>`
	Note: when you git merge from x point, the pointer of x moves to what you merged with



If local __master__ and __current__ branch are synced, then you can delete the the __current_branch

		`git branch -d current`

### Sync changes from local to remote
- Have you tested the __master__ locally using testing examples? If you are modifying a method class, make sure it runs for all examples. Else if you are modifying a forward model class, make sure it runs for all method. __TODO__

- *push* changes from *local* to *remote master*

	` git push --merge `

#### Reference:
1. git-scm.com [link](http://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)

2. git in quora [link](http://www.quora.com/How-do-you-explain-basics-of-Git-in-simple-words)

<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
