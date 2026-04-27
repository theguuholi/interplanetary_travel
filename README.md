# Interplanetary Travel — Fuel Calculator

[![CI](https://github.com/theguuholi/interplanetary_travel/actions/workflows/ci.yml/badge.svg)](https://github.com/theguuholi/interplanetary_travel/actions/workflows/ci.yml)

A real-time fuel calculator for interplanetary missions, built with **Phoenix LiveView**.

<img width="1446" height="810" alt="Screenshot 2026-04-27 at 08 56 21" src="https://github.com/user-attachments/assets/6d421d01-40ea-4340-8072-b0cc659d6caa" />

## What it does

Given a spacecraft mass and a sequence of flight steps (launch/land on a planet), it calculates the total fuel required — including the fuel needed to carry the fuel itself (recursively).

**Supported planets:** Earth · Moon · Mars

**Supported actions:** Launch · Land

## How fuel is calculated

```
fuel = floor(mass × gravity × factor − offset)
```

- **Launch:** factor `0.042`, offset `33`
- **Land:** factor `0.033`, offset `42`

Fuel is computed recursively: each fuel load also needs fuel to be carried, until the additional fuel rounds down to zero.

## Example — Apollo 11

| Step | Action | Planet |
|------|--------|--------|
| 1 | Launch | Earth |
| 2 | Land | Moon |
| 3 | Launch | Moon |
| 4 | Land | Earth |

Mass: `28,801 kg` → **Total fuel: `51,898 kg`**

## Running locally

```bash
mix setup       # install dependencies
mix phx.server  # start at http://localhost:4000
```

```bash
mix test        # run the test suite
```
