#### master:
The command `git verify` sufficed.
- - -
#### commit-one-file:
```bash
git add A.txt
git commit -m "message"
git verify
```
- - -
#### commit-one-file-staged
```bash
git reset B.txt
git commit -m "message"
git verify
```
- - -
#### ignore-them
I made a gitignore file with the following rules:
```bash
*.exe
*.o
*.jar
libraries/
```
Then I used the command `git add -A`, then commited the changes.
- - -
#### chase-branch
```bash
git merge escaped
git verify
```
#### merge-conflict
First I patched the merge conflict in vim, then I committed the changes and then I merged the branches.
- - -
#### save-your-work
First I stashed the project then I fixed the bug in the file, then commited the bugfix then I did `git stash pop` and finally added the final line to the bug text file and committed the changes.
- - -
#### change-branch-history
```bash
git rebase hot-bugfix
git verify
```
- - -
#### remove-ignored
```bash
git rm ignored.txt
git commit -m "commit message"
git verify
```
- - -
#### case-sensitive-filename
```bash
git mv File.txt file.txt
git commit -m "move"
git verify
```
- - - 
#### fix-typo
```bash
#first I fixed the typo in the file
git add .
git commit --amend 
#now I fixed the typo in the commit message
git verify
```
- - - 
#### forge-date
```bash
export GIT_COMMITTER_DATE="Wed Mar 4 12:34 1987 +0100"
git commit --amend --no-edit --date="Wed Mar 4 12:34 1987 +0100"
git verify
```
- - -
#### fix-old-typo
```bash
git rebase -i HEAD~2
#edited file 
git add file.txt
git rebase --continue 
#fix merge conflict
git add file.txt
git rebase --continue
git verify
```

