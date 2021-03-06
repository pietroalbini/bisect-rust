#![recursion_limit = "1024"]

extern crate serde;
extern crate serde_json;
#[macro_use] extern crate error_chain;
extern crate xz2;
extern crate flate2;
extern crate tar;
#[macro_use] extern crate log;
extern crate reqwest;
extern crate git2;
extern crate chrono;

pub mod errors {
    // Create the Error, ErrorKind, ResultExt, and Result types
    error_chain! {
        foreign_links {
            Git2(::git2::Error);
            Reqwest(::reqwest::Error);
            Io(::std::io::Error);
        }
    }
}

pub mod git;
pub mod sysroot;

use std::process::Command;

use errors::*;

pub fn get_host_triple() -> Result<String> {
    let output = Command::new("rustc")
        .arg("-v").arg("-V").output()
        .chain_err(|| format!("running rustc -vV to obtain host triple failed; try --triple"))?;
    let output = String::from_utf8_lossy(&output.stdout);
    Ok(output.lines().find(|l| l.starts_with("host: ")).unwrap()[6..].to_string())
}

/// The first commit which build artifacts are made available through the CI for
/// bisection.
///
/// Due to our deletion policy which expires builds after 90 days, the build
/// artifact of this commit itself is no longer available.
pub const EPOCH_COMMIT: &str = "927c55d86b0be44337f37cf5b0a76fb8ba86e06c";

pub fn get_commits(start: &str, end: &str) -> Result<Vec<git::Commit>> {
    info!("Getting commits from the git checkout in {}...{}", start, end);
    let commits = git::get_commits_between(start, end)?;
    assert_eq!(commits.first().expect("at least one commit").sha, start);

    Ok(commits)
}
