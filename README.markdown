Bash Insanity
=============

I think i rely on bash _way_ too much now or something.

This is just my (futile?) attempt at reigning in, refactoring,
simplifying and generally fixing all bash stuff I've collected over
the years. I have no idea if this is actually a _good idea_ in the
long term, but I suppose it's at least better than the spagetti mess
it used to be.

##### Edit:

It seems to be shifting into an
emacs-[kitchen-sink](http://www.emacswiki.org/emacs/TheKitchenSink)
inspired environment for running _everything_ bash related. _Still_ not
sure that's actually a good idea, but it's looking kind of fun regardless.


### **WARNING:** __NOT FINISHED__

#### Missing significant pieces!

#### Wildly unstable

Don't be surprised if i decide to rewrite half of it at random.

### So do not install it yet!

If you're insane and await to play at it anyway:

 - **BACKUP FIRST**
 - **BACKUP OFTEN**
 - You'll need to know a _lot_ about how BASH works.
 - You should turn off things in rc.bash and only
 - enable them one at a time, top-down,
 - Did I mention you should makeing *BACKUPS* yet?


Setup
-----

The actual files in the homedir are linked into here.
Most of that setup/loading is in .bashr, which
is spelled 'rc.sh' here.

#### Download and Install

To get bash to see the version in this directoy,
just link them in:

```bash
git clone git://github.com/pdkl95/bash-environment.git $HOME/.bash
cd $HOME/.bash
./setup.bash
./setup.bash install
```

At this point, the original `.bashrc` and such should be found in:
    `$HOME/.bash/backup/`

#### Uninstall

As a

```bash
cd $HOME/.bash
./setup.bash uninstall
```

#### What happens during setup?

Most significantly, the entire set of files that
bash looks at to build its environment is redirected
in a manner similar to this:

```bash
mkdir -p ~/.bash/backup
mv ~/.bash_profile ~/.bash_logout ~/.bashrc ~/.inputrc ~/.bash/backup/
ln -s ~/.bash/rc/profile.bash ~/.bash_profile
ln -s ~/.bash/rc/logout.bash  ~/.bash_logout
ln -s ~/.bash/rc/rc.sh        ~/.bashrc
lb -s ~/.bash/etc/inputrc     ~/.inputrc
```

This way, it should *theoretically* be a simple
thing to remove the symlinks and switch back to
the existing files.

Copyright
---------

None. This is 100% public domain.

As a decent amount of this was, at one point or another, stuff I
found in forums, help databases, desparate google searches, _etc_,
it was really all public knowledge to begin with.

Thanks
------

A small, _incomplete_ list of sources I'd like to thank that have
provided significant inspiration, fixes, code-fragments, and
generally good ideas.


in no particular order:

- [`/usr/share/man/man1/bash.1.bz2`](http://www.gnu.org/software/bash/manual/bashref.html)
- http://tldp.org/LDP/abs/html/
- http://wiki.bash-hackers.org/scripting/obsolete
- http://mywiki.wooledge.org/BashPitfalls
- http://stackoverflow.com/questions/tagged/bash?sort=votes
- https://www.google.com/


...and I'm sure many others!

