{% set relations = dbt_utils.get_relations_by_prefix(schema='tpcds_sf100tcl',prefix='',database='snowflake_sample_data') %}
{% for relation in relations %}
    select 
        '{{ relation.identifier }}' as table_name,
        (select count(*) from {{ relation }}) as c
        {%- if not loop.last %}
        union all
        {% endif -%}
{%- endfor %}