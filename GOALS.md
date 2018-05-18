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
