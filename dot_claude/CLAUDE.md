
## Browser Automation

Use `agent-browser` for web automation. Run `agent-browser --help` for all commands.

Core workflow:
1. `agent-browser open <url>` - Navigate to page
2. `agent-browser snapshot -i` - Get interactive elements with refs (@e1, @e2)
3. `agent-browser click @e1` / `fill @e2 "text"` - Interact using refs
4. Re-snapshot after page changes

## Code Search Strategy (MANDATORY)

**This applies to ALL code search operations, including work delegated to sub-agents.**

When searching or analyzing code - whether directly or via Task tool agents - prioritize LSP tools over rg:

1. **LSP First** - Use LSP operations for semantic code understanding:
   - `documentSymbol` - List all symbols in a file (ALWAYS START HERE)
   - `findReferences` - Find all usages of a symbol
   - `goToDefinition` - Navigate to where a symbol is defined
   - `hover` - Get type info and documentation
   - `incomingCalls` - Find callers of a function
   - `outgoingCalls` - Find functions called by a function

2. **rg/Grep Second** - Fall back to text search ONLY for:
   - String literals and comments
   - Config files (YAML, JSON, ENV)
   - TODO/FIXME markers
   - Files without LSP support (Markdown, templates)

LSP provides compiler-accurate results; rg finds text patterns.

**When to use LSP prioritization:**
- TypeScript/JavaScript projects (excellent LSP via tsserver)
- Python projects (good LSP via Pyright/Pylsp)
- Rust projects (excellent LSP via rust-analyzer)
- Ruby projects (good LSP via ruby-lsp/Solargraph)

**When rg is still appropriate:**
- Searching for hardcoded secrets (`password`, `API_KEY`, etc.)
- Finding TODO/FIXME comments
- Searching config files and environment variables
- Pattern matching across non-code files

### Agent Delegation

When using the Task tool to spawn agents for code exploration, you MUST include this instruction in the prompt:

> "Use LSP tools (documentSymbol, findReferences, goToDefinition, hover) before falling back to Grep/Glob for code search."
