{% set relations = dbt_utils.get_relations_by_prefix(
    schema="tpcds_sf10tcl", prefix="", database="snowflake_sample_data"
) %}

{% for relation in relations %}
    {% set create_table %}
    create or replace table snowflake_sample_cloned.tpcds_sf10tcl.{{relation.identifier}} as
    select * from {{relation}}
    {% endset %}
    {% do run_query(create_table) %}
{% endfor %}

select table_name from snowflake_sample_cloned.information_schema.tables
where lower(table_schema) = 'tpcds_sf10tcl'