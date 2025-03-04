const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const notcurses_source_path = ".";

    const notcurses = b.addStaticLibrary(.{
        .name = "notcurses",
        .target = target,
        .optimize = optimize,
    });
    // notcurses has saome undefined benavior which makes the demo crash with
    // illegal instruction, disabling UBSAN to make it work (-fno-sanitize-c)
    notcurses.disable_sanitize_c = true;
    notcurses.linkLibC();

    notcurses.linkSystemLibrary("deflate");
    notcurses.linkSystemLibrary("ncurses");
    notcurses.linkSystemLibrary("readline");
    notcurses.linkSystemLibrary("unistring");
    notcurses.linkSystemLibrary("z");

    notcurses.addIncludePath(.{ .path = notcurses_source_path ++ "/include" });
    notcurses.addIncludePath(.{ .path = notcurses_source_path ++ "/build/include" });
    notcurses.addIncludePath(.{ .path = notcurses_source_path ++ "/src" });
    notcurses.addCSourceFiles(&[_][]const u8{
        notcurses_source_path ++ "/src/compat/compat.c",

        notcurses_source_path ++ "/src/lib/automaton.c",
        notcurses_source_path ++ "/src/lib/banner.c",
        notcurses_source_path ++ "/src/lib/blit.c",
        notcurses_source_path ++ "/src/lib/debug.c",
        notcurses_source_path ++ "/src/lib/direct.c",
        notcurses_source_path ++ "/src/lib/fade.c",
        notcurses_source_path ++ "/src/lib/fd.c",
        notcurses_source_path ++ "/src/lib/fill.c",
        notcurses_source_path ++ "/src/lib/gpm.c",
        notcurses_source_path ++ "/src/lib/in.c",
        notcurses_source_path ++ "/src/lib/kitty.c",
        notcurses_source_path ++ "/src/lib/layout.c",
        notcurses_source_path ++ "/src/lib/linux.c",
        notcurses_source_path ++ "/src/lib/menu.c",
        notcurses_source_path ++ "/src/lib/metric.c",
        notcurses_source_path ++ "/src/lib/mice.c",
        notcurses_source_path ++ "/src/lib/notcurses.c",
        notcurses_source_path ++ "/src/lib/plot.c",
        notcurses_source_path ++ "/src/lib/progbar.c",
        notcurses_source_path ++ "/src/lib/reader.c",
        notcurses_source_path ++ "/src/lib/reel.c",
        notcurses_source_path ++ "/src/lib/render.c",
        notcurses_source_path ++ "/src/lib/selector.c",
        notcurses_source_path ++ "/src/lib/sixel.c",
        notcurses_source_path ++ "/src/lib/sprite.c",
        notcurses_source_path ++ "/src/lib/stats.c",
        notcurses_source_path ++ "/src/lib/tabbed.c",
        notcurses_source_path ++ "/src/lib/termdesc.c",
        notcurses_source_path ++ "/src/lib/tree.c",
        notcurses_source_path ++ "/src/lib/unixsig.c",
        notcurses_source_path ++ "/src/lib/util.c",
        notcurses_source_path ++ "/src/lib/visual.c",
        notcurses_source_path ++ "/src/lib/windows.c",
    }, &[_][]const u8{
        "-std=gnu11",
        "-D_GNU_SOURCE", // to make memory management work, see sys/mman.h
        "-DUSE_MULTIMEDIA=none",
        "-DUSE_QRCODEGEN=OFF",
        "-DPOLLRDHUP=0x2000",
    });
}
