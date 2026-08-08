import { tool } from "@opencode-ai/plugin"
import { existsSync } from "node:fs"
import { join } from "node:path"

export default tool({
  description:
    "Look up a symbol in the repository's tags index. " +
    "Use this to find definitions, declarations, and other symbol locations " +
    "without searching the entire source tree.",

  args: {
    symbol: tool.schema
      .string()
      .describe("Symbol name to look up, e.g. foo, MyClass, handle_request"),

    kind: tool.schema
      .string()
      .optional()
      .describe(
        "Optional ctags kind filter, e.g. function, class, struct, variable"
      ),

    exact: tool.schema
      .boolean()
      .optional()
      .default(true)
      .describe("Whether to perform an exact symbol lookup"),
  },

  async execute(args, context) {
    const tagsFile = join(context.worktree, "tags")

    if (!existsSync(tagsFile)) {
      return [
        `No tags file found at ${tagsFile}.`,
        "Generate one with Universal Ctags, for example:",
        "",
        "  ctags -R -f tags .",
      ].join("\n")
    }

    // readtags' query syntax is passed as an argument rather than
    // interpolated into a shell command, so there is no shell injection.
    const query = args.exact
      ? args.symbol
      : `^${args.symbol}`

    const command = ["readtags", "-t", tagsFile, query]

    if (args.kind) {
      command.push("-Q", `(eq? $kind "${args.kind}")`)
    }

    try {
      const proc = Bun.spawn(command, {
        cwd: context.worktree,
        stdout: "pipe",
        stderr: "pipe",
      })

      const [stdout, stderr, exitCode] = await Promise.all([
        new Response(proc.stdout).text(),
        new Response(proc.stderr).text(),
        proc.exited,
      ])

      if (exitCode !== 0) {
        if (stderr.trim()) {
          return `readtags failed: ${stderr.trim()}`
        }

        return `No matches found for symbol '${args.symbol}'.`
      }

      const result = stdout.trim()

      if (!result) {
        return `No matches found for symbol '${args.symbol}'.`
      }

      return result
    } catch (error) {
      return [
        "Unable to execute readtags.",
        "",
        "Make sure Universal Ctags/readtags is installed and available in PATH.",
        "",
        `Error: ${error instanceof Error ? error.message : String(error)}`,
      ].join("\n")
    }
  },
})
