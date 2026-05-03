#!/bin/bash

# Setup
rm -f test_results.log
touch test_results.log

echo "Running Pragma Once Tests..."

# Test 1: First time sourcing should succeed
echo "Test 1: First source..."
source ./test_lib.sh
COUNT=$(wc -l < test_results.log)
if [ "$COUNT" -eq 1 ]; then echo "✅ Pass"; else echo "❌ Fail (Expected 1, got $COUNT)"; fi

# Test 2: Second time sourcing should be blocked
echo "Test 2: Redundant source..."
source ./test_lib.sh
COUNT=$(wc -l < test_results.log)
if [ "$COUNT" -eq 1 ]; then echo "✅ Pass"; else echo "❌ Fail (Expected 1, got $COUNT)"; fi

# Test 3: Modify file and source again should succeed (Content Awareness)
echo "Test 3: Source after modification..."
echo "# Modified" >> test_lib.sh
source ./test_lib.sh
COUNT=$(wc -l < test_results.log)
if [ "$COUNT" -eq 2 ]; then echo "✅ Pass"; else echo "❌ Fail (Expected 2, got $COUNT)"; fi

# Test 4: Second source after modification should be blocked
echo "Test 4: Redundant source after modification..."
source ./test_lib.sh
COUNT=$(wc -l < test_results.log)
if [ "$COUNT" -eq 2 ]; then echo "✅ Pass"; else echo "❌ Fail (Expected 2, got $COUNT)"; fi

echo "----------------------------"
echo "Final Log Contents:"
cat test_results.log
