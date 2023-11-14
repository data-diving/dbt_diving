{%- macro get_refs_recursive(selector) -%}

{%- set models = graph.nodes.values() -%}
{%- set refs_list = [] -%}

{%- set model_name = selector -%}
{%- if selector.startswith("+") -%}
    {%- set with_downstream = selector.startswith("+") -%}
    {%- set model_name = model_name[1:] -%}
{%- endif -%}
{%- if selector.endswith("+") -%}
    {%- set with_upstream = selector.endswith("+") -%}
    {%- set model_name = model_name[:-1] -%}
{%- endif -%}

{%- set model = models | selectattr('name', 'equalto', model_name) | list -%}
{%- if model | count == 1 -%}
    {%- do refs_list.append(model[0].name) -%}
    
    {%- if with_downstream -%}
        {%- set downstream_models = models | selectattr('name', 'equalto', model_name) -%}
        {%- for downstream_model in downstream_models -%}
            {%- for ref in downstream_model['refs'] recursive -%}
                {%- do refs_list.append(ref[0]) -%}
                {%- set recursive_refs = models | selectattr('name', 'equalto', ref[0]) -%}
                {%- for recursive_ref in recursive_refs recursive -%}
                    {{ loop(recursive_ref['refs']) }}
                {%- endfor -%}
            {%- endfor -%}
        {%- endfor -%}
    {%- endif -%}

    {%- if with_upstream -%}
        {%- set recursive_models = [model_name] -%}
        {%- for upstream_model in models recursive -%}
            {%- set refs = [] -%}
            {%- for ref in upstream_model['refs'] -%}
                {%- do refs.append(ref[0]) -%}
            {%- endfor -%}

            {%- if recursive_models[-1] in refs -%}
                {%- do refs_list.append(upstream_model.name) -%}
                {%- do recursive_models.append(upstream_model.name) -%}
                {{ loop(models) }}
                {%- set recursive_models = recursive_models[:-1] -%}
            {%- endif -%}
        {%- endfor -%}
    {%- endif -%}
{%- endif -%}

{{ return(refs_list | unique) }}

{%- endmacro -%}