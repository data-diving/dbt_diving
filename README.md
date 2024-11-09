# dbt_diving
A free to use dbt package with helper macros

## Installation

To install package, add these lines to your `packages.yml` file:
```yaml
packages:
    - package: data-diving/dbt_diving
      version: ">=1.1.0"
```

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, 
or [read the docs](https://docs.getdbt.com/docs/building-a-dbt-project/package-management/) for more information on installing packages.

## Macros in the package

### get_refs_recursive(str)

1. Create a macro in your project.
2. Call the appropriate macro from the dbt_diving repository.

```bash
# Call the macro from another macro code
{% set model_refs = dbt_diving.get_refs_recursive("selector_string") %}

# Call the macro from a model code
# https://docs.getdbt.com/reference/dbt-jinja-functions/graph#accessing-models
{% if execute %}
  {% set model_refs = dbt_diving.get_refs_recursive("selector_string") %}
{% endif %}
```

**Input**: str

**Output**: list of strings

**Usage**: You can provide dbt object name of any type (model, seed table, test, etc.) as an input. If you add `+` (plus sign) at the beginning, macro will return object and all its downstream dependencies. If you add `+` at the end of the selector string, macro will return object and all its upstream dependencies. You can combine these options. [Set operators](https://docs.getdbt.com/reference/node-selection/set-operators) are also supported.

## License
[MIT](LICENSE)
