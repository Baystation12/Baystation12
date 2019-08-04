workflow "Label approved pull requests" {
  on = "pull_request_review"
  resolves = ["Label when approved"]
}

action "Label when approved" {
  uses = "pullreminders/label-when-approved-action@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    LABEL_NAME = "approved"
    APPROVALS = "1"
  }
}
