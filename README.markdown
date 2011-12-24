Bash Insanity
=============

I think i rely on bash _way_ too much now or something.

This is just my (futile?) attempt at reigning in, refactoring,
simplifying and generally fixing all bash stuff I've collected
over the years. I have no idea if this is actually a _good idea_
in the long term, but I suppose it's at least better than
the spagetti mess it used to be.

### **WARNING**

As this completely changes most evertything in bash,
installing it can be occasionally a bit hairy.

 - **BACKUP FIRST**
 - **BACKUP OFTEN**

Setup
-----

The actual files in the homedir are linked into here.
Most of that setup/loading is in .bashr, which
is spelled 'rc.sh' here.

To get bash to see the version in this directoy,
just link them in:

```bash
# make sure you are in your homedir
echo $PWD

# required
ln -s .bash/profile.sh   .bash_profile
ln -s .bash/rc.sh        .bashrc
ln -s .bash/inputrc      .inputrc


Copyright
---------

None. This is 100% public domain.

As a decent amount of this was, at one point or another, stuff I
found in forums, help databases, desparate google searches, _etc_,
it was really all public knowledge to begin with.
