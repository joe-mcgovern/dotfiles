function! MyOmniCompletionFunc(findstart, base) abort
  if expand("%") ==# ".gitlab-ci.yml"
      return s:GitlabCI(a:findstart, a:base)
  endif
  " Fallbak on ale for omni completions. I'm not yet sure if this is a good
  " idea or not. From a couple of tests, it seems like this takes quite a long
  " time.
  return ale#completion#OmniFunc(a:findstart, a:base)
endfunction

function! s:GitlabCI(findstart, base) abort
  " TODO update this guy to add an autocmd group that updates a list of
  " variables for the current buffer that's defined in the file.
  let l:names = [
  \      "CHAT_CHANNEL", "CHAT_INPUT", "CHAT_USER_ID", "CI",
  \      "CI_API_V4_URL", "CI_BUILDS_DIR", "CI_COMMIT_AUTHOR",
  \      "CI_COMMIT_BEFORE_SHA", "CI_COMMIT_BRANCH", "CI_COMMIT_DESCRIPTION",
  \      "CI_COMMIT_MESSAGE", "CI_COMMIT_REF_NAME", "CI_COMMIT_REF_PROTECTED",
  \      "CI_COMMIT_REF_SLUG", "CI_COMMIT_SHA", "CI_COMMIT_SHORT_SHA",
  \      "CI_COMMIT_TAG", "CI_COMMIT_TIMESTAMP", "CI_COMMIT_TITLE",
  \      "CI_CONCURRENT_ID", "CI_CONCURRENT_PROJECT_ID", "CI_CONFIG_PATH",
  \      "CI_DEBUG_TRACE", "CI_DEFAULT_BRANCH",
  \      "CI_DEPENDENCY_PROXY_GROUP_IMAGE_PREFIX",
  \      "CI_DEPENDENCY_PROXY_DIRECT_GROUP_IMAGE_PREFIX",
  \      "CI_DEPENDENCY_PROXY_PASSWORD", "CI_DEPENDENCY_PROXY_SERVER",
  \      "CI_DEPENDENCY_PROXY_USER", "CI_DEPLOY_FREEZE", "CI_DEPLOY_PASSWORD",
  \      "CI_DEPLOY_USER", "CI_DISPOSABLE_ENVIRONMENT", "CI_ENVIRONMENT_NAME",
  \      "CI_ENVIRONMENT_SLUG", "CI_ENVIRONMENT_URL", "CI_ENVIRONMENT_ACTION",
  \      "CI_ENVIRONMENT_TIER", "CI_HAS_OPEN_REQUIREMENTS", "CI_JOB_ID",
  \      "CI_JOB_IMAGE", "CI_JOB_JWT", "CI_JOB_MANUAL", "CI_JOB_NAME",
  \      "CI_JOB_STAGE", "CI_JOB_STATUS", "CI_JOB_TOKEN", "CI_JOB_URL",
  \      "CI_JOB_STARTED_AT", "CI_KUBERNETES_ACTIVE", "CI_NODE_INDEX",
  \      "CI_NODE_TOTAL", "CI_OPEN_MERGE_REQUESTS", "CI_PAGES_DOMAIN",
  \      "CI_PAGES_URL", "CI_PIPELINE_ID", "CI_PIPELINE_IID",
  \      "CI_PIPELINE_SOURCE", "CI_PIPELINE_TRIGGERED", "CI_PIPELINE_URL",
  \      "CI_PIPELINE_CREATED_AT", "CI_PROJECT_CONFIG_PATH", "CI_PROJECT_DIR",
  \      "CI_PROJECT_ID", "CI_PROJECT_NAME", "CI_PROJECT_NAMESPACE",
  \      "CI_PROJECT_PATH_SLUG", "CI_PROJECT_PATH",
  \      "CI_PROJECT_REPOSITORY_LANGUAGES", "CI_PROJECT_ROOT_NAMESPACE",
  \      "CI_PROJECT_TITLE", "CI_PROJECT_URL", "CI_PROJECT_VISIBILITY",
  \      "CI_PROJECT_CLASSIFICATION_LABEL", "CI_REGISTRY_IMAGE",
  \      "CI_REGISTRY_PASSWORD", "CI_REGISTRY_USER", "CI_REGISTRY",
  \      "CI_REPOSITORY_URL", "CI_RUNNER_DESCRIPTION",
  \      "CI_RUNNER_EXECUTABLE_ARCH", "CI_RUNNER_ID", "CI_RUNNER_REVISION",
  \      "CI_RUNNER_SHORT_TOKEN", "CI_RUNNER_TAGS", "CI_RUNNER_VERSION",
  \      "CI_SERVER_HOST", "CI_SERVER_NAME", "CI_SERVER_PORT",
  \      "CI_SERVER_PROTOCOL", "CI_SERVER_REVISION", "CI_SERVER_URL",
  \      "CI_SERVER_VERSION_MAJOR", "CI_SERVER_VERSION_MINOR",
  \      "CI_SERVER_VERSION_PATCH", "CI_SERVER_VERSION", "CI_SERVER",
  \      "CI_SHARED_ENVIRONMENT", "GITLAB_CI", "GITLAB_FEATURES",
  \      "GITLAB_USER_EMAIL", "GITLAB_USER_ID", "GITLAB_USER_LOGIN",
  \      "GITLAB_USER_NAME", "TRIGGER_PAYLOAD", "CI_MERGE_REQUEST_APPROVED",
  \      "CI_MERGE_REQUEST_ASSIGNEES", "CI_MERGE_REQUEST_ID",
  \      "CI_MERGE_REQUEST_IID", "CI_MERGE_REQUEST_LABELS",
  \      "CI_MERGE_REQUEST_MILESTONE", "CI_MERGE_REQUEST_PROJECT_ID",
  \      "CI_MERGE_REQUEST_PROJECT_PATH", "CI_MERGE_REQUEST_PROJECT_URL",
  \      "CI_MERGE_REQUEST_REF_PATH", "CI_MERGE_REQUEST_SOURCE_BRANCH_NAME",
  \      "CI_MERGE_REQUEST_SOURCE_BRANCH_SHA",
  \      "CI_MERGE_REQUEST_SOURCE_PROJECT_ID",
  \      "CI_MERGE_REQUEST_SOURCE_PROJECT_PATH",
  \      "CI_MERGE_REQUEST_SOURCE_PROJECT_URL",
  \      "CI_MERGE_REQUEST_TARGET_BRANCH_NAME",
  \      "CI_MERGE_REQUEST_TARGET_BRANCH_SHA", "CI_MERGE_REQUEST_TITLE",
  \      "CI_MERGE_REQUEST_EVENT_TYPE", "CI_MERGE_REQUEST_DIFF_ID",
  \      "CI_MERGE_REQUEST_DIFF_BASE_SHA", "CI_EXTERNAL_PULL_REQUEST_IID",
  \      "CI_EXTERNAL_PULL_REQUEST_SOURCE_REPOSITORY",
  \      "CI_EXTERNAL_PULL_REQUEST_TARGET_REPOSITORY",
  \      "CI_EXTERNAL_PULL_REQUEST_SOURCE_BRANCH_NAME",
  \      "CI_EXTERNAL_PULL_REQUEST_SOURCE_BRANCH_SHA",
  \      "CI_EXTERNAL_PULL_REQUEST_TARGET_BRANCH_NAME",
  \      "CI_EXTERNAL_PULL_REQUEST_TARGET_BRANCH_SHA"
  \ ]
  if a:findstart
    " locate the start of the word
    let l:line = getline('.')
    let l:start = col('.') - 1
    " This adds all chars that aren't whitespaces. We may want to update this
    " so that it also stops when it sees a $
    while l:start > 0 && line[l:start - 1] =~ '\S'
      let l:start -= 1
    endwhile
    return l:start
  else
    let l:res = []
    for name in uniq(extendnew(names, s:FetchGitlabCIVariables()))
      " The logic here is that if the current word being typed is a prefix of
      " one of the gitlab ci variable names, then its added to the
      " suggestions. This may need to be improved to handle things like $.
      if l:name =~? '^' . a:base
        call add(l:res, name)
      endif
    endfor
    return l:res
  endif
endfunction

function! s:FetchGitlabCIVariables() abort
  let l:lines = getline(0, "$")
  let l:variables_indent = 0
  let l:is_in_variables_section = 0
  let l:variables = []
  for l:line in l:lines
    if trim(l:line) ==# "variables:"
      let l:is_in_variables_section = 1
      let l:variables_indent = s:CountWhitespacePrefix(l:line)
    elseif !l:is_in_variables_section
      continue
    else
      let l:indent = s:CountWhitespacePrefix(l:line)
      if l:indent <= l:variables_indent
        let l:is_in_variables_section = 0
        let l:variables_indent = 0
        continue
      endif
      let l:pat = '^\s\{' . l:indent . '\}\(\S\+\):.*$'
      let l:matches = matchlist(l:line, l:pat)
      if len(l:matches) > 1
        let l:var_name = trim(l:matches[1])
        let l:index = index(l:variables, l:var_name)
        if l:index is -1
          call add(l:variables, l:var_name)
        endif
      endif
    endif
  endfor
  return l:variables
endfunction

function! s:CountWhitespacePrefix(line) abort
  let l:indent = 0
  for l:char in a:line
    if l:char =~ '\s'
      let l:indent += 1
    else
      break
    endif
  endfor
  return l:indent
endfunction
