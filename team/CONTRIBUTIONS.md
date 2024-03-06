# Master Documentation

## Commit Messages
Commit messages will follow the guidelines as set forth by [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). A summary of the summary is provided here, along with the usage of the most common forms. Conventional Commits give the programming team the flexibility to customize commits to their needs while providing a basic foundation to work off of. Extending guidelines agreed upon by the team beyond Conventional Commits will also be noted here. 

### Basics
Basic Conventional Commits messages have the following format.
```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```
- The two established `<type>` options are `feat` and `fix`. `fix` is used when fixing existing code, while `feat` is used when adding new features to the code base. 
- `[optional scope]` is used to help define the scope of the commit (e.g. `(string parser)` or `(api)`). 
-  `!` is an optional indicator used to denote that a commit contains a breaking change (e.g. when moving from v1.8.2 to v2.0.0).
-  `<description>` is the summary of the commit. This section should be as short and as straightforward as possible.
-  More information about `[optional body]` and `[optional footer(s)]` may be found on the Conventional Commits website. However, this team will not be utilizing them.

### Types
The following is a list of additional accepted types and their usage.
- `fix`: Fixes existing code
- `feat`: Adds new features to the code
- `docs`: Changes in documentation or comments
- `style`: Everything related to styling (of code and not application)
- `refactor`: Changes that neither fix a bug nor add a feature
- `test`: Everything related to testing (i.e. when creating a test suite and not modifying a file to pass tests)
- `chore`: Everything related to maintaining the code (e.g. updating build tasks, package manager configs, etc)

### Description 
Additional guidelines on the description summary can be found below.
- Less than 25 words.
- Do not end with punctuation.
- Write in imperative tense (i.e. add not added or adds).
- Capitalize the first word (e.g. `feat:Compute ray render`).
- Complete the sentence “After this commit, the application will…”, not "In this commit, I will…" (i.e. what will the code do and not what you did (e.g. not `feat:Add database handler` but `feat:Openfacing database api`)).
  - Banned words `Fix`, `Add`, `Revert`, `Make`.  

#### Commit Owner
This section pertains to signing a commit in the description as defined by the team.
- When solo coding, do not add initials to the commit message. Git and GitHub will be able to trace the commit back to you automatically.
  - All team members should have a GPG key assigned to their account in order to improve security and verify commit ownership. [See more here](https://ucsb-cs156.github.io/topics/GitHub/github_verified_commits.html).
- When group programming, add the initials (defined as the first letter of only the first and last name) of the group at the end of the description, regardless of whose Git is committing (e.g. `feat:describe a description-(ds/jz/pm)`). Note the hyphen, lack of spaces, and parentheses between the description and initials.
- If group members' initials are the same, utilize the hierarchy below until there is no ambiguity (e.g. `(dos/jz/pm/dss)`):
  1. Middle name initial
  2. Middle name letters
  3. Last name letters
  4. First name letters
- When coding as a complete team, the commit can contain the word *team* or the name of the team in place of initials (e.g. `fix:important update-(team)`)


## Code Styles
The following is a list of agreed-upon coding styles across the team. Any modifications and additions will be posted here.
- Lower camel case for variables (eg. `variabeThatDoesAnImportantThing`)
- First bracket on the same line (eg. `for(int 0; i < upperBound; i++) {...`)
- API endpoints will be all lowercase unless specified in requirements (eg. `https://example.com/api/foo/importantget`)
- Unused imports should be removed before a pull request for security and clarity.

## Code Issues
Issues will no doubt come up across projects and code bases. The following guidelines will apply specifically to the UCSB CS 156 M23 class and should be updated as necessary. Any issue that could be important to the whole class should be relayed to the professor when it is fixed (if nonurgent) or as soon as practical (if urgent).
- **Small Issue**: Defined as anything that can be fixed within 5-10 minutes and is simple enough to describe and correct within 100 words. These issues should be relayed across a common communication channel to the appropriate parties or the team as a whole (e.g. Slack).
- **Large Issue**: Defined as anything that needs more than 10 minutes to be fixed or is complicated that documentation and steps are required to solve. These issues should be documented in a file of the root directory in the pertaining repo named `notes.md`. It should contain the following format:
```
# Main header for notes.md. (e.g. Problems and fixes for team02)

## Issue/Topic Name
[Description and solution]
```


## Pull Requests
This Pull request outline was created utilizing the guidelines available by the [UCSB CS 156 course website](https://ucsb-cs156.github.io/topics/pull_requests.html).

- PR Title
  - Is it descriptive enough that someone familiar with the project can understand it at first glance?
  - Is it short enough to be readable at a glance?
  - Is it related to the issue at hand and does it summarize the fix?
  - It should not be in commit message format.
  - It should contain 10 words or less.
- Overview
  - Should summarize the pull request and all commits.
  - Should briefly contain all the criteria necessary for each solved issue.
  - Is it descriptive enough that someone familiar with the project can understand all changes and additions?
  - If there is a working instance of the changes, link it here.
  - Others should get the big picture of what this PR is changing.
  - Description should include changes from both the programmer's and end-users perspectives.
- Screenshots (Optional)
  - If necessary, shows what the code looks like without needing to go to an instance.
  - Add captions below screenshots if needed for clarification.
  - If committing frontend changes, this section is necessary.
- Feedback Request (Optional)
  - If the pull request is a work in progress or if there are code sections that a reviewer should pay attention to, mention it here.
  - Make sure to mention specific members or address the team as a whole.
  - Be specific about what kind of feedback you are looking for. 
- Future Possibilities (Optional)
  - Where do you think this change could take the project?
  - What features that you wish you could implement?
  - Both paragraph and list are acceptable.
  - Be comprehensive so the rest of the team knows some of the possibilities.
- Validation (Optional)
  - Steps that someone could take to validate the feature or work.
  - Of course, this applies mostly to the front-end, but API calls can also work.
  - Does not need to be complicated, but everything that can be validated by another user needs to be listed here.
- Tests
  - This is a checklist of the tests that your PR has ran through and passed. Any failed test cases should also be mentioned here.
  - A standardized list of required test cases should go here as well.
  - Any additional tests that have been run and passed can be listed as well.
  - For the purpose of this team, all test cases need to be passed and be at 100%. 
- Issue Link
  - Most PR should be linked to an issue. You can link it with the following magic words:
    - close
    - closes
    - closed
    - fix
    - fixes
    - fixed
    - resolve
    - resolves
    - resolved
  - Try to limit one PR for one issue. However, related issues can be bundled together into one.
  - Link one issue per line.

### PR Body Template

```
<!-- See https://github.com/ucsb-cs156-m23/m23-10am-4-NOTES/blob/main/masterDoc.md for more info-->
## Overview
<!--A paragraph of the PR and related content-->
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Screenshots (Optional)
<!--Necessary screenshots and any necessary captions here. Delete if not needed.-->
![Generic placeholder image](https://picsum.photos/640/480)

## Feedback Request (Optional)
<!--Anywhere specific you want reviewers to take a look at and give suggestions. Delete if not needed.-->
None needed. I am the best.

## Future Possibilities (Optional)
<!--What do you think this project could become? Delete if not needed.-->
This will go to the moon if we invest all our life savings into this concept!!!

## Validation (Optional)
<!--Steps that someone else could take to make sure everything is working-->
Just trust me, bro. :)

## Tests
<!--Add any additional tests or required tests-->
- [ ] Unit tests pass
- [ ] Test coverage is at 100%
- [ ] Mutation tests show a rate of 100% 

## Linked Issues
<!--Issues related to the PR-->
Closes #0
```

### Code Review
A *LGTM!* is not a code review!

#### Writing a Code Review
Look for the following items (This is not an exhaustive list. Use your judgment based on the situation.):
- Is the PR conforming to the standards described within this document?
- Are there relevant sections (e.g. screenshots for frontend, test coverage and mutation for all)
- Is the purpose of the PR well explained, not just the what, but also the why?
- If there is a linked issue, is the assigned issue coder in the loop with this PR (i.e. the PR requestor or approves the PR)?
- Does the PR pass all of the CI/CD tests?
- When applicable, is there a deployed dev instance to test, and does it work?
- If the issue(s) this PR addresses have acceptance criteria, are all of those met? And if so, are they checked off?
- Commented out code; typically, this should be removed before merging into the default branch.
- Quickly look at the file changes and see if any standout and should be removed (e.g. `.DS_Store` from Mac users or `*~` from emacs users or `package.json` and `package-lock.json` at the top level of the repo (they should only be in the frontend directory)

Write any issues or suggestions that you may have to the requestor and have those issues changed before approving. Remember to be constructive and respectful with your review. They took the time to write everything, after all. We are all learning, so have open discussions about your suggestion and provide guidance if necessary. Make sure your suggestions and criteria are clear for the requestor to go and fix. Your code review is not done until you approve of the PR, so make sure you respond to any changes and updates within a reasonable time frame! 

#### Responding to a Code Review
Be positive and open a discussion. You do not have to implement or agree with other people's decisions. Respond from a point of gratitude-- they took the time to look over your code after. If you agree, write something to acknowledge their feedback(e.g. “Thanks, fixed” or “Done”. Better is “good call, fixed” or “thanks for catching that, fixed”). If you don't, open a discussion with them and see how to resolve the issue; don't just dismiss the comment (e.g. “Hmm, I see it differently; let’s discuss” or “I’m not sure I understand your perspective; can you explain further?” or “I see where you are coming from, but i/we think it should be like this…”). 

### References
The following is a list of sources that inspired and contributed to the making of this document.
- [UCSB CS 156 Topics on anything and everything](https://ucsb-cs156.github.io/topics/)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [How to write a good commit message](https://dev.to/chrissiemhrk/git-commit-message-5e21)
- [Write joyous git commit messages](https://joshuatauberer.medium.com/write-joyous-git-commit-messages-2f98891114c4)
- [Initials in git messages](https://ucsb-cs156.github.io/topics/conventions/conventions_commit_messages.html#initials-at-the-start-of-your-commit-message-pc---)
- [Articles on how to write a good commit message](https://ucsb-cs156.github.io/topics/git/git_commit_messages.html#articles-on-how-to-write-a-good-commit-message)
- [Github: verified badge](https://ucsb-cs156.github.io/topics/GitHub/github_verified_commits.html)
- [Code Reviews on Github](https://ucsb-cs156.github.io/topics/code_reviews/code_reviews_github.html)
- [Code Reviews](https://ucsb-cs156.github.io/topics/code_reviews/)
- [Pull Requests](https://ucsb-cs156.github.io/topics/pull_requests.html)
- [Doing a Code Review](https://ucsb-cs156.github.io/topics/pull_requests.html#doing-a-code-review)
- [How to write the perfect pull request](https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/)
- [Gerrit/Commit message guidelines](https://www.mediawiki.org/wiki/Gerrit/Commit_message_guidelines)
- [Code review](https://www.mediawiki.org/wiki/Gerrit/Code_review)
- [Thoughtbot Code review](https://github.com/thoughtbot/guides/tree/main/code-review)
