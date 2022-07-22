# JQ cheat sheet 
```
[
  {
    "id": "bc12d628-f668-41af-8a3c-050aba1c8cb8",
    "version": "2018-01-27T00:22:10.905Z",
    "affectedApps": [
      "/dev/serviceapp1"
    ],
    "affectedPods": [],
    "steps": [
      {
        "actions": [
          {
            "action": "ScaleApplication",
            "app": "/dev/serviceapp1"
          }
        ]
      }
    ],
    "currentActions": [
      {
        "action": "ScaleApplication",
        "app": "/dev/serviceapp1",
        "readinessCheckResults": []
      }
    ],
    "currentStep": 1,
    "totalSteps": 1
  },
  {
    "id": "48bca295-f668-41af-933acf938231c8cb8",
    "version": "2018-01-27T05:00:10.905Z",
    "affectedApps": [
      "/qa/testapp"
    ],
    "affectedPods": [],
    "steps": [
      {
        "actions": [
          {
            "action": "ScaleApplication",
            "app": "/qa/testapp"
          }
        ]
      }
    ],
    "currentActions": [
      {
        "action": "ScaleApplication",
        "app": "/qa/testapp",
        "readinessCheckResults": []
      }
    ],
    "currentStep": 1,
    "totalSteps": 1
  },
  {
    "id": "bc12d628-f668-41af-8a3c-4aab392cc34d",
    "version": "2018-01-27T00:55:10.905Z",
    "affectedApps": [
      "/prod/region1/app1a",
      "/prod/region1/app1b"
    ],
    "affectedPods": [],
    "steps": [
      {
        "actions": [
          {
            "action": "ScaleApplication",
            "app": "/prod/region1/app1b"
          }
        ]
      }
    ],
    "currentActions": [
      {
        "action": "ScaleApplication",
        "app": "/prod/region1/app1b",
        "readinessCheckResults": []
      }
    ],
    "currentStep": 1,
    "totalSteps": 1
  }
]
```
# Below is the Bash shell script, including intermediate stages to show the development and use of some jq features:
```

#!/bin/bash

# Evolution of a jq script to parse Marathon API output to identify
# "stuck" deployments i.e. exceeding 30 minutes

USER_PW="username:password"
URL="http://marathon-hostname:8080/v2/deployments"
input=deployments.json

curl -s -u ${USER_PW} ${URL} > $input
```

# pretty print JSON data
```
jq '.' $input
```


# extract first array element
```
jq '.[0]' $input

```

# extract single field from first array element
```
jq '.[0].version' $input
```


# extract single field from each array element
```
jq '.[].version' $input
```

# To extract multiple fields from an array element, construct a new JSON hash object { }
```
jq '.[0]|{timestamp: .version, appList: .affectedApps}' $input
```
# if you want only to extract the fields, retaining the names, you can use this shorthand
```
jq '.[0]|{version, affectedApps}' $input
```
# create the same object for each element in the array
# Note the output is not a JSON array, just a list of objects
```
jq '.[]|{version, affectedApps}|.affectedApps |= join(",")|.version+","+.affectedApps' $input
```
# to produce a JSON array of hashes, wrap the entire expression in [  ]
```
jq '[.[]|{version, affectedApps}]' $input
```
# The |= operator updates the value of a JSON element. Here we convert the version value to UNIX epoc format in 3 steps
```
jq '.[]|{version, affectedApps}|.version |= (.[:-5]|strptime("%Y-%m-%dT%H:%M:%S")|mktime)' $input
```
# Mark deployments that have exceeded 30 minutes by adding an "overdue" element to each object with the result
```
jq '.[]|{version, affectedApps}|.version |= (.[:-5]|strptime("%Y-%m-%dT%H:%M:%S")|mktime)|if .version < (now - 1800) then .overdue = true else .overdue = false end' $input

```

# Alternatively use the "empty" operator to skip those objects that are not overdue
```
jq '.[]|{version, affectedApps}|.version |= (.[:-5]|strptime("%Y-%m-%dT%H:%M:%S")|mktime)|if .version < (now - 1800) then . else empty end' $input
```


# We want to use the human readable time format in the final output, so move the UNIX epoch conversion into the if statement expression
```
jq '.[]|{version, affectedApps}|if (.version[:-5]|strptime("%Y-%m-%dT%H:%M:%S")|mktime) < (now - 1800) then . else empty end' $input
```

# Join apps list into one comma delimited string, add some explanatory text, add -r option to omit quotes around JSON values
```
jq -r '.[]|{version, affectedApps}|if (.version[:-5]|strptime("%Y-%m-%dT%H:%M:%S")|mktime) < (now - 1800) then "Deploying since " + .version + ", apps affected: " + (.affectedApps|join(", ")) else empty end' $input
r=$(jq -r '.[]|{version, affectedApps}|if (.version[:-5]|strptime("%Y-%m-%dT%H:%M:%S")|mktime) < (now - 1800) then "Deploying since " + .version + ", Apps affected: " + (.affectedApps|join(", ")) else empty end' $input)

if [[ -n "$r" ]]
then
    echo "List of overdue deployments:"
    echo "$r"
fi
```
