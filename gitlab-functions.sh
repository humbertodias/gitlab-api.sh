#!/bin/bash

# https://docs.gitlab.com/ee/api/README.html

gitlab_json_project() {
	# Parameters
	GITLAB_HOST=$1
	PERSONAL_ACCESS_TOKEN=$2
	PROJECT_NAME=$3
	PROJECT_JSON=$(curl -s -H "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" "https://$GITLAB_HOST/api/v4/search?scope=projects&search=$PROJECT_NAME")
	# Result
	echo $PROJECT_JSON
}

gitlab_project_id() {
	PROJECT_ID=$(gitlab_json_project $1 $2 $3 | jq '.[0].id' -r)
	echo $PROJECT_ID
}

gitlab_json_files() {
	# Parameters
	GITLAB_HOST=$1
	PERSONAL_ACCESS_TOKEN=$2
	PROJECT_NAME=$3
	FOLDER_PATH=$4
	BRANCH=$5
	# Local
	FOLDER_PATH=$(echo ${FOLDER_PATH//\//%2F})
	PROJECT_ID=$(gitlab_project_id $GITLAB_HOST $PERSONAL_ACCESS_TOKEN $PROJECT_NAME)
	FILES=$(curl -s -H "Private-Token: $PERSONAL_ACCESS_TOKEN" "https://$GITLAB_HOST/api/v4/projects/$PROJECT_ID/repository/tree?ref=$BRANCH&recursive=true&path=$FOLDER_PATH")
	# Return
	echo $FILES
}

gitlab_raw_file() {
	# Parameters
	GITLAB_HOST=$1
	PERSONAL_ACCESS_TOKEN=$2
	PROJECT_NAME=$3
	FILE_PATH=$4
	BRANCH=$5
	FOLDER_PATH_OUTPUT=$6

	# Generated
	PROJECT_ID=$(gitlab_project_id $GITLAB_HOST $PERSONAL_ACCESS_TOKEN $PROJECT_NAME)
	FILE_PATH_URL=$(echo ${FILE_PATH//\//%2F})
	FILE_FULL_PATH="$FOLDER_PATH_OUTPUT/$FILE_PATH"

	# Create parent folder
	mkdir -p "${FILE_FULL_PATH%/*}"

	# Download
	curl -s -o $FILE_FULL_PATH -H "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" "http://$GITLAB_HOST/api/v4/projects/$PROJECT_ID/repository/files/$FILE_PATH_URL/raw?ref=$BRANCH"
}

gitlab_raw_files() {
	# Parameters
	GITLAB_HOST=$1
	PERSONAL_ACCESS_TOKEN=$2
	PROJECT_NAME=$3
	FOLDER_PATH=$4
	BRANCH=$5
	FOLDER_PATH_OUTPUT=$6

	# Local
	FOLDER_PATH=$(echo ${FOLDER_PATH//\//%2F})
	PROJECT_ID=$(gitlab_project_id $GITLAB_HOST $PERSONAL_ACCESS_TOKEN $PROJECT_NAME)
	FILES_JSON=$(gitlab_json_files $GITLAB_HOST $PERSONAL_ACCESS_TOKEN $PROJECT_NAME $FOLDER_PATH $BRANCH)

	# For each file
	echo $FILES_JSON | jq -r '.[].path' |
		while IFS=$'\t' read -r path; do
			echo "Creating $path"
			gitlab_raw_file $GITLAB_HOST $PERSONAL_ACCESS_TOKEN $PROJECT_NAME $path $BRANCH $FOLDER_PATH_OUTPUT
		done
}

gitlab_create_file(){
	# Parameters
	GITLAB_HOST=$1
	PERSONAL_ACCESS_TOKEN=$2
	PROJECT_NAME=$3
	BRANCH=$4
	FILE_PATH_LOCAL=$5
	FILE_PATH_REMOTE=$6

	# Local
	PROJECT_ID=$(gitlab_project_id $GITLAB_HOST $PERSONAL_ACCESS_TOKEN $PROJECT_NAME)
	COMMIT_MESSAGE="GITLAB-API: Creating file $FILE_PATH_REMOTE"

	curl --request POST \
		--form "branch=$BRANCH" \
		--form "commit_message=$COMMIT_MESSAGE" \
		--form "start_branch=$BRANCH" \
		--form "actions[][action]=create" \
		--form "actions[][file_path]=$FILE_PATH_REMOTE" \
		--form "actions[][content]=<$FILE_PATH_LOCAL" \
		--header "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" \
		"https://$GITLAB_HOST/api/v4/projects/$PROJECT_ID/repository/commits"
}

gitlab_update_file(){
	# Parameters
	GITLAB_HOST=$1
	PERSONAL_ACCESS_TOKEN=$2
	PROJECT_NAME=$3
	BRANCH=$4
	FILE_PATH_LOCAL=$5
	FILE_PATH_REMOTE=$6

	# Local
	PROJECT_ID=$(gitlab_project_id $GITLAB_HOST $PERSONAL_ACCESS_TOKEN $PROJECT_NAME)
	COMMIT_MESSAGE="GITLAB-API: Updating file $FILE_PATH_REMOTE"

	curl --request POST \
		--form "branch=$BRANCH" \
		--form "commit_message=$COMMIT_MESSAGE" \
		--form "start_branch=$BRANCH" \
		--form "actions[][action]=update" \
		--form "actions[][file_path]=$FILE_PATH_REMOTE" \
		--form "actions[][content]=<$FILE_PATH_LOCAL" \
		--header "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" \
		"https://$GITLAB_HOST/api/v4/projects/$PROJECT_ID/repository/commits"
}

