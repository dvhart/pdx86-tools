I ask that submitters Cc all maintainers listed in MAINTAINERS, they don't
always, and those that don't do get caught in a procmail filter which puts all
patches in a folder. I usually find those because patchwork lists something I
don't recognize.

I have started using patchwork to help others check the status of their patch:

* New
  * I haven't looked at it
* Under Review
  * I've started looking at it, it's pending a submaintainer, or a
    response from the author. May be queued to review-$PDX86ID branch.
* Accpted & Archived
  * I've queued it to the for-next branch
* Changes Requested & Archived
  * Requested changes from the author, this version will not be applied.
* Deferred & Archived
  * It was related to pdx86, but applied by someone else (usually Rafael).
* Not Applicable
  * Not applicable to this tree, being picked up by someone else.

When I receive a patch, I quickly test it for checkpatch using mutt macros, if
that fails, the author gets a request to clean up the patch.  I don't review it
until doesn't report Errors in checkpatch (Warnings I consider on an individual
basis and am usually pretty relaxed about).

I then check to ensure all maintainers were Cc'd and add them if missing with an
admonition for the author to include them on future patches.

I provide a patch review via email.

I apply the patches (again with a mutt macro) and build the affected drivers as
modules on my laptop. Depending on the author, I may take extra care to build
the affected drivers after each patch in the series on my laptop. If nothing
breaks here, I push to review-$PDX86ID.

At this point, two things happen. 0-day will pick up the change to the
review-$PDX86ID branch and run its various builds, sending me and a successful
report, or me and the author an error report... and sometimes a patch (which I
personally find hilarious).

Second, I have jenkins running on my local workstation (16 core, 64 GB RAM)
which picks up on "review-dvhart" changes and runs builds for 32 and 64 bit for
allmodconfig and allyesconfig.

TODO: This really needs to do some intelligent PDX86 related config fuzz
testing.

If at this point, no errors are reported, I do a fast forward merge on for-next
to review-$PDX86ID and push that. It is then merged into the daily linux-next
tree where we occasionally find a conflict with another branch (usually
Rafael's), someone usually provides a fix, and I will either:

a) Ask Rafael to take a patch instead
b) Note the merge resolution and make note of it in the pull request to Linus,
   as well as providing an example merged branch (separate from the pull request
   branch) since Linus likes to resolve the merge, but will often take the
   maintainers recommended approach.

Once the merge window opens, I have scripts to tag and sign the branch and
prepare the pull request message. I add some wording describing the fixes, and
send the pull request to Linus.

Once the pull request is merged, I do a few thing to prepare for the next
window.

The following branches are advanced to the rc# including our pull request:

for-next
fixes

At this point, most patches continue through the above path into review-$PDX86ID
and for-next for the next merge window. 0-day watches all branches, so it gets
testing there as well and some additional manually builds from me so I don't
accidentally break something in the rc period.

Patches flow through the branches as follows, always starting with
review-$PDX86ID:

    review-$PDX86ID -> for-next -> master (merge window)
                          |
                    (cherry-pick)
                          |
                          -> fixes-> master (rc cycle)

Linus has expressed a preference for cherry-picking of fixes from our own
development trees, rather than merging them in from the fixes branch or RC tags
as that runs the risk of pulling in changes from other developers. This means we
will deliver fixes twice: once during the rc cycle, and once during the merge
window. When this happens, the pdx86-tag script will catch the duplicate commits
and prompt for confirmation before creating the tag. We must note this in the
pull request to Linus, explaining these duplicates were fixes delivered during
the rc cycle but kept in the development branch to avoid conflicts with
subsequent patches.

In the rare event of a late rc cycle fix (rc6+), we may not have as much time as
we would like to run through review-$PDX86ID and for-next before cherry-picking
a patch to fixes. In those cases, we will have to fast track the fix and
explicitly discuss those cases to avoid errors.
