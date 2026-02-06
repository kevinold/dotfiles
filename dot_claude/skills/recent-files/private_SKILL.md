---
name: recent-files
description: List recently modified code and documentation files in the current project, sorted by modification time. Use when the user wants to see what files they've been working on, needs a list of recent changes, or asks about recent work, latest files, or what they modified recently. Works with TypeScript, TSX, JavaScript, JSX, and Markdown files. Includes both git-tracked and untracked files.
---

# Recent Files

This skill shows you the most recently modified code and documentation files in your project, making it easy to quickly reference files you've been working on without remembering exact paths. Works with both tracked and untracked files.

## Quick Start

When invoked, this skill will display your 10 most recently modified code and documentation files. You can then use `@filename` to reference any of them in your conversation.

## Instructions

1. **Find recently modified files** (includes both tracked and untracked):
   - Filter for TypeScript (.ts, .tsx), JavaScript (.js, .jsx), and Markdown (.md) files
   - Include files from agent-os/ and other documentation directories
   - Sort by modification time (most recent first)
   - Limit to 10 files for manageable context

2. **Display the results** in a numbered list showing:
   - File path relative to project root
   - A clear, easy-to-reference format

3. **Inform the user** that they can now reference any of these files using `@filename` in the conversation

## Command

Execute this command to find and list the files (works with both tracked and untracked files):

```bash
# Find recently modified code and markdown files (including untracked)
# Combine git tracked and untracked files, sort by modification time
(git ls-files '*.ts' '*.tsx' '*.js' '*.jsx' '*.md' 2>/dev/null; \
 git ls-files --others --exclude-standard '*.ts' '*.tsx' '*.js' '*.jsx' '*.md' 2>/dev/null) | \
  sort -u | \
  head -50 | \
  xargs ls -t 2>/dev/null | \
  head -10 | \
  awk '{printf "%2d. %s\n", NR, $0}'
```

## Output Format

Present the results like this:

```
📝 Your 10 most recently modified files:

1. agent-os/specs/daily-activity-insights.md
2. apps/web/app/home/[account]/daily-log/page.tsx
3. apps/web/app/home/[account]/daily-log/_components/daily-log-form.tsx
4. agent-os/product/roadmap.md
5. packages/features/daily-logs/src/server/server-actions.ts
6. apps/web/app/home/[account]/page.tsx
7. packages/features/daily-logs/src/lib/schemas.ts
[... etc]

You can now reference any of these files using @filename in your message.
```

## Best Practices

- **When to use**: Invoke this skill when starting a new conversation or when you need to reference recently changed code or documentation
- **Use with @**: After running this skill, you can use `@agent-os/specs/daily-activity-insights.md` or `@apps/web/app/home/[account]/page.tsx` to reference specific files
- **Keep it fresh**: Run again during long sessions to refresh the list
- **Great for agent-os work**: Automatically includes your specs, product docs, and other markdown files even if not yet committed
- **Combine with other tools**: Use alongside grep or file search for specific code patterns

## Troubleshooting

**No files shown:**
- Check that files have been modified recently (within the last 7 days)
- Ensure you're in the project directory
- Verify files exist with extensions: .ts, .tsx, .js, .jsx, .md

**Wrong files listed:**
- The skill prioritizes recently modified files only
- Files must have been modified within the last 7 days
- Modification time is based on file system metadata

**Missing untracked files:**
- This skill includes untracked files automatically
- If files are not showing, check they have the correct extension (.md, .ts, etc.)
- Ensure they're not in excluded directories (node_modules, .next, dist, build, .git)

## Limitations

- Shows code files (TypeScript/JavaScript) and Markdown files only
- Limited to 10 files (prevents context overload)
- Only includes files modified within the last 7 days
- Excludes build/dependency directories (node_modules, .next, dist, build)
- Doesn't show file size or detailed change info

## Related Skills

- Use `@skill-writer` to create custom file filtering skills
- Use Claude's built-in search tools for finding specific code patterns
