import argparse
import subprocess
import webbrowser


def get_repo_name_from_remote(remote_name):
    cmd = 'git remote get-url %s' % remote_name
    try:
        url = subprocess.check_output(
            cmd.split(' '),
            stderr=subprocess.STDOUT).strip()
    except:
        return None
    url = url.decode('utf-8').replace('git@github.com:', '')
    url = url.replace('.git', '')
    print(url)
    return url


parser = argparse.ArgumentParser()
parser.add_argument('-b', '--base', default='master', type=str, required=False)
args = parser.parse_args()
origin_repo_name = get_repo_name_from_remote('origin')
upstream_repo_name = get_repo_name_from_remote('upstream')
if not upstream_repo_name:
    upstream_repo_name = origin_repo_name

BASE_URL = "https://github.com/{upstream}/compare/{base_branch}..."\
           "{origin}:{head_branch}"
branch_cmd = "git rev-parse --abbrev-ref HEAD"
head_branch = subprocess.check_output(
    branch_cmd.split(' '),
    stderr=subprocess.STDOUT).strip()
fork_name = origin_repo_name.split('/')[0]
url = BASE_URL.format(
    upstream=upstream_repo_name,
    origin=fork_name,
    head_branch=head_branch.decode('utf-8'),
    base_branch=args.base
)
webbrowser.open_new_tab(url)
