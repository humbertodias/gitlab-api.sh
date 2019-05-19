# GitLab Functions

Loading functions

    source gitlab-functions.sh

Retrieve Project by Name

    gitlab_json_project localhost Jb6EXB21zLwsneNS1zt6 my_first_project

Retrieve Project ID

    gitlab_project_id localhost Jb6EXB21zLwsneNS1zt6 my_first_project

List files onto folder

    gitlab_json_files localhost Jb6EXB21zLwsneNS1zt6 my_first_project folder1 master

Get Single file

    gitlab_raw_file localhost Jb6EXB21zLwsneNS1zt6 my_first_project folder1/f1.txt master /tmp/output

Get Files onto Folder

    gitlab_raw_files localhost Jb6EXB21zLwsneNS1zt6 my_first_project folder1 master /tmp/output


# Ref

* https://docs.gitlab.com/ee/api/README.html