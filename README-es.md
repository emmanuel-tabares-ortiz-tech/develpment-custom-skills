[English](README.md) · [Español](README-es.md)

<p align="center">
  <h1 align="center">Development Custom Skills para Claude Code</h1>
  <p align="center">Planifica la feature. Apruébala. Impleméntala paso a paso.</p>
</p>

<p align="center">
  <img alt="Licencia" src="https://img.shields.io/github/license/emmanuel-tabares-ortiz-tech/spec-driven-develpment-custom-skills">
  <img alt="Último release" src="https://img.shields.io/github/v/release/emmanuel-tabares-ortiz-tech/spec-driven-develpment-custom-skills">
  <img alt="GitHub Stars" src="https://img.shields.io/github/stars/emmanuel-tabares-ortiz-tech/spec-driven-develpment-custom-skills?style=social">
  <img alt="Skills" src="https://img.shields.io/badge/skills-3-blue">
</p>

## Inicio rápido

```bash
npx skills@latest add emmanuel-tabares-ortiz-tech/spec-driven-develpment-custom-skills
```

## Skills

| Skill | Descripción | Argumento |
| --- | --- | --- |
| `/spec` | Diseña el documento de la feature haciendo preguntas de clarificación y lo guarda como `specs/NN-slug.md` con estado `Borrador`. | `[tema-corto]` |
| `/spec-impl` | Valida que el spec esté `Aprobado`, crea una rama e implementa paso a paso con pausas para revisar diffs. Nunca hace commit por su cuenta. | `<NN-slug>` |
| `/manual-tecnico` | Crea o actualiza `docs/manual-tecnico.md` analizando el proyecto y los cambios recientes de git. Funciona con cualquier tipo de proyecto. Soporta `lang:en` / `lang:es` (por defecto: español). | `[lang:en\|es] [ref-git-base]` |

---

## Instalación

### Opción 1 — skills.sh (recomendado, Claude Code)

```bash
npx skills@latest add emmanuel-tabares-ortiz-tech/spec-driven-develpment-custom-skills
```

Para desinstalar:

```bash
npx skills@latest remove emmanuel-tabares-ortiz-tech/spec-driven-develpment-custom-skills
```


### Opción 2 — Otros agentes (Cursor, Codex, Antigravity)

```bash
git clone https://github.com/emmanuel-tabares-ortiz-tech/spec-driven-develpment-custom-skills ~/.dev-custom-skills
cd ~/tu-proyecto
~/.dev-custom-skills/scripts/install-to-agent.sh <agent>
```

`<agent>` puede ser `claude`, `cursor`, `codex` o `antigravity`. Ver [README.md](./README.md#installation) para detalles.

### Opción 3 — Manual

```bash
# Personal (todos tus proyectos)
mkdir -p ~/.claude/skills
cp -r skills/engineering/spec ~/.claude/skills/
cp -r skills/engineering/spec-impl ~/.claude/skills/
cp -r skills/engineering/manual-tecnico ~/.claude/skills/

# O de proyecto (versionado en git)
mkdir -p .claude/skills
cp -r skills/engineering/spec .claude/skills/
cp -r skills/engineering/spec-impl .claude/skills/
cp -r skills/engineering/manual-tecnico .claude/skills/
```

Para el workflow de specs, también crea la carpeta `specs/` en la raíz del proyecto:

```bash
mkdir specs
```

---

## Releases

Este proyecto usa [release-please](https://github.com/googleapis/release-please) para releases automáticos. Los mensajes de commit deben seguir [Conventional Commits](https://www.conventionalcommits.org/):

| Prefijo | Efecto |
| --- | --- |
| `feat:` | Sube versión minor |
| `fix:` | Sube versión patch |
| `feat!:` / `fix!:` | Sube versión major |
| `docs:`, `chore:`, `refactor:` | Sin cambio de versión |

---

## Licencia

MIT

---

_Si encuentras una forma de mejorar el método o los skills, abre un issue o un PR. La parte más valiosa de un skill personal es que evoluciona con el uso._
