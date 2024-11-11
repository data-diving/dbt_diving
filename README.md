![Run Tests badge](https://github.com/data-diving/dbt_diving/actions/workflows/main.yml/badge.svg)
# dbt_diving
A free to use dbt package with helper macros

## Installation

Check [dbt Hub](https://hub.getdbt.com/data-diving/dbt_diving/latest/) for the latest installation instructions, 
or [read the docs](https://docs.getdbt.com/docs/building-a-dbt-project/package-management/) for more information on installing packages.

## Macros in the package

### get_nodes(select_string, resource_type, print_list)

1. Create a macro in your project.
2. Call the appropriate macro from the dbt_diving repository.

```bash
# Call the macro from another macro code
{% set model_refs = dbt_diving.get_nodes("select_string", "model") %}

# Call the macro from a model code
# https://docs.getdbt.com/reference/dbt-jinja-functions/graph#accessing-models
{% if execute %}
  {% set model_refs = dbt_diving.get_nodes("select_string", "model") %}
{% endif %}
```

**Input**:

  • `select_string` {str} — node select string as described [here](https://docs.getdbt.com/reference/node-selection/syntax)

  • `resource_type` {str} — specifies what resource types to return (models, sources). This parameter is optional. Default value is 'all'

**Output**: list of strings

**Usage**: You can provide dbt node name of any type (model, seed table, test, etc.) as an input. Currently, only plus `+` operator is supported from [Graph operators](https://docs.getdbt.com/reference/node-selection/graph-operators). [Set operators](https://docs.getdbt.com/reference/node-selection/set-operators) are fully supported.

### get_refs_recursive(select_string, print_list)

This macro is deprecated since version `1.2.0`. It's presented for backward compatibility and will be removed in version `2.0.0`. This macro currently runs `get_nodes()` with `resource_type="model"`

## License
[MIT](LICENSE)
