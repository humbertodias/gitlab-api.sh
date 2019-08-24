# GitLab Downloader

Auxiliary bash functions for extracting gitlab's files using just the Personal Access Token, avoiding cloning the entire repository.

## Deps

* git, curl, jq, make
* docker (optional)

```
make install-deps
```

## Parameters

    GITLAB_HOST=localhost
    PRIVATE_ACCESS_TOKEN=Jb6EXB21zLwsneNS1zt6
    PROJECT_NAME=my_first_project
    BRANCH=master
    FOLDER_PATH=folder1
    FILE_PATH=folder1/f1.txt
    OUTPUT_PATH=/tmp/output

## Functions

Loading

    source gitlab-functions.sh

Retrieve Project by Name

    gitlab_json_project $GITLAB_HOST $PRIVATE_ACCESS_TOKEN $PROJECT_NAME

Retrieve Project ID

    gitlab_project_id $GITLAB_HOST $PRIVATE_ACCESS_TOKEN $PROJECT_NAME

List files onto folder

    gitlab_json_files $GITLAB_HOST $PRIVATE_ACCESS_TOKEN $PROJECT_NAME $FOLDER_PATH $BRANCH

Get Single file

    gitlab_raw_file $GITLAB_HOST $PRIVATE_ACCESS_TOKEN $PROJECT_NAME $FILE_PATH $BRANCH $OUTPUT_PATH

Get Files onto Folder

    gitlab_raw_files localhost $PRIVATE_ACCESS_TOKEN $PROJECT_NAME $FOLDER_PATH $BRANCH $OUTPUT_PATH


Push file

    gitlab_push_file localhost $PRIVATE_ACCESS_TOKEN $PROJECT_NAME $BRANCH $FILE_PATH_LOCAL $FILE_PATH_REMOTE


## Running GitLab locally

    make docker-gitlab-run

## Private Access Token

![](etc/gitlab_private_token.png)    

# Ref

* [GitLab API](https://docs.gitlab.com/ee/api/README.html)