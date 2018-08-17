# cloud9

This repository is a docker image that conveniently containerizes the 'cloud9' project.
It is not the cloud9 project.

cloud9 is an web based ide.
When you start cloud9 on your computer, it runs a web app.
You can load the web app on your browser and start hacking.
The web app gives you a tree file layout, editors, and terminals.
All those are references to your computer.
If you type `touch /tmp/stuff` on one of the terminals, that file will exist on your system.

This project containerizes that.
It in effect creates a virtual computer that you can access using your web browser.
The virtual computer is based on fedora 28.

You can directly use this image, but it is probably better as a base image.

## Using as a base image

Create a docker file like:
```
FROM rebelplutonium/cloud:${SEM_VER}
```
where SEM_VER is the version you choose to use.
This README.md is written for 2.0.3.
If you choose to use an earlier version, then this README is not appropriate and you will have to figure it out yourself.

Then create a directory called 'extension'.
Everything that you put in the 'extension' directory will be available in the container at /opt/cloud9/extension.

However there are some special directories/files to consider:
1. extension/sbin - any scripts you put into this directory will be available in the container to the root user
2. extension/bin - any scripts you put into this directory will be available in the container to the regular user
3. extension/sudo - you can customize sudo by putting configuration in this directory
4. extension/completion - you can put bash completion scripts here
5. extension/run.root.sh - you can put a script that will be run to add as root to add another layer to the image
6. extension/run.user.sh - you can put a script that will be run to add as user to add another layer to the image
7. extension/parse.sh - you can put a script that will parse command line arguments
8. extension/init.root.sh - you can put a script that will be run as root (interactively) when the container starts
9. extension/init.user.sh - you can put a script that will be run as user (interactively) when the container starts
10. extension/post.root.sh - you can put a script that will be run as root (non-interactively) when the container starts
11. extension/post.user.sh - you can put a script that will be run as root (non-interactively) when the container starts
12. extension/cleanup.root.sh - you can put a script that will be run as root when the container stops
13. extension/cleanup.user.sh - you can put a script that will be run as user when the container stops

Environment variables
1. CLOUD9_WORKSPACE - the path of the CLOUD9_WORKSPACE - when you open the app - this is the directory that the file tree displays.
2. PROJECT_NAME - this is text that is used to title the app.
3. CLOUD9_PORT - the port on which the app listens

### GITHUB example
An example usage is https://github.com/rebelplutonium/github.

1. I did not create an extension/sbin directory (all extension directories/files are optional).
2. I did create an https://github.com/rebelplutonium/github/tree/master/extension/bin directory where I placed some scripts that are useful to git development (For example, https://github.com/rebelplutonium/github/blob/master/extension/bin/git-prepare.sh prepares a commit for a merge-request.  When I run this container I can type 'git prepare' and it will execute my script.)
3. I did not create an extension/sudo directory.  I do not think it is needed.
4. I did not create an extension/completion directory.  This would be a useful addition.
5. I created https://raw.githubusercontent.com/rebelplutonium/github/master/extension/run.root.sh.  This adds gnupg to the base image so that I can sign commits.
6. I created https://github.com/rebelplutonium/github/blob/master/extension/run.user.sh to initialize the image as user.  This creates the '/home/user/.ssh' structure (but not the actual private keys); and it customizes the bash prompt.
7. I did not create an extension/parse.sh file.  When you create a container, it will simply ignore an command line arguments you send it.
8. I did not create an extension/init.root.sh file.
9. I did create https://github.com/rebelplutonium/github/blob/master/extension/init.user.sh which on container start populates the private ssh keys, the private gpg key, inits a git repository, and checks out code from an upstream repository.
10. I did create https://github.com/rebelplutonium/github/blob/master/extension/post.root.sh which just runs `dnf update --assumeyes`
11. I did not create an extension/post.user.sh file.
12. I did not create an extension/cleanup.root.sh file
13. I did create https://github.com/rebelplutonium/github/blob/master/extension/cleanup.user.sh which when the container closes, commits any uncommitted work with a commit message indicating that it is a cleanup commit.











