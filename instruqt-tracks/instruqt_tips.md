## Setup Scripts
Setup scripts can be written in any language that is supported by the VM. Here are the rules about setup scripts:

* It must return a nonzero exit code
* In must be named `setup-<user>` where `<user>` is the user the lab will run as. For example if the user is `labuser` it will be `setup-labuser`
* Use a shebang at the top like this: `#!/bin/env python3` or `#!/usr/bin/node` or `#!/bin/bash`
* Make sure it's executable (use `chmod +x setup-labserver`)
* Should be in the same folder as your `assignment.md`

These scripts can be used at the Challenge level or at the track level

## Track-level scripts
Put them in a folder called `track_scripts` at the root of your track folder (same level as the `config.yml`).  The file goes in that folder and follows all the rules above.

Keep in mind that the track-level scripts represent a fixed cost at the beginning of your track and will make iteration harder. If at all possible, prefer adding certain actions to the VM image itself.

## Setup Script Tips
* The script will run as *root* so you may not have access to things that are in the user's environment, and changes you make will apply to `root` unless you specifically run them as your user.
* To run a command as your use, use `su -c '<COMMAND>' <YOUR_USER_NAME>`
	* Example: `su -c 'git checkout -f mm23-metrics-challenge-2-start' labuser`
* `set-workdir <SOME DIR>` will set the starting directory for all tabs. It works by modifying the `$HOME` variable so it could have other effects.  You can change this in every setup script.
* It's helpful to add `echo` statements and tag them.  That way when your script is running an you are tailing the logs using `instruqt track logs` you can easily pick out the stage of the setup script.  Example: `echo "[AUTHOR] start docker compose"`
* It's a good idea to use git branches or commits to set up any code state.  You want a clean, knowable state on start of every challenge, so using a branch in combination with the `-f` flag for `git checkout` is recommended.
	* Example: `su -c 'git checkout -f mm23-metrics-challenge-2-start' labuser`
* Kill any processes from a possible previous challenge at the beginning to ensure a clean slate, or restart them if the command is idempotent (like `docker compose up -d`)
	* `kill -9 $(lsof -ti tcp:4000) || true` for example kills anything that might be up and listening on tcp port 4000 but always returns successful.
	* Avoid overgeneral commands like `killall node` since there may be other things you need that are using node to run (like visual studio code)
	* `docker compose up -d` is always safe and makes sure some container arrangement is up and running

## Check Scripts
### Rules
*  It must return a nonzero exit code
* echoing `FAIL: <YOUR MESSAGE>` and exiting with a nonzero exit code will cause instruqt to show the user a failure with your message
* In must be named `check-<user>` where `<user>` is the user the lab will run as. For example if the user is `labuser` it will be `setup-labuser`
* Use a shebang at the top like this: `#!/bin/env python3` or `#!/usr/bin/node` or `#!/bin/bash`
* Make sure it's executable (use `chmod +x setup-labserver`)
* Should be in the same folder as your `assignment.md`

### Strictness
The biggest learning on check scripts was to **not make them too complex or specific**. Since the instruqt environment is free, users can get themselves into all sorts of correct arrangements that your script could deem as incorrect.  Instead:

* Check broad things like:
	* Did they create this file?
	* Does a request give a response with the correct substring match?

##### Examples:

```bash
if [ -f "/home/labuser/microservices-march/messenger/load-balancer/Dockerfile" ]
then
  echo "load-balancer/Dockerfile exists"
else
  fail-message "/home/labuser/microservices-march/messenger/load-balancer/Dockerfile should exist"
fi
```

```bash
# Check that the load balancer is up
if [[ "$(curl -X GET http://localhost:8085/health)" == "OK" ]]; then
  echo "messenger through lb is healthy"
else
  fail-message  "curl -X GET http://localhost:8085/health should return a 200 response with text OK"
fi
```


If you feel like the check script isn't able to test what you want, consider adding a quiz after the challenge.

### Fail Messages
Write your failure message so that it provides the user with a clue towards solving the problem.
See the above failure messages

## Solve Scripts
I found that by
1. Stopping everything and restarting everything in the `setup` scripts
2. Forcefully checking out a certain state from a git branch or commit
3. Running any other necessary commands to get the system in a certain state

I the `setup` script, `solve` scripts were not really necessary. This is highly dependent on the nature of your track though.

## Readability

### Text Volume
Instruqt is not well suited for large amounts of text. The eye easily gets lost. Recommend keeping text to a minimum.

Here are some strategies to break up text if you have a lot of it:

#### Sections
Adding `===` after a line turns it into a collapsible section. I was afraid to have "too many" of these initially, but later found that being very liberal with them increased readability. 

#### Diagrams
Diagrams can help you eliminate text but they also help break things up

#### Headings
In instruqt, lower-level headings are not visually distinct enough.  Recommend using only H1 headings `#`

#### HTML Elements
You can write html with your Markdown and use inline css to make sections of your text visually distinct.

Note that Markdown won't work inside html.

You can also use a "collapse" to hide nonessential information:

```html
<details style="cursor: pointer;">
  <summary>Why wait?</summary>
  <div style="border: 1px solid black; padding: 0.5em;">
    Node.js when auto-instrumented will produce a lot of filesystem access spans when it first starts up.
    Waiting a short time after starting the application helps us see our main traces without distractions.
  </div>
</details>
```

## Language Runtimes and CLI tooling
I think (asdf)[https://asdf-vm.com/] is the best way to set up and manage language runtimes and tooling.  For example, if you need exact versions of python, nodejs, the github cli tool, and the azure CLI took, you can define a file called `.tool-versions` in your `$HOME` directory or in the folder you are working in that looks like this:

```
nodejs 19.3.0
python 3.11.1
azure-cli 2.46.0
github-cli 2.24.3
```

Then running `asdf install` will just make sure all those are installed at the correct versions.  However, `asdf` is a very user specific tool.  Here's what I had to do to use `asdf`-managed things in a setup script:

```bash
export ASDF_DIR=/home/labuser/.asdf
export PATH=/home/labuser/.asdf/shims:/home/labuser/.asdf/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:$PATH
export NPM_PATH=/home/labuser/.asdf/shims/npm
export NODE_PATH=/home/labuser/.asdf/shims/node
```
Then when using node or npm, do it like this:

```bash
su -c "$NPM_PATH install" labuser
```

The `PATH` variable was set by running `echo $PATH` while logged in to the instruqt track as the user.

## Tabs

### Clarity
Make **REALLY** sure the user knows what tab they should be working in. 

### Ordering
Try to order the tabs in the order they are initially referenced in the instructions. If there are multiple challenges, try to keep the order the same.


## Collaboration
I didn't have time to build out a whole git-based workflow partially it's there.  But ideally it would work like this:
* Merge to `main` does an `instruqt track push --force` to the main track
* Changes are done in PRs and autopush to a track that has the same name as the branch
* No one uses the UI under pain of death

In the absence of this process, or if you have a collaborator who can only use the UI:
* Communicate and have only one person working on the track at a time
* Once the UI person has done their work do the following:
	* Commit and push what you have to git
	* Create a new branch `git checkout -b track-remote`
	* From that branch, pull with force: `instruct track pull --force`
	* Diff the two: `git diff my-branch..track-remote`
	* If all looks well, you can pull with force from `my-branch` and commit it
	* If there are changes, apply them manually or commit them then merge `track-remote` into `my-branch` using your preferrence merge strategy


## Other Notes
* Do as much busywork up front. For example, if you are having the user build a docker image in the challenge, pull the base image in the track setup.  Make sure you use specific versions instead of `latest`. 
	* Example: (in setup script) `docker pull postgrest:15.2-alpine`
* As you create the track, for each challenge maintain a bare set of commands that will solve the challenge if you're not allowing skips.  Have that ready in case frustrated users ran out of time at the last challenge and need to jump forward.
* Write up a set of troubleshooting questions for each challenge that you can anticipate and circulate it to others who might be on the hook to support your track
