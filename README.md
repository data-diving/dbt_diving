![Run Tests badge](https://github.com/data-diving/dbt_diving/actions/workflows/main.yml/badge.svg)
# dbt_diving
A free to use dbt package with helper macros

## Installation

Check [dbt Hub](https://hub.getdbt.com/data-diving/dbt_diving/latest/) for the latest installation instructions, 
or [read the docs](https://docs.getdbt.com/docs/building-a-dbt-project/package-management/) for more information on installing packages.

## Macros in the package

### get_refs_recursive(str)

1. Create a macro in your project.
2. Call the appropriate macro from the dbt_diving repository.

```bash
# Call the macro from another macro code
{% set model_refs = dbt_diving.get_refs_recursive("select_string") %}

# Call the macro from a model code
# https://docs.getdbt.com/reference/dbt-jinja-functions/graph#accessing-models
{% if execute %}
  {% set model_refs = dbt_diving.get_refs_recursive("select_string") %}
{% endif %}
```

**Input**: str

**Output**: list of strings

**Usage**: You can provide dbt object name of any type (model, seed table, test, etc.) as an input. If you add `+` (plus sign) at the beginning, macro will return object and all its downstream dependencies. If you add `+` at the end of the selector string, macro will return object and all its upstream dependencies. You can combine these options. [Set operators](https://docs.getdbt.com/reference/node-selection/set-operators) are also supported.

## License
[MIT](LICENSE)
