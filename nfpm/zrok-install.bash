cd $(mktemp -d);

ZROK_VERSION=$(
  curl -sSf https://api.github.com/repos/openziti/zrok/releases/latest \
  | jq -r '.tag_name'
);

case $(uname -m) in
  x86_64)         GOXARCH=amd64
  ;;
  aarch64|arm64)  GOXARCH=arm64
  ;;
  arm*)           GOXARCH=armv7
  ;;
  *)              echo "ERROR: unknown arch '$(uname -m)'" >&2
                  exit 1
  ;;
esac;

curl -sSfL \
  "https://github.com/openziti/zrok/releases/download/${ZROK_VERSION}/zrok_${ZROK_VERSION#v}_linux_${GOXARCH}.tar.gz" \
  | tar -xz -f -;

install -o root -g root ./zrok /usr/local/bin/;

zrok version;