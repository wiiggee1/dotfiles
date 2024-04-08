require("lint").linters.verilator.args = {
        "-sv",
        "-Wall",
        "--bbox-sys",
        "--bbox-unsup",
        "--lint-only",
        "--timing=22",
}
