# xcode-frameworks packaged for the Zig build system

This is a Zig package which provides a subset of XCode frameworks that are needed to compile games/applications for e.g. macOS.

The package is small (~102MB), generally just what Mach engine itself and a few other projects need for e.g. audio and graphics.

All symlinks are realized to their actual file contents to improve compatibility with Windows, which has extremely poor symlink support.

## Updating

To update this repository, run `./update.sh` on a macOS host machine with XCode installed followed by `./verify.sh` to verify the repository contents.

## Verifying repository contents

For supply chain security reasons (e.g. to confirm we made zero changes to the code) we provide a `git diff` command you can run to verify the contents of this repository:

```sh
./verify.sh
```

If nothing is printed, there is no diff. Deleted files are ignored.

## Issues

Issues are tracked in the [main Mach repository](https://github.com/hexops/mach/issues?q=is%3Aissue+is%3Aopen+label%3Axcode-frameworks).

## License

All files in this repository are distributed in an unmodified state,
per section 2.2.A, paragraph (ii) of the Xcode and Apple SDKs Agreement:

> You may use the macOS SDKs to test and develop application and other software;

And the last paragraph:

> Except as otherwise expressly set forth in Section 2.2.B., You may not distribute any Applications 
developed using the Apple SDKs (**excluding the macOS SDK**) absent entering into a separate written 
agreement with Apple. 

By downloading and using this software, you must also agree to the Xcode and Apple SDKs Agreement:

https://www.apple.com/legal/sla/docs/xcode.pdf

Note that this includes statements of only distributing the software built with the SDKs to
official Apple hardware, not modifying the files in any way, and only utilizing the software
on official Apple hardware.
