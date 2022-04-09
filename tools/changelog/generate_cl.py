"""
DO NOT MANUALLY RUN THIS SCRIPT.
---------------------------------

This script is designed to generate and push a CL file that can be later compiled.
The body of the changelog is determined by the description of the PR that was merged.

If a commit is pushed without being associated with a PR, or if a PR is missing a CL,
the script is designed to exit as a failure. This is to help keep track of PRs without
CLs and direct commits. See the relating comments in the below source to disable this function.

This script depends on the tags.yml file located in the same directory. You can use that
file to configure the exact tags you'd like this script to use when generating changelog entries.
If this is being used in a /tg/ or Bee downstream, the default tags should work.

Expected envrionmental variables:
-----------------------------------
GIT_NAME: Username of the github account to be used as the commiter (User provided)
GIT_EMAIL: Email associated with the above (User provided)
GITHUB_REPOSITORY: Github action variable representing the active repo (Action provided)
BOT_TOKEN: A repository account token, this will allow the action to push the changes (Action provided)
GITHUB_SHA: The SHA associated with the commit that triggered the action (Action provided)
"""
import os
import io
import re
from pathlib import Path
from ruamel import yaml
from github import Github, InputGitAuthor

CL_BODY = re.compile(r"(:cl:|🆑)(.+)?\r\n((.|\n|\r)+?)\r\n\/(:cl:|🆑)", re.MULTILINE)
CL_SPLIT = re.compile(r"(^\w+):\s+(\w.+)", re.MULTILINE)

git_email = os.getenv("GIT_EMAIL")
git_name = os.getenv("GIT_NAME")

# Blessed is the GoOnStAtIoN birb ZeWaKa for thinking of this first
repo = os.getenv("GITHUB_REPOSITORY")
token = os.getenv("BOT_TOKEN")
sha = os.getenv("GITHUB_SHA")

git = Github(token)
repo = git.get_repo(repo)
commit = repo.get_commit(sha)
pr_list = commit.get_pulls()

if not pr_list.totalCount:
    print("Direct commit detected")
    exit(0) # Change to '0' if you do not want the action to fail when a direct commit is detected

pr = pr_list[0]

pr_body = pr.body
pr_number = pr.number
pr_author = pr.user.login

write_cl = {}
try:
    cl = CL_BODY.search(pr_body)
    cl_list = CL_SPLIT.findall(cl.group(3))
except AttributeError:
    print("No CL found!")
    exit(0) # Change to '0' if you do not want the action to fail when no CL is provided


if cl.group(2) is not None:
    write_cl['author'] = cl.group(2).lstrip()
else:
    write_cl['author'] = pr_author

write_cl['delete-after'] = True

with open(Path.cwd().joinpath("tools/changelog/tags.yml")) as file:
    tags = yaml.safe_load(file)

write_cl['changes'] = []

for k, v in cl_list:
    if k in tags['tags'].keys(): # Check to see if there are any valid tags, as determined by tags.yml
        v = v.rstrip()
        if v not in list(tags['defaults'].values()): # Check to see if the tags are associated with something that isn't the default text
            write_cl['changes'].append({tags['tags'][k]: v})

if write_cl['changes']:
    with io.StringIO() as cl_contents:
        yaml = yaml.YAML()
        yaml.indent(sequence=4, offset=2)
        yaml.dump(write_cl, cl_contents)
        cl_contents.seek(0)

        #Push the newly generated changelog to the master branch so that it can be compiled
        repo.create_file(f"html/changelogs/AutoChangeLog-pr-{pr_number}.yml", f"Automatic changelog generation for PR #{pr_number} [ci skip]", content=f'{cl_contents.read()}', branch='dev', committer=InputGitAuthor(git_name, git_email))
    print("Done!")
else:
    print("No CL changes detected!")
    exit(0) # Change to a '1' if you want the action to count lacking CL changes as a failure