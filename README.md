# Rust Bisector

This is a tool written to find which commit introduced an error message into Rust,
by bisecting the commits of the Rust repository.

In order to use it, first record the range of commits which contains a regression.
Note that if a commit happened more than 90 days ago, the bisector may not be
able to download the build artifacts.

Then, you can run this command to execute a bisect between commit `a` and `b`
(use full commit hashes):

```
./bisect.sh a b
```

For each run, copy `test.example.sh` into `test.sh` and configure it to match
your test case. The script should exit with 0 if the regression occured, and
exit with nonzero code if no regression is detected.

## Detecting regressions between releases/channels

If you don't need to check for regressions between a range of nightlies, but
instead between two stable releases or stable and beta, you need to use the
`cutoff.sh` script to get the commit sha. The script accepts a git tag or a
branch name, and prints the sha.

**Example:** bisect between Rust 1.24.0 and Rust 1.25.0

```
./bisect.sh $(./cutoff.sh 1.24.0) $(./cutoff.sh 1.25.0)
```

**Example:** bisect between stable and beta

```
./bisect.sh $(./cutoff.sh origin/stable) $(./cutoff.sh origin/beta)
```

## Troubleshooting

### `Commit not found`/`tag not found`

If you get a "commit not found"/"tag not found", be sure to update the local
copy of the rust repository (located in the `rust.git`) directory:

```
$ git -C rust.git fetch --tags
```

### No regressions found

If you see no regression was found and you're sure there should be one, there
are a few things you should check:

1. Ensure the commit range you provided is correct
2. If you're using the default test script included in this repository, set the
   `SHOW_OUTPUT` option to `true`, so you can check the exact output the bisect
   script is generating
3. If you need to inspect a commit from the cache, use the
   `./extract-cache.sh <commit>` script.
