# Packages

The goal of this README is to keep track of the status of the new API system, located in `/lib/packages` for now.

As of 17/12/21, there are 5 packages:

- `school_api` (WIP)
- `school_api_models` (WIP)
- `offline` (Done)
- `shared` (WIP)
- `apis/ecole_directe` (WIP)

Planned packages:

- `apis/pronote`
- `apis/la_vie_scolaire`
- `apis/kdecole`

## Details and status

### `school_api` (WIP)

This package contains the parent class of the new API system. Packages contained in `apis` are children of it. All the business logic happens there, it remains quite abstract. Most of types come from `school_api_models`.

The API follows a modular structure. Modules can be enabled for each school service and depending on each school, at runtime.

Status:

- [ ] documentation
- [ ] `SchoolApi` class (WIP)
- [ ] modules
  - [ ] auth (WIP)
  - [ ] documents (WIP)
  - [ ] emails (WIP)
  - [ ] grades (WIP)
  - [ ] homework (WIP)
  - [ ] school life (WIP)
  - [ ] agenda
  - [ ] cloud
  - [ ] polls

### `school_api_models` (WIP)

This package contains all models needed for the `school_api`. It also contains adapters for Hive and the `offline` package.

Status:

- [x] documentation (WIP)
- [ ] features (WIP)

### `offline` (Done)

This package manages offline data through Hive.

Status:

- [x] documentation
- [x] features

### `shared` (WIP)

This package contains utilities to be used everywhere. It contains the `Response` class inspired by `@supabase/supabase-js` approach, that is essential to the new API for better error handling.

Status:

- [ ] documentation
- [ ] features (WIP)

### `ecole_directe` (WIP)

This package can't be finished if `school_api` is not finished, or at least the most of it.

Status:

- [ ] documentation
- [ ] features
