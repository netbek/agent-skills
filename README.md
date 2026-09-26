# agent-skills

## Development

### Prerequisites

1. Clone the repo:

    ```shell
    git clone --recurse-submodules git@github.com:netbek/agent-skills.git
    ```

2. Install Mise and add activation to `~/.bashrc`, e.g.

    ```shell
    curl -fsSL https://github.com/jdx/mise/releases/download/v2026.7.13/install.sh | sh
    ```

    See [other installation methods](https://mise.en.dev/installing-mise.html).

3. Trust `mise.toml`:

    ```shell
    mise trust
    ```

4. Run `make install` to install Node dependencies, agent skills, and pinned vendor sources.

### Release

1. Run `make bump-version [major|minor|patch]`. This bumps `pyproject.toml`, syncs `package.json`, `dbt_project.yml`, and the `packages.yml` pin in this README, then commits.
2. Push the commit.
3. Check the tree is clean, then run `make create-release`.

## Acknowledgments

`skills/writing-spec-and-design-docs` builds on ideas and wording from:

* [Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec) — MIT © 2024 OpenSpec Contributors — spec format (`Requirement`/`Scenario`, `SHALL/MUST`, `WHEN/THEN`), what-vs-how split, read-only grounding, clarify-before-draft.
* [obra/superpowers](https://github.com/obra/superpowers) — MIT © 2025 Jesse Vincent — `brainstorming`/`writing-plans` workflow (one-question-at-a-time, 2–3 approaches, fix-inline self-review, approval gate), `Thought | Reality` red-flags table.
* [mattpocock/skills](https://github.com/mattpocock/skills) — MIT © 2026 Matt Pocock — `domain-modeling` glossary/ADR (`Terminology`, `Decision/Rationale/Consequences`, hard-to-reverse rule), `to-spec` no-file-paths-in-spec, `grilling` interview style.

## License

Copyright (c) 2026 Hein Bekker. Licensed under the MIT License.
