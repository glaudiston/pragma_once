# test_lib.sh
# Use the new pattern: source || return 0
source ./pragma_once.sh || return 0

# This part should only run if pragma_once allows it
echo "Library Initialized" >> test_results.log
# Modified
# Modified
