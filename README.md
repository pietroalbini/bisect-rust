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
