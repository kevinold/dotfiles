# Showdown Markdown Syntax

Quick reference for creating slides in Showdown (https://showdown.tinybird.se/).

## Core Concepts

**Slide Separation:** Each H1 (`#`) header creates a new slide
**Speaker Notes:** Use fenced code blocks with `speaker` language tag
**Standard Markdown:** Most standard Markdown syntax is supported

## Slide Structure

### Create New Slides

Each H1 header automatically creates a new slide:

```markdown
# First Slide Title

Content for first slide

# Second Slide Title

Content for second slide
```

### Headings Within Slides

Use H2-H6 for headings within a slide:

```markdown
# Slide Title

## Section Heading

### Subsection

Content here
```

## Speaker Notes

Speaker notes are only visible to you during the presentation. Use fenced code blocks with `speaker` tag:

````markdown
# Slide Title

This is visible content on the slide.

```speaker
These are my speaker notes. Only I can see these during the presentation.
They can span multiple lines.
```
````

## Text Formatting

Standard Markdown formatting:

```markdown
**bold text**
*italic text*
~~strikethrough~~
```

## Lists

Bullet lists:
```markdown
- Item one
- Item two
- Item three
```

Numbered lists:
```markdown
1. First item
2. Second item
3. Third item
```

Nested lists:
```markdown
- Main item
  - Nested item
  - Another nested item
```

Task lists:
```markdown
- [ ] Unchecked task
- [x] Completed task
```

## Code

### Inline Code

```markdown
Use `keyword` for inline code within text
```

### Code Blocks with Syntax Highlighting

Showdown supports syntax highlighting for code blocks:

````markdown
```typescript
function hello() {
  console.log("Hello, Showdown!");
}
```
````

````markdown
```python
def greet():
    print("Hello, Showdown!")
```
````

Supported languages include: JavaScript, TypeScript, Python, Java, Go, Rust, and many others.

## Block Quotes

```markdown
> This is a block quote
> It can span multiple lines
```

## Links

```markdown
Visit [this site](https://example.com) for more info.
```

## Images

```markdown
![Alt text](image.png)
![Alt text](https://example.com/image.jpg)
```

## Tables

```markdown
| Name | Price | Quantity |
|:-----|------:|---------:|
| Widget | $10 | 5 |
| Gadget | $20 | 3 |
```

Alignment:
- Left: `:-----`
- Right: `-----:`
- Center: `:----:`

## Badges

Add badges to slides using special syntax:

```markdown
# Slide Title

[#badge:Important]

Content here
```

## Horizontal Rules

```markdown
---
```

Note: Horizontal rules create visual separators within a slide, but do NOT create new slides (use H1 for that).

## Complete Slide Example

````markdown
# Introduction to TypeScript

[#badge:Getting Started]

TypeScript is a **typed superset** of JavaScript that compiles to plain JavaScript.

## Key Features

- Static typing
- Enhanced IDE support
- Better code maintainability

```speaker
Remember to mention that TypeScript was created by Microsoft in 2012.
Talk about your experience migrating from JavaScript to TypeScript.
Transition to code example.
```

```typescript
interface User {
  name: string;
  age: number;
}

function greet(user: User): string {
  return `Hello, ${user.name}!`;
}
```

---

# Why Use TypeScript?

TypeScript helps catch errors early during development.

```speaker
Ask the audience who has used TypeScript before.
Share statistics about TypeScript adoption rates.
```

- Catches bugs at compile time
- Improves developer productivity
- Scales well for large projects
````

## Best Practices

1. Use H1 headers only for new slides
2. Use H2-H6 for structure within slides
3. Place speaker notes after slide content
4. Use syntax highlighting for all code blocks
5. Keep slides focused - one main idea per slide
6. Use badges to highlight important slides
7. Test your presentation in presentation mode

## Themes

Showdown offers multiple themes to choose from. Select the theme that best matches your presentation style from the app's theme selector.

## Export

Showdown supports exporting presentations to PDF format for sharing or printing.
