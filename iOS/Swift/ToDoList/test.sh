
url="http://127.0.0.1:8080/todos"
header="Content-Type: application/json"

function create() {
	curl -H "${header}" \
	-d '{"title": "learn python", "order": 3}' \
	-X POST  "${url}"
}

function update() {
	curl -H "${header}" \
	-d '{"title": "learn python this year", "completed": true, "order": 0}'\
	-X PATCH "${url}/$1"
}

function getAll() {
	curl "${url}" | jq .
}

function delete() {
	if [[ -z $1 ]]; then
		echo "must pass todoID"
		exit 1
	fi
	curl -X DELETE "${url}/$1"
}

# delete "8FFD842E-20DB-49F8-A8FF-698540ADB6A2"

# create

# getAll

# update "056A865C-293D-455A-BCAB-5E8B375F9952"

getAll