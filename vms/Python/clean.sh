
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR/cpython-main"

echo "$SCRIPT_DIR/cpython-main"

make clean
rm -rf Makefile