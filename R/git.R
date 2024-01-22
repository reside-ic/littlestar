do_git_update_refs <- function(path) {
  ## TODO: we don't cope here with ssh keys; we might do that by
  ## mounting them at another path and using here via the `ssh_key`
  ## argument.
  gert::git_fetch(repo = path)
}


do_git_list_refs <- function(path) {
  branches <- gert::git_branch_list(local = FALSE, repo = path)
  ret <- data.frame(name = branches$name,
                    type = "branch",
                    commit = branches$commit,
                    updated = branches$updated)
  ## TODO: can add tags, but getting last update time is quite
  ## expensive (around a second for dust). Could also list recent
  ## commits from origin/main too, that does go pretty quickly but I'm
  ## seeing some weird return values in dust with too many merge
  ## conflicts and not enough normal ones between, which might confuse
  ## people.
  ret <- ret[order(ret$updated, decreasing = TRUE), ]
  rownames(ret) <- NULL
  ret
}


do_git_checkout <- function(path, ref, type) {
  if (type == "is_branch") {
    ref <- sprintf("origin/%s", ref)
  }
  gert::git_reset_hard(ref, repo = path)
}


do_git_clone <- function(url, path) {
  gert::git_clone(url, path, branch = "HEAD")
}


