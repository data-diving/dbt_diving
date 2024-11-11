{%- macro get_refs_recursive(select, print_list=False) -%}

{# THIS MACRO IS DEPRECATED SINCE VERSION 1.2.0 #}
{# Please, use get_nodes() macro instead #}
{{ return(dbt_diving.get_nodes(select, resource_type='model', print_list=print_list)) }}

{%- endmacro -%}