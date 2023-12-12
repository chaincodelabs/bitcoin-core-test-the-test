# Bitcoin Core: Test The Test

The goal of these exercises is to learn the Bitcoin Core development environment
through the Bitcoin Test Framework.

## Requirements

1. Build Bitcoin Core from the included source code
2. Run the functional tests (all should pass!)
3. Modify the source code such that **ONLY ONE** functional test **FAILS**
4. Commit your modified code and push your branch back to GitHub for automatic evaluation

> [!TIP]
> **GITHUB CLASSROOM:** 
> Each student will get a private fork of this repository
> when they join the GitHub Classroom assignment. You will commit and push your
> submissions to GitHub which will evaluate the answers automatically, like a
> continuous integration test. You can commit and push as often as you like and
> GitHub will re-evaluate your code every time.

## Set Up

> [!TIP]
> **A copy of the Bitcoin Core codebase is included in this repo in [`/bitcoin`](/bitcoin).**
> It was cloned at a specific commit on master branch just after v28.0 was tagged,
> so it will require the CMAKE build system.

1. Build Bitcoin Core
    - The [docs in the repo](/bitcoin/doc/README.md#building) should provide sufficient guidance for this
    - If you have any problems, search the [issues on GitHub](https://github.com/bitcoin/bitcoin/issues) or try [Bitcoin Stack Exchange](https://bitcoin.stackexchange.com/)
2. Run all the [functional tests](bitcoin/test/README.md#running-tests-locally)
    - All tests should pass! (You can ignore "skipped" tests)
    - You may be able to speed up the test suite using a [RAM disk](https://github.com/bitcoin/bitcoin/tree/master/test#speed-up-test-runs-with-a-ram-disk)

Example commands after satisfying requirements for your system:

```
# Only use the code base in this repository
cd bitcoin

# Configure cmake to build as little as possible
cmake -B build \
    -DBUILD_GUI=OFF \
    -DWITH_BDB=OFF  \
    -DBUILD_BENCH=OFF  \
    -DBUILD_FOR_FUZZING=OFF \
    -DBUILD_KERNEL_LIB=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_TX=OFF \
    -DBUILD_UTIL=OFF \
    -DBUILD_WALLET_TOOL=OFF

# Compile!
cmake --build build -j$(nproc)

# Run the functional tests
build/test/functional/test_runner.py
```

## Challenge

1. Choose a target test from [the funcitonal test directory](bitcoin/test/functional).
2. Write a minimal commit in `src/` (`*.cpp` or `*.h` files only) that makes this one single test fail, and no others!
    - You can ignore "skipped" tests
3. Commit your changes to this repository and push.

> [!TIP]
> You do NOT need to run the [unit tests](bitcoin/src/test/README.md), fuzz tests,
> or the extended tests (`test_runner --extended`) for this exercise.

## Example

### Target test

[`feature_abortnode`](bitcoin/test/functional/feature_abortnode.py)

### Commit

```diff
commit 17f920100af18efae76bb6445f6c5bd970e7a19c
Author: Matthew Zipkin <pinheadmz@gmail.com>
Date:   Mon Nov 4 12:46:00 2024 -0500

    make feature_abortnode.py fail

diff --git a/bitcoin/src/block_reader.cpp b/bitcoin/src/block_reader.cpp
index f9288fc..10582f5 100644
--- a/bitcoin/src/block_reader.cpp
+++ b/bitcoin/src/block_reader.cpp
@@ -3333,7 +3333,7 @@ bool BlockReader::ReadBestBlock(BlockValidationState& state, CBlockIndex*
             // Try to read block from disk and increment attempts counter
-            ReadBlock(m_chainman.GetNotifications(), state, ++attempts);
+            ReadBlock(m_chainman.GetNotifications(), state, 0);
             return attempts;
         }
         fBlockRead = true;
```

### Functional test results

Example output (truncated):

```
...
wallet_txn_doublespend.py --legacy-wallet                | ○ Skipped | 0 s
wallet_upgradewallet.py --legacy-wallet                  | ○ Skipped | 0 s
wallet_watchonly.py --legacy-wallet                      | ○ Skipped | 1 s
wallet_watchonly.py --usecli --legacy-wallet             | ○ Skipped | 1 s
feature_abortnode.py                                     | ✖ Failed  | 6 s

ALL                                                      | ✖ Failed  | 1681 s (accumulated)
Runtime: 454 s

Runtime: 714 s
```