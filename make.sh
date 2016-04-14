#!/bin/bash
set -e

repo=$1
branch=$2
lang=$3

# check args
if [ -z "$1" ]; then
	echo "repo url required"
	exit 1
fi
if [ -z "$2" ]; then
	branch="master"
fi

# get source code
prodName="${repo##*/}-${branch}"
rm -rf "$prodName"
git clone $repo -b $branch "$prodName"

# get builder/runner images
builderImg="zhang0137/builder"
runnerImg="zhang0137/runner"
docker inspect $builderImg >/dev/null 2>&1 || docker pull $builderImg
docker inspect $runnerImg >/dev/null 2>&1 || docker pull $runnerImg

# build source, result in /tmp/slug.tgz
pushd "$prodName"
tar -c -O . | docker run -e LANGUAGE="$lang" -i --rm -v /tmp:/product -a stdin -a stdout -a stderr $builderImg
popd
rm -rf "$prodName"

# build product image
mkdir ./app
tar -xf /tmp/slug.tgz -C ./app

cat > Dockerfile <<EOF
FROM $runnerImg
ADD ./app /app
EOF

docker build -t "${prodName}:latest" .

# clean up
rm -rf ./app ./Dockerfile

# bye
echo result @ ${prodName}:latest
