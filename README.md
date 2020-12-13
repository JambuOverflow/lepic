# LEPIC

Supporting the assessment and management of reading fluency.

**Warning:** This is `develop` branch README and should not be merged to `master`.

[![Coverage Status](https://coveralls.io/repos/github/JambuOverflow/lepic/badge.svg?branch=master)](https://fcoveralls.io/github/JambuOverflow/lepic?branch=develop)

[![Build Status](https://travis-ci.com/JambuOverflow/lepic.svg?branch=develop)](https://travis-ci.com/JambuOverflow/lepic)

## Develop Standards & Conventions

Consider 90% of the documentation below as suggestion, the team must discuss how we'll adapt these conventions into our workflow.

> This is a suggestion.


### Branching

The central repo holds [two main branches](https://nvie.com/posts/a-successful-git-branching-model/) with an infinite lifetime:

* `master`
* `develop`


>  Any new fetures/issues must be worked on branches inherited from `develop`, before merging.

> At the end of every sprint, the `develop` branch <ins>should be</ins> merged to `master` with a release tag (presuming this must be at least a MVP).

### Branch Naming

Following [this](https://deepsource.io/blog/git-branch-naming-conventions/) convention:

1. Use issue tracker IDs (or user story IDs) in branch names.

2. Add a short descriptor of the task.

3. Use hyphens as separators.

**Example** : `3-create-flutter-env`

### Commit Messages

I've been working with this convetion in the last mounths:

```
➜  male-female-aligned git:(master) ✗ git shortlog
      [scripts] add arpabet2ipa to scripts readme doc
      [scripts] arpabet2ipa/utils: fix 'assert pts lenght' script
      Merge branch 'jvcanavarro-master-patch-38270'
      [scripts] moved old scripts to 'original' branch
      Merge branch 'cana' into 'master'
      [male,female] remove prime char from transcription 081
      [male,female] add g2p dict for the entire dataset
      [sripts] pts_ds2fs: convert dataset phoneset to falabrasil's in pts format based on 
      falabrasil's dict
      [scripts] pts_ds2fb/utils: add script to show frequency of m2m merges
```

The idea is to put into `[]` the directory, feature or issue you're working on. Recently, I found [this one](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html), which I suppose will best fit our needs:

```
Capitalized, short (50 chars or less) summary

More detailed explanatory text, **if necessary**.  Wrap it to about 72
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.

Write your commit message in the imperative: "Fix bug" and not "Fixed bug"
or "Fixes bug."  This convention matches up with commit messages generated
by commands like git merge and git revert.

Further paragraphs come after blank lines.

- Bullet points are okay, too

- Typically a hyphen or asterisk is used for the bullet, followed by a
  single space, with blank lines in between, but conventions vary here

- Use a hanging indent

```

**Remember:**


1. Separate subject from body with a blank line
2. Limit the subject line to 50 characters
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line: 
6. Wrap the body at 72 characters

> Not all commits will need a detailed explanation. In fact I think that few will need long messages, considering that we will describe what was added in Pull Request. Anyway, the team must choose one of these standards.

[A properly formed Git commit](https://chris.beams.io/posts/git-commit/) subject line should always be able to complete the following sentence: _If applied, this commit will <ins> your subject line here</ins>_.

* If applied, this commit will refactor subsystem X for readability.
* If applied, this commit will update getting started documentation.
* If applied, this commit will remove deprecated methods.

Finally, just focus on making clear the reasons why you made the change in the first place: the way things worked before the change (and what was wrong with that), the way they work now, and why you decided to solve it the way you did. If the code needs explanation, use source comments.


### Pull Request & Code Review Conventions

> If we don't use meaningful commit messages, this will be the area to explain what is the purpose and accomplishment of your code.

* Always link only one issue to your pull request [link](https://docs.github.com/pt/free-pro-team@latest/github/managing-your-work-on-github/linking-a-pull-request-to-an-issue)


### Folder Structure

I didn't found many "documentation" about this topic, especially on the division of Backend and Frontend source code. Some people might find cleaner to divide the repository into `frontend/` and `backend/`, like [this guy](https://github.com/ReeceRose/django-flutter-todo). Again, the team must briefly discuss this topic.
