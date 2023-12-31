{%- macro get_refs_recursive(selector) -%}

{%- set ns = namespace(node_list=[], cur_node_list=[]) -%}
{%- for one_union in selector.split(' ') -%}
    {%- set intersect_list = one_union.split(',') -%}
    {%- for one_intersect in intersect_list -%}
        {%- if loop.index0 == 0 -%}
            {%- set ns.cur_node_list = dbt_diving.parse_one_condition(one_intersect) -%}
        {%- else -%}
            {%- set cur_node_list_next = dbt_diving.parse_one_condition(one_intersect) -%}
            {%- set compared_node_list = [] -%}
            {%- for node in ns.cur_node_list -%}
                {%- for node_next in cur_node_list_next -%}
                    {%- if node == node_next -%}
                        {%- do compared_node_list.append(node) -%}
                    {%- endif -%}
                {%- endfor -%}
            {%- endfor -%}
            {%- set ns.cur_node_list = compared_node_list -%}
        {%- endif -%}
    {%- endfor -%}
    {%- set ns.node_list = ns.node_list + ns.cur_node_list %}
{%- endfor -%}

{{ return(ns.node_list | unique | list) }}

{%- endmacro -%}


{%- macro parse_one_condition(condition) -%}

{%- set all_nodes = graph.nodes.values() -%}
{%- set refs_list = [] -%}

{%- if condition.startswith("+") -%}
    {%- set with_upstream = condition.startswith("+") -%}
    {%- set condition = condition[1:] -%}
{%- endif -%}
{%- if condition.endswith("+") -%}
    {%- set with_downstream = condition.endswith("+") -%}
    {%- set condition = condition[:-1] -%}
{%- endif -%}

{%- set nodes = [] -%}
{%- if condition.startswith('tag:') -%}
    {%- for node in all_nodes recursive -%}
        {%- if condition.split('tag:')[1] in node['tags'] -%}
            {%- do nodes.append(node) -%}
        {%- endif -%}
    {%- endfor -%}
{%- else -%}
    {%- set nodes = all_nodes | selectattr('name', 'equalto', condition) | list -%}
{%- endif -%}

{%- for node in nodes -%}
    {%- do refs_list.append(node.name) -%}
    
    {%- if with_upstream -%}
        {%- set cur_upstream_node = node.name -%}
        {%- for upstream_model in all_nodes | selectattr('name', 'equalto', cur_upstream_node) -%}
            {%- for ref in upstream_model['refs'] recursive -%}
                {%- do refs_list.append(ref[0]) -%}
                {%- set recursive_refs = all_nodes | selectattr('name', 'equalto', ref[0]) -%}
                {%- set outer_loop = loop -%}
                {%- for recursive_ref in recursive_refs -%}
                    {%- set cur_upstream_node = recursive_ref -%}
                    {{ outer_loop(recursive_ref['refs']) }}
                {%- endfor -%}
            {%- endfor -%}
        {%- endfor -%}
    {%- endif -%}

    {%- if with_downstream -%}
        {%- set recursive_models = [node.name] -%}
        {%- for downstream_model in all_nodes recursive -%}
            {%- set refs = [] -%}
            {%- for ref in downstream_model['refs'] -%}
                {%- do refs.append(ref[0]) -%}
            {%- endfor -%}

            {%- if recursive_models[-1] in refs -%}
                {%- do refs_list.append(downstream_model.name) -%}
                {%- do recursive_models.append(downstream_model.name) -%}
                {{ loop(all_nodes) }}
                {%- set recursive_models = recursive_models[:-1] -%}
            {%- endif -%}
        {%- endfor -%}
    {%- endif -%}
{%- endfor -%}

{{ return(refs_list | unique | list) }}

{%- endmacro -%}