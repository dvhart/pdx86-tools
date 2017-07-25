I ask that submitters Cc all maintainers listed in MAINTAINERS, they don't
always, and those that don't do get caught in a procmail filter which puts all
patches in a folder. I usually find those because patchwork lists something I
don't recognize.

I have started using patchwork to help others check the status of their patch:

New - I haven't looked at it
Under Review - Usually means I'm waiting for a sub-maintainer's ack.
Accpted & Archived -
	I've queued it to the testing branch (this one perhaps I should
	wait on and leave in Under Review until I've pushed to for-next)
Changes Requested & Archived - ...
Deferred & Archived -
	means it was related to pdx86, but applied by someone else
	(usually Rafael).
... -
	There's one more for not applicable to this tree, I forget the
	name (on the plane without wifi).

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
breaks here, I push to testing.

At this point, two things happen. 0-day will pick up the change to the testing
branch and run its various builds, sending me and a sucessful report, or me and
the author an error report... and sometimes a patch (which I personally find
hilariously amusing).

Second, I have jenkins running on my local workstation (20 core, 64 GB RAM)
which picks up on "testing" changes and runs builds for 32 and 64 bit for
allmodconfig and allyesconfig.

If at this point, no errors are reported, I do a fast forward merge on for-next
to testing and push that. It is then merged into the daily linux-next tree where
we occasionally find a conflict with another branch (usually Rafael's), someone
usually provides a fix, and I will either:

a) Ask Rafael to take a patch instead
b) Tweak the commit and force a push to for-next
c) Note the merge resolution and make note of it in the pull request to Linus,
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
testing
fixes

At this point, most patches continue through the above path into testing and
for-next for the next merge window. 0-day watches all branches, so it gets
testing there as well and some additional manually builds from me so I don't
accidentally break something in the rc period.

Patches flow through the branches as follows, always starting with testing:

    testing -> for-next -> master (merge window)
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

Note: We should monitor our fixes branch and if Linus' concerns are warranted,
or if we would be better off merging the fixes branch into for-next after he
merges it, thus avoiding the issue with duplicate patches.

In the rare event of a late rc cycle fix (rc6+), we may not have as much time as
we would like to run through testing and for-next before cherry-picking a patch
to fixes. In those cases, we will have to fast track the fix and explicitly
discuss those cases to avoid errors.

First, the initial goal. I would like to improve the number of reviews patches
to platform-drivers-x86 receive. Having someone I can rely on to be paying
attention to the list and adding their review, especially to the more invasive
patches, would be a big improvement. You've been doing some of that already, and
I'd like to formalize it.

Q: What time window would you be willing to commit to for reviews to patches on
the list? With the exception of trivial patches adding DMI Matches, quirks, or
similar, I could wait that long before merging any of the patches to for-next.
If I get to them first, I may merge them to testing.

Second, when I'm traveling for work and while on vacation, it would be good to
have someone I can hand off the maintainer role to and not worry about it for up
to a couple weeks at a time. There is also illness and peak work load where
having a way to share this community load with someone would be really nice.

For this to work with the previously described branching and
automation, I think the best approach would be to have you added to
pdx86 with push privileges.

(I'm using infradead currently, someday I should move that to my kernel.org
account... but it's kind of a pain, and Linus is happy with gpg signed tags,
so... meh)

To start, we can treat the remote git repository as a critical resource that
only one of us can hold at a time. At the time of a handoff, whoever has it can
send the other an "unlock" email. When the other claims it, they send a "lock"
email. This is how Arnd and Olof handle the ARM SoC tree, seems like a
reasonable approach until we have reason to do something else. They also use IRC
for this, which I think is fine.

Regarding automation and tooling. I think there is room for improvement in the
way we handle patches in the Linux kernel community. Our lead maintainers have
20 years of tooling they've written from scratch to help them optimize their
workflow. For many of them, this is all they do, and they are amazingly
efficient at it.

On the other hand, we do not have enough maintainers and reviewers (a recurring
talking point at kernel summit). I believe part of this is due to the very high
barrier to entry with respect to tooling. A lot of potential developers (and
future maintainers) have very different ideas about email, web tools, IDEs, etc.
It's not just that they think our tools are antiquated, but they also have their
own tooling setup to fulfill their current responsibilities, and gearing up for
kernel development is actually extremely disruptive. Because our lead
maintainers are so efficient in their processes, a mechanical error in patch
submission seems very amateur in comparison - but while getting tooled up, it's
actually exceptionally easy to commit a mechanical error in patch submission.

Many new developers don't think of email as a patch submission tool, they don't
think about character encoding, line wrapping, html, etc.  The tools they use
don't work this way either. I believe this will become more and more the case as
tools like github and gerrit remove email as a patch transport mechanism.

We obviously cannot disrupt our top maintainers, not only because they wouldn't
allow it, but we also don't want to. We want/need them to continue to be
efficient.

I would like to see a tool that:
1) Eliminated email client screw ups from the first patch submission
2) Eliminated checkpatch errors from the first patch submission
3) Eliminated Cc list omissions from the first patch submission
4) Enable 0-day testing
5) Do all the above before sending the patch along to LKML/Cc lists for review.

I believe it should be possible to create a web based tool/service that would
allow new or occasional developers to submit their changes without having to
setup dedicated email tooling for patch submission.

This is a rather long term goal. In the mean time, I'd like to work to eliminate
the tedious manual stuff from our job as maintainers. My mutt scripts help, but
they could be better. Some things I'd like to improve:

1) Add pdx86-specific config awareness to my Jenkins jobs
   - Drop known problematic configs, like PM, INPUT, ACPI and see if builds
     break
2) Add per-patch builds to my Jenkins jobs
3) Adopt and modify Greg's "patch robot" email for semi-automatic email
   responses for common errors (it's cut and paste by us, but feels less
   personal)
4) Add build scripts which look at the git history and only build the pdx86
   drivers that changed
5) Integrate ninja-check into the routine patch review and correlate it's output
   with the commits being reviewed.

Finally, working together now will help make a smooth transition to a new
maintainer sometime in the future. I don't have any immediate plans to hand over
maintainership, but having someone prepared and ready to go will make that
process easier for everyone involved.
